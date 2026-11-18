Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026866;
	b=YdDPB/7oFcjHNHG/eHQrgnvoAaxDojJ3EbHGDdCjpD8D+7/CbdSKXIdwcijKeAyDuA82
	 xxHWRduq0SdcJPB6XZSzkVOvs85CzuqwGuk8UalLd4w04jKi/k+2AfqrugCTLJCY/IvgM
	 BFQwItWyfb5X4A190w2UTAZfl3R41L92PV4FEHCURKCaFk7QtV+L8IS8Ur1KlonPErcZi
	 ++hzz20ACMKpg/mVrsCNAHKFYRFAk9OwV8fw0LWUSSzUjqWVTCacQoyLlPTxUWVyGbme4
	 k+Y6YB8XCXF/SJiWIViJks1eC1ofuPfKYyyCcNe+1n6M/1GopXKOihFwt1jcUBchWKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YJsmnop7uYn7QBh7obJ7OrQSnqBm0K0s3APgmC2FbLU=;
	b=5hlCp6HJ54ALDdgFVAvFSRHfDq1Oi+wgk6c5vhwrrkpdjYU8DqSnXsHSU5PRFzF2eTiH
	 K6oVXCu95dPxC/tnA1onGcopS4F+QK5lrjfyNp3RW5bhKE/J37jIRy76wckxz5ArAeYjg
	 LLON+XgsJIc5OU6dH/JxFxxiG6Yu/lcqQcNojtij1bOIvwndMCcDTKq8qXMxruV24UziP
	 ME+MbyJICnd9XJ6cRT34zeB2pnhSSszXULcEsrN7oKePVWoAsP2qjpar3/PdRyxmfs/zw
	 z7l7rHcUH3v6STBVL6EjFKPdn8U7qgKojghcXULsRJAORaHyMUAzhQVfRxVxh3vRmUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GVpzWBnT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37511606A31C;
	Wed, 18 Nov 2026 18:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GVpzWBnT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5391F000CA;
	Wed, 18 Nov 2026 18:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026866;
	bh=YJsmnop7uYn7QBh7obJ7OrQSnqBm0K0s3APgmC2FbLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GVpzWBnTgEis3MueKFXJGOo43hz2KYOz7dPP4zEKSxpOIeeBfAVpViel88/BPi0hW
	 rM38VfmDV2pSYyz6TtggF0p3jTPfq/khQ4tWZBm6KF628RWApcH0/JgSTYvoofbKUL
	 IrVTo+TJExHZ/ND1IUrO0j93beUpXYrmyIs7UHu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1586/2151] irqchip/gic-v3-its: Dont free the tables of an enabled ITS
Date: Wed, 18 Nov 2026 15:55:21 +0100
Message-ID: <20261118150219.657137926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index b8384ceebb270..9fb9c06b9242e 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5333,16 +5333,18 @@ static int __init its_probe_one(struct its_node *its)
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



