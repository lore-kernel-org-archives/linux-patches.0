Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061179;
	b=xahOa8jrxHILsyvuBQSNrl74XGO3xa146QOdwuWZYLeJnc+nMVcgP5ihyEYJ7o3suf2e
	 Uk5e4ynkLQHZKbuHLtBcnadi2YJWbrIphxIdNT1VYixSDccuVNTlb4tvr5tez/epupgGW
	 IcgmX+ec+yM5Wpl62OR2zfWe8jJX3MVarOumdMo5soGOP5LtPTwAWZQt81Xa9nbPizOQz
	 pwtwIlctZ/smkKi0haXWGm9qSwjVC8mQdmIeoFTGbgs9jWTYpmIEhP8EGP3B2UELa0yN6
	 0uDqVkoZVnh76Sm3uoi28VDiG//QT+j0dJco+itKUpxdqPCtQVD565fCOTTRAgWJ77A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y6Ht5OyVv5+mkU9yFRq6N7gcNma+hjDn2dxAhK92qiY=;
	b=t53t7AibNeUF7XTRgstasQMdC1W+JA6N2tnx7UuAJVmi/oqqm8lOrEN6rNx/vza6K3J5
	 7Ru+Gggs5uh6N4E/LQ7cr4cbTMtgi1xt2FcE09T47bQuQDVkf+k99dNtKVNg/v90I9oLs
	 65qrpXEItDFuVumUyq/38GgqfkeFoFzNY4kFKl0H/nEqnvLghVy9ZWi/Ud0Ypp5AwgvQO
	 nuA4p+fKt8lDcxECxMEVwiU2fvchcYYC+U4JexuxeCn9wHwwuxLDc9vtYGEqC9fzxBaA/
	 Y0CX/8e1rW+ilLHo6I9/TJGqYXKeKZ6Pmh7cuJBjjqoEOkwmnJYcN2pKO3oWBEMkxpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LCqcOQok;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258A4606A320;
	Thu, 19 Nov 2026 04:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LCqcOQok
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B791F000C4;
	Thu, 19 Nov 2026 04:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061179;
	bh=Y6Ht5OyVv5+mkU9yFRq6N7gcNma+hjDn2dxAhK92qiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LCqcOQokWDWJn+ktAP/aMt0Im1AZZnQiVWsX/oAuOneA2/OpCY/1wUBbmFkXuw5g/
	 B6D2kbOpYxyMc/puU2BrrpttRkAUZnwu/kLL8N7elt7JRwSBYV190p8ihXSmvMeKwt
	 dTW30UMw3FkIpSPqY+GlmrsJZhnWXY5Vd2a9tn9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Cooper <codekipper@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1458/1848] power: supply: ab8500_fg: Request all IRQs as threaded
Date: Wed, 18 Nov 2026 15:58:16 +0100
Message-ID: <20261118150020.407017384@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 807042539d8ed11299c9278e55d2cb6df8d04a39 ]

Since these IRQs are cascaded from a nested IRQ, the
generic IRQ system detects this and refuse to deliver
a fastpath IRQ in response to request_irq():

  nested = irq_settings_is_nested_thread(desc);
  if (nested) {
          if (!new->thread_fn) {
                  ret = -EINVAL;
                  goto out_mput;
          }
   (...)

Threaded IRQs work just as well so let's just request
threaded IRQs. One of the IRQs are alread requested
as threaded anyways.

Cc: Marcus Cooper <codekipper@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 1098c619ce75 ("power: supply: ab8500_charger: Handle detection errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_fg.c | 47 ++++++++------------------------
 1 file changed, 11 insertions(+), 36 deletions(-)

diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index 161abfd4afeb0..e289e6cad777c 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -3008,14 +3008,11 @@ static int ab8500_fg_remove(struct platform_device *pdev)
 }
 
 /* ab8500 fg driver interrupts and their respective isr */
-static struct ab8500_fg_interrupts ab8500_fg_irq_th[] = {
+static struct ab8500_fg_interrupts ab8500_fg_irq[] = {
 	{"NCONV_ACCU", ab8500_fg_cc_convend_handler},
 	{"BATT_OVV", ab8500_fg_batt_ovv_handler},
 	{"LOW_BAT_F", ab8500_fg_lowbatf_handler},
 	{"CC_INT_CALIB", ab8500_fg_cc_int_calib_handler},
-};
-
-static struct ab8500_fg_interrupts ab8500_fg_irq_bh[] = {
 	{"CCEOC", ab8500_fg_cc_data_end_handler},
 };
 
@@ -3156,44 +3153,25 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 	init_completion(&di->ab8500_fg_complete);
 
 	/* Register primary interrupt handlers */
-	for (i = 0; i < ARRAY_SIZE(ab8500_fg_irq_th); i++) {
-		irq = platform_get_irq_byname(pdev, ab8500_fg_irq_th[i].name);
+	for (i = 0; i < ARRAY_SIZE(ab8500_fg_irq); i++) {
+		irq = platform_get_irq_byname(pdev, ab8500_fg_irq[i].name);
 		if (irq < 0) {
 			ret = irq;
-			goto free_irq_th;
+			goto free_irq;
 		}
 
-		ret = request_irq(irq, ab8500_fg_irq_th[i].isr,
-				  IRQF_SHARED | IRQF_NO_SUSPEND,
-				  ab8500_fg_irq_th[i].name, di);
+		ret = request_threaded_irq(irq, NULL, ab8500_fg_irq[i].isr,
+				  IRQF_SHARED | IRQF_NO_SUSPEND | IRQF_ONESHOT,
+				  ab8500_fg_irq[i].name, di);
 
 		if (ret != 0) {
 			dev_err(dev, "failed to request %s IRQ %d: %d\n",
-				ab8500_fg_irq_th[i].name, irq, ret);
-			goto free_irq_th;
+				ab8500_fg_irq[i].name, irq, ret);
+			goto free_irq;
 		}
 		dev_dbg(dev, "Requested %s IRQ %d: %d\n",
-			ab8500_fg_irq_th[i].name, irq, ret);
-	}
-
-	/* Register threaded interrupt handler */
-	irq = platform_get_irq_byname(pdev, ab8500_fg_irq_bh[0].name);
-	if (irq < 0) {
-		ret = irq;
-		goto free_irq_th;
-	}
-
-	ret = request_threaded_irq(irq, NULL, ab8500_fg_irq_bh[0].isr,
-				IRQF_SHARED | IRQF_NO_SUSPEND | IRQF_ONESHOT,
-			ab8500_fg_irq_bh[0].name, di);
-
-	if (ret != 0) {
-		dev_err(dev, "failed to request %s IRQ %d: %d\n",
-			ab8500_fg_irq_bh[0].name, irq, ret);
-		goto free_irq_th;
+			ab8500_fg_irq[i].name, irq, ret);
 	}
-	dev_dbg(dev, "Requested %s IRQ %d: %d\n",
-		ab8500_fg_irq_bh[0].name, irq, ret);
 
 	di->irq = platform_get_irq_byname(pdev, "CCEOC");
 	disable_irq(di->irq);
@@ -3230,12 +3208,9 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 
 free_irq:
 	/* We also have to free all registered irqs */
-	irq = platform_get_irq_byname(pdev, ab8500_fg_irq_bh[0].name);
-	free_irq(irq, di);
-free_irq_th:
 	while (--i >= 0) {
 		/* Last assignment of i from primary interrupt handlers */
-		irq = platform_get_irq_byname(pdev, ab8500_fg_irq_th[i].name);
+		irq = platform_get_irq_byname(pdev, ab8500_fg_irq[i].name);
 		free_irq(irq, di);
 	}
 
-- 
2.53.0



