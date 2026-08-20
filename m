Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722F246D0BD;
	Thu, 20 Aug 2026 16:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243645; cv=none; b=h3lPr7ixLPtZAbTW4t7z2QY50evyJo/accspfQ9+m+fqx4Jkpl2XmHz8O666PnX6rD4U+UCGT+MUGyAMSck1MFf2pIOsfhOZbEFvgJmpDIGja8DLwIN/3DNH8Pc2mXiOkIHyc8ArgOcoGINumFZ1TKZTnorXPbvLYF1ZNqMdsFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243645; c=relaxed/simple;
	bh=J3VImijrUKD4aCIXM0jtaRsd+ws00wYH4lZchVYn6J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIlJoBQ8aODpqRfgTAZXTmTN+4HZLxtG47Dx54UwSoo0ZgZprzZepAWEvQxKgXMgOC7gEpyKB50xtVMKx8dNSNiwyAJRqQ5fSAp/SMy2mws3GANQEjN73uHymdLuT18rt1e/g0nGj3Kp2+LP5oW9oHpF9xmQGsQFoeuOqAbqrV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hb5M1g0B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hb5M1g0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE9C1F000E9;
	Thu, 20 Aug 2026 16:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243644;
	bh=wjNhCTbdCMw9SokcoWYjYNdTmO/yW1oSCghV+XyOdzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hb5M1g0BzNB5kmLxugZgWNYWwVBFroouHnidIHAwICbYQuU9Nr10GD5qFaD/bDHZW
	 F6skh6VGRVuieOP2V3rS7ghikOCeZeXilcvlBJN8krcs3NWEYNj/0OUi7XRoRDh5Gr
	 mq/4ozuRtv235vCoXY+iVkxu+j5FPMad9Lnz3HsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Matlack <dmatlack@google.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 167/272] KVM: x86/mmu: Rename __direct_map() to direct_map()
Date: Thu, 20 Aug 2026 16:55:51 +0200
Message-ID: <20260820145236.366503018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Matlack <dmatlack@google.com>

[ Upstream commit 6c882ef4fc7bd99b67ad152e75428b669281c521 ]

Rename __direct_map() to direct_map() since the leading underscores are
unnecessary. This also makes the page fault handler names more
consistent: kvm_tdp_mmu_page_fault() calls kvm_tdp_mmu_map() and
direct_page_fault() calls direct_map().

Opportunistically make some trivial cleanups to comments that had to be
modified anyway since they mentioned __direct_map(). Specifically, use
"()" when referring to functions, and include kvm_tdp_mmu_map() among
the various callers of disallowed_hugepage_adjust().

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20220921173546.2674386-11-dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 2abd5287f083 ("KVM: x86: Check for invalid/obsolete root *after* making MMU pages available")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2991,11 +2991,11 @@ void disallowed_hugepage_adjust(u64 spte
 	    is_shadow_present_pte(spte) &&
 	    !is_large_pte(spte)) {
 		/*
-		 * A small SPTE exists for this pfn, but FNAME(fetch)
-		 * and __direct_map would like to create a large PTE
-		 * instead: just force them to go down another level,
-		 * patching back for them into pfn the next 9 bits of
-		 * the address.
+		 * A small SPTE exists for this pfn, but FNAME(fetch),
+		 * direct_map(), or kvm_tdp_mmu_map() would like to create a
+		 * large PTE instead: just force them to go down another level,
+		 * patching back for them into pfn the next 9 bits of the
+		 * address.
 		 */
 		u64 page_mask = KVM_PAGES_PER_HPAGE(level) -
 				KVM_PAGES_PER_HPAGE(level - 1);
@@ -3004,9 +3004,9 @@ void disallowed_hugepage_adjust(u64 spte
 	}
 }
 
-static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-			int map_writable, int max_level, kvm_pfn_t pfn,
-			bool prefault, bool is_tdp)
+static int direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
+		      int map_writable, int max_level, kvm_pfn_t pfn,
+		      bool prefault, bool is_tdp)
 {
 	bool nx_huge_page_workaround_enabled = is_nx_huge_page_enabled();
 	bool write = error_code & PFERR_WRITE_MASK;
@@ -4037,8 +4037,8 @@ static int direct_page_fault(struct kvm_
 	if (r)
 		goto out_unlock;
 
-	r = __direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
-			 prefault, is_tdp);
+	r = direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
+		       prefault, is_tdp);
 
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);


