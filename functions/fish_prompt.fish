# name: Gianu
function _git_branch_name
  echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
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

  if [ (_git_branch_name) ]
    # when in a git repo show the pwd relative to the git root
    set -l git_dir (command git rev-parse --show-toplevel)
    set -l relative_path (command realpath --relative-to="$git_dir" (pwd))

    if [ "$relative_path" = "." ]
      set relative_path ""
    else
      set relative_path "/$relative_path"
    end

    set cwd "$cyan" (prompt_pwd "$(basename $git_dir)$relative_path")

    set -l git_branch $green(_git_branch_name)
    set git_info "$normal($green$git_branch"

    if [ (_is_git_dirty) ]
      set -l dirty "$yellow ✗"
      set git_info "$git_info$dirty"
    end

    set git_info "$git_info$normal)"
  end

  echo -n -s $normal '[' $white (whoami) $normal '@' $red (hostname -s) $normal ' ' $cwd ' '  $git_info $normal ']$ '
end
