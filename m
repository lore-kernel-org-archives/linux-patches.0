Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061761;
	b=vCbviTyO5q69M7nDI8tK+3oqEofMwrfLvvqwf9MBty7P6sM6ZhUN5DanQO2BoidmvGXp
	 TrkJoAFSLon84DDvnVx4OlP0X4F29f4CKsk4JOavNiY101mVDom5QlMbwcloE7Quwlnm7
	 Uh6/9rNcVKNxZ5SIcD7aKKSey+6xUCy9gw7BA8Qx0jSYgr3dVDuV1emBBU9ud+Tq5wfBD
	 0kR02AmQH7D3GAMr9nsWfotHOiV4Yfn1xAT6h+WLhZxNJP2dU4sMgM0bPObB5BZoI76wt
	 DOytw7g3izLeS2kDWX51Y7UVqNLO5dDz0+6NjsS8nc2lNulwppQXnwWHccV7OIMoHRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tkr1V2IElujicWlyVUdPCzb2Bm3bkljNEe3Uh5SQ5UQ=;
	b=CY1gW3PfnCGJ47DsCRGqfZgK9HVOVn5onFnfib7+YOOsQ4RDLcndY8C6oXc5S0HP0v8U
	 PLb0I//3FHVj57fjjHrPDwbwrQT/8JyIrbZYADsmn6yce7P0/4w1cBhtbiu+uqYJCo9yV
	 vt5ffJ1hptkV0VffbkRQtWX3FXF5fsLaWOKC2yofhd/m6m9Wo0GQ+NOW5VlmL2WxeDYR9
	 8jrBrknjGbwo0qoRvEN5TNCFslfy1A6rOxU1giuTbU1JJU95+zM8WlLOaVAcyEl6tuDXo
	 CaLaXFRNVTkrnwRSiiMTKk1cH+9/BnyeksrK6cx+948WoFEE67mmfvMu9zjmuzbrhvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=luGBacRi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AEB606A330;
	Thu, 19 Nov 2026 04:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=luGBacRi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA031F000C4;
	Thu, 19 Nov 2026 04:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061760;
	bh=tkr1V2IElujicWlyVUdPCzb2Bm3bkljNEe3Uh5SQ5UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=luGBacRiGmS+XySQWz+gRysi9iTiYHlUYzh41kIbkJnJb0mD+AiFa6g73kJg1njaY
	 LcdKFl3mI2T2gP7I+wlQgHJ/NfCiMXDKzo2B/9V0RukVy2nMov63mzXZQXoPT25Yt1
	 Lw+7jAVAA3MWekxriRWxJsUWSEyQ82+CzwwCMDqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1668/1848] irqchip/gic-v3-its: Dont free a vPE table shared with another ITS
Date: Wed, 18 Nov 2026 16:01:46 +0100
Message-ID: <20261118150029.665159504@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit 32e056cc1d1582951f981113ca8b98914f29c32a ]

On GICv4.1, its_alloc_tables() copies a sibling's vPE table baser
rather than allocating one, but its_free_tables() frees it like the
rest. A probe failure on the copying ITS then frees pages the enabled
sibling still points GITS_BASER2 at, and the kernel comes up running
on that sibling.

Mark a shared table so its_free_tables() skips it.

Fixes: 5e5168461c22c ("irqchip/gic-v4.1: VPE table (aka GICR_VPROPBASER) allocation")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260925085000.753400-2-fuad.tabba@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 014a4d0e042fe..8db6d5462de79 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -85,6 +85,8 @@ struct its_baser {
 	u64		val;
 	u32		order;
 	u32		psz;
+	/* Inherited from a sibling ITS, not freed here */
+	bool		shared;
 };
 
 struct its_device;
@@ -2628,7 +2630,8 @@ static void its_free_tables(struct its_node *its)
 
 	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
 		if (its->tables[i].base) {
-			its_free_pages(its->tables[i].base, its->tables[i].order);
+			if (!its->tables[i].shared)
+				its_free_pages(its->tables[i].base, its->tables[i].order);
 			its->tables[i].base = NULL;
 		}
 	}
@@ -2722,6 +2725,7 @@ static int its_alloc_tables(struct its_node *its)
 				WARN_ON(i != 2);
 				if ((sibling = find_sibling_its(its))) {
 					*baser = sibling->tables[2];
+					baser->shared = true;
 					its_write_baser(its, baser, baser->val);
 					continue;
 				}
-- 
2.53.0



