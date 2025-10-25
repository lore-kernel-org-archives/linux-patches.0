Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3367A2FF168;
	Sat, 25 Oct 2025 16:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408738; cv=none; b=q+GYhbJjmm+uALsNAdcfvrh+fwuyPe3qj+b8T8J1ZHBHrxXo1sobyZmDVVIltM4/LMtzglwO0uPqt0nAZ0tsoQks1rSjLqEZ/TXRd7D1ceqd8G1LyP8fisYIRS3SK0L9CXry0UdCNHsMK1ZGtS3MsyXXYRdzTF3291GD/jxTbLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408738; c=relaxed/simple;
	bh=aWDaGaTRuyFu3Od/KCOqSO23J2HYkd4D6NIISeiIrBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SRbSe+/xbgbh+AYUiIMN4b3CL8oHafEXvovGOr+bdCRGFQXl25MIrLSo+oYYfwg9RNZsC+VP7lPIDhGvOGcaCvbqrcf5l6KiarBu4kq2u0cpBp/ztfKGJn81281P3QchsLEgQoVtXtSc6Jk4bMkVGyccRoMkAWS0CHo1pAFX1Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VdK+eXzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VdK+eXzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91F8C4CEFB;
	Sat, 25 Oct 2025 16:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408738;
	bh=aWDaGaTRuyFu3Od/KCOqSO23J2HYkd4D6NIISeiIrBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VdK+eXzA1LKIUWGKUwW6bewK7gjEJelioRKcrsM+8Vr2HhqQ5aaJz0J8zCMhDKo/B
	 nmtO/oxjbdkIv5LBk7hcodPEnwh0JwgBWGb/sSuobwQF7hYc7/My1AQrNDXz8ZrYNC
	 dNUSg/FdUvLpA/5rtRMScJUy806Ru+fyEP8hBX/rIYM5QfRX/r8Qvpm/WkCskdBkuC
	 UYe3GY6a/dWbEfjGVe62OMP5HfviRE/C5If2Wb9KKzLWq1XspCuALQ7Rvzh6q6KgJb
	 H0Xri+pyjOW1bz+OVNekcRXAZjbYNzPw9xg0teD7MMzaaGogT+A/F2YQmg57YI6FLO
	 zCQD11Uyfvqqg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wake Liu <wakel@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	nathan@kernel.org,
	netdev@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.17-5.4] selftests/net: Replace non-standard __WORDSIZE with sizeof(long) * 8
Date: Sat, 25 Oct 2025 11:54:50 -0400
Message-ID: <20251025160905.3857885-59-sashal@kernel.org>
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

From: Wake Liu <wakel@google.com>

[ Upstream commit c36748e8733ef9c5f4cd1d7c4327994e5b88b8df ]

The `__WORDSIZE` macro, defined in the non-standard `<bits/wordsize.h>`
header, is a GNU extension and not universally available with all
toolchains, such as Clang when used with musl libc.

This can lead to build failures in environments where this header is
missing.

The intention of the code is to determine the bit width of a C `long`.
Replace the non-portable `__WORDSIZE` with the standard and portable
`sizeof(long) * 8` expression to achieve the same result.

This change also removes the inclusion of the now-unused
`<bits/wordsize.h>` header.

Signed-off-by: Wake Liu <wakel@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Fixes selftest build failures on toolchains without GNU
    `<bits/wordsize.h>` (e.g., Clang with musl). The current code
    directly includes a GNU-internal header and uses a GNU extension
    macro.
  - Evidence: direct inclusion at
    `tools/testing/selftests/net/psock_tpacket.c:36` and use of
    `__WORDSIZE` at `tools/testing/selftests/net/psock_tpacket.c:788`.

- Change details
  - Removes non-standard header include: `#include <bits/wordsize.h>`
    (tools/testing/selftests/net/psock_tpacket.c:36).
  - Replaces non-portable `__WORDSIZE` with the portable and standard-
    compliant `sizeof(long) * 8` inside `test_user_bit_width()`
    (tools/testing/selftests/net/psock_tpacket.c:788 → now returns
    `sizeof(long) * 8`).
  - No other functional changes; all behavior, interfaces, and test
    logic remain intact.

- Behavioral impact
  - The intent of `test_user_bit_width()` is to report the userspace
    “word” width as used by the test to decide whether to skip
    TPACKET_V1 when user/kernel bit widths differ (see its use in
    `test_tpacket()` adjacent to
    tools/testing/selftests/net/psock_tpacket.c:811).
  - On Linux ABIs, `__WORDSIZE` effectively matches the bit width of
    `long`. Using `sizeof(long) * 8` is semantically equivalent across
    LP64 and ILP32, including x86_64 ILP32 (x32), where it returns 32
    and properly triggers the intended skip path when comparing to the
    kernel’s 64-bit width parsed from `/proc/kallsyms`.
  - Therefore, no functional change to test behavior, only improved
    portability.

- Scope and risk
  - Selftests-only change (single file), no kernel code touched.
  - Very small and contained: removal of one include and a one-line
    return expression change.
  - No architectural changes; no side effects beyond enabling builds on
    non-glibc toolchains.
  - Aligns with existing tools-side practice:
    `tools/include/linux/bitops.h` already falls back to a portable
    definition of `__WORDSIZE` via `__SIZEOF_LONG__ * 8`, reinforcing
    that using the C type width is the right approach.

- Stable backport criteria
  - Addresses a real user-facing bug: selftests fail to build on
    legitimate toolchains (Clang + musl).
  - Minimal risk and fully contained to a test; no runtime kernel
    impact.
  - Not a new feature; purely a portability/build fix.
  - Touches a non-critical subtree (selftests), commonly accepted for
    stable when it fixes build or test breakages.

Conclusion: This is a low-risk, portability/build fix for selftests with
no kernel runtime impact and should be backported to stable.

 tools/testing/selftests/net/psock_tpacket.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/psock_tpacket.c b/tools/testing/selftests/net/psock_tpacket.c
index 221270cee3eaa..0dd909e325d93 100644
--- a/tools/testing/selftests/net/psock_tpacket.c
+++ b/tools/testing/selftests/net/psock_tpacket.c
@@ -33,7 +33,6 @@
 #include <ctype.h>
 #include <fcntl.h>
 #include <unistd.h>
-#include <bits/wordsize.h>
 #include <net/ethernet.h>
 #include <netinet/ip.h>
 #include <arpa/inet.h>
@@ -785,7 +784,7 @@ static int test_kernel_bit_width(void)
 
 static int test_user_bit_width(void)
 {
-	return __WORDSIZE;
+	return sizeof(long) * 8;
 }
 
 static const char *tpacket_str[] = {
-- 
2.51.0

