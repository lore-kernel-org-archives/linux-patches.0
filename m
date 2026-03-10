Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD88352C4F;
	Tue, 10 Mar 2026 11:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141063; cv=none; b=M0OVzxR5AxvdfoxsygGb5CtVg6BYziZgDN77hUEhWvo3KA3rcVJ5PnzecgPLpQzavn9wvl5rzk/gdkw0jbfkiRWh4/NOeLwDmh4QlHYf7CSt3zOYXoG/QE6UPopYlK5Phzlrwnle3Y6K/MH9RitpL5GfRHvw8WCVxvA5ZuxxPzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141063; c=relaxed/simple;
	bh=GvW/i9Hy6isBUaWETFSPJtgeUuvEo/cytvfD7/NzhjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUtfR9tOpAix/iKQrvCjBhClyKpCSp3Munag1bAV450+fCIkHgdPBtFxrtbN8Z23mlCiXwiLfDLQl6eodkT5LhkjXS2TgB1VvjRBrE8NQ4H/zwONFHYJVbV2euzTxOtKYH/bjDLg/5oUWoh4eNWF1KWQwndwio6SWeA+gJ8+3ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RCvPV1Vf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RCvPV1Vf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A167FC2BC86;
	Tue, 10 Mar 2026 11:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141063;
	bh=GvW/i9Hy6isBUaWETFSPJtgeUuvEo/cytvfD7/NzhjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCvPV1Vf/gzN/mLHX73I2+dzZn4ZF6I2+Qu4C47o1c/h4Do/rKCHao1IzIL72vd7m
	 owdha/gAW1sbLKCve8TV3bBSgucNkEBoGTBr2+8leMwmbyGXQ17IgJYlmCoHjUK6Nq
	 zFLMyYZdvn0sRuKdwrQ0wF+eBeWeJDeMvxQ5T82AN4tmtF1do+tD3xn+AIDxBz7UDE
	 b1szJc/L9SqzhRKMCIprfwOeGOuu83T/9FYMoJ/77ss/p1+FQZAp0hS5z5bSL2A6sv
	 5W5ALS62iG0+Hx3ousJJnlh2zkpwX2bMSQDwybpETVyI21NgCx6F3TTdSnCLz4jRst
	 FTMs5XtNJNkfg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Zeng Heng <zengheng4@huawei.com>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 063/311] arm64: io: Rename ioremap_prot() to __ioremap_prot()
Date: Tue, 10 Mar 2026 07:01:50 -0400
Message-ID: <e2f6e68db015ae74af04b53f397c7a16b4194003.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index af90128cfed56..a9d884fd1d001 100644
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

