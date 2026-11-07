Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065491;
	b=m5wNTHfPRlCF/917NmDGaSb7Fk2QyXv7ntI9/RtPd9LbQxRldVYk0I1qiGndq99uLz2A
	 7VlEtrusbIjV5EBeX2qKIfQ6mPrDWoDB1HflJZdxbJtznnuG/l6K2xILRMJMiCY/J7o16
	 1Lyny59jP+zTWqQnEiAJI9xZGh8FU/j5NQKXq1ynU7T95Xhy5W7BeSO7UmgCaxDHS9tVw
	 LxMw7QlMrHMTAMZ410DdS7g1WpZJzFXdSEBoFa+97mN4Jt9mswddbOym1R7JZQJDhtQJH
	 Zac9BEQ/kmy0MctjbDtZGhnraJMyL1wIw4IeKCn9gjltGWRLWH+3s9dIH/Kk7Sl2V4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nl2R8ShqnwyikqVU+KMz61tmxMmsWBfv9x1Z7FBj8Co=;
	b=lVIoL6/uyGgPQ0ycs7mbBLudx305GlZriF1Wnwz2PsY+bgYrHuM088IAh+9qd7+7xBYo
	 DXqWv6tYUi8Xewf4x/NSRUCg03FSOuDnzaiMhaPPdJGLgnHSmntflTSnyX8gxSGY6Kd2l
	 Afj5a0+8awhmga5NA0JHYAWjMY0+yPc1sxxY5lWJLZA/AVJSfZQd/VZLfMXkrWA67aTgu
	 wV8qnhyGn82ZpCoDmqvDaLfPPGhWQ8TxGPXnL5Kov0QgRzmT5Ad0Y9CNBNEhFWVFmMPos
	 Prf1nOy9OL/yVip0HlwC0Th3RTj2Pfj0TILjo/ggyjxLd8Hima3qRMOXqrTg4yXMs8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Xktp/LJh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB57606A335;
	Sat,  7 Nov 2026 15:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xktp/LJh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A921F008A2;
	Sat,  7 Nov 2026 15:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065490;
	bh=nl2R8ShqnwyikqVU+KMz61tmxMmsWBfv9x1Z7FBj8Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xktp/LJhn37/UQrH+uCC4SrRi7oq7ijyXPEWuZUY2JvL6wzUbzwXaTc7pBDitQrTT
	 WKdDSrV5+kWjH3RiHLRIj6sFhk68fWpDNeRMCAOrE8wCPxcsbfkXzwdXrp2h92T0AY
	 BmxwTVm3YUJUI+UzLJV3AGFTIh45fcZFUMJwjTGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1164/1257] LoongArch: Use pa_to_nid()/nid_to_addrbase() rather than hard-code
Date: Sat,  7 Nov 2026 08:57:40 -0500
Message-ID: <20261107135011.338221295@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 7bf68a7a5f4b3..29e0f2baaa8c1 100644
--- a/arch/loongarch/kernel/irq.c
+++ b/arch/loongarch/kernel/irq.c
@@ -20,6 +20,7 @@
 
 #include <asm/irq.h>
 #include <asm/loongson.h>
+#include <asm/numa.h>
 #include <asm/setup.h>
 
 DEFINE_PER_CPU(unsigned long, irq_stack);
@@ -69,7 +70,7 @@ static int __init early_pci_mcfg_parse(struct acpi_table_header *header)
 
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



