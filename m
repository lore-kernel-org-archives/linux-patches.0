Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020397;
	b=2ZUi4e/t4VBM3eKLaShASEygpoeUrD9KrmcmXTGOJ/Z7TmYnXDJzjGcScmsZDDTWvDqt
	 QRkdZ4jVRWFBzvU8Jk0zR0iM5xu1OLi1CYaxCbEX7cN4nzBf20lKGSBiVeUicLrLHjyOT
	 cUeluxtbabDNHlaL6BFoSt14Vam7CxM0ub5r/IU+srRZ/YQHTkNbUXpzklsGMpRg5IIoR
	 kozOMTJVrs79BGY2dwfya1dbzJPNZt8mXwkiUDJndKMXWuCBJWXGvPcKOTzx48lRUPp+a
	 I8/HnvDdIX2UOfQN4SvxhuURsSTy//oSjbArEDuMmr2NEPnez7TOdKmY5XILH5zdAuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zXLbW4uUpCGdigYQwEEF4CvDweqQaLvPt8fTTO80AdU=;
	b=L5EkqRUxZ0+RKVAQYJ7CnxwYjIDfF3rxzGs6qoKGpLWrwSG5E6VECKzU1C+J/I+I8cJb
	 eIVDFecfw51L/ULB3a4Bt0gHM8ogE4fLnNIpJO/JoGCYWmkxcLpwzn80dGL3XGJQIIwKv
	 HvqzGApxMjmfuOfYCqLiwjgsxXSu1MHtJSPDFlngZ86PudoZSJY68coTlsEwtZiMuPixl
	 QNvIrAU9/W9VTNZTNLs4/WY55UWxh7HWCLZ4sTVHiKsOlVqbfHL7a6MjEK6+93MlTjbOl
	 HDgkOnj5OCdmtXNn3BIIk3S4mcXQnjeXn14ml21OCGd3w57gAIf3GUKSUXAZrTZdQwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pUNQXkOT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099D2606A31C;
	Wed, 18 Nov 2026 16:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pUNQXkOT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B9F1F000C4;
	Wed, 18 Nov 2026 16:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020396;
	bh=zXLbW4uUpCGdigYQwEEF4CvDweqQaLvPt8fTTO80AdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pUNQXkOTszLwsPINQ0y6riKmBadNRvVmo6LdryxbDoqy6/DNUVKu6rjfpcK9/5oj9
	 Aq+kbMeq+czccTjGq64OV0Il2P7ZTmUEBezKDtols//zXzaZrAiR/6p3EX7JBw+749
	 RqcD/YV+0qc/GqsVW5+9KfBSTLjLKHp/EwNZNGpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1938/2651] irqchip/gic-v3: Release the partition node in gic_irq_get_fwspec_info()
Date: Wed, 18 Nov 2026 15:52:58 +0100
Message-ID: <20261118150356.411259222@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit 0773b76611e9c596c825076d422d372697da9940 ]

gic_irq_get_fwspec_info() never puts the node it takes from
of_find_node_by_phandle(), so every lookup from a four-cell PPI or EPPI
specifier naming a partition leaks one.

The node is only used for the comparison against gic_data.parts[], and
the mask returned points into gic_data, so it can go out of scope with
the lookup.

Fixes: 68905ea65ceff ("irqchip/gic-v3: Add FW info retrieval support")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Reviewed-by: Radu Rendec <radu@rendec.net>
Link: https://patch.msgid.link/20260908142632.2795308-2-fuad.tabba@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 6e1fa5b247fc4..b0142b0a93fa4 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1728,8 +1728,6 @@ static int gic_irq_get_fwspec_info(struct irq_fwspec *fwspec, struct irq_fwspec_
 
 	/* If the specifier provides an affinity, use it */
 	if (fwspec->param_count == 4 && fwspec->param[3]) {
-		struct fwnode_handle *fw;
-
 		switch (fwspec->param[0]) {
 		case 1:			/* PPI */
 		case 3:			/* EPPI */
@@ -1738,7 +1736,10 @@ static int gic_irq_get_fwspec_info(struct irq_fwspec *fwspec, struct irq_fwspec_
 			return 0;
 		}
 
-		fw = of_fwnode_handle(of_find_node_by_phandle(fwspec->param[3]));
+		struct device_node *np __free(device_node) =
+			of_find_node_by_phandle(fwspec->param[3]);
+		struct fwnode_handle *fw = of_fwnode_handle(np);
+
 		if (!fw)
 			return -ENOENT;
 
-- 
2.53.0



