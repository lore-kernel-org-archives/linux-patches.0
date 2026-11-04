Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827192;
	b=Aj5/xv+G7ka/LnBaq4xZK3ii8RjAvPGbahRDD9GjcT/7FV8Mal1yi6Cv5w3xsqcVABet
	 rpOsUSLbDzdmfZDMzoRNMTN9UaqM6iMwpLsq0JrcD6wcrAAfmJ3aYlIE8Hn3TQrcuhu6e
	 1z9GK+6Qdw6m+lLsmtcjwzhJut3kpCPihB+ZTsFyf2f2hdO8wskanVOrSSyFswogfYEVv
	 HjfCnEBgdlO4b4Wze+Z4TRN01Km7b5xSAefjiXtnvVq7r9cnvmGYLHcdQHloFnnEWaPNL
	 09PdWgiyjApD9Xfl4k+yxqGw8OKHjxnV+pWzuS2moIPm+NwFzBhnZSRcmDH71arR7fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=awrsWNnIJLsCQXRYeBOGDKUpNJFGJ20efuZD/JrCSws=;
	b=K/b/ddey1ldRXf9oSlFkAWsxAPbrvxa0XjI88zy2Cj2FnSt8ShB1hdp1FqiWIzI4sGq+
	 3X0747G4f7qg5lp+5sDck7NuGQWCE/Dzo70/FsZNrp8diBr8cRiiQsnqF1HVzK6dAHmp/
	 Rwb7z39KEwMn++nIF3UyjeTaXtkOLey2n7KS1H340fTT8fmmfm7Kbo/ZqdiT6O3QDGL8Q
	 7kNnzwcUitKJtt1iCmWVGma/yhrOlDZZGONKwBQdNzbgXN/HLabcVVXC3drXdKhRUOeOj
	 gnTGBZv1QzLEmwO0mhwGcUrvVX8dGwUzKq/l7GihgehabS1miy4Y/PJCu+RbF7YJ2Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DIWnB7fR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD40B6075DD9;
	Wed,  4 Nov 2026 21:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DIWnB7fR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2D41F000C1;
	Wed,  4 Nov 2026 21:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827191;
	bh=awrsWNnIJLsCQXRYeBOGDKUpNJFGJ20efuZD/JrCSws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DIWnB7fR8rvm/viamgY2m7tsjzPTU1zx8n7XTc7zG1tCSxRavWYAATkIdtV02nvxh
	 kNiAN2Bm0HHt/0+V83JZj3ePZKrNyHpDUD4PaeH8v+wkCobcW4+R5dcii8Fv+cfrEU
	 D3/6YslKEYnouIifaeN8RAOBr9kMazVnQuihCmQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Dennis Tighe <dtighe@google.com>,
	Sashiko Bot <sashiko-bot@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.3 222/547] KVM: guest_memfd: Gracefully handle xarray errors when binding a memslot
Date: Wed,  4 Nov 2026 16:06:46 -0500
Message-ID: <20261104211044.463084202@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit e6ecb88711d93b9e014532f17d3d29b57e80932c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/guest_memfd.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -616,6 +616,9 @@ int kvm_gmem_bind(struct kvm *kvm, struc
 	BUILD_BUG_ON(sizeof(gpa_t) != sizeof(offset));
 	BUILD_BUG_ON(sizeof(gfn_t) != sizeof(slot->gmem.pgoff));
 
+	if (WARN_ON_ONCE(slot->flags & KVM_MEMSLOT_GMEM_ONLY))
+		return -EINVAL;
+
 	file = fget(fd);
 	if (!file)
 		return -EBADF;
@@ -654,7 +657,13 @@ int kvm_gmem_bind(struct kvm *kvm, struc
 	if (kvm_gmem_supports_mmap(inode))
 		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
 
-	xa_store_range(&f->bindings, start, end - 1, slot, GFP_KERNEL);
+	r = xa_err(xa_store_range(&f->bindings, start, end - 1, slot, GFP_KERNEL));
+	if (r) {
+		xa_store_range(&f->bindings, start, end - 1, NULL, GFP_KERNEL);
+		slot->gmem.file = NULL;
+		slot->gmem.pgoff = 0;
+		slot->flags &= ~KVM_MEMSLOT_GMEM_ONLY;
+	}
 	filemap_invalidate_unlock(inode->i_mapping);
 
 	/*
@@ -662,7 +671,6 @@ int kvm_gmem_bind(struct kvm *kvm, struc
 	 * not the other way 'round.  Active bindings are invalidated if the
 	 * file is closed before memslots are destroyed.
 	 */
-	r = 0;
 err:
 	fput(file);
 	return r;


