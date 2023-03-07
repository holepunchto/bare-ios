#include <assert.h>
#include <pear.h>
#include <uv.h>

#include "main.bundle.h"

int
main (int argc, char *argv[]) {
  int err;

  argv = uv_setup_args(argc, argv);

  pear_t pear;
  err = pear_setup(uv_default_loop(), &pear, argc, argv);
  assert(err == 0);

  uv_buf_t source = uv_buf_init((char *) bundle, bundle_len);

  err = pear_run(&pear, "/main.bundle", &source);
  assert(err == 0);

  int exit_code;
  err = pear_teardown(&pear, &exit_code);
  assert(err == 0);

  return exit_code;
}
