Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047576;
	b=CIVu++anzMq9f6rL9DrL/oqf/hwGWoFYrPDJK4zIS5QRuKUqOEA+0S4ARUFlbIxoy7Ej
	 zZtvXK4uoTR7YKL/uvuY09AyGW/FCojFiTSwzyuS60TfhpZGiqC8X2QW9/hX392HZchZn
	 OhMHOmvqD8UYiWMOMsWkmP4ssLQxiCl/ODjpOYcD7bUGMjAMiYXiMHfbdiTqcKSRWrTJX
	 jneM5vUJcTz19jXfVGWMKGiGfhFvANeuzz0VlnSVJbGkUlZLcoauWLhmkGLzniQkiPJ39
	 zrMcHv3TboLU+VT/uaQ+YSnDRdLmPuVVBYnVaRKprdp4cAgt2JzF+iXXeuBKFX9o2Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+ypUHdkAI8a3riQzyEIyS3qjIvyjYFb5v3ccirUjPxw=;
	b=YoRk3ojNdKr5LDj64eYkZJZI0GZj8jufy/Q+FOjQ6U2dfhrAek1/SWoveWAGcTuWAM+i
	 xYZjRBE7uykjA8ZwqVdKHZMX/9pwi0bnRnme7I1GPd35GGRqO9D2wSt2xPY3uDWGaiVUq
	 nrkISz8sgXGxLW9vvRn51qlnOEjlDrQWozPa5P1KmRbiBGP1p7Nn1cywxiMEGKEgMv/C0
	 2iHlDZKxA7Ux5GgsmwXartSVlZBKpMH4JFVgsEL1v2nVtS/pL5QHz9jnQ28j46BjxRyph
	 e003zvs8MDrSU9D23JCTAPsuYpSjIzwSnHJGuZF3Z7UvftAlZYXSaKeRG0tDyOPK1JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OrST1PFW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019D0606A31C;
	Thu, 19 Nov 2026 00:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OrST1PFW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54CCF1F000C5;
	Thu, 19 Nov 2026 00:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047575;
	bh=+ypUHdkAI8a3riQzyEIyS3qjIvyjYFb5v3ccirUjPxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OrST1PFW96xkn0hZkOmRHD0ho63pY23+AqnlBuw9t28KzwjStkmzpy4kx/Ln8dzY/
	 /FIC9nhZmLODxBtf62nScr4EvKCk65cudQPjwK3tStoOtY26QIS96JrfeCcD+o5Qv+
	 gyy9JNfOR3Ge6MtqdrL/OR0UvLzw2AJb50kpIgLc=
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
Subject: [PATCH 6.1 1637/2857] mm/ksm: mark migration stores with WRITE_ONCE()
Date: Wed, 18 Nov 2026 15:44:31 +0100
Message-ID: <20261118150300.279380290@linuxfoundation.org>
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
[ sashal: adapted folio->mapping and FOLIO_MAPPING_KSM to page->mapping and PAGE_MAPPING_KSM in set_page_stable_node() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/ksm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 1ef4d5bf8077a..22b991218f403 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -846,7 +846,8 @@ static inline void set_page_stable_node(struct page *page,
 					struct ksm_stable_node *stable_node)
 {
 	VM_BUG_ON_PAGE(PageAnon(page) && PageAnonExclusive(page), page);
-	page->mapping = (void *)((unsigned long)stable_node | PAGE_MAPPING_KSM);
+	WRITE_ONCE(page->mapping,
+		   (void *)((unsigned long)stable_node | PAGE_MAPPING_KSM));
 }
 
 #ifdef CONFIG_SYSFS
@@ -2819,7 +2820,7 @@ void folio_migrate_ksm(struct folio *newfolio, struct folio *folio)
 	stable_node = folio_stable_node(folio);
 	if (stable_node) {
 		VM_BUG_ON_FOLIO(stable_node->kpfn != folio_pfn(folio), folio);
-		stable_node->kpfn = folio_pfn(newfolio);
+		WRITE_ONCE(stable_node->kpfn, folio_pfn(newfolio));
 		/*
 		 * newfolio->mapping was set in advance; now we need smp_wmb()
 		 * to make sure that the new stable_node->kpfn is visible
-- 
2.53.0



