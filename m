Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91C9226CF1;
	Wed, 10 Dec 2025 03:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765338590; cv=none; b=aFIwC8sDMnr3sBuX4+5ImP63aOOdmXncqOvNDSrGVWMTyGUc/gvuXfCrXCebsixUQ/Iu+QoJH1mBYAUEBHdNEcBGHs7o1i7H49OO/+6Ybg5JKeNSu+J0uUzA5GJ/SQT9HoFT3/bKBbNbPPxCw0UTBqyFygjzmVbeQWVxbHZtkG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765338590; c=relaxed/simple;
	bh=+UuWZKvk/MU/uqpH+jr+xgi75P8oE2L7PIimsMZL3qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZyU+TEoK3Pp3QjyatxwgMA9VB3KOFjLHngejafHKQGk4ZSPa0wMCxxfwCHWam/jUsGtkfNGBN5+DepvQ+H1wfd+7cnU2yVDa3aEC8V13bFVPpKM7RfrwJitb13mKkbgJOq9eldnfoi2XQgiyOXdB3IkBsnrjWarHLFsUeXmtET4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ls3FJadt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ls3FJadt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A6BC116B1;
	Wed, 10 Dec 2025 03:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765338589;
	bh=+UuWZKvk/MU/uqpH+jr+xgi75P8oE2L7PIimsMZL3qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ls3FJadtbSmIms673RZHACwdBzY4CKdIf8qPUtTpfgmzzwWG+bNF8rLnxYwlk3ij+
	 18Z2xu15PbjH/PB8D6WRVzRLGbsI2GryEfFb8Su+79+8ei3UZoZyISzs8BqOa1KzXR
	 VsgUktr7/oGZLBazqQo3A4e5Gf9uqIwJULic5+Ptn2FdYT7RIOi6CrQ98bBwS9ZDqo
	 BUB4h5LqwzE0Ok0sTOE7sC2XNANjer1g1Kgedi47SImOTqTU9pC2mzbAOuW2xp0bfU
	 zHk86YqKJ2QkRopcEtSR9ti9yUaU1SoO2JGH/IjKKaUavnFOxSeVnjLcYQGbUpRsat
	 /65LIIYhRfcYw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Encrow Thorne <jyc0019@gmail.com>,
	Troy Mitchell <troy.mitchell@linux.dev>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.18-5.10] reset: fix BIT macro reference
Date: Tue,  9 Dec 2025 22:48:55 -0500
Message-ID: <20251210034915.2268617-14-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251210034915.2268617-1-sashal@kernel.org>
References: <20251210034915.2268617-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Encrow Thorne <jyc0019@gmail.com>

[ Upstream commit f3d8b64ee46c9b4b0b82b1a4642027728bac95b8 ]

RESET_CONTROL_FLAGS_BIT_* macros use BIT(), but reset.h does not
include bits.h. This causes compilation errors when including
reset.h standalone.

Include bits.h to make reset.h self-contained.

Suggested-by: Troy Mitchell <troy.mitchell@linux.dev>
Reviewed-by: Troy Mitchell <troy.mitchell@linux.dev>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Encrow Thorne <jyc0019@gmail.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Summary of Findings

### Bug Introduction
The bug was introduced by commit `dad35f7d2fc14` ("reset: replace
boolean parameters with flags parameter") which added the
`RESET_CONTROL_FLAGS_BIT_*` macros using `BIT()`. This was merged in
**v6.13-rc1** (October 2024).

### Affected Stable Trees
- **6.13.x stable**: YES - affected, needs this fix
- **6.12.x and earlier**: NO - the `RESET_CONTROL_FLAGS_BIT_*` macros
  don't exist in these trees

### Stable Kernel Criteria Assessment

| Criterion | Assessment |
|-----------|------------|
| Obviously correct? | ✅ YES - adding a missing include is trivially
correct |
| Fixes real bug? | ✅ YES - compilation error when including reset.h
standalone |
| Important issue? | ✅ YES - build failures are hard blockers |
| Small and contained? | ✅ YES - 1 line change |
| No new features? | ✅ YES - only fixes missing dependency |
| Low risk? | ✅ YES - zero runtime risk, cannot cause regressions |

### Why This Should Be Backported

1. **Build Fix Exception**: Build fixes are explicitly allowed in stable
   per `Documentation/process/stable-kernel-rules.rst` - this is an
   "include file fix" that makes the header self-contained.

2. **Zero Risk**: Adding a required include cannot cause runtime
   regressions. The `bits.h` header is universally available.

3. **Real Bug**: The compilation error is real - the header uses `BIT()`
   macro without including its definition.

4. **Reviewed by Maintainer**: Philipp Zabel (reset subsystem
   maintainer) reviewed and signed off, providing confidence in the fix.

5. **Minimal Change**: Single line addition - the smallest possible fix.

### Concerns

- No explicit `Cc: stable@vger.kernel.org` or `Fixes:` tag from
  maintainer, but this appears to be an oversight given the clear build-
  fix nature
- Only applicable to 6.13.x stable (older trees don't have the affected
  code)

### Conclusion

This is a textbook example of a stable-appropriate build fix: minimal,
zero-risk, fixes a real compilation error, and makes the header properly
self-contained. The fix should be backported to the 6.13.x stable tree
where the bug exists.

**YES**

 include/linux/reset.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/reset.h b/include/linux/reset.h
index 840d75d172f62..44f9e3415f92c 100644
--- a/include/linux/reset.h
+++ b/include/linux/reset.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_RESET_H_
 #define _LINUX_RESET_H_
 
+#include <linux/bits.h>
 #include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/types.h>
-- 
2.51.0

