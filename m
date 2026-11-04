Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831064;
	b=Jr/cOXlJPfghct070Fw3FQTCefJ8koF9/HOsDqBGI8N7U1hslhVx4qOGJqBbhoSiSEp7
	 0xBmdTGPaSbKguTMMAUPoVSLcAXLMZNYToZgQhENla4+T0VHyrM40CTTHh3oohESJc/PP
	 JYFD712vaXePwyYw/GQLlx/pRzoN6fnbEyuBLwPUJjl8MG22jVWeIYEFHa8+HmYnuzJ0H
	 l8cRApc77/udOJE6f+qWnND11f7FtCqhfe7B/+Xkd6BRPt91hVTxUQeDGhoXxEydCfNon
	 JVVVkix9DuH2g1qIU80q4A57a6FIdHugUKx3d31ju0hWJVXVKQM7VZnpdaxWOELXFNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hQHpf2pkqZYg+C+ZuHEcN4WkmSVyp4B4f6B8+2vVMYI=;
	b=Ix4mVOk2kEtnC9ZGxPSiFI7Rxjf9fie5KpkCMOIAd/jFAdoR3aoft2cLsXADO9v93p9C
	 bAexWByxjGzfyPthIeHlM+p4AUT6fdF78W+GGCYR6Py/xPnjxwYkFcYQRsihfKQqRu9jP
	 ZRAGKt1uSott2IcMVEYX61XIhCNxj58hCTGcNxU8fw4fr5UUkkS2th6EsvwniiS/U81p8
	 v4X6paY9MDfkDSQJM6DN/0LxXpVdUb/NJYZhVRIrihhiE6pg/PMUF8YG02NAJj+jMJod1
	 fyU1n4yql6MlR5PFsdsLy1mufwAmIrO1yynPwMgij3t2icXg0wLSlRFFUUjH+jJfuvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d941xdz+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DB4606A329;
	Wed,  4 Nov 2026 22:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d941xdz+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5541F000C1;
	Wed,  4 Nov 2026 22:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831063;
	bh=hQHpf2pkqZYg+C+ZuHEcN4WkmSVyp4B4f6B8+2vVMYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d941xdz+5bnfGnBWbStm/Swt2MTg6o3E/8WyXmKTyJIfdEVGyaJzlud12pm9pJ8WL
	 xRh62LLE9g/BqTAuJ1zr2VitOyr1+/NlaxBpRwsYgRFC1eVQQ3ZV/qyEuMJv1DfCSY
	 71lArTNUaJGMFcHC442eD9bMW//cMT6lMxpiNK6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0483/1005] gpio: mvebu: keep resume masks within the irqchip cache
Date: Wed,  4 Nov 2026 16:03:36 -0500
Message-ID: <20261104211057.514782922@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 02af7eac17bc62a72335c1fc8c4af4471654f6cc ]

mvebu_gpio_resume() writes the edge/level mask registers saved at
suspend time straight back to hardware, bypassing the irqchip's
mask_cache_priv.  genirq skips mask_irq() for a line it already
considers masked, so restoring a bit in hardware that genirq thinks
is still masked leaves that line unmasked behind genirq's back.  An
asserted level line then has nobody to ack it, and the moment
interrupts are re-enabled the chained handler storms, hanging resume.

AND the restored mask values with the matching irqchip mask cache so
only lines genirq currently considers unmasked are unmasked again.
Read the caches under gc->lock to keep them consistent with the
mask/unmask handlers.

Tested on Helios4 (armhf): 5 suspend cycles woken by magic packet,
no hang; mvebu_gpio_resume() returns in 6 usecs.

Assisted-by: LLM
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20260915004406.115230-1-rosenp@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mvebu.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 39a7ad6585f25..c613d74ed48d0 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -1006,6 +1006,8 @@ static int mvebu_gpio_suspend(struct platform_device *pdev, pm_message_t state)
 static int mvebu_gpio_resume(struct platform_device *pdev)
 {
 	struct mvebu_gpio_chip *mvchip = platform_get_drvdata(pdev);
+	u32 edge_cache = ~0U, level_cache = ~0U;
+	unsigned long flags;
 	int i;
 
 	regmap_write(mvchip->regs, GPIO_OUT_OFF + mvchip->offset,
@@ -1017,32 +1019,51 @@ static int mvebu_gpio_resume(struct platform_device *pdev)
 	regmap_write(mvchip->regs, GPIO_IN_POL_OFF + mvchip->offset,
 		     mvchip->in_pol_reg);
 
+	/*
+	 * genirq skips mask_irq() for a line it already considers masked, so
+	 * unmasking one behind its back leaves an asserted level line that
+	 * nobody masks. Restore only bits the irqchip cache still has set.
+	 *
+	 * Snapshot the caches under the raw spinlock, but release it before
+	 * the regmap writes below: regmap_write() takes a sleepable lock on
+	 * PREEMPT_RT.
+	 */
+	if (mvchip->domain) {
+		struct irq_chip_generic *gc;
+
+		gc = irq_get_domain_generic_chip(mvchip->domain, 0);
+		raw_spin_lock_irqsave(&gc->lock, flags);
+		level_cache = gc->chip_types[0].mask_cache_priv;
+		edge_cache = gc->chip_types[1].mask_cache_priv;
+		raw_spin_unlock_irqrestore(&gc->lock, flags);
+	}
+
 	switch (mvchip->soc_variant) {
 	case MVEBU_GPIO_SOC_VARIANT_ORION:
 	case MVEBU_GPIO_SOC_VARIANT_A8K:
 		regmap_write(mvchip->regs, GPIO_EDGE_MASK_OFF + mvchip->offset,
-			     mvchip->edge_mask_regs[0]);
+			     mvchip->edge_mask_regs[0] & edge_cache);
 		regmap_write(mvchip->regs, GPIO_LEVEL_MASK_OFF + mvchip->offset,
-			     mvchip->level_mask_regs[0]);
+			     mvchip->level_mask_regs[0] & level_cache);
 		break;
 	case MVEBU_GPIO_SOC_VARIANT_MV78200:
 		for (i = 0; i < 2; i++) {
 			regmap_write(mvchip->regs,
 				     GPIO_EDGE_MASK_MV78200_OFF(i),
-				     mvchip->edge_mask_regs[i]);
+				     mvchip->edge_mask_regs[i] & edge_cache);
 			regmap_write(mvchip->regs,
 				     GPIO_LEVEL_MASK_MV78200_OFF(i),
-				     mvchip->level_mask_regs[i]);
+				     mvchip->level_mask_regs[i] & level_cache);
 		}
 		break;
 	case MVEBU_GPIO_SOC_VARIANT_ARMADAXP:
 		for (i = 0; i < 4; i++) {
 			regmap_write(mvchip->regs,
 				     GPIO_EDGE_MASK_ARMADAXP_OFF(i),
-				     mvchip->edge_mask_regs[i]);
+				     mvchip->edge_mask_regs[i] & edge_cache);
 			regmap_write(mvchip->regs,
 				     GPIO_LEVEL_MASK_ARMADAXP_OFF(i),
-				     mvchip->level_mask_regs[i]);
+				     mvchip->level_mask_regs[i] & level_cache);
 		}
 		break;
 	default:
-- 
2.53.0



