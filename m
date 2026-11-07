Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062647;
	b=fO+TJ4FJKsZj1d3PYZ7400lUMpnvOneELLzHrREgZgD0tEsSVhITQZAhzawCXEkSILaj
	 MYOK8OGzSVITDCAvHMGpLrQ2qor5L1K9qoT+f9vHwxsNcTwOeXbC28X1hhdL6U6HGWChq
	 Xe9Dz/CJ1sPVG1oTJEZx+a1MvGyRsTsIgNf6MCoZqFnpSsaDHNH1182Pn6wlfEiI92GIT
	 RYVmwg9gOJL6jqTDZI7S3qvjqv87cyA0Jqh9KaWGnW1gW3ZwOLH1JWlQ074XcNbfe7RHp
	 M3NBzkPnzvBR8rLIyr0MBby12tPi9rDKL5i0ps/wv3yUbgjcY9H9nJzXJxV97Hvmo7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062647;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=InXqhY3DbS9wEMmSqU/fy7R4Tyo8rwIKzxvJEQ44GuE=;
	b=2mwuGTQ9xClhoV0BjqxxtCMCU9MKcS1N7cBdav4mm4gcAyXYQg1ZefO299y7yl/3vqCQ
	 LXHoZGRyPGGugVJtbTa6e9Tphx8AR9YdQj9WxdWlpA52SmE42MqejsEtakueJjQOApmiS
	 KtBdKcXbQJQOq0NxfW4qmAM0ewCELVfLBHSaCKIFzIu8lq7ON8bzc6HaeExQfb4Gx2v1P
	 SvWNpDlIrGqUJCcDQTSRyN1Y5a2D+8R8g2ZPXBZFLeGzqcNA+1dsCFWmZjVKZB6ft3JFc
	 idV+mu/KC2p58atjmWicrSn9VSQBTIYvJ05AnWBw9z+V1q6q4AY0LHtHDUpEYSWHr9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EdFt9wGM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69C0606A339;
	Sat,  7 Nov 2026 14:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EdFt9wGM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D951F008A2;
	Sat,  7 Nov 2026 14:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062646;
	bh=InXqhY3DbS9wEMmSqU/fy7R4Tyo8rwIKzxvJEQ44GuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EdFt9wGMxWCjSbrWtmAugEuvr4ZiVHMyOPg+saEdLJCMLNCREp71CrvH3+gGvYIEY
	 kCXe7CSr0MHqN+5W2S065FtTzhkCGNS2j5TzVpF+Qf6cbABhFzUJ6WCBCqn4twVySM
	 vlUXU2Oip60wr/7MYbqQY+n2F+AUzGI2nJizMPO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1486/1536] LoongArch: Use pa_to_nid()/nid_to_addrbase() rather than hard-code
Date: Sat,  7 Nov 2026 08:58:22 -0500
Message-ID: <20261107135039.591652281@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index d129039b368b0..f53af120bea78 100644
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



