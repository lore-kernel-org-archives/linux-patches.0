Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492A113AD3F;
	Sat, 25 Oct 2025 16:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409291; cv=none; b=S1ys2nK3Zd6dq3hcpCknIbADtFqWYv6GYsPpU1YiQM+lhd1M2oU3X0KTUXEaM/SPaWGUEVNasjFlFqu0Zeuz4+DG+KiodK5gCtKx5JHAm+0w9jsTrDE5J2HlNh+f0HFtv6zO33smTQ/sylia6sKx1UkcnPIcppL3ynTpui1vvjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409291; c=relaxed/simple;
	bh=/7yW/7ABDtGd2JvoNcs5fYGhavF3L5m8oxiPXgDUZPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NLru+qjV6d+TP5qYDuWcHFkWvwqP8c5bCB/pJlALxqV52Fi74svmOcmtcIIWComYJtH0CvcESMmt3EDZL0UBbWYlyX51gTCzUEW7P5dn3ilKCKe5h8B5580DaHU4ACgChq1SOvUgCVrst4Z7/jNIlW7XI+L/j5MvVTJd1Jw0h60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eSbM8DW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eSbM8DW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B6DC19422;
	Sat, 25 Oct 2025 16:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409291;
	bh=/7yW/7ABDtGd2JvoNcs5fYGhavF3L5m8oxiPXgDUZPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eSbM8DW3uvp0KkjMHzFHKvQAGGszzzO8+2xoTnkNeTLh2bjbVI48O37TWBTmzDsLZ
	 YlqLPw0sbxUh5n5bwpgdve/QMhoPLLWk//DmJpouqMxrnwo9FdrEfhS2CV0boNlLG4
	 JubTAExb3lrYkTyEYjyI1/m/C6p0Er6+TI04Q+wNS60JUCTiQMSd3CwXtHk4rpLKDI
	 q6e3XaTvJoyiFakJBnNYh+z4gQaqiaWK68x0ThDc99DkZL0vkAZNXKtHN0D4pfkzrP
	 hHU6bgCaoE59eFXRgWHuTTxlSSHDojhNU2ibMtXGdKlFLAJhQhWtQGyFz4kcXe5ejY
	 Z2cawOPwrWJ2w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	Joe Damato <joe@dama.to>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sasha Levin <sashal@kernel.org>,
	willemb@google.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17] selftests: drv-net: devmem: flip the direction of Tx tests
Date: Sat, 25 Oct 2025 11:58:14 -0400
Message-ID: <20251025160905.3857885-263-sashal@kernel.org>
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

[ Upstream commit c378c497f3fe8dc8f08b487fce49c3d96e4cada8 ]

The Device Under Test should always be the local system.
While the Rx test gets this right the Tx test is sending
from remote to local. So Tx of DMABUF memory happens on remote.

These tests never run in NIPA since we don't have a compatible
device so we haven't caught this.

Reviewed-by: Joe Damato <joe@dama.to>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20250811231334.561137-6-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation

- Fixes a real test bug
  - The commit corrects the Tx direction so the Device Under Test (DUT)
    is always the local system, matching the stated intent. Previously,
    the Tx path was exercised on the remote host, defeating the purpose
    of the test.

- Precise changes and their effect
  - tools/testing/selftests/drivers/net/hw/devmem.py: check_tx
    - Before: local ran the listener; remote invoked the devmem binary
      (Tx ran on remote)
      - `with bkg(listen_cmd) as socat:`
      - `wait_port_listen(port)`
      - `cmd(... {cfg.bin_remote} -f {cfg.ifname} -s {cfg.addr} -p
        {port}, host=cfg.remote, ...)`
    - After: remote runs the listener; local invokes the devmem binary
      (Tx runs on local)
      - `with bkg(listen_cmd, host=cfg.remote, exit_wait=True) as socat`
      - `wait_port_listen(port, host=cfg.remote)`
      - `cmd(... {cfg.bin_local} -f {cfg.ifname} -s {cfg.remote_addr} -p
        {port}, ...)`
    - Key corrections:
      - Move the listener to the remote host via `host=cfg.remote`,
        aligning with how Rx is validated (DUT local, peer remote).
      - Run the devmem-capable sender locally by switching
        `{cfg.bin_remote}` → `{cfg.bin_local}`.
      - Fix the server IP argument from `{cfg.addr}` (local) →
        `{cfg.remote_addr}` (remote).
      - Add `exit_wait=True` to ensure proper capture of remote `socat`
        output for assertion.
  - tools/testing/selftests/drivers/net/hw/devmem.py: check_tx_chunks
    - Applies the same direction flip as `check_tx`, and keeps the
      chunking parameter (`-z 3`) intact:
      - Listener moved to remote: `with bkg(listen_cmd, host=cfg.remote,
        exit_wait=True) ...`
      - Sender is local: `{cfg.bin_local} -f {cfg.ifname} -s
        {cfg.remote_addr} -p {port} -z 3`
  - tools/testing/selftests/drivers/net/hw/devmem.py: check_rx
    - Unchanged; already had the DUT local, running `ncdevmem -l` and
      receiving data from remote via `socat`, consistent with the
      intended direction.

- Why this fits stable rules
  - Important test fix: Corrects which system is being tested for Tx,
    preventing false confidence and misattribution of
    failures/successes.
  - Small and contained: Touches a single selftest file and only flips
    host roles and parameters; no kernel code changes.
  - Minimal regression risk: Uses established helpers (`bkg(...,
    host=cfg.remote, exit_wait=True)`, `wait_port_listen(...,
    host=cfg.remote)`) already used elsewhere (e.g.,
    `tools/testing/selftests/drivers/net/ping.py`) and preserves the
    test assertions (`ksft_eq(socat.stdout.strip(), "hello\nworld")`).
  - No features or architectural changes: Pure test orchestration fix.
  - Broader impact: Improves reliability of selftests for
    NET_DEVMEM/DMABUF Tx validation.

- Dependencies and applicability
  - Assumes the selftest suite already contains `devmem.py` and a
    version of the `ncdevmem` tool that supports the usage invoked here
    (client-side send without `-l`). Branches lacking this test or the
    necessary `ncdevmem` capabilities do not need this backport.
  - For branches where `devmem.py` exists with the original bug, this
    change is directly applicable and beneficial.

Given it is a minimal, clearly correct selftest-only bugfix that aligns
the Tx test with stated DUT semantics, it is suitable for stable
backporting where the test exists.

 tools/testing/selftests/drivers/net/hw/devmem.py | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/hw/devmem.py b/tools/testing/selftests/drivers/net/hw/devmem.py
index 0a2533a3d6d60..45c2d49d55b61 100755
--- a/tools/testing/selftests/drivers/net/hw/devmem.py
+++ b/tools/testing/selftests/drivers/net/hw/devmem.py
@@ -42,9 +42,9 @@ def check_tx(cfg) -> None:
     port = rand_port()
     listen_cmd = f"socat -U - TCP{cfg.addr_ipver}-LISTEN:{port}"
 
-    with bkg(listen_cmd) as socat:
-        wait_port_listen(port)
-        cmd(f"echo -e \"hello\\nworld\"| {cfg.bin_remote} -f {cfg.ifname} -s {cfg.addr} -p {port}", host=cfg.remote, shell=True)
+    with bkg(listen_cmd, host=cfg.remote, exit_wait=True) as socat:
+        wait_port_listen(port, host=cfg.remote)
+        cmd(f"echo -e \"hello\\nworld\"| {cfg.bin_local} -f {cfg.ifname} -s {cfg.remote_addr} -p {port}", shell=True)
 
     ksft_eq(socat.stdout.strip(), "hello\nworld")
 
@@ -56,9 +56,9 @@ def check_tx_chunks(cfg) -> None:
     port = rand_port()
     listen_cmd = f"socat -U - TCP{cfg.addr_ipver}-LISTEN:{port}"
 
-    with bkg(listen_cmd, exit_wait=True) as socat:
-        wait_port_listen(port)
-        cmd(f"echo -e \"hello\\nworld\"| {cfg.bin_remote} -f {cfg.ifname} -s {cfg.addr} -p {port} -z 3", host=cfg.remote, shell=True)
+    with bkg(listen_cmd, host=cfg.remote, exit_wait=True) as socat:
+        wait_port_listen(port, host=cfg.remote)
+        cmd(f"echo -e \"hello\\nworld\"| {cfg.bin_local} -f {cfg.ifname} -s {cfg.remote_addr} -p {port} -z 3", shell=True)
 
     ksft_eq(socat.stdout.strip(), "hello\nworld")
 
-- 
2.51.0

