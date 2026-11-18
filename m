Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020419;
	b=dxOhmtmntZ4KJFXHv3lZzQKuGjTSRJKycUjAuC6ngkSVpzIx4K6hUq7lvpSFgcN39fOW
	 2Gf0Jz34yXApck3I1km6TJQVPQ0jYjzhr/Aedff1h49npomIX4E6f7PZ+X0cO/ItaZD5X
	 xEyVDlZeCUpKUiVODt2EgQAt+3QlcuKot567qiQ895Bs9s/YUiaISWWIsUsjoCC+PyA6K
	 +44QHdoIHcP/DxUlfGLEqOOgJPCJvK1mqvxkwB6p9/cts4X7U/7UQIP0O+UuAKV0k1Jpi
	 16poMpy57tDh0oFErzoXiCEht8o+JtJUy+Ypha7ftzc6FzwjmO0rB+s0KYg4so75wKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yj6KLJmlCH1QchrfyE9mA6lUYP3kcnOtEiDYghc1+PE=;
	b=0NiTZjssa1+S31TUSpux1KsG09MVRc+NBZ7aRby0h5XAOPtj8od0KOp0B+xIqR7sPy27
	 HYnAmiejwQq+HvdtF2DEmBvyKRClpCh4DeJGb4ng8s+4mykerdxLzFdNUn4lYLo7Zdkbg
	 U6tmXN49Pb1v9/WujWv9y9hqKcNw7Yute7dCpE+Liy/8HfdoXYQnf0w/eb2gzLFydRQGo
	 1JXovucIOTT4H5TfsVAdH8uqY8fnJTUrtEGuQl4QRYtznJUz+38LFoe/S6Go0Lxzz0Mr0
	 Hfj6mJ1S03iJWGZkAXx5m+an8lko/sq9EFqlRuBzeN7v3MHW8ZBe49aJBe+DiVr07DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ozwR5yFz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1BC606A320;
	Wed, 18 Nov 2026 16:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ozwR5yFz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA20B1F000C5;
	Wed, 18 Nov 2026 16:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020419;
	bh=Yj6KLJmlCH1QchrfyE9mA6lUYP3kcnOtEiDYghc1+PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ozwR5yFzID1Zdwypvke8h3dWt5MZVDLB2q0VbTdLpHA4jWXtPHFJvg91JmQEOcw7J
	 FTY+v/HROqWzSkhZ5mmTCCWtQGceqJetBOxMIjCeMob4s3cZM7TSgeK226DAafW9xg
	 J8aEo/5njFuBL/xVzRoTsagOJo+8LEGD8fJHgeiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1945/2651] irqchip/gic-v3-its: Dont free a vPE table shared with another ITS
Date: Wed, 18 Nov 2026 15:53:05 +0100
Message-ID: <20261118150356.623905295@linuxfoundation.org>
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
index 4083265750b6b..73bce111d202f 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -87,6 +87,8 @@ struct its_baser {
 	u64		val;
 	u32		order;
 	u32		psz;
+	/* Inherited from a sibling ITS, not freed here */
+	bool		shared;
 };
 
 struct its_device;
@@ -2605,7 +2607,8 @@ static void its_free_tables(struct its_node *its)
 
 	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
 		if (its->tables[i].base) {
-			its_free_pages(its->tables[i].base, its->tables[i].order);
+			if (!its->tables[i].shared)
+				its_free_pages(its->tables[i].base, its->tables[i].order);
 			its->tables[i].base = NULL;
 		}
 	}
@@ -2704,6 +2707,7 @@ static int its_alloc_tables(struct its_node *its)
 				WARN_ON(i != 2);
 				if ((sibling = find_sibling_its(its))) {
 					*baser = sibling->tables[2];
+					baser->shared = true;
 					its_write_baser(its, baser, baser->val);
 					continue;
 				}
-- 
2.53.0



