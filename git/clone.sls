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
{% endfor %}
