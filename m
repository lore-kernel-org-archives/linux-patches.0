Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063758;
	b=d1M1xy2EQEZJOUTM8Xorz45JkUvi9kYXKLs2sW5lFC5tIkc2FwWpGXw40ibLJ3F7HAH/
	 Li+L/HhYEekW1AP7wt+WJwJ0sBtWGHE3Z4886vhBN1NI0WlkUF04xcjHQmhiXaR8jUZHB
	 k5ERM0FP4ZlIagE8CPj/2IYlrf5HkLbvtaNzckwCsXJlULIQrhacgb7+vi/oqH8TQQgKs
	 VDFobIFrS0pFLuBUwvhGOuGLcO3qUY0B1IiqUpjj4Jz26WluTLYp6RsPDUqM3oPjQpT4Q
	 tLA8wnZcYbB8rynTR24KRPg/h4hj6q208592qmKWvc4Ll5gBtg1qEWkKQTTekwS8APA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HV0OHLJT2r3SIImdBsAy6/EQJyINJf0K1Y1WVDsDIXA=;
	b=saS5NBN3ndUO3+UFa+y7HxSCvEoxSQa65yPwBeqIPzpivdXgG0rIMfFLEg7ofeUgeIms
	 yaWXRmA5Eqb7Sjktxz/7HhoUPagn3nPQ98Bh2FiHdmJg1ZlTAtGGiGFQwwFuAVCUteXsr
	 aYCzhBwc8FRyN6cTNP9YJ17zeXqeHnrooV4Z6pe97KGaX034cd426qEA29s5VfJXSG7Re
	 lIpcnsmhr4W/D/PRPIvfN2O4YawDBvFilkJIXC88qRMdogsIVhVSzeQWzhDL2mbAy4Ioh
	 MzYpcnZ6Ep/3yWnTO25VORELO8OIUQFEJtM7eI5DTJ25xCcvCLTsFw3A0qT7ZsuxzZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BR2tJFNR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90195606D81B;
	Sat,  7 Nov 2026 15:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BR2tJFNR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3ED1F008A1;
	Sat,  7 Nov 2026 15:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063758;
	bh=HV0OHLJT2r3SIImdBsAy6/EQJyINJf0K1Y1WVDsDIXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BR2tJFNRJ1Ls2Id1QsCgY9wLNYPg2wSbvNC/ejos5892dGRynoTxmbxN7NMnEFi+n
	 zs0p7FUAEuX5vLfSO044W2D62xoLrhGzsk7AhsI2Z9roFRZAovOoS8Q6tx7cNRtRih
	 z5p24rUL7+SxsnqXO1O2b9oDXP5tOHaUWGL6w+DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 803/869] LoongArch: Use pa_to_nid()/nid_to_addrbase() rather than hard-code
Date: Sat,  7 Nov 2026 08:58:05 -0500
Message-ID: <20261107134920.149493564@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 244eb26bbd152896f976db6415550993cd60b46d ]

NODE_ADDRSPACE_SHIFT is 44 now but may be changed in future, so use
pa_to_nid()/nid_to_addrbase() rather than hard-code.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/numa.h | 2 +-
 arch/loongarch/kernel/irq.c       | 3 ++-
 arch/loongarch/pci/pci.c          | 3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/include/asm/numa.h b/arch/loongarch/include/asm/numa.h
index bbf9f70bd25f4..c9654ff900a3a 100644
--- a/arch/loongarch/include/asm/numa.h
+++ b/arch/loongarch/include/asm/numa.h
@@ -14,7 +14,7 @@
 #define NODE_ADDRSPACE_SHIFT 44
 
 #define pa_to_nid(addr)		(((addr) & 0xf00000000000) >> NODE_ADDRSPACE_SHIFT)
-#define nid_to_addrbase(nid)	(_ULCAST_(nid) << NODE_ADDRSPACE_SHIFT)
+#define nid_to_addrbase(nid)	(_U64CAST_(nid) << NODE_ADDRSPACE_SHIFT)
 
 #ifdef CONFIG_NUMA
 
diff --git a/arch/loongarch/kernel/irq.c b/arch/loongarch/kernel/irq.c
index 80946cafaec1b..130954ab9ee20 100644
--- a/arch/loongarch/kernel/irq.c
+++ b/arch/loongarch/kernel/irq.c
@@ -19,6 +19,7 @@
 
 #include <asm/irq.h>
 #include <asm/loongson.h>
+#include <asm/numa.h>
 #include <asm/setup.h>
 
 DEFINE_PER_CPU(unsigned long, irq_stack);
@@ -68,7 +69,7 @@ static int __init early_pci_mcfg_parse(struct acpi_table_header *header)
 
 	for (i = 0; i < n; i++, mptr++) {
 		msi_group[i].pci_segment = mptr->pci_segment;
-		pch_group[i].node = msi_group[i].node = (mptr->address >> 44) & 0xf;
+		pch_group[i].node = msi_group[i].node = pa_to_nid(mptr->address);
 	}
 
 	return 0;
diff --git a/arch/loongarch/pci/pci.c b/arch/loongarch/pci/pci.c
index f33c7ea1443d9..0b99b32110a5d 100644
--- a/arch/loongarch/pci/pci.c
+++ b/arch/loongarch/pci/pci.c
@@ -12,6 +12,7 @@
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <asm/cacheflush.h>
 #include <asm/loongson.h>
+#include <asm/numa.h>
 
 #define PCI_DEVICE_ID_LOONGSON_HOST     0x7a00
 #define PCI_DEVICE_ID_LOONGSON_DC1      0x7a06
@@ -43,7 +44,7 @@ int raw_pci_write(unsigned int domain, unsigned int bus, unsigned int devfn,
 
 phys_addr_t mcfg_addr_init(int node)
 {
-	return (((u64)node << 44) | MCFG_EXT_PCICFG_BASE);
+	return (nid_to_addrbase(node) | MCFG_EXT_PCICFG_BASE);
 }
 
 static int __init pcibios_init(void)
-- 
2.53.0



