Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED6E2F5B;
	Sat, 25 Oct 2025 16:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408772; cv=none; b=s2QVae2r5qxW4TxydEEZFfBdFz7Oh7bme3hrrp2BFa3bjgJdUx1Bjfw3XgmQYUK5TG/o+T0Kof9o78GNiaKCRmborVaH++fxcub5oxPO6pWasnAHcsOyvdXzidZOXp6F8tqw/iHN2tJB+MXmdDT7TlqGrQL8kAxhJwMcHSLdx2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408772; c=relaxed/simple;
	bh=urn2WeO975c1UiyO3/5DKndRBTtTAN36cfg8QLLSjq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FRCvVgoSomFf9V0LRx7Epl5UvuXcVreqieahB6g+g48k7YaQaBw1A0qTso7iPft3SgJA66sBFj7WtulJxN7G9e/MUlMOLzRHmC5tXrYNzPJp02RuFDyRJkNzO1LNQwRDqU2SGwKlCw/+WhfR+IHRhu7itUKfZ8pu5OBto8Wczko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=utuNb0BD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="utuNb0BD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0758BC4CEFB;
	Sat, 25 Oct 2025 16:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408771;
	bh=urn2WeO975c1UiyO3/5DKndRBTtTAN36cfg8QLLSjq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utuNb0BDmWS2qHLLV8mrSDeFxg0bGR7lC7rUH/q8HNhr7FPl0RnL5h9Exz+ukqhle
	 BZ1uNLOMy6tLgq+/n8PshoVfWpUqmQ3CzQuQNCUNEdh5rZ0WHMJRCu7dPYRwIGf5AE
	 jZNo8l+Tn2H9SahHDoUO/zeGBozR0yuX68zyMriLNycE8Nrly7uQcTGBzSB6wYzZ/X
	 0wSOI7dskFBOkh4fJvlba4/hyA3AJXazMkKC0V9qjU9D3jD2Gol3LoER6C3SyTCBEp
	 V+FlqR7XYlKPsWLI3S3/pbzISiZXu9LMFe7dsFKxkQIZhNOEiGI+RRzZ5nRBMU1/ZV
	 dBMp228ofzx9A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	Joe Damato <joe@dama.to>,
	Sasha Levin <sashal@kernel.org>,
	pabeni@redhat.com,
	willemb@google.com,
	daniel.zahka@gmail.com,
	leitao@debian.org,
	alexandre.f.demers@gmail.com,
	cjubran@nvidia.com,
	mohsin.bashr@gmail.com,
	petrm@nvidia.com,
	sumanth.gavini@yahoo.com,
	alexander.deucher@amd.com,
	gal@nvidia.com,
	sdf@fomichev.me
Subject: [PATCH AUTOSEL 6.17] selftests: drv-net: wait for carrier
Date: Sat, 25 Oct 2025 11:54:56 -0400
Message-ID: <20251025160905.3857885-65-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit f09fc24dd9a5ec989dfdde7090624924ede6ddc7 ]

On fast machines the tests run in quick succession so even
when tests clean up after themselves the carrier may need
some time to come back.

Specifically in NIPA when ping.py runs right after netpoll_basic.py
the first ping command fails.

Since the context manager callbacks are now common NetDrvEpEnv
gets an ip link up call as well.

Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20250812142054.750282-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Rationale
- Fixes real flakiness in selftests: The commit addresses a race where
  subsequent tests (e.g., `ping.py`) run immediately after
  `netpoll_basic.py` and the first ping fails because carrier has not
  come back yet. This is a correctness fix for the test suite, improving
  determinism and reliability, not a feature.
- Small, contained change in selftests only: All changes are confined to
  the Python selftests support code under `tools/testing/selftests/`,
  with no impact on kernel runtime or ABIs. Risk of regression to kernel
  behavior is essentially zero.
- Concrete synchronization mechanism:
  - Adds `wait_file()` utility to poll a file until a condition is met,
    with timeout, avoiding hangs and tight loops. File:
    tools/testing/selftests/net/lib/py/utils.py:235.
  - Uses `wait_file()` to wait for `/sys/class/net/<ifname>/carrier` to
    become “1” (link up) after setting the device up. This directly
    addresses transient carrier state issues that cause intermittent
    test failures. File:
    tools/testing/selftests/drivers/net/lib/py/env.py:1 (imports) and
    env base class `__enter__` addition around the top of the file.
- Unifies context manager behavior across environments:
  - Moves the context manager setup (`__enter__/__exit__`) into the
    common base class (`NetDrvEnvBase`), so both `NetDrvEnv` and
    `NetDrvEpEnv` now ensure the interface is up and carrier is ready
    when entering a test. File:
    tools/testing/selftests/drivers/net/lib/py/env.py:1 (new
    `NetDrvEnvBase.__enter__`); removal of per-class
    `__enter__/__exit__` in `NetDrvEnv` and `NetDrvEpEnv`.
  - This directly ensures `NetDrvEpEnv` (used by `ping.py` and
    `netpoll_basic.py`) will “ip link up” and wait for carrier as the
    commit message highlights.
- Proper symbol exposure:
  - Re-exports `wait_file` through the local shim so existing `from
    lib.py import ...` imports continue to work. File:
    tools/testing/selftests/drivers/net/lib/py/__init__.py:1 (adds
    `wait_file` to the import list from `net.lib.py`).

Risk and dependencies
- Behavior change is localized to selftests and limited to environment
  setup:
  - The only externally observable change is a short wait (up to 5s)
    during test setup if carrier is not immediately present; this
    reduces false failures and timeouts are enforced (`TimeoutError`)
    rather than hanging. File:
    tools/testing/selftests/net/lib/py/utils.py:235 (`deadline=5`
    defval).
- Dependencies align with existing tree layout:
  - The underlying `tools/testing/selftests/net/lib/py` library is
    present and already re-exported through
    `drivers/.../lib/py/__init__.py`, so adding `wait_file` and
    importing it in `env.py` is consistent with the existing import
    patterns.
- Potential side effects are positive:
  - `NetDrvEpEnv` now also ensures the link is up on entry, which is
    typically what these tests assume. Tests that need link-down can
    still change link state after entering the context.

Stable backport criteria
- Important bug fix: Resolves intermittent failures in widely used
  driver selftests (affects users running CI or developers verifying
  backports).
- Minimal risk and scope: Python-only selftest changes; no architectural
  kernel changes; no feature additions.
- No broader side effects: Only test execution behavior
  (synchronization) is adjusted.
- Even without explicit “Cc: stable”, this kind of selftest-stability
  fix is appropriate for stable to keep selftests reliable across
  branches.

Conclusion
- This commit is a good candidate for stable backports: it fixes real
  flakiness with a small, targeted change to selftests, carries minimal
  regression risk, and improves consistency by centralizing the carrier
  wait in the common environment setup.

 .../selftests/drivers/net/lib/py/__init__.py  |  2 +-
 .../selftests/drivers/net/lib/py/env.py       | 41 +++++++++----------
 tools/testing/selftests/net/lib/py/utils.py   | 18 ++++++++
 3 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/lib/py/__init__.py b/tools/testing/selftests/drivers/net/lib/py/__init__.py
index 8711c67ad658a..a07b56a75c8a6 100644
--- a/tools/testing/selftests/drivers/net/lib/py/__init__.py
+++ b/tools/testing/selftests/drivers/net/lib/py/__init__.py
@@ -15,7 +15,7 @@ try:
         NlError, RtnlFamily, DevlinkFamily
     from net.lib.py import CmdExitFailure
     from net.lib.py import bkg, cmd, bpftool, bpftrace, defer, ethtool, \
-        fd_read_timeout, ip, rand_port, tool, wait_port_listen
+        fd_read_timeout, ip, rand_port, tool, wait_port_listen, wait_file
     from net.lib.py import fd_read_timeout
     from net.lib.py import KsftSkipEx, KsftFailEx, KsftXfailEx
     from net.lib.py import ksft_disruptive, ksft_exit, ksft_pr, ksft_run, \
diff --git a/tools/testing/selftests/drivers/net/lib/py/env.py b/tools/testing/selftests/drivers/net/lib/py/env.py
index 1b8bd648048f7..c1f3b608c6d8f 100644
--- a/tools/testing/selftests/drivers/net/lib/py/env.py
+++ b/tools/testing/selftests/drivers/net/lib/py/env.py
@@ -4,7 +4,7 @@ import os
 import time
 from pathlib import Path
 from lib.py import KsftSkipEx, KsftXfailEx
-from lib.py import ksft_setup
+from lib.py import ksft_setup, wait_file
 from lib.py import cmd, ethtool, ip, CmdExitFailure
 from lib.py import NetNS, NetdevSimDev
 from .remote import Remote
@@ -25,6 +25,9 @@ class NetDrvEnvBase:
 
         self.env = self._load_env_file()
 
+        # Following attrs must be set be inheriting classes
+        self.dev = None
+
     def _load_env_file(self):
         env = os.environ.copy()
 
@@ -48,6 +51,22 @@ class NetDrvEnvBase:
                 env[pair[0]] = pair[1]
         return ksft_setup(env)
 
+    def __del__(self):
+        pass
+
+    def __enter__(self):
+        ip(f"link set dev {self.dev['ifname']} up")
+        wait_file(f"/sys/class/net/{self.dev['ifname']}/carrier",
+                  lambda x: x.strip() == "1")
+
+        return self
+
+    def __exit__(self, ex_type, ex_value, ex_tb):
+        """
+        __exit__ gets called at the end of a "with" block.
+        """
+        self.__del__()
+
 
 class NetDrvEnv(NetDrvEnvBase):
     """
@@ -72,17 +91,6 @@ class NetDrvEnv(NetDrvEnvBase):
         self.ifname = self.dev['ifname']
         self.ifindex = self.dev['ifindex']
 
-    def __enter__(self):
-        ip(f"link set dev {self.dev['ifname']} up")
-
-        return self
-
-    def __exit__(self, ex_type, ex_value, ex_tb):
-        """
-        __exit__ gets called at the end of a "with" block.
-        """
-        self.__del__()
-
     def __del__(self):
         if self._ns:
             self._ns.remove()
@@ -219,15 +227,6 @@ class NetDrvEpEnv(NetDrvEnvBase):
             raise Exception("Can't resolve remote interface name, multiple interfaces match")
         return v6[0]["ifname"] if v6 else v4[0]["ifname"]
 
-    def __enter__(self):
-        return self
-
-    def __exit__(self, ex_type, ex_value, ex_tb):
-        """
-        __exit__ gets called at the end of a "with" block.
-        """
-        self.__del__()
-
     def __del__(self):
         if self._ns:
             self._ns.remove()
diff --git a/tools/testing/selftests/net/lib/py/utils.py b/tools/testing/selftests/net/lib/py/utils.py
index f395c90fb0f19..c42bffea0d879 100644
--- a/tools/testing/selftests/net/lib/py/utils.py
+++ b/tools/testing/selftests/net/lib/py/utils.py
@@ -249,3 +249,21 @@ def wait_port_listen(port, proto="tcp", ns=None, host=None, sleep=0.005, deadlin
         if time.monotonic() > end:
             raise Exception("Waiting for port listen timed out")
         time.sleep(sleep)
+
+
+def wait_file(fname, test_fn, sleep=0.005, deadline=5, encoding='utf-8'):
+    """
+    Wait for file contents on the local system to satisfy a condition.
+    test_fn() should take one argument (file contents) and return whether
+    condition is met.
+    """
+    end = time.monotonic() + deadline
+
+    with open(fname, "r", encoding=encoding) as fp:
+        while True:
+            if test_fn(fp.read()):
+                break
+            fp.seek(0)
+            if time.monotonic() > end:
+                raise TimeoutError("Wait for file contents failed", fname)
+            time.sleep(sleep)
-- 
2.51.0

