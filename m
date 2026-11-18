Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047542;
	b=Ud3+6f7n6x3CicfiF7I/IVJA4+TkRu5+WWYcjniL5GwSyk47KQgAUfEhh4XdB3oeaTWx
	 EVVuL4lXP7vY7nyhJ7TmVzCCLq2QXKMx0rmUcxRZ91XCZhzhlCahoSaIM7hnKnKN+qsPA
	 /DLD41Cdk2rguSBwhPEDTK9NkfCTe/yyNBHXBNq9UrEqZhVQZ1+tJNB6a0l+7P3PhguN2
	 fwlNFKsU13ZsyhQWBQhtc73coYkNTFvWDz8g3Lf4hCCADA/jVhIXmLoCGeuMIFGi1jyhP
	 RsMf7opzx7ZZO/FOAATMYGkUd7FUBVHOd+3xRsP9CABAQYyk/1SW4NF19NkH/j1BqTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WSePtPD5dRU1tas5ayJlzIkMgoWpwUS6Ck4SZ5UZoL0=;
	b=EVqVfTILhwRwvfJWxLiB5X2anVbUUXL4buYfrnnWmNMz6RO2kFa+YjM6LlByDIzwfVTY
	 m/ZPyHiDOD6YMYN7ic5QN8EPJ3rt3OpwgElfuXB47EK0o8r/EqZFSGHO5/5QqhgD+juwn
	 R6wzyfPhJcl+w04Ol2OeFUgc7gvq1GBUzUsjPoWQ2AT7mwDXt0kMkcGXpz6Cynnwuts+u
	 Yrxw/RmKMQc3wzdisc/N3KGuqrumj5STlWa8E+lgWR2BT1CcN66k493R9fqNanGsGU+OB
	 3MR8XNyid4lD7CvBkEdEF142mL2X1XuIhGQU04hSWFRgrK7wfUnzh+Jm3M6h3GFjMZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lXXuWUaM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B35606A32A;
	Thu, 19 Nov 2026 00:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lXXuWUaM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8AC1F000C4;
	Thu, 19 Nov 2026 00:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047542;
	bh=WSePtPD5dRU1tas5ayJlzIkMgoWpwUS6Ck4SZ5UZoL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lXXuWUaMJcU8LdzwiYvhXLZULze4MvUKlGcsgBCWJfSE3z6ww/8umITEZd0ooAU73
	 4s60SKWqXPlHBmcVOEgMfYwSZElMlIeOMhOXQ55Y4DwUEiYoy2VXdSaQvkIKk5Ab3j
	 YQ+8oGjbHCqukJbYQTeG2fKWcQjYQ/m609rVfkeQ=
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
Subject: [PATCH 6.1 1675/2857] mm/madvise: preserve VMA_SOFTDIRTY_BIT when changing anonymous names
Date: Wed, 18 Nov 2026 15:45:09 +0100
Message-ID: <20261118150301.642375290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: inferred name-only operations from new_flags == vma->vm_flags before merging instead of using an explicit name-change indicator ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 77dfca84d27ae..15d0e10ea400f 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -143,6 +143,7 @@ static int madvise_update_vma(struct vm_area_struct *vma,
 			      struct anon_vma_name *anon_name)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	bool set_new_anon_name = new_flags == vma->vm_flags;
 	int error;
 	pgoff_t pgoff;
 
@@ -179,6 +180,9 @@ static int madvise_update_vma(struct vm_area_struct *vma,
 	}
 
 success:
+	if (set_new_anon_name)
+		return replace_anon_vma_name(vma, anon_name);
+
 	/*
 	 * vm_flags is protected by the mmap_lock held in write mode.
 	 */
-- 
2.53.0



