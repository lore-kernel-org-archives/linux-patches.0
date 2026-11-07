Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063636;
	b=3bmoymnt01gmzkIt/qn6FHWmOOOnsn8CAIcbvxAfHvn9HKtcx6+y96I0hC0CbG5YycKM
	 D17t3vUDh1x85gEptcuRxH4BBBg+zcxI3jIRPZ+bi4ulw8SjK+j8khaqIn/Ox9R1icY4d
	 YM/YuwmHzSdNU2sb0uH12WPSxOBiTSssv/5MGkYVaqER105UgP+gSds0ChPLINVgAhEIu
	 LyL6vsI9CWF6lbl7pupnUOSH+MQ1GXS4byXC/dCwhoSOYFc5yQSA0IJnKprb+OaHPE358
	 UuPP0+5Jhg0o4mTkthTmpMuqTyLoymf/5/PCzDkopb/HkaTHcikSflGZP9DFjuvVkMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063636;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vjw3JM6v9Sc0WRkBZA5RscusPZatKaFm01XwJdhJCN8=;
	b=GOYTIuFrepXt0Ii8jRZH4sY2rbzd0W4yTYFxwt8WDobIlANIDitbhCQ1s8Yj3wyWoUU+
	 CscNxQgZZv/yaIF2KBfjjapfrWgr0jptR347QcC3DAxxzhxkhq6xuK5S09GRHk3IAnea5
	 ahYh4vIHktcvgC+31y/VnlIrqdxsV0VT96MutEDruBBNRSt1h+BcDthIwrnTpfexuzl5w
	 sUhpPfaMP7lH2NJAq5ONn0I/r8LlvvJmVzEJnyeU+j8nfe1VVMBK6xuxK/AwcUrGsjvz4
	 5H72iLFqCAKb6jDPfyLHtSD5JbDc1r9/xEGGnhFVyFtY1Ic++YneaW1BNCrQrEAbykQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WSLZEJYg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C8C606A333;
	Sat,  7 Nov 2026 15:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WSLZEJYg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FAE1F0089F;
	Sat,  7 Nov 2026 15:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063635;
	bh=vjw3JM6v9Sc0WRkBZA5RscusPZatKaFm01XwJdhJCN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WSLZEJYgh+THwJ4O8x12/H7LtTT2K6mPWlSGENtjFStCpLY+4tPy6aW8nVk8xGPDD
	 Rd6VOBfhcP8o/0BqFJ7Tl2doLqGieXio2dKohm56R1/qVKh7H6IJlX+hnvn07ROPLl
	 1s7iUY5rqD6HWBBsAz1ugCt5yfvj6HXeEgoJQpNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vernon Yang <yanglincheng@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Ridong Chen <ridong.chen@linux.dev>,
	Davidlohr Bueso <dave@stgolabs.net>,
	David Hildenbrand <david@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 751/869] mm: vmscan: dont count per-node proactive reclaim as memory pressure
Date: Sat,  7 Nov 2026 08:57:13 -0500
Message-ID: <20261107134918.217476393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vernon Yang <yanglincheng@kylinos.cn>

[ Upstream commit 2ca8b38962f239b17f7881a4710c11328ce38ac9 ]

When the cgroup has no memory pressure at all, writing to
/sys/devices/system/nodeX/reclaim triggers proactive reclaim on
NUMA node, causing increase in the writer cgroup's memory PSI.

Due to this reclaim is performed in the context of the write(),
accounted as memory pressure on the writer, like
commit e22c6ed90aa9 ("mm: memcontrol: don't count limit-setting reclaim
as memory pressure"). This is unexpected, the similar scenarios (e.g.
senpai) will continue to occur, only this time it is for the
/sys/devices/system/nodeX/reclaim knob.

The Documentation/ABI/stable/sysfs-devices-node documentation also
notes that "This interface is equivalent to the memcg variant."

This patch unifies the semantics of the memcg and node interfaces:
per-node proactive reclaim is no longer counted as memory pressure,
and the per-node proactive reclaim interface no longer produces
phantom pressure.

I ran demo[1] that performs per-node proactive reclaim 10000 times
in qemu, writer cgroup memory.pressure as follows:

without patch:

some avg10=31.53 avg60=13.42 avg300=3.31 total=10602985
full avg10=31.53 avg60=13.42 avg300=3.31 total=10602985

with patch:

some avg10=9.59 avg60=3.41 avg300=0.81 total=2686221
full avg10=9.59 avg60=3.41 avg300=0.81 total=2686221

Link: https://lore.kernel.org/20261012022917.1102467-1-vernon2gm@gmail.com
Link: https://github.com/vernon2gh/app_and_module/tree/main/reclaim_node_psi [1]
Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmscan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c983815bde5bf..6d53f83e9dbcf 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7642,7 +7642,8 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
 					   sc->gfp_mask);
 
 	cond_resched();
-	psi_memstall_enter(&pflags);
+	if (!sc->proactive)
+		psi_memstall_enter(&pflags);
 	delayacct_freepages_start();
 	fs_reclaim_acquire(sc->gfp_mask);
 	/*
@@ -7666,7 +7667,8 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
 	memalloc_noreclaim_restore(noreclaim_flag);
 	fs_reclaim_release(sc->gfp_mask);
 	delayacct_freepages_end();
-	psi_memstall_leave(&pflags);
+	if (!sc->proactive)
+		psi_memstall_leave(&pflags);
 
 	trace_mm_vmscan_node_reclaim_end(sc->nr_reclaimed);
 
-- 
2.53.0



