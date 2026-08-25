Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6C64749C1;
	Tue, 25 Aug 2026 13:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666254; cv=none; b=mZXOGShCJTZnAel3ej3neuCP2buTtiptBmTuupAopgLkzPopzz0wYl5HG1eNtfdJELtycelWGtmdibxpOCO/dzKean9BRZQ3Da2J1ScqOqtSeA4WHi0y5uiEgMH3RGE+Kzke5Fdejp7Wf3VN4nPFUfO4BDEuE9kSeoVCg5m2vZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666254; c=relaxed/simple;
	bh=Bk1h+YAqxa3YSOGJVJPfXTaOV4x8IAMOa33X3+egZvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIX2gkyLTLQdR/cr0yNCHTbyw+OQYhNuzN7UPAKdR/fm+xZNIGlPoCx6YWFrU4niUJOOzei7GA8eoCbUaevCx3rNcSww5vmrE82R8DwNpPDp9kavtoc/bmVcr9yU6ECGZRhHI8F4ndqlrQcRQwriMcU1V8KoA0yyGOHljMJv5D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNveE7BY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNveE7BY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6521F000E9;
	Tue, 25 Aug 2026 13:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666252;
	bh=3ZqFSojGkKROVjzOGp4fwYuM2ypCwcmKshKTD7Otks8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UNveE7BYt2XCgry+kcpmHRUwTgsABWC/dbIGAPe9QnJpF6eC/kGZiwoZF4BkfiuDy
	 lv06LsQsrCI59f/LTeAApXSjIIg01xqT70DSut5Z1QuaPTBD0n7gwcHydxYT5pzTgd
	 5BJkb2vitPtIoOWa2+EMFx2JHWvOtZWGR80NcUo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Matlack <dmatlack@google.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Kenta Akagi <k@mgml.me>
Subject: [PATCH 5.15 57/76] KVM: x86/mmu: Rename __direct_map() to direct_map()
Date: Tue, 25 Aug 2026 15:26:50 +0200
Message-ID: <20260825132543.816199020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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
Signed-off-by: Kenta Akagi <k@mgml.me>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2995,11 +2995,11 @@ void disallowed_hugepage_adjust(u64 spte
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
@@ -3008,9 +3008,9 @@ void disallowed_hugepage_adjust(u64 spte
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
@@ -4055,8 +4055,8 @@ static int direct_page_fault(struct kvm_
 	if (r)
 		goto out_unlock;
 
-	r = __direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
-			 prefault, is_tdp);
+	r = direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
+		       prefault, is_tdp);
 
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);


