Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038843;
	b=v9jXuw011li+LY8LBdV6vSXCRxoC2DP/nw8iJJ6nRSPJQ4a1sf31B4Gho6CI/OMYRyBM
	 tPl9gM/guqMT5CbY7Ovje3prCs0NzubS0trLX5aGMUBieSVTDta3QoC0FwdJItokxzmEG
	 sQ+OIanxHSXY0xJn7v1NoW7GO8Dvy4hijodHBofIkoM+C+6O1c8dH0dHVEPG/PreyTlTW
	 mmAhdFdQJg9VjptGPQBbovpaqvk9OWbMOzSnCTuEbIMl1TrK8S0k0YRN6tCfEYWSyqQSA
	 h6vnBLSYf7xawZVQylw9h3p+EoWwINMBe/+e0a9mgIRZEa9DcNsonVMcr2vVa1WJrzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cOBjw8QpMSjgQYQNj2fcvHvmA3prueRhh7hKg1R4sI0=;
	b=FVKfUNgN86U5VFDl58nQc+SwmTk0q2g+OoAMG6h2QX9SKVLvBel2S+khrfXoikltjnWx
	 FNSgVODnDn7c4Jso2A9n2PZ++LQLaFyhR6z2XlTEwTwyb0jBfJsZZSzvGE+GVTJuqXV1M
	 lke3F8OQOEoZWCtYd9CbQafYMju3z0u3NUWwVtCeHSvuGFYq5ScMBBkfiKkb/6V6Ojyqj
	 hli3RW3zXue4M14/lgRxKKPdzL1Ok5LYJVavGZ1FjghIl5z5RnrLaJjSHbeQNRwZn5+fx
	 k/3BdQUqjxSD+OUBpDGderC/XR2a/YvYBbFAnteswQCw+R6B8c131CKpo+VOScSW3+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vGOI+IwS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5037B606A332;
	Wed, 18 Nov 2026 21:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vGOI+IwS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9BE1F000C4;
	Wed, 18 Nov 2026 21:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038843;
	bh=cOBjw8QpMSjgQYQNj2fcvHvmA3prueRhh7hKg1R4sI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vGOI+IwSaFHQzrURMTOsHW0ZrG1DVpvLkEbmc0z8Kl9F15IgYDsWlrBo8LKTjyF6D
	 5Up+ePpDJF2pK3Yn0m9ZY+Z056Cnqqo0bIcTE1xaKYNiyQVq3kOJuGHHZK8/5nz+Th
	 P/Br2VpczMXVzT7QCXOFdG4K78q78iB5A4VwDXtI=
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
Subject: [PATCH 6.6 1888/3318] mm/ksm: mark migration stores with WRITE_ONCE()
Date: Wed, 18 Nov 2026 15:41:50 +0100
Message-ID: <20261118150418.635981809@linuxfoundation.org>
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
[ sashal: Adapted folio_set_stable_node() to set_page_stable_node() with page->mapping and PAGE_MAPPING_KSM. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/ksm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 902258abee418..cd68f44754af1 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -916,7 +916,8 @@ static inline void set_page_stable_node(struct page *page,
 					struct ksm_stable_node *stable_node)
 {
 	VM_BUG_ON_PAGE(PageAnon(page) && PageAnonExclusive(page), page);
-	page->mapping = (void *)((unsigned long)stable_node | PAGE_MAPPING_KSM);
+	WRITE_ONCE(page->mapping,
+		   (void *)((unsigned long)stable_node | PAGE_MAPPING_KSM));
 }
 
 #ifdef CONFIG_SYSFS
@@ -3089,7 +3090,7 @@ void folio_migrate_ksm(struct folio *newfolio, struct folio *folio)
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



