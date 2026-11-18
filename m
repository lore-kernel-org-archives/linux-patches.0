Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037577;
	b=ryMNBctDjWkEagmlT4C6oA5xF90JMBPvx2oaoJd4Knf/geXGJ7au/lMYk8NU260cDy/S
	 ao/N39PCI/N1jG8vkDWn7mrja4IaVqv43D2/Un2uyliNc9CSqYaZCuvq3NCbtKecwgV8A
	 G2Owp3LKHekhCFfSe9vSwkQ1j6RCxOCeRINewhNeeD7QLgXHizYXvjKizJIx5rqnRkc3i
	 tjptrIQduerhrP7hTVd3YENKjmT9mk6hyIWfEb2fBeS/rKViDseQ8E/7KmIIvHKXWSVMt
	 WvAQ2xHVVKfw8rKV7FdtMV1mgxSV9heH5lpBc2fBRqW+dp7/U5dxvuMO58Asp3JZKWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pZIu/Qwfrf5XwUWkyTWEzosbonzDp3PRu0Zl8XTtyGo=;
	b=ghYMo2tfVSpWUsNa5rxqdu6pqLy4wVZhHyquk0dKUDnMZaYZxLSwUt/X+90FMnPbGfMw
	 vyEI2+DGECbc4wyhLt+VgpgD9ZB1nwbmGWx2oDI6cwhlIrHw+9p8x1farXJnk8yZ4Uuu2
	 yuNEclQavfyulDw2lQyNnq2OwAZW9IEFxFhe8lvg2dBJ+y5Bb2VJnCpJo4RQVgHKnB01n
	 yvUHgHq3ZfFhzx+nOWCkVM0o1+/3oFrQI/PBJ1WwJNFq6//MLVYqeKT18selcELnNcU3F
	 YLD3piuyEwQVlBYgH8Q38F8SCe8Dv7ybR5S170UhAIrrJt7Bo6KCgB8ZKZswEKiOpig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OnCnv4Wo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4C8606A320;
	Wed, 18 Nov 2026 21:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OnCnv4Wo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBAD1F000C4;
	Wed, 18 Nov 2026 21:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037577;
	bh=pZIu/Qwfrf5XwUWkyTWEzosbonzDp3PRu0Zl8XTtyGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OnCnv4Wop3CZ+eQ+QMspIXLZDt+2bIzLz64w2QpuGQF/+kF9iKyutvEIFf2YK9pLu
	 58W46kXnZSg1PIzxeHz+TOGBHOuZCcZFVn8y44AxhU+pqDl3zqTzGlAcfZopL+dIqd
	 ctyFSH9n+YRO2gsHOS+EI/ScUuXp1OX478BTUU1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Rik van Riel <riel@surriel.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Dev Jain <dev.jain@arm.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	SJ Park <sj@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1446/3318] mm/mglru: dont use stack pointers when walking PUD and PMD tables
Date: Wed, 18 Nov 2026 15:34:28 +0100
Message-ID: <20261118150404.224943808@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 65a9bf08a3e4d6e58df211ed900c16bafb79b267 ]

MGLRU passes stack copies of page-table entries in walk_pud_range() and
walk_pmd_range() when walking to the next level. These copies can become
stale when khugepaged or MADV_DONTNEED (CONFIG_PT_RECLAIM) removes a PTE
table concurrently.

This pattern dates back to commit bd74fdaea146 ("mm: multi-gen LRU:
support page table walks"). Likely, earlier locking masked the latent
bug. Later changes exposed it: commit 1d65b771bc08 ("mm/khugepaged:
retract_page_tables() without mmap or vma lock") allowed concurrent
retraction, and commit cf4a65539c13 ("memcg-v1: no need for memcg locking
for MGLRU") dropped the walker's outer RCU protection.

The fix is simple, so just fix the original commit so we don't have to
speculate. To fix it, pass the actual PMD/PUD pointers. This restores the
RCU-protected lookup and validation against the live PMD. Note that the PUD
handling is required as well to handle folded page tables correctly in all
cases.

Fix generated by an LLM and sent by Josef Bacik in private.

[ david: handle walk_pud_range() as well, clarify+simplify description,
         adjust Fixes: ]

Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Link: https://patch.msgid.link/20261031-fixes_core-v3-1-d6437171ecc3@kernel.org
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d5ab35610ecdb..cbc2de77db3ed 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4212,7 +4212,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 
 		walk->mm_stats[MM_NONLEAF_FOUND]++;
 
-		if (!walk_pte_range(&val, addr, next, args))
+		if (!walk_pte_range(pmd + i, addr, next, args))
 			continue;
 
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
@@ -4248,7 +4248,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
 			continue;
 
-		walk_pmd_range(&val, addr, next, args);
+		walk_pmd_range(pud + i, addr, next, args);
 
 		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
 			end = (addr | ~PUD_MASK) + 1;
-- 
2.53.0



