Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F221DE8BF;
	Wed, 19 Feb 2025 09:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956706; cv=none; b=d9Bv7kOrNq0SLmOO2dUnDcluXY0H0MMJAvX2gOk/gAeyNUJB16/ifJLUIdtMTBeUgAvjAP5Ki1HsdxTfiLP06GiqakDgobgcZSTuAwn2BYwX1Qk0fwd3QQ+okj5pTfznZyT4Jp7wGf1jbHfWLa2zGbxQZMPi2VhnXyniFkIzCrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956706; c=relaxed/simple;
	bh=38vDO+tQW+vJPjzY1vQL/x1M+x6dLGAqeunEOPdoOko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thV4aPQ7B8Hvt87iIkKkszBjPShv0skR+hf61ceT4YMovF7WcFY28SOyPA59346rCpDCkwQ5JH5Ljjd+AUie0YOt927lLXKYSZ3aNdmA3GdlZpDp9oZtj51diECUcfRXIdKfpvgAqltlqbbgC2fJ5mdVB15R+uy+Fo1i7PVL6sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swhshR/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swhshR/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D20C4CED1;
	Wed, 19 Feb 2025 09:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956705;
	bh=38vDO+tQW+vJPjzY1vQL/x1M+x6dLGAqeunEOPdoOko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swhshR/pf+AK+/ugJUsqWOmvLE/C1OYE1d3vHsXh73YO74agF+VCs86vIskqTXEwf
	 VuL8Uf/TlGVnJpl4U2O/pU3FqXVx4hiZQGgOb3K5jQixlSXLG/eLeNs/E67tYTNXsU
	 0DD/eauX7nAelWFQ9RfmogFhtYS2ZidIPVErIdQc=
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
Subject: [PATCH 6.1 271/578] arm64/mm: Ensure adequate HUGE_MAX_HSTATE
Date: Wed, 19 Feb 2025 09:24:35 +0100
Message-ID: <20250219082703.682506057@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 134dcf6bc650c..99810310efdda 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -544,6 +544,18 @@ pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 
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



