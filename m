Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062958;
	b=AQ9t8w6PzWRkPC9AOP1+a2pw+kNHyLEcgsSckWoY58GRVf6iBYkQW48iGUYcaq7wDto4
	 Bo5Ov8HQxnB3khJaFhteTrKSl81ENyNZhavSEs/OKUytOhe77iEowt6QRQWzAE8nLsCXH
	 c07fr8JdN8LTvq71mhO6aMja4jUHm+DJ8v7FqMjHsZU6T0afi8Hp+uDOEH0bZEi3uDjRt
	 0Fg7h1cjdMOILbU5Bq/ch9K7gZZjKNVHpAgpFl+E7okeLXsyZmFM3esrZj1uQlP6veL2T
	 4aAsLroovb0Fu3afnyuKfxD14FrN3oNvvMEEOH/TpQ/6WjlWVd9QERcNzaPYJAgj3qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZyaiAjhKzkyIRCYqdHD9Ko7hIQ2aL74EGJx58pkSZ80=;
	b=rtXGCoFqRyPROF3u38bw6MA6IvTMqH2FneGZ5oVBYEskUyuiFuGk/OxTQ+CNjZp2P9cf
	 Re6iOeO80cXRG2VDrdSuYYr3csS7aC3TwBxyxG9K374/hZyQo5KGVq0VwZYoJUa88X0nt
	 HgSVD3+fRUDODIyUNK/PnICBwRew3fq0cgWUB/EOHMZ9viRvNZ9nd4ZUrIPEIyE7/94Qo
	 LaRGUKBlXbADVMPkHyc/8tGTCYYxK1i9NzFbb+U9psBUaKHcc6GYoaYoRCo512t3zSaza
	 t/0uJbiwfPF2Cd25vjDHwvM9oP0WvGpMe3kTVCmYzfSYpDNENfGlP94K0Pcgq1Hssxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1vzWJij;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61F0606D808;
	Sat,  7 Nov 2026 14:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1vzWJij
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953F81F008A5;
	Sat,  7 Nov 2026 14:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062957;
	bh=ZyaiAjhKzkyIRCYqdHD9Ko7hIQ2aL74EGJx58pkSZ80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m1vzWJijSQmj7faUBHgqR0uAiyXTMbQGfAu9ZFmevNTJ7+AaaOX973QlHyB0Kbo7K
	 SMRRaiauKtfZ8VErvl4lgGz4LgznYqKFK3Y1DdQHnt2GHSL+2mqE/sI1vljd2is3W7
	 pJngcCwAoOc9K28jIS1X2svgaTyQ4lQEpcnEpTBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 220/869] ASoC: fsl_xcvr: free IRQ before canceling reset work
Date: Sat,  7 Nov 2026 08:48:22 -0500
Message-ID: <20261107134859.367076519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 83701fdb2d8d644c547773791da48d6ecb3a5e1d ]

irq0_isr() schedules work_rst on a preamble error, and reset_rx_work()
touches regmap.  remove() cancels that work while the IRQ is still
registered, so the handler can queue it again during teardown.  The IRQ
is also requested before INIT_WORK() and spin_lock_init().  Probe
failure does not call remove(), so freeing the IRQ leaves queued work
running, and an earlier interrupt schedules uninitialized work.

Initialize the lock and devm_work_autocancel() before the IRQ.  Failed
probe then frees the IRQ and cancels the work.  Unbind frees the IRQ
before cancel_work_sync() and pm_runtime_disable().

Fixes: 1e5d0f106164 ("ASoC: fsl_xcvr: reset RX dpath after wrong preamble")
Cc: stable@vger.kernel.org # 6.13+
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Link: https://patch.msgid.link/20260923054017.93553-1-mhun512@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_xcvr.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/sound/soc/fsl/fsl_xcvr.c b/sound/soc/fsl/fsl_xcvr.c
index d7a823384c08a..08683f989cee2 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -3,6 +3,7 @@
 
 #include <linux/bitrev.h>
 #include <linux/clk.h>
+#include <linux/devm-helpers.h>
 #include <linux/firmware.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
@@ -57,6 +58,7 @@ struct fsl_xcvr {
 	struct snd_aes_iec958 tx_iec958;
 	u8 cap_ds[FSL_XCVR_CAPDS_SIZE];
 	struct work_struct work_rst;
+	int irq;
 	spinlock_t lock; /* Protect hw_reset and trigger */
 	struct snd_pcm_hw_constraint_list spdif_constr_rates;
 	u32 spdif_constr_rates_list[SPDIF_NUM_RATES];
@@ -1555,7 +1557,7 @@ static int fsl_xcvr_probe(struct platform_device *pdev)
 	struct fsl_xcvr *xcvr;
 	struct resource *rx_res, *tx_res;
 	void __iomem *regs;
-	int ret, irq;
+	int ret;
 
 	xcvr = devm_kzalloc(dev, sizeof(*xcvr), GFP_KERNEL);
 	if (!xcvr)
@@ -1643,12 +1645,22 @@ static int fsl_xcvr_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, PTR_ERR(xcvr->reset),
 				     "failed to get XCVR reset control\n");
 
+	/*
+	 * irq0_isr() schedules work_rst. Prepare the work and its lock
+	 * before the IRQ, and register the cancel action first so a failed
+	 * probe frees the IRQ and then cancels any queued work.
+	 */
+	spin_lock_init(&xcvr->lock);
+	ret = devm_work_autocancel(dev, &xcvr->work_rst, reset_rx_work);
+	if (ret)
+		return ret;
+
 	/* get IRQs */
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
+	xcvr->irq = platform_get_irq(pdev, 0);
+	if (xcvr->irq < 0)
+		return xcvr->irq;
 
-	ret = devm_request_irq(dev, irq, irq0_isr, 0, pdev->name, xcvr);
+	ret = devm_request_irq(dev, xcvr->irq, irq0_isr, 0, pdev->name, xcvr);
 	if (ret)
 		return dev_err_probe(dev, ret, "failed to claim IRQ0\n");
 
@@ -1689,8 +1701,6 @@ static int fsl_xcvr_probe(struct platform_device *pdev)
 			fsl_xcvr_comp.name);
 	}
 
-	INIT_WORK(&xcvr->work_rst, reset_rx_work);
-	spin_lock_init(&xcvr->lock);
 	return ret;
 }
 
@@ -1698,6 +1708,8 @@ static void fsl_xcvr_remove(struct platform_device *pdev)
 {
 	struct fsl_xcvr *xcvr = dev_get_drvdata(&pdev->dev);
 
+	/* Free the IRQ first so irq0_isr() cannot requeue work_rst. */
+	devm_free_irq(&pdev->dev, xcvr->irq, xcvr);
 	cancel_work_sync(&xcvr->work_rst);
 	pm_runtime_disable(&pdev->dev);
 }
-- 
2.53.0



