Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585959;
	b=AbbThwSqYdmKPKKgxB+uwL4oTKO+RBhzYIhyvf8i2cWn0snEg2Vx5ZQ5u1nsosXQ+R9O
	 j1E+qu4UfKq9Ue4FWt0vR2dqniPZqrHHGwIBaCG1jhw8Jj1yqsDlid6FB0TJn4MhHL8mF
	 6JJZFspj4GTyGp4k30dEfSZkr4AfpypMMtqG0NawzLUKLJFFyVsnZRzKooYDHTrllkyKg
	 /slEl/VgDQVugiC3rXCyZNrykNODCKIanTZpkxWAwSFiYHuogcaAGfx7iX/fTKpyjI/77
	 EF6/T9Mr0ZAawfVhSSzb8ufr5mfau8ZtkMJZYn0gQ06u/UIl1tLTHerL1/0Z/tnxSeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jJnxqNEc9Ip+ieCE2hZ8ZyBHA+FG9mGwP6YvbqQElT8=;
	b=SNs49PgOrCPvLqeFVLKDp51IXBB8l6D9Cb5b9eHKyIcpZC8pcIJOAY50YayQnQem1PE5
	 Gx8+EPRRNRM1ic6H8meUXy0xCqq/1cqSFnC11uAFmdE+bwBn2dh173oSUXdPhSgz4wEzW
	 3ZsRoVrUPy+FqUB1iaHaZHsbxDJb1fnh4wDelrZg3skaN82zRgQm62ilmO6C6GMPpyj0Y
	 VNka0DgxBPxuDItUxGp+wYR53j2R78+0f8Lb81kYYFU1GDaRy6gRJ/CopaQvr8WpmQRof
	 DMZxXoHeWQ8ZFbLIZz0ImKoJZFrwlxCrxQVw6lvpKALIm47OyftzNn1r3VQdA8KKi3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qIAhmztr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F384606A896;
	Fri, 13 Nov 2026 16:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qIAhmztr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B707C1F000C6;
	Fri, 13 Nov 2026 16:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585959;
	bh=jJnxqNEc9Ip+ieCE2hZ8ZyBHA+FG9mGwP6YvbqQElT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qIAhmztrfgrN0bGFxDDnzcgene0AQ8cZAuBMkrW76Add5tnmPDANjNPohMUCCE2xd
	 Fddt/V4sp9MrUq3R3ns1RUxW3GS0MwDd22HKuZy7JiqhQ3GJ8lB+2/YTfBc3544nVC
	 Jm4Ddv7ih1WPRVgI5SZHwdeciuuFLlOiyF5rrCa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Ridong Chen <ridong.chen@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Chris Li <chrisl@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kairui Song <ryncsn@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 504/507] mm/mglru: use explicit tier range in read_ctrl_pos()
Date: Fri, 13 Nov 2026 10:53:28 -0500
Message-ID: <20261113153814.205346845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Kairui Song <kasong@tencent.com>

[ Upstream commit c1d0e799321c817a22eab2abf2485250cffad7b4 ]

read_ctrl_pos() encodes the tier range in a single "tier" parameter via
"tier % MAX_NR_TIERS" as the start and "min(tier, MAX_NR_TIERS-1)" as the
end.  This is hard to follow, maintain, or extend.  Tier values 0..3
select a single tier, while tier == MAX_NR_TIERS selects the full range.

Replace it with explicit (tier_min, tier_max) parameters using a closed
[tier_min, tier_max] interval, and add LRU_TIER_MIN and LRU_TIER_MAX for
the tier bounds.  The call sites now become self-documenting:

  - get_tier_idx:   (LRU_TIER_MIN, LRU_TIER_MIN) for the first tier,
                    (tier, tier) for each subsequent tier
  - get_type_to_scan: (LRU_TIER_MIN, LRU_TIER_MAX) for the full range

No functional change.

Link: https://lore.kernel.org/20260906-mglru-flags-cleanup-v6-5-9aacbd77d4ca@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lian Wang <lianux.mm@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Stable-dep-of: ca6e32f3f424 ("mm/vmscan: avoid false-positive -Wuninitialized warning, again")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mmzone.h |  2 ++
 mm/vmscan.c            | 18 ++++++++++--------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 94f9c3ff54160..da8dd04fb462a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -492,6 +492,8 @@ enum lruvec_flags {
  * folio->flags, masked by LRU_REFS_MASK.
  */
 #define MAX_NR_TIERS		4U
+#define LRU_TIER_MIN		0U
+#define LRU_TIER_MAX		(MAX_NR_TIERS - 1)
 
 #ifndef __GENERATING_BOUNDS_H
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 963cdd67039d1..8ec8fdede5dd8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3194,8 +3194,8 @@ struct ctrl_pos {
 	int gain;
 };
 
-static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
-			  struct ctrl_pos *pos)
+static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
+			  int tier_max, int gain, struct ctrl_pos *pos)
 {
 	int i;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -3204,7 +3204,7 @@ static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
 	pos->gain = gain;
 	pos->refaulted = pos->total = 0;
 
-	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
+	for (i = tier_min; i <= tier_max; i++) {
 		pos->refaulted += lrugen->avg_refaulted[type][i] +
 				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
 		pos->total += lrugen->avg_total[type][i] +
@@ -4808,9 +4808,9 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
 	 * This value is chosen because any other tier would have at least twice
 	 * as many refaults as the first tier.
 	 */
-	read_ctrl_pos(lruvec, type, 0, 2, &sp);
-	for (tier = 1; tier < MAX_NR_TIERS; tier++) {
-		read_ctrl_pos(lruvec, type, tier, 3, &pv);
+	read_ctrl_pos(lruvec, type, LRU_TIER_MIN, LRU_TIER_MIN, 2, &sp);
+	for (tier = LRU_TIER_MIN + 1; tier <= LRU_TIER_MAX; tier++) {
+		read_ctrl_pos(lruvec, type, tier, tier, 3, &pv);
 		if (!positive_ctrl_err(&sp, &pv))
 			break;
 	}
@@ -4831,8 +4831,10 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 	 * Compare the sum of all tiers of anon with that of file to determine
 	 * which type to scan.
 	 */
-	read_ctrl_pos(lruvec, LRU_GEN_ANON, MAX_NR_TIERS, swappiness, &sp);
-	read_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_NR_TIERS, MAX_SWAPPINESS - swappiness, &pv);
+	read_ctrl_pos(lruvec, LRU_GEN_ANON, LRU_TIER_MIN, LRU_TIER_MAX,
+		      swappiness, &sp);
+	read_ctrl_pos(lruvec, LRU_GEN_FILE, LRU_TIER_MIN, LRU_TIER_MAX,
+		      MAX_SWAPPINESS - swappiness, &pv);
 
 	return positive_ctrl_err(&sp, &pv);
 }
-- 
2.53.0



