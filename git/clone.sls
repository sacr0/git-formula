include:
  - git

{%- for repo, setting in salt['pillar.get']('git:latest', {}).iteritems() %}

git_directory_{{ repo }}:
    file.directory:
    - name: {{ setting.get("target_folder") }}
    {%- if setting.get('dir_user',False) %}
    - user: {{ setting.get("dir_user") }}
    {%- endif %}
    {%- if setting.get('dir_group',False) %}
    - group: {{ setting.get("dir_group") }}
    {%- endif %}
    {%- if setting.get('dir_mode',False) %}
    - dir_mode: {{ setting.get("dir_mode") }}
    {%- endif %}
    - makedirs: True

git_repo_{{ repo }}:
  git.latest:
    - name: {{ setting.get("repo_url") }}
    - target: {{ setting.get("target_folder") }}
    {%- if setting.get('identity',False) %}
    - identity: {{ setting.get("identity") }}
    {%- endif %}
    {%- if setting.get('http_user',False) %}
    - http_user: {{ setting.get("http_user") }}
    {%- endif %}
    {%- if setting.get('http_pass',False) %}
    - http_pass: {{ setting.get("http_pass") }}
    {%- endif %}
    {%- if setting.get('branch',False) %}
    - branch: {{ setting.get("branch") }}
    {%- endif %}
    {%- if setting.get('submodules',False) %}
    - submodules: {{ setting.get("submodules") }}
    {%- endif %}
    {%- if setting.get('force_clone',False) %}
    - force_clone: {{ setting.get("force_clone") }}
    {%- endif %}
    - require:
      - file: git_directory_{{ repo }}
    {%- for require_name, require_setting in setting.get('require', {}).iteritems() %}
      require_setting.get("type"): require_setting.get("name")
    {% endfor %}
    {%- if setting.get('watch_in') %}
    - watch_in:
    {%- for watchin_name, watchin_setting in setting.get('watch_in', {}).iteritems() %}
      watchin_setting.get("type"): watchin_setting.get("name")
    {% endfor %}
    {%- endif %}

{%- if setting.get('auto-update') %} 
git_repo_{{ repo }}_cronjob:
  cron.present:
    - name: "git -C {{ setting.get("target_folder") }} pull"
    - identifier: "git repo - auto update: {{ repo }}"
    {%- for variable, value in setting.get('auto-update',{}).iteritems() %}
    - {{variable}}: '{{value}}'
    {%- endfor %}
{%- endif %}
{% endfor %}
