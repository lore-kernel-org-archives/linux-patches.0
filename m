Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98412281375;
	Thu, 13 Feb 2025 14:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457117; cv=none; b=tSXIa/AtzSSWJUKtAeA7FqK72Kfvzi2uT9DFl5QBmIUSbpbegWIawCmlirKzqmKTWmxqWcsJFbp5qScWj6y2mO3XH9hil3r8yuWfC7scZdOWIXEEES0Eij7D95LbO19sOoIKWgat8C9zXk6soDloJmD/s+/FMZhiXi6rrlotsCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457117; c=relaxed/simple;
	bh=QbYu5tcFJpICXFPEleK/DPk1kwwWWDH/Zmndr3rc+8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xuv6vHj59SppblXu2QgUFSpfOZrRoXoTiAOsjH8JWpSXFkLVaM+0vyU5dS3gc4aEY3AB9SHD7xuXunkfyUv/eoLOr8B3u8ONG24ULkIGHYgqfyD4LArL5vwuEkuvxp4Yo071y982tY4m2ONCcqyz0WD2UMm7AVb/BtG4UPCU60w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7vCvmRu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7vCvmRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33E6C4CED1;
	Thu, 13 Feb 2025 14:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457117;
	bh=QbYu5tcFJpICXFPEleK/DPk1kwwWWDH/Zmndr3rc+8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7vCvmRuSXw4hqiJVLVwMMOR6kg+fgLZasX79/KiMON+qIhqzaC/aJiaKVGIPg71q
	 +n9dSrqzdD1l6eDwUVbxEvgQzCiKvkV2Of0Jvzd6K4Wm7RaXCSdeiD3uFHpeUoKMp2
	 pBkc6L/oZNT06bJ9MrFJx+m/9eta4g5MUe6v0vLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/422] arm64/mm: Ensure adequate HUGE_MAX_HSTATE
Date: Thu, 13 Feb 2025 15:22:34 +0100
Message-ID: <20250213142436.629719861@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit 1e5823c8e86de83a43d59a522b4de29066d3b306 ]

This asserts that HUGE_MAX_HSTATE is sufficient enough preventing potential
hugetlb_max_hstate runtime overflow in hugetlb_add_hstate() thus triggering
a BUG_ON() there after.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Link: https://lore.kernel.org/r/20241202064407.53807-1-anshuman.khandual@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/hugetlbpage.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 5f1e2103888b7..0a6956bbfb326 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -508,6 +508,18 @@ pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 
 static int __init hugetlbpage_init(void)
 {
+	/*
+	 * HugeTLB pages are supported on maximum four page table
+	 * levels (PUD, CONT PMD, PMD, CONT PTE) for a given base
+	 * page size, corresponding to hugetlb_add_hstate() calls
+	 * here.
+	 *
+	 * HUGE_MAX_HSTATE should at least match maximum supported
+	 * HugeTLB page sizes on the platform. Any new addition to
+	 * supported HugeTLB page sizes will also require changing
+	 * HUGE_MAX_HSTATE as well.
+	 */
+	BUILD_BUG_ON(HUGE_MAX_HSTATE < 4);
 	if (pud_sect_supported())
 		hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
 
-- 
2.39.5



