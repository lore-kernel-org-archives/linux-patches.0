Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049918;
	b=VBbH4BTlDwByQAyQNaP8x5s8CcSJOCjCwQQnWRknx2C8rqs/nKn6D0UdKXm2sy6kDPqm
	 0YVFHW/UaEUZW273aKi0ioFN/IFAF1sznBaW8x2ylxmWAh11znYqMhZAkAG1LUqObYcRp
	 3ARrASXvuyJUfkfwMeh5tXi2e8jL1kzMnQi/WOej0We0IbVpiyOlLYiRKSak73VDtpbeR
	 WS1uDWD0ydsFX3rUd/9OTB1zaxkRdcsbYk2pjJGJCHdgn8r9VYMotC0FXb8hAKQg3FRK+
	 YI/iVDchKwqLMAazKIq6MuUj3r1q146CzFZybH8SRz14UcXlIaeJidH5us5ED23qivw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hd9E4X4kjY4gh+J/vNplSxwnyhnPC2jsh3lF04FfZRo=;
	b=vA9Q3Vaec+tRQgOIl5FJf201ErDrjFRyMjXLB1PMQf7yK91eK0nUVG5q6zyOw09026qe
	 aUXFvW8/gaQUdJF8he6WWjsOYTmjWVpNV9u+vuhW0g1vwHCrlIvU/skR4laM6I9oT4f+Q
	 nrCc7WDUEJAcQHOOOkLIR/Flt9kkT+oBLGXCbPdYpvnPMsBgDiwbmNGWAfqe6WcLTBn9F
	 wXhSAx4RIVyHvJPuE7WOHo8trovPO71OPzPhizelqCuTPznJfHWgl+x3sr9Bq7L31iSNd
	 91yGHejcTkac/N8+lbZMmxHwquzhAbUaD6mUWGnILw9wHSE6Pb1mAiGVupFwqkxGJdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IuyiLwsR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CCA606A325;
	Thu, 19 Nov 2026 00:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IuyiLwsR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1225A1F000C4;
	Thu, 19 Nov 2026 00:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049918;
	bh=Hd9E4X4kjY4gh+J/vNplSxwnyhnPC2jsh3lF04FfZRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IuyiLwsRxiyHFFHlf4WnynLw/Xq4X/yts6jTa8g5v/rxTsqIyzZFJbfREqapGJ5Fe
	 8kj8fGA7ZVbdCDZZKOvHqL7LNpIjARrQBprPQWW9E0Wot9jougtoQY2h1oQNgiW8Hj
	 pNaT0Wl48wAoHufUo/UBHj64sqVSuy2ZZkt+Zkc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2522/2857] irqchip/gic-v3-its: Dont free the tables of an enabled ITS
Date: Wed, 18 Nov 2026 15:59:16 +0100
Message-ID: <20261118150332.349007355@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit d09b36d8e0e60f35bd1cd7d63aadc6dfad61700c ]

its_probe_one() enables the ITS before its_init_domain(), the last step
that can fail, and the unwind from there frees the tables and the
command queue without disabling it. The kernel comes up with an enabled
ITS pointing at freed pages.

Enable the ITS last. Nothing reaches the new domain before then: this
runs from init_IRQ(), and the ITS joins its_nodes only after the enable.

Fixes: 4c21f3c26ecc2 ("irqchip: GICv3: ITS: DT probing and initialization")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260925085000.753400-3-fuad.tabba@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 0b8ad8bb59359..38b856c705def 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5195,16 +5195,18 @@ static int __init its_probe_one(struct its_node *its)
 	}
 
 	gits_write_cwriter(0, its->base + GITS_CWRITER);
+
+	err = its_init_domain(its);
+	if (err)
+		goto out_free_collection;
+
+	/* Enable last: the unwind frees memory an enabled ITS may access */
 	ctlr = readl_relaxed(its->base + GITS_CTLR);
 	ctlr |= GITS_CTLR_ENABLE;
 	if (is_v4(its))
 		ctlr |= GITS_CTLR_ImDe;
 	writel_relaxed(ctlr, its->base + GITS_CTLR);
 
-	err = its_init_domain(its);
-	if (err)
-		goto out_free_collection;
-
 	raw_spin_lock(&its_lock);
 	list_add(&its->entry, &its_nodes);
 	raw_spin_unlock(&its_lock);
-- 
2.53.0



