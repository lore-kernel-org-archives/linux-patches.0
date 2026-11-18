Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034350;
	b=taRFzYv0q43q/qSERBjl1Q5ThPyNmmVjOaPEtaMYakVpKyXXuhuySKyZaW2QL+mEIaaD
	 5K13flhvGRNmv58e0y0IriJXiYcK9JZv+PTD3yValuZoeWs3to1e1rGPrrxtooW4fwy5E
	 KtL2b1SpVzM9kPKW36U419Qcs7c/HY3XPS9t7CDUtYWiAi88hwm7oPwCKL2NAofL1QfCO
	 3+2kie0sk61jFsWdoMKvqSR97uvkUmyhg/fsfBpJ1g8Yv7YKEY1/2xfxSxPjnHOS69IBr
	 EKhF5usxERp/4I1riwTyjtqpIUiOc8JunvPpTxkQHiNDDepV96OilhXUdlrhewJjmZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jvFob3oIHcmsbxKTgZ9I98vrvctnhvGxhf+laMLEvvQ=;
	b=oUur0GpAFqe8VaLnpAwkQomPu0mwX3B2l73RjEyceTZU0371mlQ+LDKeP+YpkxB++G2B
	 j59gcvZJG/fuYW2Kd0cbQoFSScNHd4V5l/09HfNPscNhqT2jKC6uLTBe0cBvY+urSWIOV
	 uSDPqFQnCSf+5K7+TLfm/CdmQ/HQRgTnVvs+e1/KvnUOeQ8zIU5NV3pln5lrg5XGif9+k
	 oIb33H0xKW2Ts/LnXYbYENlyfHSYUWZeHLOVNR3v3vzW1H73ioh4Qqqfbc1KNYg7rqCzs
	 6vzW+gOndQU2CPlOncidyoGbNlVp+DBs/3YZGGPmmiZc877iBdBoLavQ3OCojT2zpoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BdwBRZYt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EE2606A31C;
	Wed, 18 Nov 2026 20:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BdwBRZYt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DB21F000C4;
	Wed, 18 Nov 2026 20:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034350;
	bh=jvFob3oIHcmsbxKTgZ9I98vrvctnhvGxhf+laMLEvvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BdwBRZYt/mAzjkiM7UnhlsXfkQkh6CIwJSiXk4wremv0QGEH/ZUoqaovMcfsyeaUg
	 9eFi0AtWjrh/5UCCuJRU5mKKHbGpgPMs37d5JGbGPWYdq0rrfZt+uyrIqwUVJP9wQD
	 EnB/dtXgA3ORiOMmm8aTxHcDUGoBwFYj+lbfll9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0339/3318] gpio: mvebu: keep resume masks within the irqchip cache
Date: Wed, 18 Nov 2026 15:16:01 +0100
Message-ID: <20261118150326.149627796@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4eb0c78067145..b2e13b13bfbfb 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -1011,6 +1011,8 @@ static int mvebu_gpio_suspend(struct platform_device *pdev, pm_message_t state)
 static int mvebu_gpio_resume(struct platform_device *pdev)
 {
 	struct mvebu_gpio_chip *mvchip = platform_get_drvdata(pdev);
+	u32 edge_cache = ~0U, level_cache = ~0U;
+	unsigned long flags;
 	int i;
 
 	regmap_write(mvchip->regs, GPIO_OUT_OFF + mvchip->offset,
@@ -1022,32 +1024,51 @@ static int mvebu_gpio_resume(struct platform_device *pdev)
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



