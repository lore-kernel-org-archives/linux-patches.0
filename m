Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E762D6453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B221EC340EE;
	Tue, 22 Mar 2022 21:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985356;
	bh=Hn/AIoQdeTw5O5kZZ7f+AVx97B+TM9hDMs/OwKX3LVQ=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=IPou8L9ZNHBCjwbnuaBc6PtXf3MRj5bX/sFfSQtSXYTb/e5HLIdpkfmORt+epFi1l
	 drMhOv/MJSKjZdY6llZvHGNDsApFnQ7rqSEJkyd8o+8ph5sGIPeXmbkUjn0V1VsPW2
	 CBXrMcAGMsLXooMK0LWT4hlwD2oOFj0NBRQoMQYo=
Date: Tue, 22 Mar 2022 14:42:36 -0700
To: vbabka@suse.cz,hughd@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 080/227] mm: _install_special_mapping() apply VM_LOCKED_CLEAR_MASK
Message-Id: <20220322214236.B221EC340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Hugh Dickins <hughd@google.com>
Subject: mm: _install_special_mapping() apply VM_LOCKED_CLEAR_MASK

_install_special_mapping() adds the VM_SPECIAL bit VM_DONTEXPAND (and
never attempts to update locked_vm), so it ought to be consistent with
mmap_region() and mlock_fixup(), making sure not to add VM_LOCKED or
VM_LOCKONFAULT.  I doubt that this fixes any problem in practice: just do
it for consistency.

Link: https://lkml.kernel.org/r/a85315a9-21d1-6133-c5fc-c89863dfb25b@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mmap.c~mm-_install_special_mapping-apply-vm_locked_clear_mask
+++ a/mm/mmap.c
@@ -3448,6 +3448,7 @@ static struct vm_area_struct *__install_
 	vma->vm_end = addr + len;
 
 	vma->vm_flags = vm_flags | mm->def_flags | VM_DONTEXPAND | VM_SOFTDIRTY;
+	vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 
 	vma->vm_ops = ops;
_
