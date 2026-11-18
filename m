Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038395;
	b=UVEdbjXZwQhgdMNw6jqNcAfb9pVtu5WaRAA/bZHU965QgzRyCIkJmc3YHOFJ6YEAZwxI
	 H28e6jHWtUHR9QWt/YTJFshom/YVjMbK+BkknCaEDMrYHbEeDn/asbXlArLaUj3eLwFCC
	 3caT/H+wi0GQILI+bcS8HLiFsnR115L2wZX6J2M/bqbvQKGqbbeYMidcK1PrdkBEjxyjs
	 tHNSJ38EA4tGTHdwQp4GqUS5on17vDREySh2a+f9eQYjrwQVWb1QiR4ba+gpLJTiW1piO
	 A+9mhbsefSksbLkU4s8kvc0PL0Pa6nspLHKt4eu3xAqZ1GIUqHDKAf7rPfLshv/Fy0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sf2N0bY4jr+k1NI1NDPP2EBjXlsIw4kSlIhv6lS4Q8E=;
	b=2p+Jzyqxqg2ZRvCmSIlxRfTeu9g7VKo1yKXQMCzNwrVEudE4PS7ZZ0lJhMaYlw8sk/Fm
	 KvyQtpuxH5/RDbFQhkxu71lxLkO/JRpbjOwZplgnvZhTv1MdQI8Alh+IzgFnLzF+u16jQ
	 XS2BHMDys/zvqmgSQ8UFXltFU+PoBlRk8XlxOHJEPmTd4E3KWSNPB1tmp6P2+EESTPbS4
	 cy628ZsUeqWiWwJ3EA4TpLmvh6YCq8iamqoAY+gp/KPK86LS3fsrVIQs6vr313HzkQPvo
	 WfAc/kM+CcGgr+YAQalFxMCCqBfkEZ9hczR2W5oG9jaxwwEx1mhMnTumajTxeb1UXUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=koA8eK8G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66ED3606A320;
	Wed, 18 Nov 2026 21:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=koA8eK8G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F061F000C4;
	Wed, 18 Nov 2026 21:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038395;
	bh=sf2N0bY4jr+k1NI1NDPP2EBjXlsIw4kSlIhv6lS4Q8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=koA8eK8G5ZafhPH00FDC7UISbm1KQSGL3bJWxVNBuDI9YBiy4gX6vVh0rtayOWlVh
	 iJmcDEVDortZo9JIPOwBsnpLITDR5cmOTU7ypI3GiG0j8pHM2KXIOoHGOPzUJTt8hF
	 AM5cQ+NpJ2d1GvOHm+DYt/5f8XyfNnBHqQXcBgkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1728/3318] irqchip/imx-intmux: Fix runtime PM teardown on remove
Date: Wed, 18 Nov 2026 15:39:10 +0100
Message-ID: <20261118150413.708103513@linuxfoundation.org>
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
index cdd6c47e589d3..4a9c5b0fccc86 100644
--- a/drivers/irqchip/irq-imx-intmux.c
+++ b/drivers/irqchip/irq-imx-intmux.c
@@ -285,12 +285,16 @@ static int imx_intmux_probe(struct platform_device *pdev)
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
 
@@ -298,6 +302,11 @@ static void imx_intmux_remove(struct platform_device *pdev)
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



