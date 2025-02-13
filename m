Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1315426B095;
	Thu, 13 Feb 2025 14:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458626; cv=none; b=P2h9voPSx9G4Z5c8RbARHEaer2/M0l3aRPB0+YNiAK28o+NFwnH/pQ52OAWYpo6FMDR1FZbINvdswJ2ShYMJPS5GXT1LsosuTbgS12TBzXQ/aguSBkJ2Xp7ZoNgOQmtYoK2rbegFA6rGRko2vTZw0KZuMTzPenq0RIsLCjx3PnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458626; c=relaxed/simple;
	bh=AG5KvTkWo9kKa90u2Pm9+d+vXSnfEVfPJIchZMkIK+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4lFb9LpPo9R/+7XDusLI4CdouO9st8I8kMtqf+C3gLdrGOt97siG3Q5x2WUcBc+pcdCfHkzYVDGtjC42PzQwozJUMCaktsc45SDWvQ1LJsygM64RxxiEswFCFj7foCKgbm8H4gG/3MMxXVohamKJ8d2ZM2gHbhpe6fClM3MY9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dw206q/9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dw206q/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43593C4CED1;
	Thu, 13 Feb 2025 14:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458625;
	bh=AG5KvTkWo9kKa90u2Pm9+d+vXSnfEVfPJIchZMkIK+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dw206q/9QYwqDjBJ9EoctmKTZ8KK+uMBZvqS6u3Tk666eq7+Px6MQVfzAVFqWkNDk
	 sFOMHqJt+k/NCUvTbelF84xQ43qXyohElBBIEM+QnCp4oDHtOcyR0+X0B9bG6ledTm
	 E0A0giSZMm7v1ovHd3twvUso1PvV/UYIo5U+hEWw=
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
Subject: [PATCH 6.13 006/443] arm64/mm: Ensure adequate HUGE_MAX_HSTATE
Date: Thu, 13 Feb 2025 15:22:51 +0100
Message-ID: <20250213142440.863623856@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 3215adf48a1b6..98a2a0e64e255 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -519,6 +519,18 @@ pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 
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



