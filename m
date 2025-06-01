Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AB4257AF3;
	Sun,  1 Jun 2025 23:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820874; cv=none; b=ix0eeFjythJm0Wusq2THTQipgtA8LOoVkcCrbvzgQFrqZJ78R9I7kQ/8spU4fJ5nZpeAVkwvi6IKG9mf1fIbZZzCXLRWNvjmetNkk6ZHI3S19lFoCNeMuDsTqk/zNtwY4Wi5HLo08S1nRgoqatUwdY4ZUW1velHx1kckYPE/L7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820874; c=relaxed/simple;
	bh=f2WYD4Y4R0bJMxER0HxNBbKZ+Ld3JpjNmYLQli+y9PI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aBNBk1/TS4sJboOLxrhrkPc4bYJFPnEJvePmHU0pvDQOq5/1+Spyx909soqMZney28ROilhC8wEje6PPhDqSTuvy2trKbm9/iFX7r3HhsA0YvHBKZqLkaGPhhxALJliJa3crnIKM+PgjI6SeEkq5gbKFMMC11pKM+RPgu6tTeZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KoJIq2Ez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KoJIq2Ez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C84CC4CEE7;
	Sun,  1 Jun 2025 23:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820874;
	bh=f2WYD4Y4R0bJMxER0HxNBbKZ+Ld3JpjNmYLQli+y9PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KoJIq2Ezbe35o2ltQlb4aQm79qR/eM0uG5SgHQp7gHfPUrHOqrMhUYIk0uvofXP/J
	 dadEYVrM5fyjKOeFocctOQtfdLzUcAMJ5vMkPFB3LNHE68wt2SdSjIUvgNlLrcbPSk
	 oYMwi3lEaKGBh1zrTUkSjo4dZrCfwmHutCStAwXACc224hp43nD8C+Az7Qcbc3ZiwC
	 yBUdsK6BAEQvGjRwUoaL1NaL5KiG/I7+ihMBuEKxvAWd3oIzb1Z+lUfHFH7tvakeWP
	 ZiIaagYVh/MpiQKe5dqr+KrhPf31OBqhrWQ9HIX2104CzOozZrZ5LxOozK3SZ+0EYj
	 z/YCN5Eqc00sQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Damon Ding <damon.ding@rock-chips.com>,
	Douglas Anderson <dianders@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	andrzej.hajda@intel.com,
	neil.armstrong@linaro.org,
	rfoss@kernel.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	l.stach@pengutronix.de,
	bivvy.bi@rock-chips.com,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 10/93] drm/bridge: analogix_dp: Add irq flag IRQF_NO_AUTOEN instead of calling disable_irq()
Date: Sun,  1 Jun 2025 19:32:37 -0400
Message-Id: <20250601233402.3512823-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601233402.3512823-1-sashal@kernel.org>
References: <20250601233402.3512823-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
Content-Transfer-Encoding: 8bit

From: Damon Ding <damon.ding@rock-chips.com>

[ Upstream commit efab13e7d13a641a22c7508cde6e1a5285161944 ]

The IRQF_NO_AUTOEN can be used for the drivers that don't want
interrupts to be enabled automatically via devm_request_threaded_irq().
Using this flag can provide be more robust compared to the way of
calling disable_irq() after devm_request_threaded_irq() without the
IRQF_NO_AUTOEN flag.

Suggested-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Damon Ding <damon.ding@rock-chips.com>
Link: https://lore.kernel.org/r/20250310104114.2608063-2-damon.ding@rock-chips.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees based on
the following analysis: ## Code Change Analysis The commit makes a
simple, targeted fix to address a race condition in interrupt handling:
1. **Line 1639**: Changes `irq_flags = IRQF_TRIGGER_RISING |
IRQF_TRIGGER_FALLING;` to `irq_flags = IRQF_TRIGGER_RISING |
IRQF_TRIGGER_FALLING | IRQF_NO_AUTOEN;` 2. **Line 1642**: Changes
`irq_flags = 0;` to `irq_flags = IRQF_NO_AUTOEN;` 3. **Line 1659**:
Removes the `disable_irq(dp->irq);` call that was previously needed
after `devm_request_threaded_irq()` ## Backport Suitability Assessment
**Matches Stable Tree Criteria:** 1. **Fixes an Important Bug**: The
commit addresses a race condition where interrupts can fire between
`devm_request_threaded_irq()` and `disable_irq()`, which could cause
system instability or unexpected behavior. 2. **Small and Contained
Change**: The modification is minimal (3 lines changed) and affects only
the interrupt setup logic in `analogix_dp_core.c:1608-1659`. 3. **Low
Risk of Regression**: The change uses a well-established kernel pattern
(IRQF_NO_AUTOEN) that's been proven safe across multiple subsystems. 4.
**Clear Technical Merit**: As noted in the commit message, using
`IRQF_NO_AUTOEN` is "more robust compared to the way of calling
disable_irq() after devm_request_threaded_irq()". **Strong Precedent
from Similar Commits:** The analysis shows **ALL** similar commits in
the provided reference set have "Backport Status: YES": -
`drm/msm/adreno: Use IRQF_NO_AUTOEN flag in request_irq()` - **YES** -
`drm/imx/dcss: Use IRQF_NO_AUTOEN flag in request_irq()` (both
instances) - **YES** - `drm/imx/ipuv3: Use IRQF_NO_AUTOEN flag in
request_irq()` - **YES** - `drm/exynos: move to use request_irq by
IRQF_NO_AUTOEN flag` - **YES** **Additional Context from Kernel
Repository:** Examination of `/home/sasha/linux/drivers/gpu/drm/bridge/a
nalogix/analogix_dp_core.c:1659` confirms this follows the exact same
pattern as other successful backports - replacing the `request_irq()` +
`disable_irq()` sequence with `IRQF_NO_AUTOEN` flag usage. This is a
textbook example of a stable tree candidate: it fixes a real race
condition bug with minimal, proven-safe code changes that follow
established kernel patterns.

 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index bfa88409a7ff0..e23af674d91c0 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1636,10 +1636,10 @@ analogix_dp_probe(struct device *dev, struct analogix_dp_plat_data *plat_data)
 		 * that we can get the current state of the GPIO.
 		 */
 		dp->irq = gpiod_to_irq(dp->hpd_gpiod);
-		irq_flags = IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING;
+		irq_flags = IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING | IRQF_NO_AUTOEN;
 	} else {
 		dp->irq = platform_get_irq(pdev, 0);
-		irq_flags = 0;
+		irq_flags = IRQF_NO_AUTOEN;
 	}
 
 	if (dp->irq == -ENXIO) {
@@ -1656,7 +1656,6 @@ analogix_dp_probe(struct device *dev, struct analogix_dp_plat_data *plat_data)
 		dev_err(&pdev->dev, "failed to request irq\n");
 		goto err_disable_clk;
 	}
-	disable_irq(dp->irq);
 
 	return dp;
 
-- 
2.39.5

