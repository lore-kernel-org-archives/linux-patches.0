Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059439;
	b=0Top+ZRtKESjZw+/0ipO7ZzmXhnVgLEuU8lDXei78F+KIHra25/mzMydbbPlbgSYrVjJ
	 e7UML1u0PNUNW7SKZQnfszn246o95/4N2ZksgvPkX1cwPPyd04C8+ECpbULaFqOkg1vT6
	 Yn+y/LSVhe9e9zuwxWtHvn5xI7TYoTtTor8DBbL8YwO35VbyWF/joVkxIzjls5AhfLVXO
	 UR8zM8Mgjs7zWUBemhGm9fbKFxznMtBtsDFLT3J/XeCYcxOuoBHfGdvKRqlBENBtFA/a3
	 Sx+3xwUhHdr/8ZtVvYYq90slEU3NKDm/z2efyZkY63dWBPw3X6w84O1GSCDfK6pEVug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GFkkNo+zag44yzuLSqj2nXrhGhxESceGNOmzp1YWcac=;
	b=ei4RWg02RwXQ635P7jGlqiKyjOpN+CPKJD9H33gApTQStMhXdMeOL6QFwx3L9npfua+j
	 3JI3Qpk7QrdjFfrj8eos7hHGVlACqyADDPc5fsy2fOlLwbuo2OUs3qerpxg3zE82ythUT
	 jFbwX8JGO+dSgQpz3DnKjrkpwOvr/71QSGB5Oc3JNfjr7vgsMSETHQ2fpeHhWiKXbsGe9
	 PzkXJzkNRU3lOd4/SQthyitJSo/sIlnEIdZLg34FfD1yzsAIrQhNMpJZa4yrlXdGU1zSu
	 ZhPdPCygzyHJ0N1b/PfOV0b30kN1/qiLyykvsKK/eqVpPlNfopwPLVVAHqooCEIzgNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PkOJWK1E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EF5606A31C;
	Thu, 19 Nov 2026 03:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PkOJWK1E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E9A1F000C4;
	Thu, 19 Nov 2026 03:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059439;
	bh=GFkkNo+zag44yzuLSqj2nXrhGhxESceGNOmzp1YWcac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PkOJWK1EkDV77rGnUnUUUm9g5Izy8+1aEd0BnBJ6j8E0UAZrXZFUf125wYB4UAmiV
	 Hqc918wVFQ6y48e+bz1DVTmiV2ilEMBYAkaiKZpj6Q2xgSAK1BOiDd7D/o4ZFYTdK+
	 hZqUsjJOp3W3JTdfWRDyWGsx5u4sxqFKvUkwcw6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Samarth Narang <samarth.colleges@gmail.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0840/1848] mm/madvise: atomically clear the young bit on THP MADV_COLD
Date: Wed, 18 Nov 2026 15:47:58 +0100
Message-ID: <20261118145951.806920003@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Falcato <pfalcato@suse.de>

[ Upstream commit 246c8cc33438a71c28f9b86baa492d9a0a130316 ]

As-is, madvise_cold_or_pageout_pte_range() discards the hardware young bit
by invalidating the PMD, doing pmd_mkold() and subsequently writing to the
pmd again.  However, it does so in a racy manner, looking at a
possibly-stale snapshot.  It's entirely possible that a write elsewhere
set the hardware D bit, which this logic now loses.

Fix it by using pmdp_test_and_clear_young().  This is an atomic
modification of the PMD entry, and thus safe against any possible racing
writes.  As a (nice) side-effect, this elides one non-required TLB flush
in pmdp_invalidate().

This bug can interact with the swapping system in complicated ways,
leading to data loss.  For instance, if a folio is marked lazyfree, but
was later read from, and then MADV_COLD'd while racing a write to that
same THP, dropping the dirty bit may lead to data loss as
reclaim/MADV_PAGEOUT drops the "clean" anon folio:

T0                                T1
================================================================
MADV_FREE(thp)			|
  folio marked lazyfree		|
read(thp)			|
  PMD marked young by hardware	|
				| MADV_COLD(thp)
write(thp)			|   if (pmd_young(pmd)) {
  PMD marked dirty by hardware	|     set(pmdp, pmd_mkold(pmd));
MADV_PAGEOUT/reclaim		|
  dirty bit may or may not be   |
  set				|
    reclaim/pageout may drop    |
    the folio			|

Link: https://lore.kernel.org/20261013191719.95502-1-pfalcato@suse.de
Fixes: 9c276cc65a58 ("mm: introduce MADV_COLD")
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Samarth Narang <samarth.colleges@gmail.com>
Closes: https://lore.kernel.org/linux-mm/20261011132227.413217-1-samarth.colleges@gmail.com/
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
[ sashal: adjusted context because the pmd_young() check lacks the !pageout guard ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 8b6ed35c1d265..ad33cdbf27a88 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -361,10 +361,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		}
 
 		if (pmd_young(orig_pmd)) {
-			pmdp_invalidate(vma, addr, pmd);
-			orig_pmd = pmd_mkold(orig_pmd);
-
-			set_pmd_at(mm, addr, pmd, orig_pmd);
+			pmdp_test_and_clear_young(vma, addr, pmd);
 			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		}
 
-- 
2.53.0



