Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038976;
	b=mJtwZHO7OwW4XA2lmuH8InDWdXZ8C4E3V6WnzfF+a0LQ8hsQfCEuQ+36wIMyRtPJduv9
	 fuLdNvwci338q4pXoSvM4AnjYyS7XaR/Wf5qpRhHUCcVRNmP0L9ttXpOwwhil7rwsMrVT
	 4vxMqSfMhkn2GVNEHozSzCIeYCvKozdrBJR4/TTARzluAxBtQ2Fi6Vv7v8TrEU2ld59yC
	 UUq4Yb3NdufV/3qPgAFBQIh5WlqMKIBzOS321Z9+qU3icaDaJHjjEEDyLMbGPqG02y3oM
	 ctMeGdRJpvRyPpBvjNa0mELlyEI2vTuPPG/bvBaQb4ITOnOhkTxgwtKOidW2Q0lWcNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gKe06axcaebD/3fH7lrNoLrlsGFb8yefe0jeO7mU55o=;
	b=HIY6L67OuFpReZX9rISJTfwJsGWRufuTU9ib9CXgAbA9+IHswFCDZAcb6TXyGJBF80M2
	 gxcmXRTm588swKB/8mkU3MuYHkHKY6MEchAkJaY8tEO6vFetct8oSEcdstgqOLaNU7sAO
	 pUVlblRruBo3j1D/YgYsDfm42c34nEaa4GUe17gDJ+wiYjFZK3kpvCyl0Y1k/Rv9haX8t
	 OSZ7nvbrmxhI6efOoB4gvcXIhyRusC+LnmyvFXPlgnsU840J1znvremuUdiw4Fo2sH1QI
	 3rYhzwqlQ3hCHQ17i8ggivCit6q4g+QTnatqAX9IcSjDgWlA0YncixWkW6uBn2Ktu5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UyfFyVCn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAFE606A320;
	Wed, 18 Nov 2026 21:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UyfFyVCn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEBB1F000C4;
	Wed, 18 Nov 2026 21:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038976;
	bh=gKe06axcaebD/3fH7lrNoLrlsGFb8yefe0jeO7mU55o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UyfFyVCn7wiFvpsKgkMlYr0+/y5FlhwxI9gVlqUmHILFGfKuG40K3u9t7owQg0txT
	 GxLwgd7AUNZyeuHBnnuKWDBzjIiNQrUH21fg0mLAys2f7xcz3yWxVfSw1ucKCAxU6U
	 Cu2SSJ0Igb9AQq6kjCFfrqLlMDDjd8WSxmkqhp/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	SJ Park <sj@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Colin Cross <ccross@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1935/3318] mm/madvise: preserve VMA_SOFTDIRTY_BIT when changing anonymous names
Date: Wed, 18 Nov 2026 15:42:37 +0100
Message-ID: <20261118150420.091984324@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 652f15be3c11415725694ccea317c51e35c0b582 ]

When changing the anonymous VMA name, madvise_update_vma() calls
vma_modify_name() to possibly merge with adjacent VMAs. We don't call
vma_modify_flags() and consequently don't obtain the new VMA flags.

Later in the function we update the VMA flags to the stale new_vma_flags
we obtained before. This can result in us losing the VMA_SOFTDIRTY_BIT
flag set on a VMA we just merged with.

There is no need to update the VMA flags at all, so just exit early. This
skips calling khugepaged_enter_vma(), but since the flags didn't change
this is fine.

[ljs@kernel.org: minor edit of commit message, rebased]
Link: https://lore.kernel.org/20261023-fix-vma-atomic-v1-3-8ff4fae1fc85@kernel.org
Fixes: 9a10064f5625 ("mm: add a field to store names for private anonymous memory")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jann Horn <jannh@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: SJ Park <sj@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Colin Cross <ccross@google.com>
Cc: <stable@vger.kernel.org>
[ sashal: added a local set_new_anon_name flag by comparing new_flags with vma->vm_flags ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index b7f5bbfb5c91d..f3a9c0f3b45a9 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -140,6 +140,7 @@ static int madvise_update_vma(struct vm_area_struct *vma,
 			      struct anon_vma_name *anon_name)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	bool set_new_anon_name = new_flags == vma->vm_flags;
 	int error;
 	pgoff_t pgoff;
 	VMA_ITERATOR(vmi, mm, start);
@@ -175,6 +176,9 @@ static int madvise_update_vma(struct vm_area_struct *vma,
 success:
 	/* vm_flags is protected by the mmap_lock held in write mode. */
 	vma_start_write(vma);
+	if (set_new_anon_name)
+		return replace_anon_vma_name(vma, anon_name);
+
 	vm_flags_reset(vma, new_flags);
 	if (!vma->vm_file || vma_is_anon_shmem(vma)) {
 		error = replace_anon_vma_name(vma, anon_name);
-- 
2.53.0



