Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065408;
	b=ZHk1wi1Z2Dl661w9TfC0erNy+qbV3S4CpKz1Y40v1A+keMCXUC0YGm+y8XpGN9LlBSrO
	 GW7RGq4b9HODRIzMFt6loBTXxajaTFqSG7tiaSn5SLNWyIXwGdJFg8XvLZ1d8vnUP40pK
	 0x04zrodm4SaD9DKW8zfG7urjjAmjkE+bN85JTY1NEt8Ypi9fcR4Qrl9+dlmDYE+sMlal
	 6Oc0AOJAH0KRtKASpg2voaxZMjFdybjWubE403P4KamkPvHoakJJpP11adIQTryr/p7jD
	 rYjTIbmV1HiApRmruABoEALhBdWL8gmGXJhA+6ERHK4S8HLGQ9F8H6WSFNoaVR7gZkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gNSuNh9qIAAMkroKBbw/CZsVRAN2JXknWCrL99r9uVI=;
	b=jafYyhwg8wwj6r0Zo+L+lC1SRawkA9CoU+kGDL4Bh26Q/OBxA6MLvabXTBWseXySWlJe
	 +umEs00P6ktGMbYrfhIv/kujiWaJMS4NoXybH3UvbrQUfREQMSgYzFRm84qdukaLzysVW
	 ytkgYz8xk5ytc0m/ueLdbJTD2EkXXTfubD+s6tzLF/nyHhcacMxoIvjb/2cWWCeyJg6j1
	 jGCF0LRjyasKv6Yjk5DMO2Jb3Jt/6P5PoH3e82hOCp2UPU/fTa9VvvfO5hY7hshP4/dXB
	 zihKCnRqwt6YechDKdZOEVnXSZ08xk/fktruNFofwtaSSC5X19hNKFWXArs22r0UnFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L2dPlXE1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131DB606A33A;
	Sat,  7 Nov 2026 15:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L2dPlXE1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E3D1F0089F;
	Sat,  7 Nov 2026 15:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065407;
	bh=gNSuNh9qIAAMkroKBbw/CZsVRAN2JXknWCrL99r9uVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L2dPlXE1JfwLo7y4WPz7ylAKNZbrh0WsC1CgtNxbDLP95wq+IPscdxXOqp/C7FJwJ
	 5tRA3DsgXqvWOvE9xzXGnipRNgO6zg4gGfYlCQplEtwbTgQFc7gq6Ops+830Rci4Pp
	 MjN4dC8uiqi04Un2iNpRlZCyhc+m3YFT5WnZx01E=
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
Subject: [PATCH 7.3 1088/1257] mm: vmscan: dont count per-node proactive reclaim as memory pressure
Date: Sat,  7 Nov 2026 08:56:24 -0500
Message-ID: <20261107135009.316798463@linuxfoundation.org>
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
index 59f4a805fd53c..6a14e42ea9ed6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7847,7 +7847,8 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
 					   sc->gfp_mask);
 
 	cond_resched();
-	psi_memstall_enter(&pflags);
+	if (!sc->proactive)
+		psi_memstall_enter(&pflags);
 	delayacct_freepages_start();
 	fs_reclaim_acquire(sc->gfp_mask);
 	/*
@@ -7871,7 +7872,8 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
 	memalloc_noreclaim_restore(noreclaim_flag);
 	fs_reclaim_release(sc->gfp_mask);
 	delayacct_freepages_end();
-	psi_memstall_leave(&pflags);
+	if (!sc->proactive)
+		psi_memstall_leave(&pflags);
 
 	trace_mm_vmscan_node_reclaim_end(sc->nr_reclaimed, NULL);
 
-- 
2.53.0



