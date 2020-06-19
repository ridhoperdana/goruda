// GENERATED BY goruda
// This file was generated automatically at
// {{ .TimeStamp }}

package delivery

import (
	"net/http"
	{{ .PackageName }} "github.com/golangid/goruda/generated"
	"github.com/labstack/echo"
	"strconv"
)
{{ $packageName := .PackageName }}{{ $implementationName := print .ServiceName "Implementation" }}{{ $serviceName := .ServiceName }}
type httpHandler struct {
	service {{ $packageName }}.{{ $serviceName }}
}
{{ range $key, $val := .Methods }}
func (h httpHandler) {{ $key }}(c echo.Context) error {
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
	result, err := h.service.{{ $key | camelcase }}({{ range $index, $element := $val.Data.Attributes }}{{ if ne $element.GetBitNumber "" }}int{{$element.GetBitNumber}}(input{{$index}}){{ if ne $index $val.Data.Attributes.GetLastIndex }},{{ end }}{{ else }}input{{$index}}{{ if ne $index $val.Data.Attributes.GetLastIndex }},{{ end }}{{ end }}{{ end }})
	if err != nil {
		return err
	}
	return c.JSON(http.StatusOK, result)
}
{{ end }}

func RegisterHTTPPath(e *echo.Echo, service {{ $packageName }}.{{ $serviceName }}) {
	handler := httpHandler{
		service: service,
	}
	{{- range $key, $val := .Methods }}
	e.{{ $val.MethodsName }}("{{ $val.Path }}", handler.{{ $key }})
	{{- end }}
}
