Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5C03FE7;
	Tue, 12 Aug 2025 19:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025244; cv=none; b=R6eo0PlCYwcltUtz6kvZXa8po5zWRU5G6r1YpLDDsXO7fiteUVtaT78XT4YsRScSeZkqswXhRR2/OvkEBd537tJ0x7wwkwLCvxEaZCtLsappzIorRfptF9YNUA+fTYjKjlMybiQrlSUBTZExeD8I2OOP1OoURxsZ7RNaWppUERc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025244; c=relaxed/simple;
	bh=52vVsZmN49O0NKzsA02ObLZuVCJcGPTxuQ4yOZ6FTng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sN8u4GQ25w/IzAHouExYpS5HohS4zTeP9lpa6m1bOjWRrIv//2vfe/UOBRs2cdGE6LbN+qAE+3TtXjh7T+7t4jNDeFVi+HzDidJxFLtZIPnOY5f8cvVmlAr6+nUxnNOVVVFD7A0UBbvj2p9uxujp7u71z6OEsFDhxY1HIv+J/60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cx7yiqnW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cx7yiqnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29134C4CEF0;
	Tue, 12 Aug 2025 19:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025244;
	bh=52vVsZmN49O0NKzsA02ObLZuVCJcGPTxuQ4yOZ6FTng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cx7yiqnWBkOd2IJ5upkeQ0yoEPdErRA72KcE98xjd1Bhetf+SY0xwHHJ8k56xbhQA
	 UZmUOT8KjOtnDaDM0oz9eNH9SX1DvtwlGDRyIoBXxTWaQrmX9NJBSniS5dDGR0vTwo
	 WqQwQOtjIjn+h/+HqC4sO7WxYBE76AyceKkVmNBw=
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
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 612/627] mm/hmm: move pmd_to_hmm_pfn_flags() to the respective #ifdeffery
Date: Tue, 12 Aug 2025 19:35:07 +0200
Message-ID: <20250812173455.163390608@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 188cb385bbf04d486df3e52f28c47b3961f5f0c0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -183,6 +183,7 @@ static inline unsigned long hmm_pfn_flag
 	return order << HMM_PFN_ORDER_SHIFT;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline unsigned long pmd_to_hmm_pfn_flags(struct hmm_range *range,
 						 pmd_t pmd)
 {
@@ -193,7 +194,6 @@ static inline unsigned long pmd_to_hmm_p
 	       hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
 			      unsigned long end, unsigned long hmm_pfns[],
 			      pmd_t pmd)


