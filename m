Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B2C1D4154;
	Tue, 15 Oct 2024 11:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992647; cv=none; b=XFN3Rq7ugpRCUDgA1HpbIOeGq28d9iocWlEvJh37tWS+hJtVL6rfxO3LVIv+aIoxz0BuJXqWPgGWHHEpz9EBdvATRMgEXqGE0xXW+MN4KBOyZMOOQu4Z2fFZF0bY9heQzHGCf/KNwzT7GxN8LvQRaz1O9lT2NDLanRcmm3u9g8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992647; c=relaxed/simple;
	bh=WgV/782MN6SkKHagtdqycz48QfYS+70b/+9IPBc6tcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTCfM3+21i7k/FG3HOkvzySFL8O1oduQkJUvUY8CUGo++aPN8UoNAtvffgaB7lf/A5n7ja1S/x3b04CJ4ZLjKaQZ9k0MF3vn41UnUmKRk26uyToqNjEYfy/sifPa7O9UbI3iMgSfC5fpXmeHhcaK8CRPCywTV3hiiemoh5/EeAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRGO/52h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRGO/52h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0621DC4CEC6;
	Tue, 15 Oct 2024 11:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992647;
	bh=WgV/782MN6SkKHagtdqycz48QfYS+70b/+9IPBc6tcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRGO/52hjWDemz/M2B0fnq5DeVLZGWQhJpG71wyNsDWlH45ipXHWKkMKBDW8wBaHC
	 WqESP+zcxdw+3fWsRj6c79eF/SPECuh3ykwTOUf+rLJ0DmvNDgRuAPsQujPro3FOQa
	 cgDnSBKet6IQ5rLmrkA1sgp3kojArK7ivxeF0xW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 176/691] powerpc/32: Remove noltlbs kernel parameter
Date: Tue, 15 Oct 2024 13:22:04 +0200
Message-ID: <20241015112447.349463374@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 56e54b4e6c477b2a7df43f9a320ae5f9a5bfb16c ]

Mapping without large TLBs has no added value on the 8xx.

Mapping without large TLBs is still necessary on 40x when
selecting CONFIG_KFENCE or CONFIG_DEBUG_PAGEALLOC or
CONFIG_STRICT_KERNEL_RWX, but this is done automatically
and doesn't require user selection.

Remove 'noltlbs' kernel parameter, the user has no reason
to use it.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/80ca17bd39cf608a8ebd0764d7064a498e131199.1655202721.git.christophe.leroy@csgroup.eu
Stable-dep-of: f9f2bff64c2f ("powerpc/8xx: Fix initial memory mapping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 3 ---
 arch/powerpc/mm/init_32.c                       | 3 ---
 arch/powerpc/mm/nohash/8xx.c                    | 9 ---------
 3 files changed, 15 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index e2c2ccba6e388..c22a8ee02e73b 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3626,9 +3626,6 @@
 
 	nolapic_timer	[X86-32,APIC] Do not use the local APIC timer.
 
-	noltlbs		[PPC] Do not use large page/tlb entries for kernel
-			lowmem mapping on PPC40x and PPC8xx
-
 	nomca		[IA-64] Disable machine check abort handling
 
 	nomce		[X86-32] Disable Machine Check Exception
diff --git a/arch/powerpc/mm/init_32.c b/arch/powerpc/mm/init_32.c
index b702f2b642957..967432d1b6c78 100644
--- a/arch/powerpc/mm/init_32.c
+++ b/arch/powerpc/mm/init_32.c
@@ -80,9 +80,6 @@ unsigned long __max_low_memory = MAX_LOW_MEM;
  */
 static void __init MMU_setup(void)
 {
-	if (strstr(boot_command_line, "noltlbs")) {
-		__map_without_ltlbs = 1;
-	}
 	if (IS_ENABLED(CONFIG_PPC_8xx))
 		return;
 
diff --git a/arch/powerpc/mm/nohash/8xx.c b/arch/powerpc/mm/nohash/8xx.c
index 5348e1f9eb940..94efd4fa6e768 100644
--- a/arch/powerpc/mm/nohash/8xx.c
+++ b/arch/powerpc/mm/nohash/8xx.c
@@ -18,8 +18,6 @@
 
 #define IMMR_SIZE (FIX_IMMR_SIZE << PAGE_SHIFT)
 
-extern int __map_without_ltlbs;
-
 static unsigned long block_mapped_ram;
 
 /*
@@ -32,8 +30,6 @@ phys_addr_t v_block_mapped(unsigned long va)
 
 	if (va >= VIRT_IMMR_BASE && va < VIRT_IMMR_BASE + IMMR_SIZE)
 		return p + va - VIRT_IMMR_BASE;
-	if (__map_without_ltlbs)
-		return 0;
 	if (va >= PAGE_OFFSET && va < PAGE_OFFSET + block_mapped_ram)
 		return __pa(va);
 	return 0;
@@ -49,8 +45,6 @@ unsigned long p_block_mapped(phys_addr_t pa)
 
 	if (pa >= p && pa < p + IMMR_SIZE)
 		return VIRT_IMMR_BASE + pa - p;
-	if (__map_without_ltlbs)
-		return 0;
 	if (pa < block_mapped_ram)
 		return (unsigned long)__va(pa);
 	return 0;
@@ -157,9 +151,6 @@ unsigned long __init mmu_mapin_ram(unsigned long base, unsigned long top)
 
 	mmu_mapin_immr();
 
-	if (__map_without_ltlbs)
-		return 0;
-
 	mmu_mapin_ram_chunk(0, boundary, PAGE_KERNEL_TEXT, true);
 	if (debug_pagealloc_enabled_or_kfence()) {
 		top = boundary;
-- 
2.43.0



