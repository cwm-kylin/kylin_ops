from django.conf.urls import patterns, include, url


urlpatterns = patterns('kylin_ops.views',
    # Examples:
    url(r'^$', 'index', name='index'),
    # url(r'^api/user/$', 'api_user'),
    url(r'^skin_config/$', 'skin_config', name='skin_config'),
    url(r'^login/$', 'Login', name='login'),
    url(r'^logout/$', 'Logout', name='logout'),
    url(r'^exec_cmd/$', 'exec_cmd', name='exec_cmd'),
    url(r'^file/upload/$', 'upload', name='file_upload'),
    url(r'^file/download/$', 'download', name='file_download'),
    url(r'^setting', 'setting', name='setting'),
    url(r'^terminal/$', 'web_terminal', name='terminal'),
    url(r'^usermanagers/', include('usermanagers.urls')),
    url(r'^asset/', include('asset.urls')),
    url(r'^kylin_log/', include('kylin_log.urls')),
    url(r'^permission/', include('permission.urls')),
)
