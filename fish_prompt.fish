# name: Gianu
function _git_branch_name
  echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _git_commit_hash
  echo (command git rev-parse --short HEAD 2> /dev/null)
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function fish_prompt
  set -l cyan (set_color cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l green (set_color -o green)
  set -l white (set_color -o white)
  set -l normal (set_color normal)

  set -l cwd $cyan(basename (prompt_pwd))

  set -l git_display (_git_branch_name)

  if [ ! $git_display ]
    set git_display (_git_commit_hash)
  end

  if [ $git_display ]
    # when in a git repo show the pwd relative to the git root
    set -l git_dir (command git rev-parse --show-toplevel)
    set -l relative_path (command realpath --relative-to="$git_dir" (pwd))

    if [ "$relative_path" = "." ]
      set relative_path ""
    else
      set relative_path "/$relative_path"
    end

    set cwd "$cyan" (prompt_pwd "$(basename $git_dir)$relative_path")
    set git_info "$normal($green$git_display"

    if [ (_is_git_dirty) ]
      set -l dirty "$yellow ✗"
      set git_info "$git_info$dirty"
    end

    set git_info "$git_info$normal)"
  end

  set -l output $normal '[' $white (whoami) $normal '@' $red (hostname -s) $normal ' ' $cwd ' ' $git_info $normal ']'

  echo -n -s $output

  set -l prompt_length (string length -V "$output")
  set -l remaining_space (math $COLUMNS - $prompt_length)

  if [ $remaining_space -le 50 ]
    echo
  end

  echo -n -s $normal "\$ "
end
