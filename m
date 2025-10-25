Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A31314B87;
	Sat, 25 Oct 2025 16:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409426; cv=none; b=sssD9kLuIaZNUrAnvzbuAjCGRrqUcD0gRHNPj5V3M7XMIT+XH+yEwcpp1rHE1T/a1bP1N2XiERNP/IhY+/nynHWgroXNWh2FcRFHWLmlpf+K12tBGljVLahHfSZVKHl7yjmZ6k8NSOAKKwmK4jdU5NdPsj28/nRcV85amIpYyS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409426; c=relaxed/simple;
	bh=yXpQY07Tafmj/Pdwexa/B6VXHHHJCtffvKSXKK8lIeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rF5PyCmRSRQC0Gwvawc6FTpT6EPWQhWMELyxuhSnks4uDDyefy4xLX//nQUh8F49k/0vH0/1/8lx0UVpj75NibAgVw4Q9n8XKLgiGSodKpKiN828BzJiFHNwZP8vjoBk4JFxI6QJbHxw/gtiND3mv83t8wBn68EszmTbyXYfwpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u4wgKOdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u4wgKOdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564D3C4CEFB;
	Sat, 25 Oct 2025 16:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409426;
	bh=yXpQY07Tafmj/Pdwexa/B6VXHHHJCtffvKSXKK8lIeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u4wgKOdEeCF1+oL+4NyTzPLihvVNURyWdbtdYm4gSnjINiXls/7xyyKu9FiNkP3BH
	 G0mUxPd9T0B+r8z0L1nUVERdVgJdQrJ+YKxUBZ4XinPXlsSFmq0Mi/N50U/lLlRaHy
	 VOHIWGsenKNz+queFyoaYOKBXoHkRKCXluUFfuCeTCQUG9ByYH+SQfX8QY9POvF+7c
	 h36th0tIiUHmZDmQKL5TzYKURVFk+NcQKm8wtgUqKrWKQHXOnH6F6gZMn36CFuMflT
	 qMmZOcFRO5C8WSphN/seAfEKl1+1NRhlpH3+lc8cNKwEpWvj7l8skiP2I+ta7cwEfs
	 O5uaM6vEY+ZSw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.10] selftests: traceroute: Use require_command()
Date: Sat, 25 Oct 2025 11:59:12 -0400
Message-ID: <20251025160905.3857885-321-sashal@kernel.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 47efbac9b768553331b9459743a29861e0acd797 ]

Use require_command() so that the test will return SKIP (4) when a
required command is not present.

Before:

 # ./traceroute.sh
 SKIP: Could not run IPV6 test without traceroute6
 SKIP: Could not run IPV4 test without traceroute
 $ echo $?
 0

After:

 # ./traceroute.sh
 TEST: traceroute6 not installed                                    [SKIP]
 $ echo $?
 4

Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20250908073238.119240-6-idosch@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes a real bug in selftests reporting: when traceroute binaries are
  missing, the script previously exited 0 (PASS) after printing a manual
  “SKIP” message, which hides missing test coverage from harnesses and
  CI. The change standardizes behavior to return the kselftest skip code
  (4), matching framework expectations.
- Small, contained change limited to selftests; no kernel code touched,
  no ABI or API impact, no architectural changes.

Specifics in the code:
- The script sources the common helpers, so `require_command()` is
  available: tools/testing/selftests/net/traceroute.sh:7.
- Inline, ad hoc checks are removed from the test bodies:
  - run_traceroute6(): drops the `command -v traceroute6` guard and
    manual “SKIP” echo shown in the diff.
  - run_traceroute(): drops the `command -v traceroute` guard and manual
    “SKIP” echo shown in the diff.
  This eliminates duplicate logic and prevents returning success on
missing deps.
- Centralized, framework-compliant dependency checks are added before
  running tests:
  - tools/testing/selftests/net/traceroute.sh:463 `require_command
    traceroute6`
  - tools/testing/selftests/net/traceroute.sh:464 `require_command
    traceroute`
- The helper `require_command()` is defined in the shared library:
  - tools/testing/selftests/net/lib.sh:537 `require_command()` calls
    `check_command`, which logs a SKIP via `log_test_skip` and then
    exits with `EXIT_STATUS`.
  - The kselftest constants define skip as 4:
    tools/testing/selftests/net/lib.sh:22 `ksft_skip=4`.
  Consequently, when the command is missing, the script prints “TEST:
<cmd> not installed [SKIP]” and exits 4, exactly as described in the
commit message.

Risk and compatibility:
- Effect is limited to how the test reports missing prerequisites. This
  aligns traceroute.sh with many other selftests already using
  `require_command` (e.g.,
  tools/testing/selftests/net/rtnetlink_notification.sh:108), improving
  consistency across the selftests suite.
- One behavioral change: if either `traceroute6` or `traceroute` is
  missing, the entire script will SKIP early rather than partially
  running the remaining tests. This is a reasonable and common selftests
  convention, and it avoids false PASS outcomes. It does not affect
  kernel behavior.

Stable backport criteria:
- Addresses test correctness and CI signal integrity (important for
  users running selftests).
- Minimal, localized change with very low regression risk.
- No features or architectural shifts; purely a selftest reliability
  fix.
- Consistent with established kselftest patterns and constants.

Given these points, this is a safe and beneficial selftest fix
appropriate for stable trees.

 tools/testing/selftests/net/traceroute.sh | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/net/traceroute.sh b/tools/testing/selftests/net/traceroute.sh
index 282f14760940d..b50e52afa4f49 100755
--- a/tools/testing/selftests/net/traceroute.sh
+++ b/tools/testing/selftests/net/traceroute.sh
@@ -203,11 +203,6 @@ setup_traceroute6()
 
 run_traceroute6()
 {
-	if [ ! -x "$(command -v traceroute6)" ]; then
-		echo "SKIP: Could not run IPV6 test without traceroute6"
-		return
-	fi
-
 	setup_traceroute6
 
 	# traceroute6 host-2 from host-1 (expects 2000:102::2)
@@ -268,11 +263,6 @@ setup_traceroute()
 
 run_traceroute()
 {
-	if [ ! -x "$(command -v traceroute)" ]; then
-		echo "SKIP: Could not run IPV4 test without traceroute"
-		return
-	fi
-
 	setup_traceroute
 
 	# traceroute host-2 from host-1 (expects 1.0.1.1). Takes a while.
@@ -306,6 +296,9 @@ do
 	esac
 done
 
+require_command traceroute6
+require_command traceroute
+
 run_tests
 
 printf "\nTests passed: %3d\n" ${nsuccess}
-- 
2.51.0

