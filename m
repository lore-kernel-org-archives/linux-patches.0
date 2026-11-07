Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060580;
	b=GGWTRnhl7WHJ5s0mwsGaZ9rMnq9pKwGqpUWApUG2cv7aETB+Tjspxs1SiWJ3mIvD/upM
	 vlLjzy3EQDseyCJ4ieEBAJ/adoAvubCtHbhEd/16oSu1IpU31YwtsB5dqaK4lg8C0FltF
	 hwF3AId7p1ONhAR1plWVU5tVF0XUfHDb+DB/uwp8nvGlSS3jxNJ8GYdoCIwNz1iszYAWY
	 e/p9K6FNkvzzw0n5JLU+WRab9pUzCyxXe1+YDVv5XhfyVklIzoB+k2BXd1i5uSHs/bMdG
	 siy3kEeo9gZy+NnuedcVklmrKl3XPnbieIL+xIl7oG2x5RGw53jbqB0ZmGIQJoI5eYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mfa9PGPKX1CUoycw03Dyv789sQ9hgeXYN+fRJJ/grm4=;
	b=Q6M7PA+2xgNIFwxdNNghYU729f1vrW6BhRvIZBysVzrDC2mGbVzj2dZ+yst038t+8UsA
	 IFJ7CDAuODMlw3deT1TKnSWcm2pmrIBXbE8IyoCPR9xVPLh1mdvDfJZMDmuLnejFSZCKo
	 Fwz6zjieaNOho0uQiQ8iDfEmINqSYU1Z299hqMSlrYrca0+qIojIjuEaF+F3iw3RhSXNz
	 iPAOlIC+/PGop5l99kqnsjpUBWE0UDirHCcgoJFg8jg3+yD0mhFQhYODqJo9prU6ekJR5
	 k1RG5AcmpPgZDZXi0rgkdxwHFoeI5gwrvAZc3trFb5k2DQnXX2vbCruRY7AAyDM2Fvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tcAqlj1y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2823606A330;
	Sat,  7 Nov 2026 14:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tcAqlj1y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757FC1F0089F;
	Sat,  7 Nov 2026 14:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060579;
	bh=mfa9PGPKX1CUoycw03Dyv789sQ9hgeXYN+fRJJ/grm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tcAqlj1yLUFNMx3nbZsmkYiLysi041MVGGz2VSvDqaASA2pUTTo9eBPjSvcRTpCEb
	 zv1qvHmRy5eoJwLEQp+656rMOjSuRPDOjL+EZFJ/XB+8xeK3RG4BW2incJdFgIoSVk
	 Losun8IK5dUC/ZVR9n6g5wkaJfM0FxZEz3q/hHjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@kernel.org>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Leno Hou <lenohou@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0011/1536] mm: vmscan: fix dirty folios throttling on cgroup v1 for MGLRU
Date: Sat,  7 Nov 2026 08:33:47 -0500
Message-ID: <20261107134957.991413520@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Wang <baolin.wang@linux.alibaba.com>

[ Upstream commit 13b6b620910436c29dea398382e83c9499fd13e4 ]

The balance_dirty_pages() won't do the dirty folios throttling on
cgroupv1.  See commit 9badce000e2c ("cgroup, writeback: don't enable
cgroup writeback on traditional hierarchies").

Moreover, after commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no
longer attempt to write back filesystem folios through reclaim.

On large memory systems, the flusher may not be able to write back quickly
enough.  Consequently, MGLRU will encounter many folios that are already
under writeback.  Since we cannot reclaim these dirty folios, the system
may run out of memory and trigger the OOM killer.

Hence, for cgroup v1, let's throttle reclaim after waking up the flusher,
which is similar to commit 81a70c21d917 ("mm/cgroup/reclaim: fix dirty
pages throttling on cgroup v1"), to avoid unnecessary OOM.

The following test program can easily reproduce the OOM issue.  With this
patch applied, the test passes successfully.

$mkdir /sys/fs/cgroup/memory/test
$echo 256M > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
$echo $$ > /sys/fs/cgroup/memory/test/cgroup.procs
$dd if=/dev/zero of=/mnt/data.bin bs=1M count=800

Link: https://lore.kernel.org/3445af0f09e8ca945492e052e82594f8c4f2e2f6.1774606060.git.baolin.wang@linux.alibaba.com
Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Leno Hou <lenohou@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmscan.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f9b5fbd072db5..074e403ffd146 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4809,9 +4809,24 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	 * If too many file cache in the coldest generation can't be evicted
 	 * due to being dirty, wake up the flusher.
 	 */
-	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken)
+	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken) {
+		struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+
 		wakeup_flusher_threads(WB_REASON_VMSCAN);
 
+		/*
+		 * For cgroupv1 dirty throttling is achieved by waking up
+		 * the kernel flusher here and later waiting on folios
+		 * which are in writeback to finish (see shrink_folio_list()).
+		 *
+		 * Flusher may not be able to issue writeback quickly
+		 * enough for cgroupv1 writeback throttling to work
+		 * on a large system.
+		 */
+		if (!writeback_throttling_sane(sc))
+			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
+	}
+
 	/* whether this lruvec should be rotated */
 	return nr_to_scan < 0;
 }
-- 
2.53.0



