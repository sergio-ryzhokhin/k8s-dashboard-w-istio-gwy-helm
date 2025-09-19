{{/* vim: set filetype=mustache: */}}
{{/*
    Pack up tls certificate details to use in corresponding secret
*/}}
{{- define "kubernetes-dashboard.proxy-certs" -}}
{{- $cert := dict "Cert" "" "Key" "" -}}
{{- if and (.Values.customTlsCertFile) (.Values.customTlsKeyFile) -}}
{{- $cert = dict "Cert" ( .Files.Get .Values.customTlsCertFile ) "Key" ( .Files.Get .Values.customTlsKeyFile ) -}}
{{- else -}}
{{- $cert = genSelfSignedCert ( .Values.domain ) nil (list .Values.domain) 3650 -}}
{{- end -}}
tls.crt: {{ $cert.Cert | b64enc }}
tls.key: {{ $cert.Key | b64enc }}
{{- end }}

{{/*
TLS Secret annotations
*/}}
{{- define "kubernetes-dashboard.tls-secret-annotations" -}}
{{- with .Values.tlsSecretAnnotations }}
{{- toYaml . }}
{{- end }}
{{- end -}}
