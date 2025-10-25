Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A32C306496;
	Sat, 25 Oct 2025 16:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409621; cv=none; b=sG4ZPgZct39q87TgaDnuxnUp+1d/2DCZW0Rg8FjQISkR5JqcuhO8ddU1n6S6X2tjMK0bc7x9hIjeuwJuv3P9UsY9dGaRC9B/PRDRY3m6KnCSLPfU2eWSl4Bdca0stopdeAvVeHDHNPYSNNsvT82dZdfgt3wW26CaZYwUUaoJAmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409621; c=relaxed/simple;
	bh=lHXmSwpImaguJhdytnV4YsY9kThpja29e6/NdiB7iMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MpipLN6Mx2pE4QAXiUcTPdwzNEWunXfKSU2pUYPQ6xsZLhOmdO6woGogPCmuJWrvBc2Am3lKmlgX7RKvbihOxcJ6jMGRLmf9H26UpI6BdrPT2HNWf3foFX8svlyg6EkBIhRmnDBujPAG40ANGB8kYUXg9yfIdeduxbhLvPoV8fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZUasmcCT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZUasmcCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECAFC116D0;
	Sat, 25 Oct 2025 16:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409619;
	bh=lHXmSwpImaguJhdytnV4YsY9kThpja29e6/NdiB7iMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZUasmcCTXbIjeng+GBJyJ6uUiRjCpO8nbxm/mJsqTge0QDj2AFHmmgzNG6f/dQ0YL
	 kr2ZpWnNRQwraeeeYleD4FaNzoJNVN5JfYAAPK8vNap5rl4GnQqMQWgOfb4E7WSFIh
	 40WlsR57EggAL7csOK91Eb/J8IXcfukb5ZwgGfUpo9BxXmXghx562+Tnh0G6ZoUW22
	 42KbxXV7lTBByQezDPdX/wxbizQspKAV2T3imEjQdF+/rFKSm9mtqjPsWY5NDbiCRM
	 Dwt9ssXw4tgl5ur5D085hMXGeTIUY5ZvCISmBYAJ+1v6Yx1cwsgjKeU+9K0rftGeT6
	 Vc+tXd1OdBhBA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	martineau@kernel.org,
	netdev@vger.kernel.org,
	mptcp@lists.linux.dev
Subject: [PATCH AUTOSEL 6.17-6.12] selftests: mptcp: join: allow more time to send ADD_ADDR
Date: Sat, 25 Oct 2025 12:00:27 -0400
Message-ID: <20251025160905.3857885-396-sashal@kernel.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit e2cda6343bfe459c3331db5afcd675ab333112dd ]

When many ADD_ADDR need to be sent, it can take some time to send each
of them, and create new subflows. Some CIs seem to occasionally have
issues with these tests, especially with "debug" kernels.

Two subtests will now run for a slightly longer time: the last two where
3 or more ADD_ADDR are sent during the test.

Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250907-net-next-mptcp-add_addr-retrans-adapt-v1-3-824cc805772b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed: The patch slows two MPTCP selftests that signal three
  addresses to reduce flakiness. It injects `speed=slow` for the “signal
  addresses” and “signal invalid addresses” subtests so `run_tests` runs
  in slow mode:
  - tools/testing/selftests/net/mptcp/mptcp_join.sh:2271-2272 sets
    `speed=slow` before `run_tests` in the “signal addresses” block.
  - tools/testing/selftests/net/mptcp/mptcp_join.sh:2284-2285 sets
    `speed=slow` before `run_tests` in the “signal invalid addresses”
    block.

- How it works: `speed=slow` is consumed by `do_transfer()` which maps
  it to `-r 50` for `mptcp_connect`:
  - Default/dispatch:
    tools/testing/selftests/net/mptcp/mptcp_join.sh:953 defines `local
    speed=${speed:-"fast"}` and at 967-972 maps `fast`→`-j`, `slow`→`-r
    50`, or numeric speed→`-r <num>`.
  - mptcp_connect semantics: the `-r` option enables “slow mode,
    limiting each write to num bytes,” giving the protocol time to
    exchange ADD_ADDR and create subflows
    (tools/testing/selftests/net/mptcp/mptcp_connect.c:132, parsed in
    1426 and handled in the ‘r’ case 1444-1450).

- Why it’s needed: With three or more ADD_ADDR to send, debug kernels
  and slower CI runners can time out or not complete subflow setup
  before data transfer finishes. Slowing writes increases the window for
  address signaling and subflow establishment, improving determinism.
  This aligns with existing practice elsewhere in the script where many
  subtests already run with `speed=slow` for similar reasons (e.g.,
  numerous `speed=slow` calls throughout the file).

- Scope and risk:
  - Test-only: Changes are confined to
    `tools/testing/selftests/net/mptcp/mptcp_join.sh` and do not touch
    kernel code paths or ABIs.
  - Minimal and contained: Two call sites adjusted; no logic or
    expectations changed, only pacing.
  - Low regression risk: Only increases runtime slightly for two
    subtests; expected counts remain the same (e.g., still `chk_join_nr
    3 3 3` and `chk_add_nr 3 3` in
    tools/testing/selftests/net/mptcp/mptcp_join.sh:2273-2274; and
    unchanged checks after the invalid addresses case at 2286-2288).

- Stable-policy fit:
  - Fixes test flakiness affecting CI/users running stable selftests
    (practical impact for validation).
  - No new features or architectural changes; very small diff; conforms
    to stable rules for low-risk test fixes.
  - No “Cc: stable” tag, but the change is a clear reliability fix for
    selftests, which stable trees commonly accept to keep test suites
    meaningful.

Given it’s a tiny, isolated selftest reliability improvement with no
kernel-side risk and tangible benefit for CI stability, it is suitable
for backporting.

 tools/testing/selftests/net/mptcp/mptcp_join.sh | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 8e92dfead43bf..fed14a281a6d9 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2151,7 +2151,8 @@ signal_address_tests()
 		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
 		pm_nl_set_limits $ns2 3 3
-		run_tests $ns1 $ns2 10.0.1.1
+		speed=slow \
+			run_tests $ns1 $ns2 10.0.1.1
 		chk_join_nr 3 3 3
 		chk_add_nr 3 3
 	fi
@@ -2163,7 +2164,8 @@ signal_address_tests()
 		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.14.1 flags signal
 		pm_nl_set_limits $ns2 3 3
-		run_tests $ns1 $ns2 10.0.1.1
+		speed=slow \
+			run_tests $ns1 $ns2 10.0.1.1
 		join_syn_tx=3 \
 			chk_join_nr 1 1 1
 		chk_add_nr 3 3
-- 
2.51.0

