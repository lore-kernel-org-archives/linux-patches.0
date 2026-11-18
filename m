Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054335;
	b=JfbcTgArvxptbj8ZiPnZy3zkqH/UriVAFF0K1pm52bM6F3bnjBUjXGigH7yHLdymbB6K
	 /U9J4tKrrPZ70nI4PRdJjz7oT4BBxB0MMlbmu7RseFWGo/8tAEwTllJV4Xi2bh2Mz9h0o
	 xdmKQXa5YPDxW/70LYAYjyIi7GcyeOX4rVy4+kdvDi8+8yLeQU7km8tHCxQPFj8hGh8PP
	 k35DBgE1LqEpfrN/29wZ1KpbksPbijyatAHezwYtSghZVO22FDAXRohfUhHsnf+YEisQt
	 7WzlLzWnNEwtsDarOJMkX8UPdMePY5rlJGonabqIsLkqmsJUxRE0i8QKe4R8kDeLZzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tEVRpo+PW4Tpj0isMO202zXsfV1vV3bOGBSjzhAByI0=;
	b=m5iBf8aSjGhrTqdKJIPRcihn1ku37QLX14DrvpH4K2r+yump7+OwnFeDnBSbGv+hlndY
	 ymdczs8khFhIaKLa993hiw7mHdiOsXb1kRgLtwCEuKX/6IgFj70TrFIQVE48dirdQQf8C
	 LU6PMcXDYnxsIoqkYuH65mlJtT9PiTryLDLGaixTLdAWa2N2rqnkbuOtQAZ5p6sWXGCp2
	 0PN7BPQ1v+jCLTRecpDPB/PP7DjTApIoEkssulUzuOCR4W0plzR7RpSMvBMu4rolX46aw
	 3p4hfAScJb0fsGDAdTtLYjgYD+L9IdqFSEgmod3xEQjeN1g6ovXPhAGN7nlC607XRJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KS1OY5P+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5C0606A320;
	Thu, 19 Nov 2026 02:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KS1OY5P+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CC81F000C4;
	Thu, 19 Nov 2026 02:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054335;
	bh=tEVRpo+PW4Tpj0isMO202zXsfV1vV3bOGBSjzhAByI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KS1OY5P+jyxJmMA/qHY9Eing6nFdbaIfpfqxym40AdT/0vSfF0khh6qvMqbQuUFRA
	 EbZf9rrEIA0JkOwCpNrl0Wmj2FPWY18mW1CzbqQtTdzLVKKT1EmvX9IKVZGuvc+6zz
	 8iILRmkpCjOZmKLmp51LweIJFUNCOIK/IWnYaB4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1237/2214] mm/ksm: mark migration stores with WRITE_ONCE()
Date: Wed, 18 Nov 2026 15:48:33 +0100
Message-ID: <20261118150101.217968250@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

[ Upstream commit d3863210464f69c18615cbe400d48a6e53e770d4 ]

ksm_get_folio() deliberately samples stable_node->kpfn and folio->mapping
without taking the folio lock because the KSM folio may be migrated
concurrently.  folio_migrate_ksm() updates the same state using plain
assignments.

The reader can load the old kpfn, then the migrator can store the new
kpfn, execute smp_wmb(), and clear the old folio's mapping before the
reader checks that mapping.  Thus the initial kpfn load can overlap its
update and the subsequent mapping load can overlap the clear, with no
common lock.  This leaves marked READ_ONCE() accesses racing with plain
stores.

The kernel reported:

  BUG: KCSAN: data-race in folio_migrate_ksm / ksm_get_folio

  read (marked) to 0xffff8ce401421330 of 8 bytes by task 48 on cpu 3:
   ksm_get_folio+0x7f/0x2a0
   ksm_scan_thread+0x1635/0x3330
   kthread+0x1af/0x1f0

  write to 0xffff8ce401421330 of 8 bytes by task 102 on cpu 1:
   folio_migrate_ksm+0x6a/0xd0
   folio_migrate_flags+0x193/0x420
   __migrate_folio.isra.0+0x162/0x1a0
   migrate_folio+0x4c/0x70
   move_to_new_folio+0xd6/0x170

Use WRITE_ONCE() for both stores to pair them with the existing lockless
reads.  This preserves the existing smp_wmb()/smp_rmb() migration protocol
and control flow while preventing compiler transformations of the shared
accesses.

Link: https://lore.kernel.org/20260824112433.191301-1-nicoyip.dev@gmail.com
Fixes: c8d6553b9580 ("ksm: make KSM page migration possible")
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Xu Xin <xu.xin16@zte.com.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
[ sashal: Adapted folio-based KSM operations to the existing page-based interfaces. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/ksm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index a4079051dbdf1..f17ad97c8c9f1 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -862,7 +862,8 @@ static inline struct stable_node *page_stable_node(struct page *page)
 static inline void set_page_stable_node(struct page *page,
 					struct stable_node *stable_node)
 {
-	page->mapping = (void *)((unsigned long)stable_node | PAGE_MAPPING_KSM);
+	WRITE_ONCE(page->mapping,
+		   (void *)((unsigned long)stable_node | PAGE_MAPPING_KSM));
 }
 
 #ifdef CONFIG_SYSFS
@@ -2779,7 +2780,7 @@ void ksm_migrate_page(struct page *newpage, struct page *oldpage)
 	stable_node = page_stable_node(newpage);
 	if (stable_node) {
 		VM_BUG_ON_PAGE(stable_node->kpfn != page_to_pfn(oldpage), oldpage);
-		stable_node->kpfn = page_to_pfn(newpage);
+		WRITE_ONCE(stable_node->kpfn, page_to_pfn(newpage));
 		/*
 		 * newpage->mapping was set in advance; now we need smp_wmb()
 		 * to make sure that the new stable_node->kpfn is visible
-- 
2.53.0



