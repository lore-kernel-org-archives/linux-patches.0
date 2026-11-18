Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059617;
	b=cORyG81KEDS74kX3dSels+/zqVlByEPd+HO4X0rHiRvHpGz2tldNcW+qI3MXkQ6hAk7w
	 jaScvtn9DilV0Rt85TMjbIPZZfO8Tn94swvcBSTF06qgCFYJy59YaJiuGazSCKwwgW2Yv
	 iEPxeFL8x1tx8hEU7ihY+XKYzTQXR9t5xGJcttDV65rCoBsaeR6GqTfimXpLD7rwxxgZg
	 5MAyqg1X0AG7NkujiN8uLaLmlsjlZLGUOMOBoj/kZfgZLrJhhEdK6ZViRvxfqXykS7Tni
	 9p5qSFYZKrD//yI4flN3afHinADRTQdZ5DdbSG7FE+ngQuId/4HAbfjqVAbQAl2HXPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gUPTKZ6nZZRi9kzSlZiKeLn96PTVrCzT5SewO0UTCQU=;
	b=jg5+J6QKKP7sUrr3WOPmi4QACXdTNAhIbcWaGfJY5I+5wQdduaK/xx+Gr88fFiZYtTP5
	 GA1qO5iyxNF0JVM6oQGIO/a5YA3x2AlnH139/qtGpL1NsjetTgKaqsVd/JY8Na0GQjnY8
	 3dBW4kIO8MgOpaU/MGWNVupVRtj0QVtV4xDleneR8bBsX6nN/5JsM8Ip9zGHFF7Zq86Le
	 hZfw3+tvUNnyNMIkCwDIMdZ/JgWoDSVpM5E6oYngQx98NMghY3j5DcjrQRD/PQf61kk1q
	 beTPQPqscCwXowmvy6nxuSmZqQW3cIvow+1bwShvKuRW+vBO9cqxZjx0cn4U+9Qtkrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jNAD78YS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577DC60A261F;
	Thu, 19 Nov 2026 03:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jNAD78YS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67E31F000C9;
	Thu, 19 Nov 2026 03:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059617;
	bh=gUPTKZ6nZZRi9kzSlZiKeLn96PTVrCzT5SewO0UTCQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jNAD78YSTusKJP2M+i99L4/1r5HSLg1048BDBGw/y2TGNPTdDPmTe0RQS8EeazxGw
	 RhjuxBFfRnD/5W4rifXpQabBZjAHm+/niqQ23MA33tl+sXiMqz9FPI8dOxjvH2CwGx
	 F7+MplEWyPwjbV3RQ4my6wwrYRhjxnHmXPZ3CF+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0905/1848] irqchip/imx-intmux: Fix runtime PM teardown on remove
Date: Wed, 18 Nov 2026 15:49:03 +0100
Message-ID: <20261118145954.670260169@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit b167c1a30e9e020e4c5e102c7a555943742c024b ]

imx_intmux_probe() enables the IPG clock and then drops its runtime PM
reference with pm_runtime_put(). With CONFIG_PM enabled, the runtime
suspend callback disables the IPG clock. With CONFIG_PM disabled, the
clock remains enabled after probe.

imx_intmux_remove() accesses the CHANIER registers without first making
sure that the device is runtime active. The device may therefore be
runtime suspended with the IPG clock disabled when these registers are
accessed. In addition, the remove path only calls pm_runtime_disable()
and does not balance the clock enable when CONFIG_PM is disabled.

Resume the device and acquire a runtime PM reference before accessing
the registers. If resume fails, skip the register accesses but still
tear down the chained handlers and IRQ domains. Disable runtime PM
afterwards, drop the acquired reference without triggering another
runtime suspend, and explicitly disable the IPG clock.

This keeps the clock enabled while the hardware registers are accessed
and balances the clk_prepare_enable() performed during probe for both
CONFIG_PM configurations.

This issue was found by manual code inspection.

Fixes: bb403111e017 ("irqchip/imx-intmux: Implement intmux runtime power management")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Radu Rendec <radu@rendec.net>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260914134211.1734163-1-lgs201920130244@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-imx-intmux.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-imx-intmux.c b/drivers/irqchip/irq-imx-intmux.c
index 576f28c9ebdb3..37f9be67f7c58 100644
--- a/drivers/irqchip/irq-imx-intmux.c
+++ b/drivers/irqchip/irq-imx-intmux.c
@@ -289,12 +289,16 @@ static int imx_intmux_probe(struct platform_device *pdev)
 static void imx_intmux_remove(struct platform_device *pdev)
 {
 	struct intmux_data *data = platform_get_drvdata(pdev);
-	int i;
+	int i, ret;
+
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret < 0)
+		dev_warn(&pdev->dev, "failed to resume device: %d\n", ret);
 
 	for (i = 0; i < data->channum; i++) {
 		/* disable all interrupt sources of this channel */
-		writel_relaxed(0, data->regs + CHANIER(i));
-
+		if (ret >= 0)
+			writel_relaxed(0, data->regs + CHANIER(i));
 		irq_set_chained_handler_and_data(data->irqchip_data[i].irq,
 						 NULL, NULL);
 
@@ -302,6 +306,11 @@ static void imx_intmux_remove(struct platform_device *pdev)
 	}
 
 	pm_runtime_disable(&pdev->dev);
+	if (ret >= 0) {
+		pm_runtime_put_noidle(&pdev->dev);
+		clk_disable_unprepare(data->ipg_clk);
+		pm_runtime_set_suspended(&pdev->dev);
+	}
 }
 
 #ifdef CONFIG_PM
-- 
2.53.0



