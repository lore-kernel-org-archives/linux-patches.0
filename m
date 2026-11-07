Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064661;
	b=ZqF0e26VqUyoFR+snTA3c77UlJxFqgIVhFJM6eYBcpOfZ5x4TelsI4dlPyxLlcD5KNAf
	 gL9m2MNAva9uinEQZRyIRhjCd8IY9Yr+2EKeW1Scv+vm4UqL/Tv5V4A3dMxxipNiwVsD0
	 ZCAiZSkogNI8+tMashult/k1FeJQYCt109fgxc2ytp2du1EdUcXN6mXgB3q+QT20tgN4B
	 /doEMT4OQKE14QBK+tAUwnMHGNd2mQBZjMCJ18A9jiQsmiVanskUTBd8V3l9hTfyBFBEY
	 IQi+mbNIGc44koeAImkp5wNCYpwhHoy76xrRaqWyQFbSiFJk9V8ENZzR5yCnbNbKbUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064661;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6Tb9nJMHIaiol+gvE2igfX0uLHkCUCxikD/ss5F4bUA=;
	b=LYj4+0mSnMm5xEEuEu2rN0iN1HUCg6Py3ja23okEeRQgyiop0IgX1rt6c8Cm+owC9U0z
	 HhPZLN8gb1K4JbnuX6cBsAPycUaChdzMPmVGCwFLbifb7K7V1mFE8ePvHWLLDF4d83u/q
	 Ab9v1zNiT+esqvLYLw7dahl764Gmki7ACKW0fa8r8ybJYiCYEUzuputAV/0w8uypAMDtI
	 SEWWMLSKl4P/Vpx7OITNlKC7bnrNq8rUBmQb3pcbs/AXiI19yXtl6a120lzYuU0pQ96Dq
	 RH1cK8Sxa7fVP4Lp33ZUy6pXn0X0aNKmnqVdg7xyVIAzy5GCu6TgeGohU2Fy7iFpG1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2mKCR/uM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0590A606CE44;
	Sat,  7 Nov 2026 15:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2mKCR/uM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2851F0089F;
	Sat,  7 Nov 2026 15:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064660;
	bh=6Tb9nJMHIaiol+gvE2igfX0uLHkCUCxikD/ss5F4bUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2mKCR/uMeZpmBVqiLApTPbibadMf6+TfYuJsE/pE5Td96UWLV43YaBkHQfS4FBBlH
	 kgrGPlH4C/hFqKBRUxZumr+CnvQRJPCO9/bgsXTre9xuzN2tYgJ2EPX7EhkTHTF/qb
	 V2t72e/Cq3xG11/XdsTVJTwg4OoobKrFWbuuIgdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Colin Ian King <colin.i.king@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0660/1257] mm/hugetlb_cgroup: move per-node usage on cross node migration
Date: Sat,  7 Nov 2026 08:49:16 -0500
Message-ID: <20261107134957.487454729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongfu Li <lihongfu@kylinos.cn>

[ Upstream commit fe0ba1909c59660f078560f5130e7af7c6004f12 ]

Patch series "mm/hugetlb_cgroup: move the per-node usage along with the
folio", v2.

The per-node usage reported by hugetlb.<size>.numa_stat is accounted
against folio_nid() in __hugetlb_cgroup_commit_charge() and
__hugetlb_cgroup_uncharge_folio(), so it is only correct while a folio
stays charged on the same node and in the same hugetlb_cgroup.

Two paths move a folio which stays charged, and neither moves the usage
with it.  hugetlb_cgroup_migrate() only moves the hugetlb_cgroup pointers
of a folio migrated to another node, and hugetlb_cgroup_move_parent() only
moves the page_counter charges and the hugetlb_cgroup pointer of the
folios of a dying cgroup.  In both cases the node (or cgroup) which was
charged keeps a usage which never goes away, while the node (or cgroup)
which ends up uncharging the folio underflows as soon as the folio is
freed.

Patch 1/2 moves the usage along with the folio on cross node migration,
patch 2/2 does the same for the folios a dying cgroup reparents.

This patch (of 2):

hugetlb.<size>.numa_stat uses folio_nid() to account usage in
__hugetlb_cgroup_commit_charge() and __hugetlb_cgroup_uncharge_folio().
hugetlb_cgroup_migrate() only moves hugetlb_cgroup pointers, leaving
per-node usage behind on the source node during cross-node migration.

When the migrated folio gets uncharged, we subtract usage from the
destination node counter.  This creates stale usage on the source node and
unsigned long counter underflow on the destination node.  The
hugetlb.<size>.numa_stat interface exposes these incorrect per-node usage
values to userspace.

Add a hugetlb_cgroup_move_usage() helper which moves the usage from the
old node to the new node, and call it from hugetlb_cgroup_migrate().

Link: https://lore.kernel.org/20260918-for-hugetlb-charge-v2-0-2b6d8c2bdc36@kylinos.cn
Link: https://lore.kernel.org/20260918-for-hugetlb-charge-v2-1-2b6d8c2bdc36@kylinos.cn
Fixes: f47761999052 ("hugetlb: add hugetlb.*.numa_stat file")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb_cgroup.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index ecb6e0b7819a0..7cf7c18119b43 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -179,6 +179,34 @@ static void hugetlb_cgroup_css_free(struct cgroup_subsys_state *css)
 	hugetlb_cgroup_free(hugetlb_cgroup_from_css(css));
 }
 
+static void hugetlb_cgroup_move_usage(struct hugetlb_cgroup *from,
+				      struct hugetlb_cgroup *to,
+				      struct folio *from_folio,
+				      struct folio *to_folio)
+{
+	int idx = hstate_index(folio_hstate(from_folio));
+	unsigned long nr_pages = folio_nr_pages(from_folio);
+	int from_nid = folio_nid(from_folio);
+	int to_nid = folio_nid(to_folio);
+	unsigned long usage;
+
+	lockdep_assert_held(&hugetlb_lock);
+
+	if (!from || !to)
+		return;
+
+	if (from == to && from_nid == to_nid)
+		return;
+
+	usage = from->nodeinfo[from_nid]->usage[idx];
+	if (WARN_ON_ONCE(usage < nr_pages))
+		return;
+	WRITE_ONCE(from->nodeinfo[from_nid]->usage[idx], usage - nr_pages);
+
+	usage = to->nodeinfo[to_nid]->usage[idx];
+	WRITE_ONCE(to->nodeinfo[to_nid]->usage[idx], usage + nr_pages);
+}
+
 /*
  * Should be called with hugetlb_lock held.
  * Since we are holding hugetlb_lock, pages cannot get moved from
@@ -906,6 +934,9 @@ void hugetlb_cgroup_migrate(struct folio *old_folio, struct folio *new_folio)
 	/* move the h_cg details to new cgroup */
 	set_hugetlb_cgroup(new_folio, h_cg);
 	set_hugetlb_cgroup_rsvd(new_folio, h_cg_rsvd);
+
+	hugetlb_cgroup_move_usage(h_cg, h_cg, old_folio, new_folio);
+
 	list_move(&new_folio->lru, &h->hugepage_activelist);
 	spin_unlock_irq(&hugetlb_lock);
 }
-- 
2.53.0



