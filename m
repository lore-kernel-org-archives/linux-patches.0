Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064876;
	b=QbxSy3lI7S8URnd9rTM8pCWdxjM9f0ZLtXfoqQJ560+mvFZHWInFarw+a7OKGknC6lZc
	 S1l020ZvkI77stdeRBfEZVeEmF4FSW5xZ9Fb/sVAMtBaqvWvr3nTAjqbQyeGPPQLIgzjU
	 D+tExkq98OtsTjh2XvQd7RAa0BGVZbZva7ez/toLOcWAm/lRjmhIuw0tgH8uClKS6x1/p
	 ucfIP2nMb9+IqpleS7ApnXRjNtKqiVCHF3g8DsRpUlQ0oEx1ii7WmKgazfhk3BFDEqhkV
	 YPkaXyzKsXx8hvvjdXI0gRA3TsslHhsku92Bk2kLcc0U7HJfJ4wAlqg7knBOB8CArpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C/qKEbDYpIiC+wbLuoPkR8jl/l9xnb2T30QHYJoxOIU=;
	b=yM5aqzTblSTOOzTRvc/Ji/uzwUq9t+an0kOMhjwFb+9DaU0zSZCGNXVuaJEH9uBnxFGs
	 7Nh4ZVwElp4MfVh+YWYUE5e0Yo+J/IKGsY0Ijzm7oE3XWwzsPQJdiXXwiuwMt/cR5Qd+q
	 fmTveiHBYmWdDElgDH1dGIma8Iw2WN1WIY4ySCCJacaOR748jNcGHUJou8heU7JywKIPy
	 oA9wXGGHKKKaidUP4fWQsp5xFAw1ZwT8/jBBfdd6rpXk3jARsII/eVWt8HS87+hazlney
	 XpTMZeQme7wU8HkCz1x7Us9UaObNkMRN/KG4hi/gw0cg7Nn72qMTuC5RVmVdzsRd+Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DL7rz9FG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B79606CE4E;
	Sat,  7 Nov 2026 15:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DL7rz9FG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7621F0089F;
	Sat,  7 Nov 2026 15:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064875;
	bh=C/qKEbDYpIiC+wbLuoPkR8jl/l9xnb2T30QHYJoxOIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DL7rz9FGrEPkYMPAzafk+6x6xEbWxGkoXMiBa96mUp613GTKDvxlhJB7M5d/WW/Ob
	 HMR0LvqQHCwLf7dhmrwtXPrncrgmH5yNelYsDqPiN4xyXIk7NcxLgljYiIcR7VcQ8K
	 OydXl22OMWu4R5jeNehGHxoyDgmTQLQpxbmvY2kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0788/1257] irqchip/imx-intmux: Fix runtime PM teardown on remove
Date: Sat,  7 Nov 2026 08:51:24 -0500
Message-ID: <20261107135001.087210396@linuxfoundation.org>
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
index 47c2681d138a0..de2a8f98f6255 100644
--- a/drivers/irqchip/irq-imx-intmux.c
+++ b/drivers/irqchip/irq-imx-intmux.c
@@ -288,12 +288,16 @@ static int imx_intmux_probe(struct platform_device *pdev)
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
 
@@ -301,6 +305,11 @@ static void imx_intmux_remove(struct platform_device *pdev)
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



