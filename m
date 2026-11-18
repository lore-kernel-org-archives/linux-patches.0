Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028707;
	b=M7VlS8hB/bodB62SWaQzL1j/tZADAPeLOY6Xr+K8Be2A565wgO62TDjF40fGGlSqk5hm
	 PrtwdtELtX7FMFzCnL6MQe0CGxiHKTLCGKC/84e2fiHNJ8UHmUUaXQ6tCPYLR4pMQXTw1
	 pO0kCR5PN7WBdvHlk6owhxTjLcFC3tgLXeh+b1b0O89gy+ErlUlsrKUPrAmvrnBSotUwb
	 4fzopaoVIWc3tLCxuFkP9ckWPjHPX0GKeb7JDmeCCOoZLJ0B6DntgmZgHaLNVz4a6mPkW
	 cgi/GZ2baMZX9KpyB5vS88Y9GVQ1t5YARh1WVtk46quRitUym38bXZbYdOD/cjkFTfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iNtJUgRi0yLDUcugfzyzAto6J3Jl5YZ+aSmf1+uybqk=;
	b=MU7N+XmxrfJvTzuHFHNJUuhXZnv5fy71AAMpjbuhBINq63k/55FNfGgUYB8+CTagoxRI
	 WeyLnWRIXURV/Jv2YIhDYlmeb0RygzPEij4s7yGpTeLeo3R4uvNJ8rUgEOLSavMZ3FTs0
	 TZdhoNshj2r1DaAwJ7Pn9o7tmzFPynNDxiDpMu8X6+mg1/hbioKJdBZASbXutzucJ0lRu
	 P0xLpTJsqu2z+mMmtN0xu5htFtGjODbf5PIDjqRscmQfhXDRSXZB9ACnig7D1N3eCZ6P0
	 0eBm6VBDT07SaTMAv0o8BWpDBmvDv76nua85nTkAUlPYGtaOVx7/1sUwEFdY94jSmCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MLa8CkJv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EB0606A320;
	Wed, 18 Nov 2026 19:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MLa8CkJv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AEC1F000C4;
	Wed, 18 Nov 2026 19:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028707;
	bh=iNtJUgRi0yLDUcugfzyzAto6J3Jl5YZ+aSmf1+uybqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLa8CkJvRARdnT6HgE4WIyoX/UOrMPvSTRHTy+v6/wdkLINNKpGbAuA53LvtLEgHT
	 dpYJEd4zw4IsAROtZwTHUrIVWpcUoTuEkBDBLBih3DY30jDHDemYa6EYD1M/g4kVKL
	 j3tQZgkuFPa4C0OG91t6hnQJXLGA5WrGNGc5eF1c=
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
Subject: [PATCH 6.12 0091/1756] mm/madvise: preserve VMA_SOFTDIRTY_BIT when changing anonymous names
Date: Wed, 18 Nov 2026 15:36:58 +0100
Message-ID: <20261118150011.876239624@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: inferred name-only changes from pre-merge flag equality instead of using a separate name-change indicator ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 6ce97106d6d44..2f2f4ba351a0b 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -140,6 +140,7 @@ static int madvise_update_vma(struct vm_area_struct *vma,
 			      struct anon_vma_name *anon_name)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	bool set_new_anon_name = new_flags == vma->vm_flags;
 	int error;
 	VMA_ITERATOR(vmi, mm, start);
 
@@ -157,6 +158,9 @@ static int madvise_update_vma(struct vm_area_struct *vma,
 
 	/* vm_flags is protected by the mmap_lock held in write mode. */
 	vma_start_write(vma);
+	if (set_new_anon_name)
+		return replace_anon_vma_name(vma, anon_name);
+
 	vm_flags_reset(vma, new_flags);
 	/*
 	 * If the vma become good for khugepaged to scan,
-- 
2.53.0



