project('fcore', 'fortran', 'cpp')

ferror_proj = subproject('ferror')
ferror_dep = ferror_proj.get_variable('ferror_dep')

incDir = include_directories('include')

subdir('src')
fcore_lib = static_library('fcore', sources,
  dependencies: ferror_dep,
  include_directories: incDir)

fcore_dep = declare_dependency(link_with: fcore_lib)

executable('strings_example', 'examples/strings_example.f90',
  dependencies: fcore_dep)
