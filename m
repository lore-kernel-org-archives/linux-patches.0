Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015557;
	b=ZUiDZyKj2bRTw2iVtLUYPRHeDp/imIKxcWbd/ePfkw7e1b2qSOw0vxRVe3TOa7qGeH3W
	 MJwXuXcTJTkBKiooQ7nb6pdKpkHgzvfdncfge0tukGZvExEX4yCjw/Es4mk/G8fbj0smJ
	 xhu0rrJvxL1g2hjdY//zVWsLSMqTTMhCky/l/Si8PV5qdAJIrwwzcaLkgKVTWkPm8YLY+
	 AGP0dn9QWZJ5BVLcTblpE0SOIk5G6Y1CymtZQCTv59zElrrGQTviL2+PSk5TAnkBS5brk
	 rWO13AAGd/V3kiEoz1sHo6A0PL8Qmcb1SXIYRMnFizlHZw+M1NsoFMPc9NsQT8hcVdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EcgoE8dYhKhT1xBdN/iz8Njm80UbtZmLvdE5BiCtWXQ=;
	b=dlIhnwisOoqwn/YEVxKADwFUjBIfizbiMU8pHOsK1w+0V+cCVRN38dpZeD5ytbt4R7L0
	 pRXBuXmxRSa52tS+moZix9aKWA+D5/RkOi2o65ER17O4nTmIicSdmOZMhsmbyRp5BeUAD
	 cSEWECdqXBtH+q00eaNKoA2oyAEnsz7uaMXaPGJYH9Z1nvkBgDSKgAFQhBFQE+f94fW3g
	 wQkRRbBeL/cUx3LBWzf111tjcBfbvJcpYSpWGZs1x0Qk/FoKMCCrZbL4olYQVh1O+p2IS
	 wDQLFlgbQ5lU8z57reyFu4OMDBF/5TzVPKqr2TM+3dLQ1NjK4+zqqyVtcnOT/jzHfHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MVhepN+C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84911606A334;
	Wed, 18 Nov 2026 15:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MVhepN+C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965081F000C9;
	Wed, 18 Nov 2026 15:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015557;
	bh=EcgoE8dYhKhT1xBdN/iz8Njm80UbtZmLvdE5BiCtWXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MVhepN+CE3U/nTNrXegl07PdDh4zPTVtYxnW6fOtcr2jVe6RsVwj9cn6afqtWfBeY
	 aCEwjH2h+JIBdCDQVqugXJ1XGuGDizBrz1YOvsRV4TSey3sqnioNsCjs17c3Ev0Qmx
	 SbyUR0HWCNkbvt5uCaw7szzrKwq5svKalrYQqzJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0217/2651] irqchip/riscv-imsic: Use GENMASK for base address masks
Date: Wed, 18 Nov 2026 15:24:17 +0100
Message-ID: <20261118150255.684643188@linuxfoundation.org>
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
index b8d1bbbf42f73..9505ddbd9eec9 100644
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
@@ -769,9 +770,9 @@ static int __init imsic_parse_fwnode(struct fwnode_handle *fwnode,
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
 
@@ -850,9 +851,9 @@ int __init imsic_setup_state(struct fwnode_handle *fwnode, void *opaque)
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



