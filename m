Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064115;
	b=udVlTnU5xsWhQbTxUIOhoSf0A0dTYnTSIunrji5FUjBwH++c0U7zK96YYENyo6Mjaejh
	 pJn2WqYmxzrzSQ8h82IlYZUWxAJYTkW0blFhYPXZ7/0kFQjpi1ZatW2tbpJlqWNpA68+d
	 EyQR9b+MxQZKmtPMlfy1YZ5cz2pi0VvhZUOxnzwhsugY8tRWOB9gjFBQUJQlidCV3NfGZ
	 gsUJoM/nmvM2txQ+6taJUV4035qAhFNGQdw17vc7bTxJRiT5lARmUUscRGPpAdSJsN6kY
	 wSWNI9Y+Y1O2bc8yhrbnoq0RX/Mfv7CpdxuGzgkzmNKyHvYJ9iPWBl/6IzqjJAgk1BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rBIzKFdMgXJM18Gi5e3/hNl750NnSvoSOlNpYKTJw+s=;
	b=NwBnhEH9WtSi9YCFh4waumGfyx9S/xEz1ivdcdmpaxOsrUnnRFozq05x34+Vl5m5/k2Q
	 NvsZ/8M27Dw1Gk9rSgeO5EcIcdQJYIqwL51GqGXYe4WOFZ4o0X5c3zd8mFBy6EkOLem/t
	 DKMyqe1h/EuLlW0xPV25cKcgSq/7iFQ8LyeYo8xjS5zPG83XBYfHb1lzHY6qqlwd0Ki7D
	 QS9D+ts4jrkYurSeytKlA5yEF+8QYoaGyCtlj6UQdG+IKjKE4I03WE/sDBgcCZVgyLaK2
	 5BiYtqasFhR/YIOiozrCykuuiJ6kmEYReAtGPT3PYUX4NyqptSHBlkRir1jKv+MdJAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GSpTpo0w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1F2606A33E;
	Sat,  7 Nov 2026 15:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GSpTpo0w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E951F0089F;
	Sat,  7 Nov 2026 15:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064115;
	bh=rBIzKFdMgXJM18Gi5e3/hNl750NnSvoSOlNpYKTJw+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSpTpo0wyLrZnx/n4ZgZ2yCB8YEwBlJvW6a0gSsj3vD93qmiokl/kH5OI9kXLwbKy
	 4ZMuYe9jhL8CC4sqq2ELlp3Ukx7jnELUT5YQt0dD6rokkqfa2j0h9X6PiGDh4GPSge
	 uely1q9miFJv4bEnR6UeEYP4pqN4nY76sSXPCAwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0272/1257] ASoC: fsl_xcvr: free IRQ before canceling reset work
Date: Sat,  7 Nov 2026 08:42:48 -0500
Message-ID: <20261107134946.999173300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 9828272043511..29929dfcce2a6 100644
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
@@ -1617,7 +1619,7 @@ static int fsl_xcvr_probe(struct platform_device *pdev)
 	struct fsl_xcvr *xcvr;
 	struct resource *rx_res, *tx_res;
 	void __iomem *regs;
-	int ret, irq;
+	int ret;
 
 	xcvr = devm_kzalloc(dev, sizeof(*xcvr), GFP_KERNEL);
 	if (!xcvr)
@@ -1705,12 +1707,22 @@ static int fsl_xcvr_probe(struct platform_device *pdev)
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
 
@@ -1751,8 +1763,6 @@ static int fsl_xcvr_probe(struct platform_device *pdev)
 			fsl_xcvr_comp.name);
 	}
 
-	INIT_WORK(&xcvr->work_rst, reset_rx_work);
-	spin_lock_init(&xcvr->lock);
 	return ret;
 }
 
@@ -1760,6 +1770,8 @@ static void fsl_xcvr_remove(struct platform_device *pdev)
 {
 	struct fsl_xcvr *xcvr = dev_get_drvdata(&pdev->dev);
 
+	/* Free the IRQ first so irq0_isr() cannot requeue work_rst. */
+	devm_free_irq(&pdev->dev, xcvr->irq, xcvr);
 	cancel_work_sync(&xcvr->work_rst);
 	pm_runtime_disable(&pdev->dev);
 }
-- 
2.53.0



