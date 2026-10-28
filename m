Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212510;
	b=ozT57QubByYifmiasLOr76GFCjMcGuFNv8pngGhWdokEep6SBZhl3VWjVSY4qY+0t00T
	 tQ4lwEdRS0MiubSs0bsh1g6LtIjQy6kKnzHSr2APDY66uC2lCmADag5sqfKW9ka0o0XtT
	 sAXFCzuGt1K65BMfX74TqSpcL9My2fG6nG6vxNUdEbJsSFsRe2nW0l3Z7sAqwOnajKJAc
	 eASzRf4bK1v0L/P9dczIvO5Bl9uL9CG3E4Xa76PJoz9pQ+BddxOWegMflNWMaup2wnH5L
	 S2gG+9CySgBoX43h99vXJ7qkTN1BBTi22QurPU4PyldgQqntrcYwllhex8Z1tAn97TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ob9iKaLSI42YkvDcwkyqVQGEYsPfNDhAykeyMUfAYmE=;
	b=zcNpQdATB8XZbnk6btnj1C7Fel8NlPrQxRgOdZk9tgNNI4/4M25+bpj3yfIcvaJ7fYse
	 gBcDN8ZAYdciN89PYamWSCmHHnmhH7ZbYHPnXztoUNdqL9dV/CDMKYS4af6x0Rra8IuzS
	 yBlXP1lP5W5c9JXbvqaRuNfYv5O9WMa9oNZhB+5HcPeok4h4Zs8L38Q0/MdWQcPjfeBnZ
	 43fkfQIL1rwnrE4Cu/onWjoRYOwZyNyVvCf44etWKIzx6eIfsygXF7PMg/JylbM1OHPnN
	 S+a/OEe10cQBjXx5UN6hLyNIn10ntOdi2alIwkflp7fRgkBA4J5NLDVEg63gn7Ka+Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bkZGql2h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9563606A31E;
	Wed, 28 Oct 2026 18:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bkZGql2h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442771F01825;
	Wed, 28 Oct 2026 18:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212509;
	bh=Ob9iKaLSI42YkvDcwkyqVQGEYsPfNDhAykeyMUfAYmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bkZGql2hxlBL9EG3fhJ4h9ydt6YCGODKkiUtNVe3/BNP7EECHEFWnJFlf9MSaiyuO
	 cFJwazwBG4sSEn6S0Auh20w50NigMj2CnKJ7Vx5OOdoda9Tj9p7n+MxayWMoQego8+
	 cNygdAqXIgFXpXZ4R1rXWocQuWr8w1GqtLnrKjPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 0179/1887] rtc: spear: initialize IRQ state before requesting alarm IRQ
Date: Wed, 28 Oct 2026 17:37:55 +0100
Message-ID: <20261028170503.310165178@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 055ef5ce9f67a6a3a1363fa663007f8196cc0fb8 upstream.

devm_request_irq() enables the interrupt before it returns, so the handler
may run while probe is still initializing the device. Initialize the MMIO
address and spinlock before requesting the alarm IRQ.

Fixes: 0942a71e435f ("rtc: add support for spear rtc")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260902080318.3498434-1-runyu.xiao@seu.edu.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-spear.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -363,6 +363,12 @@ static int spear_rtc_probe(struct platfo
 	if (irq < 0)
 		return irq;
 
+	config->ioaddr = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(config->ioaddr))
+		return PTR_ERR(config->ioaddr);
+
+	spin_lock_init(&config->lock);
+
 	status = devm_request_irq(&pdev->dev, irq, spear_rtc_irq, 0, pdev->name,
 			config);
 	if (status) {
@@ -371,10 +377,6 @@ static int spear_rtc_probe(struct platfo
 		return status;
 	}
 
-	config->ioaddr = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(config->ioaddr))
-		return PTR_ERR(config->ioaddr);
-
 	config->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(config->clk))
 		return PTR_ERR(config->clk);
@@ -383,7 +385,6 @@ static int spear_rtc_probe(struct platfo
 	if (status < 0)
 		return status;
 
-	spin_lock_init(&config->lock);
 	platform_set_drvdata(pdev, config);
 
 	config->rtc->ops = &spear_rtc_ops;


