Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045851;
	b=3NnCXZx1RxXTTL4cxhDxOzffq2OyrVDp7qnM4Z39wWvEFLJb0OxR8OceyvUfwR/QjIiW
	 j4nXWDP1VIG6DsLTiV3wwQjXgGlrtt+ZjvbJ6op6Q0Md7X9GCcbOW5PWKIuPiaKuT/vu7
	 rCxs59ydDTxBoe21qzxT19Cw16h4P5V3isMy52uat8eydzS3yOmxGdeWUntyJHPif4vKH
	 ziM1ARq3T2gcFtFR1tlZCpwXWPvVxKnE1XOgeUfsi2dpgOYjGzTCYaCEgOyVPfkDqkqU/
	 m/Nr2P2PirZ4z3aJAMklqiPYuclnG/wp/L3LRQip4/kzXKIF2e7Fszshc2+rKjlOSBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4rLnfo5MOYrm/Jz1ra5MdbAefNNfyDhY4eG/q+WZZsA=;
	b=cQKtnFTskUWOjXix4FX4fxjIhzG8btJ1zXAIsljF1wBZg50GuyBTaWGApj8N9aMRfgst
	 m71ui52DEHTgyKEOsZ8soeIVIQVTylOzvfO1utmCxjEoNtQDME1yYGObtJwEYcB4s0qIf
	 LQ4iQRjtW724pCLn+pyoZ/E7o2apj67hQ16XD8IwkXvUGZu5CyM+ueSrjsK0e2O8Mut45
	 oXl3s7WU9Ra3i8W+RN/A0wclEgw9E1nN6FAEGifvUF0PqyxHUAcsb5SfabY17oCuL088D
	 DmDG808UPUfhpM87a2G6YrlnlI30Oj3qXNs+fqOq0XNn/JES+0bgwJnaUbryRBgM1aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=otQ2gV1I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76284606A32A;
	Wed, 18 Nov 2026 23:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=otQ2gV1I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FC11F000C5;
	Wed, 18 Nov 2026 23:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045851;
	bh=4rLnfo5MOYrm/Jz1ra5MdbAefNNfyDhY4eG/q+WZZsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=otQ2gV1IrMciGR3zBS7MmGi/jLNIcvPmgldW6TzNTgttrXvmpcBSH+ZT1k2dE4vyX
	 XkGizYyX2dws9n8OjBC53/TuKiITRnmRp/qoa0mIOsbfURPQp6XpYR8C7S/7TlvV7r
	 O87yp7FDdJKgxw1H+mYYs1ZSWMWLvg7SQUUKngGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1069/2857] LoongArch: Use pa_to_nid()/nid_to_addrbase() rather than hard-code
Date: Wed, 18 Nov 2026 15:35:03 +0100
Message-ID: <20261118150240.094648736@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 27f319b498625..50c30c9d2a180 100644
--- a/arch/loongarch/include/asm/numa.h
+++ b/arch/loongarch/include/asm/numa.h
@@ -14,7 +14,7 @@
 #define NODE_ADDRSPACE_SHIFT 44
 
 #define pa_to_nid(addr)		(((addr) & 0xf00000000000) >> NODE_ADDRSPACE_SHIFT)
-#define nid_to_addrbase(nid)	(_ULCAST_(nid) << NODE_ADDRSPACE_SHIFT)
+#define nid_to_addrbase(nid)	(_U64CAST_(nid) << NODE_ADDRSPACE_SHIFT)
 
 #ifdef CONFIG_NUMA
 
diff --git a/arch/loongarch/kernel/irq.c b/arch/loongarch/kernel/irq.c
index 4496649c9e68b..0a8d3beb3662e 100644
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
index a25307d6aee81..d4deff031ded7 100644
--- a/arch/loongarch/pci/pci.c
+++ b/arch/loongarch/pci/pci.c
@@ -13,6 +13,7 @@
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <asm/cacheflush.h>
 #include <asm/loongson.h>
+#include <asm/numa.h>
 
 #define PCI_DEVICE_ID_LOONGSON_HOST     0x7a00
 #define PCI_DEVICE_ID_LOONGSON_DC1      0x7a06
@@ -44,7 +45,7 @@ int raw_pci_write(unsigned int domain, unsigned int bus, unsigned int devfn,
 
 phys_addr_t mcfg_addr_init(int node)
 {
-	return (((u64)node << 44) | MCFG_EXT_PCICFG_BASE);
+	return (nid_to_addrbase(node) | MCFG_EXT_PCICFG_BASE);
 }
 
 static int __init pcibios_init(void)
-- 
2.53.0



