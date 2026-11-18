Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029098;
	b=ZIdSNnIok21rr2cjHuFfBwyZMUZVzdxjcwCXAMuvlMvp+uqaVvM4ut52qIL9MyEsr+NQ
	 lNIZpaQiAj78TzTUz9Rcm7xxecntVpddgVSJgIYN3J02X7gwSvkxmeGz7mdeb1NltMqtf
	 s75QX/mecttQhqwgajsG1MmnHtXiF06AHa/PMMOqomGIdoohRsu+kOzHWQFkdSA9Csoko
	 2MEQ7FZMSstsE2UALdcaHSqKQATn0TXzD+1cW9ZCYf/flljfelzrYVPS7kmOOdpSJgWu9
	 xuJ1MKDpg+S/xlwEYkbuljIfjM3FPdTzn0X1EMD3WP3hg1062EGLv6gTE5HwnWumSsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=27eKhSk9oha9KgduKK5smMvJo1jeZbCFO7PHWNtlOzc=;
	b=IW6V2wDfJANFIoIvO3SRKVT0SYgaAkd2O4WPgN1iAmyB0AgmIWfJEaqJnLnBUWZExpyx
	 tZ6ElBhh+wf3+0XaMyhrQjs33rj+v/s3YuGbg47Y1ieYw7qNz9stk7UZOkFC0v5+orVvT
	 MaElyPVeLjcjM2fTW9k6fgKBWHSqsHbBKkiNkjUr6HB3/h+INo61GfhYIvGcImiv2CIZN
	 ModdRtj4k4WQuUXb1vixYoluEfqEH6rukyYgZsYQZpu0cMaUFxErJLqPycvqvBxqHgdmz
	 bpSTPlFrZLHWdj1GomdvkXuyN2uiF4kcULmzcurpP9UsdyUk3PXlunn7ML9OXHi/zEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WEpETg3h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68232606A32A;
	Wed, 18 Nov 2026 19:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WEpETg3h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0431F000C4;
	Wed, 18 Nov 2026 19:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029098;
	bh=27eKhSk9oha9KgduKK5smMvJo1jeZbCFO7PHWNtlOzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WEpETg3hKJZaBqFhzC+pYrkQj73bOSaOkTBw1SW5WcyN9Z3N2Dag5VFBy9kGWxHsq
	 aoCA523HjgXEqkAdBp6Kxt6SbZkhiV2h3MBkvKYjWgWeiC59yRw+3MVjYixHbawXJH
	 6KDno0s/gL9jhEBxtTavTXYb5hrwfdp8jbimRE5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0230/1756] irqchip/riscv-imsic: Use GENMASK for base address masks
Date: Wed, 18 Nov 2026 15:39:17 +0100
Message-ID: <20261118150017.426448166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 06ff0e17c0c33..61e30372a67df 100644
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
@@ -739,9 +740,9 @@ static int __init imsic_parse_fwnode(struct fwnode_handle *fwnode,
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
 
@@ -820,9 +821,9 @@ int __init imsic_setup_state(struct fwnode_handle *fwnode, void *opaque)
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



