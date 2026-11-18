Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033436;
	b=CjrI+vTcYYjnqHY2HFd3Glr3Ewi2SYe3RHs4YgDD4OWJLHOjzlstfkr4yJRrs7sdd4Kz
	 8o3QKfxwPnh7vQQwWqQeEvlpdgAbSyhC8w7b/Vm2NcGGkLZ0LCO9RPg28DW4xKIgeQxup
	 lc3q4VmHmEMS/etmmNTODbAnYUMYQ2JIZaVIwF95SyJ5dJVvIy+Tcxu9TmC0C0fuue0Y8
	 BEeBBgukX/03ZoYDKZMjPRAv2t+nq95OKDnPEi7fvH4f2w6+bsIES90km5Q8PefxVnb0P
	 mY7Z+nmbH1cpLodW+aUEnS/NVmrZt7KnRcWyzOaIXhFj2sadJGYnlLqjrkCiuqjIXDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Db2PCO1ZvhzN2CSZO/jo+gujxH3R+bGpo9bbhd7uS5k=;
	b=bKnyeK1Nnic4NbIiWLPM+f0eTQt1XL3J2s5jiZywZzkzSkE+5aovWcZZrvlZOFclob63
	 2578Z3Vy3s4u537WKhxXLzkrAnHO/9YjwaHwmD/uIRFPP3bpvkMLNc6o0TcP+VV3/DHj9
	 Mm0avnF+Ke5S48KNcbqqs31QEsYeiwiEYVzDlRlW+M8z9+QpWLosL1kPizNOg9AjTkUhg
	 oFzkTBtNyZJ3pYnk/UiInZIPx0+Tt80VtYdmHNPWjUBA5bNGorTuefsSJPhO7mSTG7KjU
	 bVs9uXCoVaOjskKvJCa5M1V1uh6iYNV33DpbsqCz/tIOWV8CmG65fQGV1kWCFJIEmlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BJWR2fcm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE98E606A31C;
	Wed, 18 Nov 2026 20:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BJWR2fcm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6091F000C6;
	Wed, 18 Nov 2026 20:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033436;
	bh=Db2PCO1ZvhzN2CSZO/jo+gujxH3R+bGpo9bbhd7uS5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BJWR2fcmWGSutyxJLLax1Pjy2K9/B5VxcmsfepQzdTmB+x+SxFGfl6En7rL/p+tCr
	 TKb+N4kwdeZcThb+jQOc968Xcw9Db4bH3g6ouwHJS4Tfcu7jRErid+MWlZNJ7+KPjV
	 bOeMu/cUHesOLxBLEyrBxHNn5RNFWwhBzroPlECA=
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
	Leno Hou <lenohou@gmail.com>
Subject: [PATCH 6.6 0015/3318] mm: vmscan: fix dirty folios throttling on cgroup v1 for MGLRU
Date: Wed, 18 Nov 2026 15:10:37 +0100
Message-ID: <20261118150314.147539863@linuxfoundation.org>
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

From: Baolin Wang <baolin.wang@linux.alibaba.com>

commit 13b6b620910436c29dea398382e83c9499fd13e4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5431,8 +5431,22 @@ static bool try_to_shrink_lruvec(struct
 	 *  If too many file cache in the coldest generation can't be evicted
 	 *  due to being dirty, wake up the flusher.
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
 	/* whether this lruvec should be rotated */
 	return nr_to_scan < 0;
 }


