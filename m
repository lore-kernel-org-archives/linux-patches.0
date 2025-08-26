Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9F9350843;
	Tue, 26 Aug 2025 14:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219351; cv=none; b=GNL3CXRLuwryCVoFz1dxUsmAs/leIf8Ynq4a3NRBWjpT3aNUXxOC9uzsp2KDu0ZfW8rwDTCWvAS7VUUsehKfTRVglnCDWtnQGli8aD3Gjx88IP+LHgPISMA/ebY9nQXKAqGrLej4LEFk83TocGmLoyyt6FKn6OfFL3NAJf/A+VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219351; c=relaxed/simple;
	bh=/gP7oUwHkx0gMqhKgSRqm8fIQlddIfvHr5KKpcNxF9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOmtIZwG/nowGIkcCJCa4xhVqT1FUy5OU1HZMPlE9V/3FEViyzDJ4wKdT6mynm2Gk/tr/bQQ56GG3JBazn2n2Vnw5et2ZQT2D8eQC0MMh/qSaAXbG7DA6S+uDrURD8IOGVxcLSuG4a4LeOJy+VEk8OgUoxabHrboTe67nz7/8E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUIg3zfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUIg3zfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485FCC4CEF1;
	Tue, 26 Aug 2025 14:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219351;
	bh=/gP7oUwHkx0gMqhKgSRqm8fIQlddIfvHr5KKpcNxF9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUIg3zfsF/coHemkwGlaKBtQa/iWflAFbQULX8ZqhXOprUsSMgUNktyzHwtrn2G3W
	 390rxdYnSI6MTfGnGj/JSfPnZJfn+5zQaEZBPDO4dSzEf4NjQMMjtWjIXtDq4qrbTt
	 jo/fk+v1oBOlQfvuje6o7nv9bLMJDqdZ9aMcr5Rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Bill Wendling <morbo@google.com>,
	Jerome Glisse <jglisse@redhat.com>,
	Justin Stitt <justinstitt@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 347/403] mm/hmm: move pmd_to_hmm_pfn_flags() to the respective #ifdeffery
Date: Tue, 26 Aug 2025 13:11:13 +0200
Message-ID: <20250826110916.457706458@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 188cb385bbf04d486df3e52f28c47b3961f5f0c0 ]

When pmd_to_hmm_pfn_flags() is unused, it prevents kernel builds with
clang, `make W=1` and CONFIG_TRANSPARENT_HUGEPAGE=n:

  mm/hmm.c:186:29: warning: unused function 'pmd_to_hmm_pfn_flags' [-Wunused-function]

Fix this by moving the function to the respective existing ifdeffery
for its the only user.

See also:

  6863f5643dd7 ("kbuild: allow Clang to find unused static inline functions for W=1 build")

Link: https://lkml.kernel.org/r/20250710082403.664093-1-andriy.shevchenko@linux.intel.com
Fixes: 992de9a8b751 ("mm/hmm: allow to mirror vma of a file on a DAX backed filesystem")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Minor context adjustment ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -392,6 +392,7 @@ static int hmm_vma_walk_hole(unsigned lo
 	return hmm_vma_walk_hole_(addr, end, fault, write_fault, walk);
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline uint64_t pmd_to_hmm_pfn_flags(struct hmm_range *range, pmd_t pmd)
 {
 	if (pmd_protnone(pmd))
@@ -401,7 +402,6 @@ static inline uint64_t pmd_to_hmm_pfn_fl
 				range->flags[HMM_PFN_VALID];
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
 		unsigned long end, uint64_t *pfns, pmd_t pmd)
 {


