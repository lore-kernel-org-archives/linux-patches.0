Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774701;
	b=4xce2x+/D1LyhzpRa3F8Ugn/7f1VjaKDCsK16RaYLtWNUsLFSFhZbmMPJjn87cXyL1/N
	 Z9BClukyls22D0ZvuNFqKUWJUcnLRRwoZOMBzZnFqEuTT//UOJYEKi2PcqT7xQW5n3jZr
	 E0geX+sc41kluzfaLGry5TS0iys8FGZKffH7acOmgt6q1dfrbCSvASr7tK+bt1I1GUlki
	 5ZCsTDJkNP92hHKFVvhynGBYazLdJVgTZ8edY2jZc1AYx1EgGwK9pm+rO+opCxWchWG1n
	 F3nhvWAuSPahEbM8DVQYNSlpT0W69uqo2EGXI9dc7BmIEttuGL2blDU299VIO5W2akw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774701;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fGEGLSwwl3wABj5iOhto8rqnVkc4C5nIxuD4F5AZKFQ=;
	b=UtcxCiCKN6BPRKWrnZCHSLueWCnWBUuNiLZl8Px1Vh8q1IltjhKsBtb+LaxfSMyu9yHJ
	 wUNagcfnJDmJsg8uoc4GTxZ+E30eiVQ4n5CHJeBQQctUDnyhFDLXQeNpsaBNnv/c0FDI0
	 ksdVc6F8K0sBbrqoMzIvQiALjSQtufyNZLE3DIOTlaL0JtR9IeGwqy6uL6YV/KSFV6ySh
	 a31wToURC1oiK1MvTIXLse1rihcapYIl8iaVQOyAIyNBUKKShjpXui0VqFepjGQTZekR3
	 Gqo+O0C06hz5i/N2YVrOj6wrzwNV2SzBv66y0TuUxb3BMWpWzIsr3FvEk3gwEwMfwzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YBMsuoq4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB54606A31A;
	Fri, 23 Oct 2026 16:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YBMsuoq4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408A81F01825;
	Fri, 23 Oct 2026 16:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774700;
	bh=fGEGLSwwl3wABj5iOhto8rqnVkc4C5nIxuD4F5AZKFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YBMsuoq49rrxnMvYVSq4IhkoUEjvThhgiju7rpjdsXXtDuKGOwWn4qS/q6snGFbKs
	 8AH6C7V80feod4PhKwBCIydUtdkxQe5GezLMXNBbbGnMMvz1ySEa3vIjL7geocx40I
	 2ahnhqpv0jIm27qdJqyGAAwvvlmqYWpIj9J33XZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 091/242] net: stmmac: dwmac1000: clear the RGMII status interrupt
Date: Fri, 23 Oct 2026 18:38:53 +0200
Message-ID: <20261023163715.929552585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Velkov <iav@iav.lv>

[ Upstream commit aa07285705f8d5bac464eb1c5b7412f8e88b91e1 ]

Since commit 2e2c878a3141 ("net: stmmac: remove SGMII/RGMII/SMII
interrupt handling") nothing on the RGMII path reads GMAC_RGSMIIIS, so
RGSMIIIS stays pending behind GMAC_INT_MASK from the first link change
on. stmmac_resume() resets the MAC in stmmac_hw_setup(); the reset sets
GMAC_INT_MASK to 0 until dwmac1000_core_init() writes the mask again,
and the pending status storms the line:

  dwmac_dma_interrupt: unexpected status 04000000

A register dump at the first message on ODROID-HC4 showed it:

  core int_status 00000001 int_mask 00000000 pmt 00000000 rgsmiiis 0000000d

When the resume thread runs on the CPU that takes the MAC interrupt,
the storm starves it: a soft lockup, then a watchdog reset or a hang.

Read GMAC_RGSMIIIS in dwmac1000_irq_status() when the status is not
masked, as the driver did before 2e2c878a3141; the read clears it.

Wake-on-LAN resume from s2idle with the resume thread and the MAC
interrupt on one CPU: Helios64 (dwmac-rk), 7.3-rc6, soft-locked in 3 of
3 resumes without a fix and in 0 of 10 with this patch; it ran with an
out-of-tree dwmac-rk change that keeps the GMAC powered across suspend.
ODROID-HC4 (dwmac-meson8b): 0 of 10 with this patch, 2 of 2 without a
fix on a 7.3-rc5 build. irq_rgmii_n went up by one per resume.

Fixes: 2e2c878a3141 ("net: stmmac: remove SGMII/RGMII/SMII interrupt handling")
Assisted-by: LLM
Signed-off-by: Igor Velkov <iav@iav.lv>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261009201709.1917585-1-iav@iav.lv
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index d4ace39248915..66337cfd98243 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -312,6 +312,12 @@ static int dwmac1000_irq_status(struct stmmac_priv *priv,
 	if (intr_status & (PCS_ANE_IRQ | PCS_LINK_IRQ))
 		stmmac_integrated_pcs_irq(priv, intr_status, x);
 
+	/* Reading RGSMIIIS clears the interrupt the MAC reset unmasks. */
+	if (intr_status & PCS_RGSMIIIS_IRQ) {
+		readl(ioaddr + GMAC_RGSMIIIS);
+		x->irq_rgmii_n++;
+	}
+
 	return ret;
 }
 
-- 
2.53.0



