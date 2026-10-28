Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212413;
	b=fhXiL1rvJPB58A4vH1L8kk1YL7bj8t0ndBTJcnPU0uTVjMWyI8fkSgxzoIdzr1M3Rt/T
	 E4HYNYFo1lvo+ZnfzwmtAvzoWF37Vj/ZPnuivZOsxrjzH+pFx/pqW9dulrHJIu0UqE+Rw
	 WSBXQFemPMIzq/pa4pNko1ACN82HHPkGhUaZhwa43dN9mONaQYEuEU+BkpWoz+iiHH411
	 0CkQMRHlQW2DdLTohCcnwH5adEc1oGRLQpF2iSDpWXrRrKGVObcMckjuvzfVY42MC6urI
	 SxnNNf2/V4mmL47APDWUEoK8o4owRJ8nf6SooJZPSeC2UaPtIFNM7Re+9DZk9ZGMWrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mzuAeTp/JB2G7NyMILd52fZlFVeT63RDLcqWTMka3Bw=;
	b=mvme8WFSPN+c7N0rUk8k/k3Kkbqa8GOGq5lOGsUDGd2jjzA94Z+BeoADeUyOzN+VLFhr
	 Zh+m4GDee+9TItvEuhDm1XkB44/185RGNP7O7P+/sjKFaQtBM2iI3p/f5ASGqJkr9xf4c
	 5gijNixepq1EL3oiEyABnQZw13+ZDIxay5/WM7QPLmRw4gKu+9sgn4wNQ3h6oKEVlzTTk
	 6lLJBBr4Njas4p4XAhi0ZcDTMgr91UwGDTrbm/LZjf7hQaQ7zUil3TDQ+n3v0/SdYxaG4
	 fTcUm+H9QZu0Ut/adzdB3a556K0LMRw6AlrdGAnk9iP+nMaTHiBdWNDYa8HH2HRJeqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yw6+jWGL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59439606A31E;
	Wed, 28 Oct 2026 18:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yw6+jWGL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DF31F01825;
	Wed, 28 Oct 2026 18:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212413;
	bh=mzuAeTp/JB2G7NyMILd52fZlFVeT63RDLcqWTMka3Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yw6+jWGLrt/kwDZS+E44YzTSSVyX2DhwQdk8rs84a0IHEA8nZZ5en5+sA1+7rfUdw
	 mkxRnhpCZeGDJ9GfJJOre+RAExGN5yTHq4HGkcw+R0B+HSfQTlKMXNvYWMql7JqPlX
	 ZwnvGuh9zh1BueXIenFCYh7fesHsOoRGNltIh5vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaewook You <jaewook376@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0144/1887] mm/hugetlb: preserve mremap address delta when skipping page tables
Date: Wed, 28 Oct 2026 17:37:20 +0100
Message-ID: <20261028170502.513619733@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Jaewook You <jaewook376@gmail.com>

[ Upstream commit 9bdad082d44bdcf93716973dcba6be77e8a06e7b ]

move_hugetlb_page_tables() optimizes mremap() by advancing to the last
entry in the page table when the source page table does not exist, either
initially or after unsharing a PMD table.  The common loop increment then
steps to the first entry in the next page table.

However, the code advances both the source and destination addresses to
the last entries in their respective page tables, which is wrong.  The
destination address must be advanced only by the same amount as the source
address.

If the source and destination offsets within their page tables differ, the
destination address can be advanced too far, causing follow-up issues.
Fix this by advancing the destination address by the source advance
distance.

With a reproducer, we were able to trigger a kernel panic on x86-64.  With
this fix in place, we can no longer reproduce the issue.

Link: https://lore.kernel.org/20260914132352.472-1-jaewook376@gmail.com
Fixes: e95a9851787b ("hugetlb: skip to end of PT page mapping when pte not present")
Fixes: 4ddb4d91b82f ("hugetlb: do not update address in huge_pmd_unshare")
Signed-off-by: Jaewook You <jaewook376@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Johan Hovold <johan@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
[ Adjusted context to retain huge_pte_offset() instead of hugetlb_walk(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bfcb936084e85..a44a6602659cf 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5278,18 +5278,21 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
 	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(mapping);
 	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
+		const unsigned long offset_to_last_entry =
+			(old_addr | last_addr_mask) - old_addr;
+
 		src_pte = huge_pte_offset(mm, old_addr, sz);
 		if (!src_pte) {
-			old_addr |= last_addr_mask;
-			new_addr |= last_addr_mask;
+			old_addr += offset_to_last_entry;
+			new_addr += offset_to_last_entry;
 			continue;
 		}
 		if (huge_pte_none(huge_ptep_get(src_pte)))
 			continue;
 
 		if (huge_pmd_unshare(&tlb, vma, old_addr, src_pte)) {
-			old_addr |= last_addr_mask;
-			new_addr |= last_addr_mask;
+			old_addr += offset_to_last_entry;
+			new_addr += offset_to_last_entry;
 			continue;
 		}
 
-- 
2.53.0



