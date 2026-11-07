Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060365;
	b=KlS6EVZnQ3lJjuHBhZ9dm4+NmN1bVUIXSeXuHiPsaHOmwxRwPO1CKZw6pIyVVHv+SNv0
	 PW4H05qMZaGVgxFQrBJS+aq5mAZDkFAbem/2X9sy9Pqb50Kq3vDONaH3HA8A0hWqAAYre
	 rjgGbPr0sjaKw7j5bk5VIES4Zw7eReASvjlW1DUVLyr/wgWw5acmPmv/XA6Lcsb7FLlGp
	 TpCZ4DTxdFbbrtBvb0hT0QV1zb/r/cqekIcP8d/qWQoDOhrrSvm+LUDLPd5/PZRi9Yhig
	 HmHXWDvlhiEGrhz9b5BQGOTb1KKDaTN+9D0PxKMInEWNmoDu4gBI76sevROSeTNA7hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y3CoVmuuUN71iONPQ73K2gKZFoY9l0mPhZcgFay5UN8=;
	b=GWhwt72ewbZLGkbYO5HLhr1LDLSMi6jagBQCfYQSgpmHcuH0qkXMpjZo9HKUbIW6LLtQ
	 /D9uJ5ieFQalmhtZckEljxjetqjS49iHrykzrDVM0Ctzj1puMkIi7V/xVZLvb9VLkosgp
	 h199sLC0oHgzA/1EmUrUCOpaFekSBYloNxpNcZuXMIW7EznUMcgSpEEdSiOMFC4xLjeUB
	 Ezh0UaDUA2PA7Lslf5V1wvO4XxzCH7eFO1wcXrOzlLz03WJW8wgZWnMcttqF8+BPox7r5
	 qUNaWTKEb86lbLOVIW3bPh8lbyKmGUx+JCLXQ9/Cg1Wfwms1C1Z56sBBAFUjFSM6F7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Gi+dCIB/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E3C606A32C;
	Sat,  7 Nov 2026 14:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gi+dCIB/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A307F1F0089F;
	Sat,  7 Nov 2026 14:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060364;
	bh=Y3CoVmuuUN71iONPQ73K2gKZFoY9l0mPhZcgFay5UN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gi+dCIB/noBI09OYV+64m/tVTO8A7+aIlRSTvjGc7SazUNQnHITytm81GQL0fLnUn
	 Waoyes+1aclva3bSRE48yd+f82WHbiCXsH5JuKyLw3AGc7840Yw6THikioxpDysERv
	 XRy5B7OjSPaW3xNLttOc7OLTEfHFwRnSDa8f1xME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Dennis Tighe <dtighe@google.com>,
	Sashiko Bot <sashiko-bot@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 005/869] KVM: guest_memfd: Gracefully handle xarray errors when binding a memslot
Date: Sat,  7 Nov 2026 08:44:47 -0500
Message-ID: <20261107134852.230857850@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit e6ecb88711d93b9e014532f17d3d29b57e80932c ]

If inserting a memslot into a guest_memfd's bindings xarray fails,
propagate the error back to the caller, i.e. fail memslot creation as well.
Signalling success and continuing on with memslot creation results in
use-after-free, as the guest_memfd instance will remain reachable via the
memslot after the file is freed (kvm_gmem_release() won't nullify the file
pointer due to lack of a valid binding).

Opportunistically WARN and reject binding if KVM_MEMSLOT_GMEM_ONLY is
already set, partly to guard against goofs elsewhere, but mostly so that
KVM doesn't need to worry about clobbering flags when unwinding on failure.

Regarding the unwind, the slot must be fully prepared before inserting it
into the bindings, at which point the slot becomes reachable.  I.e. waiting
to update the slot in order to avoid the ugly unwind isn't an option.  And
as part of the unwind, explicitly nullify the relevant bindings, as xarray
can store a subset of entries when populating a range.

Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
Cc: stable@vger.kernel.org
Reported-by: Stefan Teodorescu <fane@google.com>
Reported-by: Dennis Tighe <dtighe@google.com>
Reported-by: Sashiko Bot <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260823135031.4F6DC1F000E9%40smtp.kernel.org
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Link: https://patch.msgid.link/20260922001332.1121266-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ sashal: Changed the two &f->bindings references to &gmem->bindings to match the existing variable name. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/guest_memfd.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index a59a4446b8461..2ab7bb46a371e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -576,6 +576,9 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	BUILD_BUG_ON(sizeof(gpa_t) != sizeof(offset));
 	BUILD_BUG_ON(sizeof(gfn_t) != sizeof(slot->gmem.pgoff));
 
+	if (WARN_ON_ONCE(slot->flags & KVM_MEMSLOT_GMEM_ONLY))
+		return -EINVAL;
+
 	file = fget(fd);
 	if (!file)
 		return -EBADF;
@@ -613,7 +616,13 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (kvm_gmem_supports_mmap(inode))
 		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
 
-	xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
+	r = xa_err(xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL));
+	if (r) {
+		xa_store_range(&gmem->bindings, start, end - 1, NULL, GFP_KERNEL);
+		slot->gmem.file = NULL;
+		slot->gmem.pgoff = 0;
+		slot->flags &= ~KVM_MEMSLOT_GMEM_ONLY;
+	}
 	filemap_invalidate_unlock(inode->i_mapping);
 
 	/*
@@ -621,7 +630,6 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	 * not the other way 'round.  Active bindings are invalidated if the
 	 * file is closed before memslots are destroyed.
 	 */
-	r = 0;
 err:
 	fput(file);
 	return r;
-- 
2.53.0



