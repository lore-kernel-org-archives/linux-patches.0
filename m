Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059985;
	b=Nvo9zuyr+i1N/rJ81DDYIgPWH1qZ2/jGma/GAKLAi9IKMiLR25BV+vC2OdaWOjMgHHCH
	 pRAbnVZhG5BXN3dVYmvcPAwkbC1/iPyB6HkOvp/QaMHdvo6vX2sZ045GCTfXM38D8tdXr
	 yXUWM8NmJtgLgPbWCm7jFD4TbYj3/qnsJG5r3NbSsIFZldEYmLQv/riJinmfmO0CNQw5r
	 c8MB4dTMk6hOCej2B/NzgtLMP/kSMngt965vy5Zo5J+BPuk8RnKO8PTbWdVpfjg/SreLL
	 PDCQk+zs683Ri68Qv6/jJQ6Re9MG8VHypkinQw+DlvjvdClu6yPvJEaWsq9SFwd41aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4T6rJuP5uqJFRLfjCroQph0xlJsLp4EmwpPoQJEKTp8=;
	b=WlsuGMp3vzsjtZmXkDtuvRllQ6sjfDOXNrqvLPam5SOK8NWJnIUSHprOWT5RWFLrotqT
	 ITW/1oacdMaB+SP9SfTklZvBxzOWf8gpOiCNj6syns1lOOTxyzIq8ZwwALnQGnYOQa2F/
	 N+m62YYqJi/fxghF3CFryijEypnlq5sQYTSKGzvUBklaOIvON6aa9jB616L0GsujFIVSj
	 yB+PjLt1KnvXL4nGKRN4IAi9Y1C83qJBvqXOt6zbcCiTPVxL37HLtrIgVrOLI9oUU3hJh
	 YrscH315vGqi/yRGh/q9u1R1g2r40MpXRsk6ulJbm8KTU2EtRVDDIcrI67ygLaczJ5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1qpsuGYa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE46D606A330;
	Thu, 19 Nov 2026 03:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1qpsuGYa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6031F000C8;
	Thu, 19 Nov 2026 03:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059985;
	bh=4T6rJuP5uqJFRLfjCroQph0xlJsLp4EmwpPoQJEKTp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1qpsuGYa4/BN+DXbP13jTOZMgOjDFSNz6CMdy41cZz5MMaB3G7HX88q5MFaj8h1+G
	 msAuTWxpdkz1ssQGhz+YKgEO/GMa6K1Aqujpu+rA3b7Y2sh8egKOZgvCLfryASsf/+
	 WHVPy+VsUsNQvnMA3MIqhKMegfI8N7F7k3bVgXTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <albinwyang@tencent.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1037/1848] mm/madvise: add cond_resched() in THP branch of madvise_cold_or_pageout_pte_range()
Date: Wed, 18 Nov 2026 15:51:15 +0100
Message-ID: <20261118150000.771203018@linuxfoundation.org>
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

From: Wei Yang <albinwyang@tencent.com>

[ Upstream commit f5cfc8e3b20ad71949a1e5623ff45882c063a71b ]

During stress testing with stress-ng on a 256-CPU system, a softlockup was
observed when madvise(MADV_COLD) was called on a 31GB memory region backed
by transparent hugepages.  The region contains 15935 THP PMD entries, and
the softlockup was triggered after 14485 of them had been processed.

The THP branch of madvise_cold_or_pageout_pte_range() has no scheduling
point.  walk_pmd_range() invokes it once per 2MB PMD entry with no
cond_resched() anywhere in the loop.  Each iteration calls
pmdp_invalidate() which issues a synchronous TLB shootdown (dsb ish)
waiting for all CPUs to acknowledge.  This operation can be time-consuming
under heavy system load, causing the accumulated time across all PMD
entries to exceed the softlockup threshold (20s) and panic when
softlockup_panic=1.  On a CONFIG_PREEMPT_NONE=y kernel, there is no other
opportunity to reschedule during this entire traversal.

The regular PTE path already has an unconditional cond_resched() at the
function tail (introduced by commit 9c276cc65a58 ("mm: introduce
MADV_COLD") and commit 1a4e58cce84e ("mm: introduce MADV_PAGEOUT") when
MADV_COLD and MADV_PAGEOUT were first introduced) and a conditional one
inside the loop (commit b2f557a21bc8 ("mm/madvise: add cond_resched() in
madvise_cold_or_pageout_pte_range()")).  The THP branch never received
equivalent treatment.

Fix by adding cond_resched() at the huge_unlock exit path after
spin_unlock(ptl) and reclaim_pages(), which is the single exit point for
all goto paths in the THP branch.

Crash log:
  watchdog: BUG: soft lockup - CPU#63 stuck for 23s! [stress-ng-vm:1665914]
  ...
  Call trace:
  pmdp_invalidate+0x48/0x68
  madvise_cold_or_pageout_pte_range+0x84c/0xb00
  walk_pmd_range.isra.0+0x1ac/0x3b0
  walk_pud_range+0x120/0x190
  walk_pgd_range+0x170/0x1b8
  __walk_page_range+0x184/0x198
  walk_page_range_vma+0x94/0x128
  madvise_cold+0xd8/0x198
  madvise_vma_behavior+0x234/0x638
  madvise_walk_vmas.constprop.0+0xdc/0x210
  madvise_do_behavior+0xa8/0x328
  do_madvise+0xd8/0x140
  __arm64_sys_madvise+0x2c/0xe0

Link: https://lore.kernel.org/20261010024042.4070048-1-albin_yang@163.com
Signed-off-by: Wei Yang <albinwyang@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
[ sashal: adjusted context for reclaim_pages() using page_list instead of folio_list ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index ba7a1e819f9a8..acfe24ced5905 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -381,6 +381,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		spin_unlock(ptl);
 		if (pageout)
 			reclaim_pages(&page_list);
+		cond_resched();
 		return 0;
 	}
 
-- 
2.53.0



