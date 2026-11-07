Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064449;
	b=Rt4+jUxc6IqO8j1Nti2XrYSdp7iBPLvAxomvUrOBRxZFFwdZLEQ+dh+Vsfz1DWxRtQKY
	 NOC0H9S1ROCl1S4QIJRVG6Ji5P49lZWhH2dwhPUZaFUmuroGrb9StjDeTz9xALQCUeGyi
	 Csh7RT3cqEbNmA5Gx1kZ3+y2CNR9YuVPCoiAyudS1bl3wtDWNPry3BYfUrwX3V55k75YN
	 gGLta95/4r9djTFooiEBcfNtZW8/J5hA4u4ogMvCD08joN4Z58u3Ja30G3AQCpZUWI5Y5
	 /xKoPt0zxaDLv9cm0at7Ou9LUeOKPhr2Grnp7GWW4KDpIw0jHE0FLLGX44JF68BBBRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gG1gXcG8bK0FHzRt2uh5520CrvHWERiTCAtYVro3rEQ=;
	b=yjxzWCNYkfULfzjCWknMovoF2ijkvjDm1fqjG3hp11CkROoykM+NR0nXyOIxC/pYEpgT
	 BPGhgSNAriYF+huCq9e/OzPOj/J+Si0aWVLXFo2z6p8dQ2ncIZK6nlOKdhAt3zbJ/J3f4
	 MV5sNRvqOv7drGXnoWBD1kxe/1/2U90P+nVOwZk7DONdBwdLQlZGfFXqF2+fGYEIzyCp7
	 afiyVM2erB/F8y/cbzRXYgrP8FI6Q2GJh31WvjOtHHu2shgUdu9vrgRYernPRkG5sqVS3
	 8o1EfeuvH80ShHmtInvP7JMUgtA+ynyj92dAPVxm4XqMKbMQwpiCRPpSmSAtQGhK13g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ubhd0wkr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDA56082BCF;
	Sat,  7 Nov 2026 15:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ubhd0wkr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D3D1F008A1;
	Sat,  7 Nov 2026 15:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064448;
	bh=gG1gXcG8bK0FHzRt2uh5520CrvHWERiTCAtYVro3rEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ubhd0wkrsuW69hLxT2C7RE/tA+sP/ufBPfXDUT0jfDgRoszxeTMAWSr/8oP949K74
	 KZSJhRUYXaq7hMI89NWi0VeIZwH5l8xWVVvWncfgTEIRQgOoRM1CCZ3Lff3Xc9hmZJ
	 k2DjABCUyWNq6teY9K+ApN16o2tYK2Gk+/c9u9zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	syzbot+ced4d9a8cadb5ef3adae@syzkaller.appspotmail.com,
	Muchun Song <muchun.song@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Chris Li <chrisl@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0492/1257] mm/memcontrol: fix data-race on reading jiffies_64
Date: Sat,  7 Nov 2026 08:46:28 -0500
Message-ID: <20261107134953.028571807@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit c20cf1c3c8cdd98618d6fcc794003a0e003ae858 ]

KCSAN reported a data-race between tick_do_update_jiffies64() updating
jiffies_64 and mem_cgroup_flush_stats_ratelimited() reading it directly.

Unlike jiffies, jiffies_64 is not volatile, so raw reads are plain
accesses and can even be torn on 32-bit.  Use get_jiffies_64() instead,
and fix the same pattern in mem_cgroup_flush_foreign().

Link: https://lore.kernel.org/20260827025457.116191-1-jiayuan.chen@linux.dev
Fixes: 508bed884767 ("mm: memcg: change flush_next_time to flush_last_time")
Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: syzbot+ced4d9a8cadb5ef3adae@syzkaller.appspotmail.com
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 856a7d07586cc..d399710e9799a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -757,7 +757,7 @@ static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
 		return;
 
 	if (mem_cgroup_is_root(memcg))
-		WRITE_ONCE(flush_last_time, jiffies_64);
+		WRITE_ONCE(flush_last_time, get_jiffies_64());
 
 	css_rstat_flush(&memcg->css);
 }
@@ -785,7 +785,7 @@ void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
 {
 	/* Only flush if the periodic flusher is one full cycle late */
-	if (time_after64(jiffies_64, READ_ONCE(flush_last_time) + 2*FLUSH_TIME))
+	if (time_after64(get_jiffies_64(), READ_ONCE(flush_last_time) + 2 * FLUSH_TIME))
 		mem_cgroup_flush_stats(memcg);
 }
 
@@ -3946,7 +3946,7 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	unsigned long intv = msecs_to_jiffies(dirty_expire_interval * 10);
-	u64 now = jiffies_64;
+	u64 now = get_jiffies_64();
 	int i;
 
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
-- 
2.53.0



