package delivery
import (
	"net/http"
	{{ .PackageName }} "github.com/golangid/goruda/generated"
	"github.com/labstack/echo"
	"strconv"
)
{{ $packageName := .PackageName }}
{{ $implementationName := print .ServiceName "Implementation" }}

type httpHandler struct {
}
{{ range $key, $val := .Methods }}
func (h httpHandler) {{ $key }}(c echo.Context) error {
	service := {{ $packageName }}.{{ $implementationName }}{}
	{{- range $index, $element := $val.Data.Attributes }}
	{{ if $element.IsRequired }}
	fromRequest{{ $index }} := c.Param("{{ $element.Name }}")
	{{ else }}
	fromRequest{{ $index }} := c.QueryParam("{{ $element.Name }}")
	{{ end }}
	{{ if $element.IsInteger }}num, err := strconv.ParseInt(fromRequest{{ $index }}, 10, 64)
	if err != nil {
		return err
	}
	input{{$index}} := num
	{{ else if $element.IsFloat }}num, err := strconv.ParseFloat(fromRequest{{ $index }}, 64)
	if err != nil {
		return err
	}
	input{{$index}} := num
	{{ else }}input{{$index}} := fromRequest{{$index}}
	{{ end }}
	{{- end }}
	result, err := service.{{ $key | camelcase }}({{ range $index, $element := $val.Data.Attributes }}{{ if ne $element.GetBitNumber "" }}int{{$element.GetBitNumber}}(input{{$index}}){{ if ne $index $val.Data.Attributes.GetLastIndex }},{{ end }}{{ else }}input{{$index}}{{ if ne $index $val.Data.Attributes.GetLastIndex }},{{ end }}{{ end }}{{ end }})
	if err != nil {
		return err
	}
	return c.JSON(http.StatusOK, result)
}
{{ end }}

func RegisterHTTPPath(e *echo.Echo) {
	handler := httpHandler{}
	{{- range $key, $val := .Methods }}
	e.{{ $val.MethodsName }}("{{ $val.Path }}", handler.{{ $key }})
	{{- end }}
}