Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041696;
	b=ZBGTdlSXtsoah/yEs/MBtfhXpK2MFRdD15GVZE+y0cK+f1WYPYFXVDZ6uQyte5mJG7Q9
	 vIFzLv6Lr8rbTnvyapsbRl1L1GQwaZq8pzY39bwyPnkxSQP208M3Bk+9rAPKh4fyqxiyx
	 KsrPjiDI8NnEr2Yr1varuuMR+XJ1r98UE5Nx5N8HihicDyrEMRYEm2h0IptlKmUV1YckM
	 8fEG1sqZxuZkxP1cpkkyw/09cZIm1TPtpekX6u7lsCQWHf47FiEr1+kReA3a6nCfSCR63
	 W4fBC3YVfElxFI+/kLgWIKDNnVjNFsUSOzmkhBeBdBWd1ziq1pLDHSlbFavR+vqozKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rwcEuCpFvLs9J728Zl1R2hBdl9c7dYD2nt89UBrm4IQ=;
	b=bWzN6vleZCTQ8sqWReaRja8WHTvUgf2Oxn16r61XyXYK185VRjAltihYCbxe6+Hd9hP0
	 MZEE3dHAEzKQbCnk2haADHt7D6089lBnx9PfdOYa+p9ACXM6x1RiimvHLsz1csLd0JyQ/
	 RRoq406dD3FVcgzCEMDtn1Ql+dZdqXlkCUtyHso1Kjt9eU0UNkox4cHTPwN3loeJk2i0v
	 mczsevFxI1pnYnxlr5n6wL/B6M+ViOiCEkJfYRqiJ3kG7Cw4Wd6YpjSbv3DL7dhx/bLRK
	 1X9IsO2zCPCOm95T3v+kbtf7EFPVmpcvm035yjg5JjgF6lmOHmHxUT6svS0MNs70tFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O6SgCuii;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7606606A31C;
	Wed, 18 Nov 2026 22:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O6SgCuii
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BAC1F000C4;
	Wed, 18 Nov 2026 22:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041696;
	bh=rwcEuCpFvLs9J728Zl1R2hBdl9c7dYD2nt89UBrm4IQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O6SgCuiiLKhDN3B/d+DkMxwj7HppTRtevNZj/P43NqnTEXn5xVXG0lDZ0DcasYc8J
	 ImLQA5+bXC+h2yDQHn1PB/33JNaDM+FhzKHq5XuVmxqEjE6wHozaaGpCnzsJH4umxJ
	 evW4AdEVkfS7FTEqgJidG8ZL6aosPtVNUVFkY5mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2907/3318] irqchip/gic-v3-its: Dont free a vPE table shared with another ITS
Date: Wed, 18 Nov 2026 15:58:49 +0100
Message-ID: <20261118150447.672967098@linuxfoundation.org>
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
index 312b64f8e1f64..1447d91cf6f7f 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -83,6 +83,8 @@ struct its_baser {
 	u64		val;
 	u32		order;
 	u32		psz;
+	/* Inherited from a sibling ITS, not freed here */
+	bool		shared;
 };
 
 struct its_device;
@@ -2620,7 +2622,8 @@ static void its_free_tables(struct its_node *its)
 
 	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
 		if (its->tables[i].base) {
-			its_free_pages(its->tables[i].base, its->tables[i].order);
+			if (!its->tables[i].shared)
+				its_free_pages(its->tables[i].base, its->tables[i].order);
 			its->tables[i].base = NULL;
 		}
 	}
@@ -2719,6 +2722,7 @@ static int its_alloc_tables(struct its_node *its)
 				WARN_ON(i != 2);
 				if ((sibling = find_sibling_its(its))) {
 					*baser = sibling->tables[2];
+					baser->shared = true;
 					its_write_baser(its, baser, baser->val);
 					continue;
 				}
-- 
2.53.0



