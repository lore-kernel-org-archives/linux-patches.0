Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACAC305044;
	Sat, 25 Oct 2025 16:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409071; cv=none; b=EROmKMXbq3jZW6mjA6cXJVQM2W/ACrd+9G90J0WJzX1Wo9eqit6pTks2AJzXtM4dVI0gPm3w1WCydoyw287w5+K49EJMHJ11kZOHIQyN71LV4IQhkGyvPHEWiB8T57kPZm8p9qcYoV2JEdMfnpedWaI50WKxMTyjhzamdlM7MPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409071; c=relaxed/simple;
	bh=oi0FjETQX+W7dZXME9M5RtKaF9y51UgpKRa6LGQ2e20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dvXhpKIy/003g6IvmZGLXF6UVwvw15cLWsWlB8oA4pEiasUn4syiO4MVgphD8XleU1vz6hFxghr9VTtCE26rX0AiJEPQrsV9UMn7r1xSboK2x0LC+p0lYGN+tAfjRsgpZR5TnxMpHVskGUV8TXw9cZX/AxTKETcwsy7MrPl7rDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SRIuMW8w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SRIuMW8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51DAC4CEFF;
	Sat, 25 Oct 2025 16:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409070;
	bh=oi0FjETQX+W7dZXME9M5RtKaF9y51UgpKRa6LGQ2e20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRIuMW8wOi3LJI3MqIWkQMkFU/UdFLS+ZXn5uGwCDlJUHuG28W4sUtkRMG1LSfBZ+
	 LbJgTdHUpl2iAVaypHoQ/5TF7hCi3xvbFSML/S6+dGdKPGfaX7ha6oxZn7R0owf7xN
	 1h1KsVvN/k/61Qr5cb01fZUCRsDRsUyFeObI3LnWT7lce651uclIsS1n6qf1C7mrRp
	 5x6+lwEUt7qh53mpq+L5zmim8/hBf4rQXtCTSSwlxCOMX5ysTi1zuu/D5Cgl4rAASE
	 nYypphyOh1zhJrjBXmZZFm0Ro0fCLjvawDIMYCXWEAvpOig8agXFpOMje8eCNwkA1o
	 /M2WCJCUt2IjA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Ahern <dsahern@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.4] selftests: Disable dad for ipv6 in fcnal-test.sh
Date: Sat, 25 Oct 2025 11:57:02 -0400
Message-ID: <20251025160905.3857885-191-sashal@kernel.org>
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

From: David Ahern <dsahern@kernel.org>

[ Upstream commit 53d591730ea34f97a82f7ec6e7c987ca6e34dc21 ]

Constrained test environment; duplicate address detection is not needed
and causes races so disable it.

Signed-off-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250910025828.38900-1-dsahern@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

**Rationale**
- Fixes real test flakiness: IPv6 Duplicate Address Detection (DAD) in
  constrained netns-based selftests can leave addresses “tentative” and
  create timing races. Disabling DAD makes IPv6 addresses usable
  immediately, eliminating nondeterministic failures the commit message
  calls out.
- Small, surgical change: Adds two `sysctl` writes in the namespace
  setup function to disable DAD; no broader logic changes.
- Consistent with existing practice: Many net selftests already disable
  DAD to stabilize execution, so this aligns `fcnal-test.sh` with the
  rest of the suite.

**Scope and Risk**
- Test-only change under `tools/testing/selftests/`; no impact on kernel
  runtime or userspace APIs.
- No architectural changes; confined to `create_ns()` namespace
  initialization.
- Low regression risk: `fcnal-test.sh` does not validate DAD behavior
  and already uses `nodad` where needed and even sleeps for DAD in
  places, indicating this is purely to avoid races, not to test DAD.

**Code References**
- New sysctls added to `create_ns()` disable DAD for both existing and
  future interfaces in the ns:
  - `tools/testing/selftests/net/fcnal-test.sh:427`: `ip netns exec
    ${ns} sysctl -qw net.ipv6.conf.default.accept_dad=0`
  - `tools/testing/selftests/net/fcnal-test.sh:428`: `ip netns exec
    ${ns} sysctl -qw net.ipv6.conf.all.accept_dad=0`
- Context shows this is part of standard IPv6 netns setup already
  setting related sysctls:
  - `tools/testing/selftests/net/fcnal-test.sh:424`:
    `net.ipv6.conf.all.keep_addr_on_down=1`
  - `tools/testing/selftests/net/fcnal-test.sh:425`:
    `net.ipv6.conf.all.forwarding=1`
  - `tools/testing/selftests/net/fcnal-test.sh:426`:
    `net.ipv6.conf.default.forwarding=1`
- The script already works around DAD in specific places (underscoring
  the race):
  - `tools/testing/selftests/net/fcnal-test.sh:4084`: `sleep 5 # DAD`
  - Multiple address additions use `nodad` (e.g.,
    `tools/testing/selftests/net/fcnal-test.sh:393`, `3324`, `3602`,
    `4076`, `4125`, `4129`).
- Precedent across other net selftests (common pattern to disable DAD):
  - `tools/testing/selftests/net/traceroute.sh:65`:
    `net.ipv6.conf.default.accept_dad=0`
  - `tools/testing/selftests/net/fib_nexthops.sh:168`:
    `net.ipv6.conf.all.accept_dad=0`
  - `tools/testing/selftests/net/fib_nexthops.sh:169`:
    `net.ipv6.conf.default.accept_dad=0`

**Stable Criteria**
- Fixes important flakiness affecting users of stable selftests.
- Minimal, contained change with negligible risk.
- No features or architectural shifts; strictly improves test
  determinism.
- Touches only selftests; safe for all stable series carrying this test.

Given the above, this is a good candidate for stable backport to keep
the selftests reliable and deterministic.

 tools/testing/selftests/net/fcnal-test.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index f0fb114764b24..cf535c23a959a 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -424,6 +424,8 @@ create_ns()
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.keep_addr_on_down=1
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.forwarding=1
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.default.forwarding=1
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.default.accept_dad=0
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.accept_dad=0
 }
 
 # create veth pair to connect namespaces and apply addresses.
-- 
2.51.0

