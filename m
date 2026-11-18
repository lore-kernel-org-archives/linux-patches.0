Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022680;
	b=R+DVW65wbHYe5ma1XMaGH8DvQ1+KhehnF2Y2CXfzFyKcPcvoNUp7YFTdIhyqf53U1S3s
	 ZriWISeh7GpacjrI67l7RBEQe5ev7XuD4LwI70DMRbPgnM8fzSy9H3gJopNEG1c4ic9EB
	 JefLDfA5M0WmWJK/3b3cy+Uue/xQSwsDiruw173B7DVKEkoSZPO2mSt757hRQ9VNj/c/n
	 EMmaMzPi8utDN2ED1zjuHdgGygwW4DiljkMrZTBQYQQWcHoDvPTjmWAu6/Wt1WYTp05MN
	 yC7gyYoaEf0ExlYuMiiezvxDpuuGMHFBoewLv7DOFALmDpi5GdCTguGx4e8JyUYWZxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YERmAgN/2ZQejD7qy3lgUyr4rjx0zMmW3tvZOt4PUCo=;
	b=xcmEt8XmNOw6ta9UsmWABWkUyNKmqrYkTSMTbBE6vkboqNqqwrFYvC1n4/L71wZZT2v3
	 jQsU+lS+6/lfAXHAfTizVYb50K59lcstUNJZaBwIXAkpwKk8Bs6EUGzxhB4UbvLtGalx7
	 yyX84W/q5ea9ZwukoFUZlpx9Df6T/C+PRBqYGuV8mMnHhSOUqAKlWBo1RitpdUkylo9Zj
	 XNzzfvTMSU8WZTdmhMcPBAjq4voC187tXG8OrqVwtw5KuV++JqSgWVv5zanYR4v748+ml
	 h2kkp3EqbTN+qHx5yo6dDN/r8FjEPABeSXOYU2FwIsFbuKJVvIcQPU7/z/TyZhftF8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=05l9dYmw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A74A606A31C;
	Wed, 18 Nov 2026 17:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=05l9dYmw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17F01F000C4;
	Wed, 18 Nov 2026 17:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022680;
	bh=YERmAgN/2ZQejD7qy3lgUyr4rjx0zMmW3tvZOt4PUCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=05l9dYmwnjeFhxxBVATV6kCecFeI9rxviivowcZx2pCFbvWIO0INDMP7JrxyBXwQY
	 EYUMp2z7CDg1kO91iTsvoXswVxveoNDRVrFBYqBU7Zc2NiBPqB2R2vIc0SI4KdnRjI
	 AknbvqT4rzAvk2H7cRG886QRVWlIh+fGUYPjDD70=
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
Subject: [PATCH 6.18 0092/2151] mm/madvise: preserve VMA_SOFTDIRTY_BIT when changing anonymous names
Date: Wed, 18 Nov 2026 15:30:27 +0100
Message-ID: <20261118150125.151571545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
[ sashal: Adjusted context to match vm_flags_reset(vma, new_flags) instead of vma_overwrite_flags(vma, new_vma_flags). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index bd0a5093a2df2..c500f1cbd4987 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -176,6 +176,9 @@ static int madvise_update_vma(vm_flags_t new_flags,
 
 	/* vm_flags is protected by the mmap_lock held in write mode. */
 	vma_start_write(vma);
+	if (set_new_anon_name)
+		return replace_anon_vma_name(vma, anon_name);
+
 	vm_flags_reset(vma, new_flags);
 	/*
 	 * If the vma become good for khugepaged to scan,
@@ -185,9 +188,6 @@ static int madvise_update_vma(vm_flags_t new_flags,
 	if (new_flags & VM_HUGEPAGE)
 		khugepaged_enter_vma(vma, new_flags);
 
-	if (set_new_anon_name)
-		return replace_anon_vma_name(vma, anon_name);
-
 	return 0;
 }
 
-- 
2.53.0



