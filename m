Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043654;
	b=mYyAxxbZGSgS7JdkiAOqGr0XXU6Wh/KhcLXq3StjGQ9EwOP34z/S+u8ystTl8cTaLKGv
	 ytpCbrdg/7uDUg17gy3oOPax2jw4vtuXlRPGLEI9Ze1zHyGyCqCEF3YRDYMpgtsb6qQwo
	 8pQQmHCRIlUJdoxyt3vufJUP3KXHssyConte4ZRYIXwx9tnvT48HbvzFn3+Df1dEgx1/Q
	 EJ91vwOMyDhHA5vIzEofkdObeVFparSdUgRQXAtfy6Umw4R/48lmraxcucoblq1oqXHte
	 v3SLEryXJ3DFrXwqyPJ/3fjqE4/fV4EDp9+WpAcdz4ft4sjRI3CTPvLZuHLFwrVFZ7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YdCCY/EiqzlQJlV0WfBJ/HK5dphsk1swB+AkGg0QmmI=;
	b=Lndgs5TaHONJdgOiVgbpZZMjtNZUtzLh1yDoW4WzX+URqHOwL0byaBJdZdg19XudZEkx
	 1yfI+Ef9feJ3r75Ih2LhIKKaX2iDrOXx8Rg4wG0Q4ohpF7+gOtf18cQGSVEJFAIQilmF2
	 LNNFz9fBtjyh1sA6sCdr/bS94M7sRXtgN1dE5HMG00bA41QQ/H+CUk0zvtiuLlkzrmwHn
	 zRjGjdxc0qkW722tb+RhOPlonKbFboLw2bjlWGZISa9TmMkpUPXKAy7PrbHx9xxtvb7uF
	 bEvEe6PTGDI5EJ2H/5B26kjjIxHLkJz20liiSHXQA8kCRqMePjKp/vOhH3eyIWre3BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N7deDfh6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933CB606A320;
	Wed, 18 Nov 2026 23:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N7deDfh6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4AE31F000C4;
	Wed, 18 Nov 2026 23:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043654;
	bh=YdCCY/EiqzlQJlV0WfBJ/HK5dphsk1swB+AkGg0QmmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7deDfh6MWcxcuDa+TxVmBKO3niSLZcpLcK34C5zXOqe613adCACHlaodNDNoiVt7
	 ueAMxPkE/XklObl9M4iQNt4lHvc7bGMyv4XvHVxGtKfzLr/QAn2j7bmVd9JPaErjKK
	 kovJWF/o1f4VrpFh3cWjV2m8QNZJF6VcP/oBEr7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0288/2857] gpio: mvebu: keep resume masks within the irqchip cache
Date: Wed, 18 Nov 2026 15:22:02 +0100
Message-ID: <20261118150211.787539944@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f58f835d0acb3..0abf413170324 100644
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



