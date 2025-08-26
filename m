Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EA828314A;
	Tue, 26 Aug 2025 14:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217564; cv=none; b=A7UWjjKWYGMSz+cH72uI33iNKYey3QBAtY0l+ByWearhss4ZmqRRzcLhydqn0vaG1FusVC5Z0rBWbvDMF9N/lGBMseH38NcyK+fdjLByFMBnqkBCmAQLIbx2fhlZlxo1F0w7At3VnH0GOCZntD+lrRX/QzH2Fz4CwSYub4WJq30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217564; c=relaxed/simple;
	bh=vste3EivTYYHBO86+wOynmO5bX/wxnVPgpUd8PNO3DE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jf3mVjb79IZQjdEbRMJnB9xhkXueQdQBl7sEKmtWt5cPViyFIQ3TWHcvirahEuEtomGxzBMbFd+L21yb+SFTsuzHumqxFHRxt5gtIjsWWlvsT2tLMAl7P4ERfd7eHOH8xynRY5EnfR3uapGyjRoOQnjJVSn9JsK/BZJNwd+3tv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XTZFeG9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XTZFeG9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5EEC113CF;
	Tue, 26 Aug 2025 14:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217564;
	bh=vste3EivTYYHBO86+wOynmO5bX/wxnVPgpUd8PNO3DE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTZFeG9W067xxOw11J7LtjwgVC4Y5+8GITZ3B8gbC7pzMfd0ljyeWsX8o17DZn8Rt
	 I8s2kV3Icb2LsCSpjBhwxSUBNBikJT14OFoy1OWwyVhh940GwIHwB+0MFCnp9lP9um
	 t7n+6a57YLVReaK5SEnfhonycjv7iEugsm+vbDmk=
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
Subject: [PATCH 5.10 190/523] mm/hmm: move pmd_to_hmm_pfn_flags() to the respective #ifdeffery
Date: Tue, 26 Aug 2025 13:06:40 +0200
Message-ID: <20250826110929.137155534@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -171,6 +171,7 @@ static inline unsigned long hmm_pfn_flag
 	return order << HMM_PFN_ORDER_SHIFT;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline unsigned long pmd_to_hmm_pfn_flags(struct hmm_range *range,
 						 pmd_t pmd)
 {
@@ -181,7 +182,6 @@ static inline unsigned long pmd_to_hmm_p
 	       hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
 			      unsigned long end, unsigned long hmm_pfns[],
 			      pmd_t pmd)


