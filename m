Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC0330CDBF;
	Sat, 25 Oct 2025 16:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409407; cv=none; b=YYfmD8ruDyOtXlF5Y9kKV53MGTdvJ+P7+tG1gqnRTpxzg1ZEZeuOr09VvQbHNv0v9Z/QUs2flq6zhBPdXGk0sR2R1zVZWDTt1qHGjXnvj2QvN3HOdhONhNVE0VthnB6jFdswP3QobZjZVDFTVZpOpO1OpRWkHjxhdcSADLPkcI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409407; c=relaxed/simple;
	bh=+JWPeq66ZgliSKi8RN7Ifwh0FIgoMR4yXPN39vlrryw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ccUz1FtM3Pigh7Sjlg8FppnG7He7TRlOAHB7c5HnDGscGcjtle8ZM0WsT4pnF6iF7YxtZ/6ljzDgSR0arqWNdSERSDLBdI9WgFS+kEK1dmxZfueqw9+ZxXT696l/Q6lATATsWghyZtzVZwgLJJRhncAHfQlDS1JO2rUfw6Z/L6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TVDOCQy+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TVDOCQy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C2BC4CEF5;
	Sat, 25 Oct 2025 16:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409407;
	bh=+JWPeq66ZgliSKi8RN7Ifwh0FIgoMR4yXPN39vlrryw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVDOCQy+Y/kUuVpTkgLHLPPkrBLCY+IpK/4KHdIL9XdkELgeG/GS4NOOdL0KPz+s8
	 ooZZ4yAgiHeMBPhfFywL8M6yysW0oAksvQEIDe4RmYqDwwvSeye1wf8jouK89FkzxJ
	 blzZ817KrFr734zCQ540dLZTSTo1/hs+3CHk+eC4H2JCN8i5QahiSfdX1S7m64PW9/
	 UtT9tG/5Q2tFBCSamnz2IY6b3v+IPxk6MWOWB7tNURUIv7ZgZ45cWsrxEg6VnfOeWb
	 A3uOkgOFzcXmT38t37JS8pBsPS/JL+n/GrVV5FlJeryx4cFR4Hqd1Mzav0x71dmNHe
	 OwSjnF9//E6WA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Petr Machata <petrm@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] selftests: net: lib.sh: Don't defer failed commands
Date: Sat, 25 Oct 2025 11:59:00 -0400
Message-ID: <20251025160905.3857885-309-sashal@kernel.org>
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

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit fa57032941d4b451c7264ebf3ad595bc98e3a9a9 ]

Usually the autodefer helpers in lib.sh are expected to be run in context
where success is the expected outcome. However when using them for feature
detection, failure can legitimately occur. But the failed command still
schedules a cleanup, which will likely fail again.

Instead, only schedule deferred cleanup when the positive command succeeds.

This way of organizing the cleanup has the added benefit that now the
return code from these functions reflects whether the command passed.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/af10a5bb82ea11ead978cf903550089e006d7e70.1757004393.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - In tools/testing/selftests/net/lib.sh: wrapper helpers schedule
    deferred cleanups even when the “positive” command fails, and they
    unintentionally mask failures because the last executed command
    (defer) returns success. This leads to confusing follow-up errors
    and unreliable feature-detection logic.
  - The change makes deferred cleanup conditional on success and
    preserves the original command’s exit status, so failures are
    detected and reported correctly.

- Specific code changes
  - ip_link_add(): from running defer unconditionally to chaining with
    success, i.e. `ip link add ... && defer ip link del dev "$name"`
    (tools/testing/selftests/net/lib.sh).
  - ip_link_set_master(): `ip link set dev "$member" master "$master" &&
    defer ip link set dev "$member" nomaster`.
  - ip_link_set_addr(): captures `old_addr=$(mac_get "$name")` and only
    schedules rollback if setting the new address succeeds: `... &&
    defer ip link set dev "$name" address "$old_addr"`.
  - ip_link_set_up()/ip_link_set_down(): only schedule the opposite
    action if the set operation actually succeeded, e.g. `... && defer
    ip link set dev "$name" down/up`.
  - ip_addr_add(): `ip addr add dev "$name" "$@" && defer ip addr del
    dev "$name" "$@"`.
  - ip_route_add(): `ip route add "$@" && defer ip route del "$@"`.
  - bridge_vlan_add(): `bridge vlan add "$@" && defer bridge vlan del
    "$@"`.
  - Net effect: cleanup commands are deferred only after successful
    state changes; failure paths do not schedule doomed cleanups.

- Why it’s a good stable backport
  - User impact: Fixes real test flakiness and misleading pass/fail
    reporting in widely used net selftests. Feature detection can
    legitimately fail; previously that failure both scheduled a failing
    cleanup and could be hidden by a succeeding defer, making debugging
    hard.
  - Scope and size: Small, contained changes to a single selftests shell
    library file; no kernel/runtime code affected.
  - Risk profile: Minimal. The helpers now return the true result of the
    underlying ip/bridge command and don’t enqueue impossible cleanups.
    Tests that “passed” due to masked errors will start failing earlier
    and more clearly, which is the correct behavior.
  - Architecture/ABI: No architectural changes, no new features;
    strictly test reliability and correctness improvement.
  - Stable policy fit: Important bugfix for selftests that improves
    determinism and correctness with minimal risk.

- Side effects considered
  - Return codes of these helpers now reflect the command outcome. Any
    test inadvertently relying on the old, incorrect “always succeed”
    behavior may fail earlier, but that exposes pre-existing issues
    rather than introducing regressions.
  - Cleanup behavior in failure paths becomes a no-op (correct),
    avoiding secondary errors and noise.

Given the correctness fix, limited scope, and low risk, this commit is
well-suited for stable backporting.

 tools/testing/selftests/net/lib.sh | 32 +++++++++++++++---------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/net/lib.sh b/tools/testing/selftests/net/lib.sh
index c7add0dc4c605..80cf1a75136cf 100644
--- a/tools/testing/selftests/net/lib.sh
+++ b/tools/testing/selftests/net/lib.sh
@@ -547,8 +547,8 @@ ip_link_add()
 {
 	local name=$1; shift
 
-	ip link add name "$name" "$@"
-	defer ip link del dev "$name"
+	ip link add name "$name" "$@" && \
+		defer ip link del dev "$name"
 }
 
 ip_link_set_master()
@@ -556,8 +556,8 @@ ip_link_set_master()
 	local member=$1; shift
 	local master=$1; shift
 
-	ip link set dev "$member" master "$master"
-	defer ip link set dev "$member" nomaster
+	ip link set dev "$member" master "$master" && \
+		defer ip link set dev "$member" nomaster
 }
 
 ip_link_set_addr()
@@ -566,8 +566,8 @@ ip_link_set_addr()
 	local addr=$1; shift
 
 	local old_addr=$(mac_get "$name")
-	ip link set dev "$name" address "$addr"
-	defer ip link set dev "$name" address "$old_addr"
+	ip link set dev "$name" address "$addr" && \
+		defer ip link set dev "$name" address "$old_addr"
 }
 
 ip_link_has_flag()
@@ -590,8 +590,8 @@ ip_link_set_up()
 	local name=$1; shift
 
 	if ! ip_link_is_up "$name"; then
-		ip link set dev "$name" up
-		defer ip link set dev "$name" down
+		ip link set dev "$name" up && \
+			defer ip link set dev "$name" down
 	fi
 }
 
@@ -600,8 +600,8 @@ ip_link_set_down()
 	local name=$1; shift
 
 	if ip_link_is_up "$name"; then
-		ip link set dev "$name" down
-		defer ip link set dev "$name" up
+		ip link set dev "$name" down && \
+			defer ip link set dev "$name" up
 	fi
 }
 
@@ -609,20 +609,20 @@ ip_addr_add()
 {
 	local name=$1; shift
 
-	ip addr add dev "$name" "$@"
-	defer ip addr del dev "$name" "$@"
+	ip addr add dev "$name" "$@" && \
+		defer ip addr del dev "$name" "$@"
 }
 
 ip_route_add()
 {
-	ip route add "$@"
-	defer ip route del "$@"
+	ip route add "$@" && \
+		defer ip route del "$@"
 }
 
 bridge_vlan_add()
 {
-	bridge vlan add "$@"
-	defer bridge vlan del "$@"
+	bridge vlan add "$@" && \
+		defer bridge vlan del "$@"
 }
 
 wait_local_port_listen()
-- 
2.51.0

