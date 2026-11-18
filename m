Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036991;
	b=Wr5Yf1+ao3Ez0Lo8sbBZJ54xiFIaDaiyuZVk8EghdloWvgGbxBC3F8KQBp181HxFExmd
	 Cni05YRaCIcb2SbgesqxrcdPff5thhJO51aRLGlq5js9TwxKtVtD/Y8Zn3Nips4/rj5Ht
	 fz10S5n9pvMI9vDlmNY+T/PISr1vjvVw9ATyLXWf0Q4AbN0JgwlonlYaCxu14qk5GkJTo
	 f1nJGHPuwQF5HDGgFAeUf6GPp5IcshHOyYIPEDSDsDFn2V1BXnmHYnM8fnBlMo8Ryo5UW
	 emW4HsKdZObErDnS0CdmVRXZrldbDJhjgvFPIhHFeiQSmN3ymISJDNINoOeGAMcw46w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uwHzGIz1Rm+Pw9egg+8HGD9/ZZPbSPSEKsj3U/7vceQ=;
	b=oQVNsrSF24PbR0SpdpFGh8JbJrjqDuNhhrZC22j2DV/Ps+6YddyZF/1J2QmkfsXHAO43
	 OS51cVKiwOojMtycGWv8zlT3mTv2ctnlbshKlnj7IZftR3sJh3BSrhSwGpzM34JrayrqH
	 D4qz77WsnV4XlNNzA5UKZgtzcAzw39qOia/P/4+J6J4D9CIdmoOhHno5goVeFHUkAMtsh
	 nljDEmJYOFTrVJFzIoDPpAcsWqAC/hTRvNy7FOEATqNgyP2cGzbsahR9fFrlJoSL0YGsD
	 yKIgS2BkKZTM4DhePnu0fO/qoGhlnDK1zFF65JITlT6NJIPbLlqNA7jRZYRAl8iQ7vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KAudJGJM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DA1606A33A;
	Wed, 18 Nov 2026 21:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KAudJGJM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DF71F000C4;
	Wed, 18 Nov 2026 21:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036991;
	bh=uwHzGIz1Rm+Pw9egg+8HGD9/ZZPbSPSEKsj3U/7vceQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KAudJGJMveFYjqRgttIHrQdz7nQ7xqK/ajgb+9Ggjvjwxo182RAom4gJWF2kQse+5
	 zd7xwqbHstA5gcBvo8zon5R4338Q6eMkcjQYJDtrIImjwpKfIhSpmU4HQ01zwxmKqA
	 BuXI5iO0QFdlYMF2JtHBMX4tfj1QO2dFe1nZMo38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1256/3318] LoongArch: Use pa_to_nid()/nid_to_addrbase() rather than hard-code
Date: Wed, 18 Nov 2026 15:31:18 +0100
Message-ID: <20261118150357.879834939@linuxfoundation.org>
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
index b5f9de9f102e4..553d8f72f0e23 100644
--- a/arch/loongarch/include/asm/numa.h
+++ b/arch/loongarch/include/asm/numa.h
@@ -14,7 +14,7 @@
 #define NODE_ADDRSPACE_SHIFT 44
 
 #define pa_to_nid(addr)		(((addr) & 0xf00000000000) >> NODE_ADDRSPACE_SHIFT)
-#define nid_to_addrbase(nid)	(_ULCAST_(nid) << NODE_ADDRSPACE_SHIFT)
+#define nid_to_addrbase(nid)	(_U64CAST_(nid) << NODE_ADDRSPACE_SHIFT)
 
 #ifdef CONFIG_NUMA
 
diff --git a/arch/loongarch/kernel/irq.c b/arch/loongarch/kernel/irq.c
index df42c063f6c43..f4da717512746 100644
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



