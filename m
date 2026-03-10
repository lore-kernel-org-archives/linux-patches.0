Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B37466B5F;
	Tue, 10 Mar 2026 09:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133350; cv=none; b=W/RMMAiKmQ9w+f6YYZmCLBvAEwMSUndXyw66lFT+jEzU7qTk6lkGdb5ZF8uMS88jzQMQ17HzBhfhW06KKpHX3B0YV9fU+XaW21LTiSBl2jxA3etd6CLy80CJNKIxmq52PzfgExXamuPJM5p5w4nXaF+UlM162Vz3lWxESgkJxBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133350; c=relaxed/simple;
	bh=/pfT4GXWD1PVywa2nHkiu746UNeE6cn73+BrpGLI79w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HzEM0F8V4nm+VPqtuVLiontcL0uNauUw49lqAdAta+0O3p8mU3EpmpEFKcCSft2xYSnu6c9zxKqpx1ciqZ/e5DRnW85xvSJrm2Cr/gl/zgKdmDcv75SG+Kp+GWEzjN8m2QFKT9KqM90tZT9zcZMYcogW9ZNWw+BvOe03Xh8jM80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VwLabUqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VwLabUqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E30C19423;
	Tue, 10 Mar 2026 09:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133350;
	bh=/pfT4GXWD1PVywa2nHkiu746UNeE6cn73+BrpGLI79w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VwLabUqhIIpC1odXvHp0P8JpPROW5XAVT1GrNRpQXuRo/NWHcO1hLneyT/PjDIvll
	 scGChFbNM/rJ9mDnqxWoqomvdfYGBFS+e1tMoSXIZQYfbks+CjYO5iip5anw663mCq
	 O5SobgT1E0dtuMYJ8PYs1ck6ZldVWP2BEvGhRxFeOIeEC7mvroY8XnH+021SdOiiLC
	 BD9wK7eVNqMkQeQ6sxSnnaIeCfcqQXWfaBdvJLlbYjEsQZw707dqVj4fhjhixf3J4n
	 UDsAFtZsJOUNo255kXCdi6370uGN6u4HbJO38mtrAAlcPkO82T2ZiorcMrTXxtYkSQ
	 3wQd8AE7HZcoA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Isaac J. Manjarres" <isaacmanjarres@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] dma-buf: Include ioctl.h in UAPI header
Date: Tue, 10 Mar 2026 05:01:30 -0400
Message-ID: <20260310090145.2709021-30-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Transfer-Encoding: 8bit

From: "Isaac J. Manjarres" <isaacmanjarres@google.com>

[ Upstream commit a116bac87118903925108e57781bbfc7a7eea27b ]

include/uapi/linux/dma-buf.h uses several macros from ioctl.h to define
its ioctl commands. However, it does not include ioctl.h itself. So,
if userspace source code tries to include the dma-buf.h file without
including ioctl.h, it can result in build failures.

Therefore, include ioctl.h in the dma-buf UAPI header.

Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20260303002309.1401849-1-isaacmanjarres@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good - `_IOW` is defined in `include/uapi/asm-generic/ioctl.h`, which is
included via `<linux/ioctl.h>`.

## Analysis

**What the commit does:** Adds `#include <linux/ioctl.h>` to the UAPI
header `include/uapi/linux/dma-buf.h`.

**Problem:** The header uses `_IOW` and `_IOWR` macros (lines 172,
177-181) to define ioctl commands but never includes the header that
defines those macros. If userspace includes `dma-buf.h` without
separately including `ioctl.h` first, compilation fails.

**Category:** This is a **build fix** for userspace programs. The dma-
buf UAPI header is broken in the sense that it is not self-contained —
it relies on a transitive include that may or may not exist depending on
what other headers the user includes first.

**Stable kernel criteria assessment:**
1. **Obviously correct:** Yes — the header uses macros from ioctl.h, so
   it should include it. This is a textbook missing-include fix.
2. **Fixes a real bug:** Yes — userspace build failures when including
   this header standalone.
3. **Small and contained:** Yes — single line addition of an include.
4. **No new features:** Correct — this adds no new functionality.
5. **Risk:** Essentially zero. Adding a missing include to a UAPI header
   cannot break anything. The macros were already being used; this just
   makes the dependency explicit.

**User impact:** dma-buf is widely used in graphics (GPU drivers,
Vulkan, OpenGL), media, and Android. Any userspace program trying to
include this header in isolation would fail to compile. This has been a
latent bug since 2016.

**Reviews:** Reviewed by T.J. Mercier (Google) and Christian König (AMD,
dma-buf maintainer), giving strong confidence in correctness.

**Verification:**
- Read the file and confirmed `_IOW` is used on lines 172, 177-179 and
  `_IOWR` on line 180, without a prior include of ioctl.h (before this
  commit).
- Confirmed `_IOW` is defined in `include/uapi/asm-generic/ioctl.h`
  (reached via `<linux/ioctl.h>`).
- Confirmed the header was introduced in commit c11e391da2a8f (2016) and
  has never included ioctl.h — longstanding bug present in all stable
  trees.
- The change is a single-line include addition with zero risk of
  regression.
- Reviewed-by from the subsystem maintainer (Christian König).

This is a trivial, zero-risk build fix for a UAPI header that affects
userspace compilation. It meets all stable kernel criteria and falls
squarely into the "build fixes" exception category.

**YES**

 include/uapi/linux/dma-buf.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/dma-buf.h b/include/uapi/linux/dma-buf.h
index 5a6fda66d9adf..e827c9d20c5d3 100644
--- a/include/uapi/linux/dma-buf.h
+++ b/include/uapi/linux/dma-buf.h
@@ -20,6 +20,7 @@
 #ifndef _DMA_BUF_UAPI_H_
 #define _DMA_BUF_UAPI_H_
 
+#include <linux/ioctl.h>
 #include <linux/types.h>
 
 /**
-- 
2.51.0

