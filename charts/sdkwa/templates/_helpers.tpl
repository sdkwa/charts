{{/*
Expand the name of the chart.
*/}}
{{- define "sdkwa.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sdkwa.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "sdkwa.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "sdkwa.labels" -}}
helm.sh/chart: {{ include "sdkwa.chart" . }}
{{ include "sdkwa.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sdkwa.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sdkwa.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "sdkwa.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "sdkwa.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "sdkwa.postgresql.fullname" -}}
{{- if .Values.postgresql.fullnameOverride -}}
{{- .Values.postgresql.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.postgresql.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name "sdkwa-postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "sdkwa.redis.fullname" -}}
{{- if .Values.redis.fullnameOverride -}}
{{- .Values.redis.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.redis.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name "sdkwa-redis" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Set postgres host
*/}}
{{- define "sdkwa.postgresql.host" -}}
{{- if .Values.postgresql.enabled -}}
{{- template "sdkwa.postgresql.fullname" . -}}
{{- else -}}
{{- .Values.postgresql.postgresqlHost -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres secret
*/}}
{{- define "sdkwa.postgresql.secret" -}}
{{- if .Values.postgresql.enabled -}}
{{- template "sdkwa.postgresql.fullname" . -}}
{{- else -}}
{{- template "sdkwa.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres secretKey
*/}}
{{- define "sdkwa.postgresql.secretKey" -}}
{{- if .Values.postgresql.enabled -}}
"postgresql-password"
{{- else -}}
{{- default "postgresql-password" .Values.postgresql.auth.secretKeys.adminPasswordKey | quote -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres port
*/}}
{{- define "sdkwa.postgresql.port" -}}
{{- if .Values.postgresql.enabled -}}
    5432
{{- else -}}
{{- default 5432 .Values.postgresql.postgresqlPort -}}
{{- end -}}
{{- end -}}

{{/*
Set redis host
*/}}
{{- define "sdkwa.redis.host" -}}
{{- if .Values.redis.enabled -}}
{{- template "sdkwa.redis.fullname" . -}}-master
{{- else -}}
{{- .Values.redis.host }}
{{- end -}}
{{- end -}}

{{/*
Set redis secret
*/}}
{{- define "sdkwa.redis.secret" -}}
{{- if .Values.redis.enabled -}}
{{- template "sdkwa.redis.fullname" . -}}
{{- else -}}
{{- template "sdkwa.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Set redis secretKey
*/}}
{{- define "sdkwa.redis.secretKey" -}}
{{- if .Values.redis.enabled -}}
"redis-password"
{{- else -}}
{{- default "redis-password" .Values.redis.existingSecretPasswordKey | quote -}}
{{- end -}}
{{- end -}}

{{/*
Set redis port
*/}}
{{- define "sdkwa.redis.port" -}}
{{- if .Values.redis.enabled -}}
    6379
{{- else -}}
{{- default 6379 .Values.redis.port -}}
{{- end -}}
{{- end -}}

{{/*
Set redis password
*/}}
{{- define "sdkwa.redis.password" -}}
{{- if .Values.redis.enabled -}}
{{- default "redis" .Values.redis.auth.password -}}
{{- else -}}
{{- default "redis" .Values.redis.password -}}
{{- end -}}
{{- end -}}

{{/*
Set redis URL
*/}}
{{- define "sdkwa.redis.url" -}}
{{- if .Values.redis.enabled -}}
    redis://:{{ .Values.redis.auth.password }}@{{ template "sdkwa.redis.host" . }}:{{ template "sdkwa.redis.port" . }}
{{- else if .Values.env.REDIS_TLS -}}
    rediss://:$(REDIS_PASSWORD)@{{ .Values.redis.host }}:{{ .Values.redis.port }}
{{- else -}}
    redis://:$(REDIS_PASSWORD)@{{ .Values.redis.host }}:{{ .Values.redis.port }}
{{- end -}}
{{- end -}}
