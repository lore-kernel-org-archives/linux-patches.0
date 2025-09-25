Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89F454F81
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 23:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758843979; cv=none; b=Pc1S1Q5h50wU2jQKP01tJXgTbL3tT2gB0mVMHuyN2BFK/D41gaHb6HwQjmnanwP0zz7KKLsFZ99MBsq19f2QHGwVvpkguOgawc/43vI11m1TsAmKtlgwmhSWYCZkWaVgx1Ze1BtfSlMDdOzhIZY/RUd6sQgaq7luNYUeyp8XHu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758843979; c=relaxed/simple;
	bh=gAxMMO8iLbRfWUQ4XZXNybZmAABcJXpeoRBJ86bPuRc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=m+/9g+DMxq41JZo+IIXgsjkx7pk7ocuGd670tlg+DMwf3b8DAkR1L7MRIevII3I2xAfs7cse+8J1Pc+SNEWgp6lcQ/wm8FbFZ54QX8p4jgU2f+mO4Nr1il0JoiuSHs+MeL+hoCkYBJqJH0BymNRhRw+2MMUopWTQna2nLj/86Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kKxVye+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kKxVye+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E618BC4CEF0;
	Thu, 25 Sep 2025 23:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758843979;
	bh=gAxMMO8iLbRfWUQ4XZXNybZmAABcJXpeoRBJ86bPuRc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kKxVye+3Izk9Gil8d0gYEG3VBsDXau0c2QJZb4YGVXnPcBOiDPtYQx1Secx/X25fG
	 D7k0dAyr3Pw5j1CWJQbDOqCvAwUgezBPFTdaVL9RYIFwkFmlvKd2JsdPJRq2VIKeF6
	 IP6RhJamtXE5/xungZKqnHa0fBfHlr/kJFmvT+Zni9L55woDYMvXpAbUQgAKOc+7Sd
	 hTerWBXo85W9LiioUtfaY1gUywnh/+HgTcNkBga6z/bwmWw1pDKR3JAo+eOvc/Dovv
	 Vux54+isn3hQl4RXk3iDEw2PrmuaMdyb9wMoZ91016cLO1BTvf2orKosq+KAxznJxg
	 3RpMoUxnrCGKQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 25 Sep 2025 19:46:07 -0400
Subject: [PATCH 2/2] macintosh/via-pmu-backlight: Include linux/of.h and
 uapi/linux/fb.h
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-2-d256858d86a6@kernel.org>
References: <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-0-d256858d86a6@kernel.org>
In-Reply-To: <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-0-d256858d86a6@kernel.org>
To: Lee Jones <lee@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Daniel Thompson <danielt@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Simona Vetter <simona.vetter@ffwll.ch>, linuxppc-dev@lists.ozlabs.org, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2124; i=nathan@kernel.org;
 h=from:subject:message-id; bh=gAxMMO8iLbRfWUQ4XZXNybZmAABcJXpeoRBJ86bPuRc=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBlXrzg//Zlr5/Nn4qbse7+EVU87vnS/v0e47UlEm96dr
 Wd0S7llO0pZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBEzk1n+Ctunn5VfU++zpPY
 dZayqztfPHvnJrDFQFV72rzD035mqPExMqypecY3bdk5h5n6k40aa67/F1aucOZue/1y04zjyfG
 az3kB
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After the recent removal of the fb.h include from backlight.h, which
transitively included of.h, there are several errors from
via-pmu-backlight.c (errors from bl_curve not being properly defined
omitted):

  drivers/macintosh/via-pmu-backlight.c:22:20: error: 'FB_BACKLIGHT_LEVELS' undeclared here (not in a function)
     22 | static u8 bl_curve[FB_BACKLIGHT_LEVELS];
        |                    ^~~~~~~~~~~~~~~~~~~
  drivers/macintosh/via-pmu-backlight.c: In function 'pmu_backlight_get_level_brightness':
  drivers/macintosh/via-pmu-backlight.c:63:38: error: 'FB_BACKLIGHT_MAX' undeclared (first use in this function); did you mean 'BACKLIGHT_RAW'?
     63 |         pmulevel = bl_curve[level] * FB_BACKLIGHT_MAX / MAX_PMU_LEVEL;
        |                                      ^~~~~~~~~~~~~~~~
        |                                      BACKLIGHT_RAW
  drivers/macintosh/via-pmu-backlight.c: In function 'pmu_backlight_init':
  drivers/macintosh/via-pmu-backlight.c:144:17: error: implicit declaration of function 'of_machine_is_compatible' [-Wimplicit-function-declaration]
    144 |                 of_machine_is_compatible("AAPL,3400/2400") ||
        |                 ^~~~~~~~~~~~~~~~~~~~~~~~

FB_BACKLIGHT_{LEVELS,MAX} are available from the userspace API fb.h so
just include that avoid dragging in the full fb.h header unnecessarily.
Include linux/of.h for of_machine_is_compatible().

Fixes: 9f218f9bb9d2 ("backlight: Do not include <linux/fb.h> in header file")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/macintosh/via-pmu-backlight.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/macintosh/via-pmu-backlight.c b/drivers/macintosh/via-pmu-backlight.c
index 26bd9ed5e664..f7b7853b3802 100644
--- a/drivers/macintosh/via-pmu-backlight.c
+++ b/drivers/macintosh/via-pmu-backlight.c
@@ -11,7 +11,9 @@
 #include <asm/ptrace.h>
 #include <linux/adb.h>
 #include <linux/backlight.h>
+#include <linux/of.h>
 #include <linux/pmu.h>
+#include <uapi/linux/fb.h>
 #include <asm/backlight.h>
 
 #define MAX_PMU_LEVEL 0xFF

-- 
2.51.0

