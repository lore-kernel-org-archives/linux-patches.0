Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053988;
	b=eordMxhShk1LSUnESTVEafCJc+ihvORNjWfditsHReMFCXo8UNszui67aja1B5lKdHOM
	 dBEse4jmXhy1/kuUsNpzI4VbvcBTdOyXaia37Pv3l+aPvbrLUrP3uOVB06rVgyWO9Fifo
	 CRPCYM85k6K/AVZUacXlB3ayiPtNDkh6U0d6ZHY6eRqCBGN9dLYlvjEnR+/U9hvgvLB1v
	 Pz6gYuwO/VhCVvlq9/uaOcmRSbkU0fNY0mKm30HbcIjnEHF/4zpK3T7tsTAJ4xcivMg+o
	 NY1BOq6j3x6TkUTYiGJQJMRe2VDduH+P8rySvnLBe2nczS4lZuTfS4ivC97piKMk1Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jwW13ieVBEKtHIf7ucGpWoQu4s18b1gKpnVX0OLj4Wc=;
	b=WZDkZKt4hibf0LOs9SjH0y9rpXmS4Z99D1u/OXEFeK/V+1FcMKCBHJdnCgkufmdH2sGX
	 3j7X+J9/bEmlHMHFB9ZEBG0b3rYIFxKcc26xAJFomksCpJcEWx0pnA7HYNsdyDxE/X3vW
	 sRiRq67ZKE4ogBXVBuXeAwBmMfTmoZiGFFxMSMiCo4pSOtLxgfkvLW63D9UOuUYX1OQZ4
	 IGr5jqxSJExJX3az4x9u5opPxT+ENNCz+5UqgNm9eQe+UwtrtluY6+WwHC49441SYf3Ew
	 80PKQJc0ZQjf9UcUyL3PYDZMr/19eZG83yHeN8bkn06LmkTGuRc6vB5JnjxaDLyjF5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OjuABIJV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF40606A31C;
	Thu, 19 Nov 2026 02:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OjuABIJV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F791F000C4;
	Thu, 19 Nov 2026 02:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053988;
	bh=jwW13ieVBEKtHIf7ucGpWoQu4s18b1gKpnVX0OLj4Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OjuABIJV2IyPhcdgFW3tcaBqp55eozKDY+15bhS3gEcdxoUYPsm4PBwsaqSMgpIj8
	 3uDrP8W+irAc0wD/25X5T4VS6Uwk2jd1gXexBrdQ59ag/Q1yo/egnX6YXujRVrEL3A
	 5TWPZ6st4izvbXPPhH8ilZIo9hrswE58yVAO2VWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1074/2214] irqchip/imx-intmux: Fix runtime PM teardown on remove
Date: Wed, 18 Nov 2026 15:45:50 +0100
Message-ID: <20261118150055.228822895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 45d2ac494a82d..10390446b4f01 100644
--- a/drivers/irqchip/irq-imx-intmux.c
+++ b/drivers/irqchip/irq-imx-intmux.c
@@ -286,12 +286,16 @@ static int imx_intmux_probe(struct platform_device *pdev)
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
 
@@ -299,6 +303,11 @@ static void imx_intmux_remove(struct platform_device *pdev)
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



