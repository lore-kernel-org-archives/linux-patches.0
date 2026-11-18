Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023064;
	b=c5qPwebZwmbVA/2Gxz593tMcFTffYD6c8pJXYFul4f95iggIAH57cCC9/pPhhDM+UtWf
	 JlR+C7fOkuhZVItfDeioNBE87xV0LPfxZPgzQkWsrUx7y9iVGfjOLLScGc2KLSigxbLYg
	 G4xZ8gehZkcTd4EmiZ5q6YDilosJoTEBM6WVenjoBqSthtXZVXRYUTDXcVp3M0wQvbxAK
	 /YWd7iM7MTh/6V/d6blqgSp4b9dGr4DZ6E7So40D5f1TwmWdm5cbNxBEJfloJD6qldxJl
	 ktzC6x8gywHiWgfqLqFy9WP1Fz6BWCC7QbgpPwAYuX+qMNpEb0qzBuX/VBQJp8lRsPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yo+3lVoLhYnq6nBlUx+vwzDyOup7p5QY6qBeniKGEAY=;
	b=rqX0CLw3iz/aYnitPfw77zR/6ayChW/VTVwQo+pv26T3a+biE1s8HBiYxRTxEHbjPQAg
	 +mnFImfGK/y6aNUViVmsPNHX9b6JgENaCmfC3D99duZ+59yLwyQejjDl6WUq8/8jWR40e
	 UYqGEwRU9yJR1n6c+6UIWdnh648nBVnh2vlnKgEKn1+u1MwYsqv9Gfjezj58Eg3Jrtwhz
	 XZEF0qxv8lzyDMN2nJAuNkpYQ2Ms8vbBoFOgEasZ2/z6sraTzk4ddBhG7Z8md16n2g/iy
	 5RPuzwrn5aJEqasAIzlsaakHbnzYqVwJO0uCiBaxeXtrUnckmvfm+1YQh9E5RhnfxKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oC+kqlUE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA83606A31C;
	Wed, 18 Nov 2026 17:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oC+kqlUE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300541F000C4;
	Wed, 18 Nov 2026 17:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023064;
	bh=yo+3lVoLhYnq6nBlUx+vwzDyOup7p5QY6qBeniKGEAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oC+kqlUEXjd7fYNKOkTs6uwO8Nlhxm7bPzYiNsOzoB6blf6oB7X8uAcH3zS6Fe4ep
	 5Tr4z22avg0Tsrq8Z/Ty8cmrD9hKQWDZ93HSyU5Y3AjoSDsazvxfpZVJnrKo668Fdb
	 4ujKwZXAYxHgS9dFw5GFDiXUGjx5xGDDeeyTO7VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0234/2151] irqchip/riscv-imsic: Use GENMASK for base address masks
Date: Wed, 18 Nov 2026 15:32:49 +0100
Message-ID: <20261118150130.302610984@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit bd7d57a03c4b0fa3b0291ec64d688ebfed5edffc ]

The IMSIC DT binding allows riscv,guest-index-bits up to 7 and
riscv,hart-index-bits up to 15. On RV32, guest-index-bits=7 and
hart-index-bits=13, together with the 12-bit IMSIC page offset, is a
binding-valid layout that consumes a 32-bit low-address mask.

The parser accepts this equality case because it rejects only values
larger than the remaining bit budget. The base address canonicalization
then builds the low-address mask with BIT(sum) - 1. When sum is 32 on
RV32, that expression shifts an unsigned long by its full width.

Keep the legal equality layout and express the mask with GENMASK(sum - 1,
0) instead. The existing parser bounds guarantee that sum - 1 is below
BITS_PER_LONG at both mask sites.

Fixes: 21a8f8a0eb35 ("irqchip: Add RISC-V incoming MSI controller early driver")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://patch.msgid.link/20260718040000.004.929c1ef2-caplitmus-rv@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-riscv-imsic-state.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-riscv-imsic-state.c b/drivers/irqchip/irq-riscv-imsic-state.c
index dc95ad856d80a..e42be461ae670 100644
--- a/drivers/irqchip/irq-riscv-imsic-state.c
+++ b/drivers/irqchip/irq-riscv-imsic-state.c
@@ -7,6 +7,7 @@
 #define pr_fmt(fmt) "riscv-imsic: " fmt
 #include <linux/acpi.h>
 #include <linux/cpu.h>
+#include <linux/bits.h>
 #include <linux/bitmap.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
@@ -779,9 +780,9 @@ static int __init imsic_parse_fwnode(struct fwnode_handle *fwnode,
 		return -EINVAL;
 	}
 	global->base_addr = res.start;
-	global->base_addr &= ~(BIT(global->guest_index_bits +
-				   global->hart_index_bits +
-				   IMSIC_MMIO_PAGE_SHIFT) - 1);
+	global->base_addr &= ~GENMASK(global->guest_index_bits +
+				       global->hart_index_bits +
+				       IMSIC_MMIO_PAGE_SHIFT - 1, 0);
 	global->base_addr &= ~((BIT(global->group_index_bits) - 1) <<
 			       global->group_index_shift);
 
@@ -860,9 +861,9 @@ int __init imsic_setup_state(struct fwnode_handle *fwnode, void *opaque)
 		}
 
 		base_addr = mmios[i].start;
-		base_addr &= ~(BIT(global->guest_index_bits +
-				   global->hart_index_bits +
-				   IMSIC_MMIO_PAGE_SHIFT) - 1);
+		base_addr &= ~GENMASK(global->guest_index_bits +
+				      global->hart_index_bits +
+				      IMSIC_MMIO_PAGE_SHIFT - 1, 0);
 		base_addr &= ~((BIT(global->group_index_bits) - 1) <<
 			       global->group_index_shift);
 		if (base_addr != global->base_addr) {
-- 
2.53.0



