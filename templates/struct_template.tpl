// GENERATED BY goruda
// This file was generated automatically at
// {{ .TimeStamp }}

 package {{.Packagename}}

 {{ if   (gt (len .Imports) 0) }}
import (
{{- range $key, $val := .Imports}}
		{{- if not (eq ($val.Alias) ($val.Path) ) }}
	{{$val.Alias}}  "{{$val.Path}}"
		{{- else }}
  "{{$val.Path}}"
		{{- end }}
{{- end}}
)
{{ end }}

{{ if .IsStructPolymorph }}
 type {{.StructName}} struct {
{{ else }}
 type {{.StructName | camelcase}} struct {
{{ end }}
	{{ range $i,$att :=  .Attributes -}}
	 {{  $att.Name | camelcase }}  {{$att.Type}}  `json:"{{$att.Name | snakecase}}"`
	{{ end -}}
}
{{ $structName := .StructName }}
{{ if .IsStructPolymorph }}
	{{- range $key, $val := .Attributes }}
		{{ if ne $val.Name "" }}
			func (p {{ $structName }}) To{{ $val.Type }}() {{$val.Type}} {
				return p.{{ $val.Name }}
			}
		{{ else }}
			func (p {{ $structName }}) To{{ $val.Type }}() {{$val.Type}} {
				return p.{{ $val.Type }}
			}
		{{ end }}
	{{- end }}
{{ end }}