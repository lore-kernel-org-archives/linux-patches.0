Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DC02C1595;
	Sun,  7 Jun 2026 10:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828234; cv=none; b=pJNN+zFJBLoYquMtOm6cekquarMZmmRWAoxNTafk2a2/DdUprmDATBfb56DJjwLETrUnvADln6GgWaywVJH98RcqC0OAzy2ihMbzIIZZ9/sZUWONt/UKOBbgJCpEvPBMCRIibpA8R2L/XgZbZ40oYboxKTRmWq71bVAGOl8lvGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828234; c=relaxed/simple;
	bh=M9OigHTLbjoD6p6ehDaI7qhiK/0Mb0jPA6DATlGg0vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVbZIFq5AuooKbU9D6t6sHp3DfYN39GV9xK7yWaNaRiWJwvWRac0S0d70BCpnaPkfEpyVsBsbuHwP2hrI00ZRPkzXVuOGZEsrZ8He9tqqpf2iS+QSwgr9/28zduJ4d9zUnogWC53Dbz+xTpYGJSWeIWFIq39ImSUnI0e1aFBUG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qRGND2+1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qRGND2+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422081F00893;
	Sun,  7 Jun 2026 10:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828233;
	bh=mNJCgS96O+7/45T+6bpQdGETECaW5mhLuH+Ss7uJqlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qRGND2+14+XxMJpbwsMniCssRmhTdHiP9pA09ZOeIEdZqslaFg6i6Afgp6WjhaddC
	 60JXCuQTvyGuvI3LE0vKWDX89oEA+RMyeas6PB+6XPInV2H+vs1mXJ5X4t0sVYEdC1
	 BuyPsHfMVxSm1nWjrGrYa8ZixdbYTBWJnZPThPV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Xiangyu Chen <xiangyu.chen@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 122/307] arm64: io: Rename ioremap_prot() to __ioremap_prot()
Date: Sun,  7 Jun 2026 11:58:39 +0200
Message-ID: <20260607095732.244152647@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

commit f6bf47ab32e0863df50f5501d207dcdddb7fc507 upstream.

Rename our ioremap_prot() implementation to __ioremap_prot() and convert
all arch-internal callers over to the new function.

ioremap_prot() remains as a #define to __ioremap_prot() for
generic_access_phys() and will be subsequently extended to handle user
permissions in 'prot'.

Cc: Zeng Heng <zengheng4@huawei.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/io.h | 7 ++++---
 arch/arm64/kernel/acpi.c    | 2 +-
 arch/arm64/mm/ioremap.c     | 7 +++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 1ada23a6ec1900..e6ad41131d80b4 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -274,15 +274,16 @@ __iowrite64_copy(void __iomem *to, const void *from, size_t count)
 typedef int (*ioremap_prot_hook_t)(phys_addr_t phys_addr, size_t size,
 				   pgprot_t *prot);
 int arm64_ioremap_prot_hook_register(const ioremap_prot_hook_t hook);
+void __iomem *__ioremap_prot(phys_addr_t phys, size_t size, pgprot_t prot);
 
 #define ioremap_prot ioremap_prot
 
 #define _PAGE_IOREMAP PROT_DEVICE_nGnRE
 
 #define ioremap_wc(addr, size)	\
-	ioremap_prot((addr), (size), PROT_NORMAL_NC)
+	__ioremap_prot((addr), (size), __pgprot(PROT_NORMAL_NC))
 #define ioremap_np(addr, size)	\
-	ioremap_prot((addr), (size), PROT_DEVICE_nGnRnE)
+	__ioremap_prot((addr), (size), __pgprot(PROT_DEVICE_nGnRnE))
 
 /*
  * io{read,write}{16,32,64}be() macros
@@ -303,7 +304,7 @@ static inline void __iomem *ioremap_cache(phys_addr_t addr, size_t size)
 	if (pfn_is_map_memory(__phys_to_pfn(addr)))
 		return (void __iomem *)__phys_to_virt(addr);
 
-	return ioremap_prot(addr, size, PROT_NORMAL);
+	return __ioremap_prot(addr, size, __pgprot(PROT_NORMAL));
 }
 
 /*
diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index e6f66491fbe932..a99476819e6b2d 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -379,7 +379,7 @@ void __iomem *acpi_os_ioremap(acpi_physical_address phys, acpi_size size)
 				prot = __acpi_get_writethrough_mem_attribute();
 		}
 	}
-	return ioremap_prot(phys, size, pgprot_val(prot));
+	return __ioremap_prot(phys, size, prot);
 }
 
 /*
diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index 6cc0b7e7eb0384..1e4794a2af7d63 100644
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -14,11 +14,10 @@ int arm64_ioremap_prot_hook_register(ioremap_prot_hook_t hook)
 	return 0;
 }
 
-void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
-			   unsigned long prot)
+void __iomem *__ioremap_prot(phys_addr_t phys_addr, size_t size,
+			     pgprot_t pgprot)
 {
 	unsigned long last_addr = phys_addr + size - 1;
-	pgprot_t pgprot = __pgprot(prot);
 
 	/* Don't allow outside PHYS_MASK */
 	if (last_addr & ~PHYS_MASK)
@@ -39,7 +38,7 @@ void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
 
 	return generic_ioremap_prot(phys_addr, size, pgprot);
 }
-EXPORT_SYMBOL(ioremap_prot);
+EXPORT_SYMBOL(__ioremap_prot);
 
 /*
  * Must be called after early_fixmap_init
-- 
2.53.0



