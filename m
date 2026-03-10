Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F3A313E32;
	Tue, 10 Mar 2026 11:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141921; cv=none; b=h8fqL26Y/2MNrZDSHgByGthYp2FB2AEE85wb8BwurxAjuDx8mKKn42U3HKYNKGqB+CkjISir9RFm0FoRe2TcXzMh5kymUpF6HE1IoftxY5dLDq3zF+y0WQEncwHUR0rsvJncPrSRnwwZKPwyyMoYLtebFK2zKdVOcMM+mS9rsiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141921; c=relaxed/simple;
	bh=27KOIU/jQ9lS+AdlBlr4XMo6W1PJ+9NCG6Me3sgjczg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Psox0JSGblOeLkKwWTHApJXYWcRyFz1BxbadHAMmw8f616S9VbZag+3nBsvxbbQ4NkimOvRpzBrOGfJnL1vrle/yIh4wFIS/KewhUfTGJJZxwOQ1UKnmSffSHHalNYO+LxmC4HG1NZHMf8xaBKQ0uRcuNW8g25f7Ndx0VMuZmWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AE3zSv5v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AE3zSv5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920D3C19423;
	Tue, 10 Mar 2026 11:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141921;
	bh=27KOIU/jQ9lS+AdlBlr4XMo6W1PJ+9NCG6Me3sgjczg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AE3zSv5vbEhy5wWx3n0Xu47P26bUrJ9iAksYcn6eJwDmAQcUqs35frAQCqRmPb1dv
	 BLCCvpg6wA0SwtuqKYOpm3Bl5L7MWsFNFtStNM0o3rVaq9PNZbKX22wDSNMiF+k550
	 4kRc9cV/rbOF5aSUnEuYVm6IhmD1T/t5sC1RgDDHjDwvoJldgYisy7I6EuajXzgNi7
	 uRkYmibl+DzDmrHCcD9aLYff+rbRyD8T7pvfTVuIPoVYPgBPoOv+EKoagXkvpJnD6q
	 7AZUZ+TJfdBi3wyCOqwNau25kHTY2ONNsMvgMrmcPr3CwtvzsaD03l1Zov5wAhptDo
	 S5pUJ5cFHS6dA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Zeng Heng <zengheng4@huawei.com>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 045/314] arm64: io: Rename ioremap_prot() to __ioremap_prot()
Date: Tue, 10 Mar 2026 07:15:04 -0400
Message-ID: <e294c8b16e0e7245cd12ee70a88fc2c11f52d22f.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Will Deacon <will@kernel.org>

[ Upstream commit f6bf47ab32e0863df50f5501d207dcdddb7fc507 ]

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
Stable-dep-of: 8f098037139b ("arm64: io: Extract user memory type in ioremap_prot()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/io.h | 11 ++++++-----
 arch/arm64/kernel/acpi.c    |  2 +-
 arch/arm64/mm/ioremap.c     |  6 +++---
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 83e03abbb2ca9..cd2fddfe814ac 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -264,19 +264,20 @@ __iowrite64_copy(void __iomem *to, const void *from, size_t count)
 typedef int (*ioremap_prot_hook_t)(phys_addr_t phys_addr, size_t size,
 				   pgprot_t *prot);
 int arm64_ioremap_prot_hook_register(const ioremap_prot_hook_t hook);
+void __iomem *__ioremap_prot(phys_addr_t phys, size_t size, pgprot_t prot);
 
-#define ioremap_prot ioremap_prot
+#define ioremap_prot __ioremap_prot
 
 #define _PAGE_IOREMAP PROT_DEVICE_nGnRE
 
 #define ioremap_wc(addr, size)	\
-	ioremap_prot((addr), (size), __pgprot(PROT_NORMAL_NC))
+	__ioremap_prot((addr), (size), __pgprot(PROT_NORMAL_NC))
 #define ioremap_np(addr, size)	\
-	ioremap_prot((addr), (size), __pgprot(PROT_DEVICE_nGnRnE))
+	__ioremap_prot((addr), (size), __pgprot(PROT_DEVICE_nGnRnE))
 
 
 #define ioremap_encrypted(addr, size)	\
-	ioremap_prot((addr), (size), PAGE_KERNEL)
+	__ioremap_prot((addr), (size), PAGE_KERNEL)
 
 /*
  * io{read,write}{16,32,64}be() macros
@@ -297,7 +298,7 @@ static inline void __iomem *ioremap_cache(phys_addr_t addr, size_t size)
 	if (pfn_is_map_memory(__phys_to_pfn(addr)))
 		return (void __iomem *)__phys_to_virt(addr);
 
-	return ioremap_prot(addr, size, __pgprot(PROT_NORMAL));
+	return __ioremap_prot(addr, size, __pgprot(PROT_NORMAL));
 }
 
 /*
diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index f1cb2447afc9c..b285e174f4f51 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -377,7 +377,7 @@ void __iomem *acpi_os_ioremap(acpi_physical_address phys, acpi_size size)
 				prot = __acpi_get_writethrough_mem_attribute();
 		}
 	}
-	return ioremap_prot(phys, size, prot);
+	return __ioremap_prot(phys, size, prot);
 }
 
 /*
diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index 10e246f112710..1e4794a2af7d6 100644
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -14,8 +14,8 @@ int arm64_ioremap_prot_hook_register(ioremap_prot_hook_t hook)
 	return 0;
 }
 
-void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
-			   pgprot_t pgprot)
+void __iomem *__ioremap_prot(phys_addr_t phys_addr, size_t size,
+			     pgprot_t pgprot)
 {
 	unsigned long last_addr = phys_addr + size - 1;
 
@@ -38,7 +38,7 @@ void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
 
 	return generic_ioremap_prot(phys_addr, size, pgprot);
 }
-EXPORT_SYMBOL(ioremap_prot);
+EXPORT_SYMBOL(__ioremap_prot);
 
 /*
  * Must be called after early_fixmap_init
-- 
2.51.0

