#include "clar.h"
#include "clar_test.h"
#include <stdio.h>
#include <string.h>

static char *fixture_tex;
static char *fixture_mml;
static char *result;

void test_cornercases__initialize(void)
{
  global_test_counter++;
}

void test_cornercases__cleanup(void)
{
  if (fixture_tex != NULL) {
    free(fixture_tex);
  }

  if (fixture_mml != NULL) {
    free(fixture_mml);
  }

  if (result != NULL) {
    free(result);
  }
}

void test_cornercases__broken_up_inline_env(void)
{
  fixture_tex = read_fixture_tex("cornercases/broken_up_inline_env.txt");
  fixture_mml = read_fixture_mml("cornercases/broken_up_inline_env.html");
  result = mtex2MML_parse(fixture_tex, strlen(fixture_tex), MTEX2MML_DELIMITER_DEFAULT);

  cl_assert_equal_s(fixture_mml, result);
}

void test_cornercases__some_crazy_alignment(void)
{
  fixture_tex = read_fixture_tex("cornercases/some_crazy_alignment.txt");
  fixture_mml = read_fixture_mml("cornercases/some_crazy_alignment.html");
  result = mtex2MML_parse(fixture_tex, strlen(fixture_tex), MTEX2MML_DELIMITER_DEFAULT);

  cl_assert_equal_s(fixture_mml, result);
}

void test_cornercases__overflow(void)
{
  fixture_tex = read_fixture_tex("cornercases/overflow.txt");
  fixture_mml = read_fixture_mml("cornercases/overflow.html");
  result = mtex2MML_parse(fixture_tex, strlen(fixture_tex), MTEX2MML_DELIMITER_DOLLAR);

  cl_assert_equal_s(fixture_mml, result);
}
