Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020527;
	b=WGPrzI7bRVgNhGyN6HsbNd+C2gTUGHvJYcYiEKU20oVPcBdPEgWJBUFW8DZXAkjBa4wO
	 epeaiZKjBcwwYEi8P0tOGTbdr9f9GK+Q8OnkVcRi2fzikr4vPnEKLvM0B7FkKcCGJhclU
	 JBUHlT9E3FNuuWuPvQeeMhBIws/AWnD5/v6F75Q6aIG9WSkOU5lxfADYXfWKtkusdZUB9
	 ZoijLtIZdDKjiCzGlhuXtXfH8NGOwRQhBHcPgfs181vQyVXUbUmm+5Ubn0ovEZOuXPXLY
	 iyBtqJfZnSVh4U+gztMCRRLu7suiUy071bpvMDHgeVJiP6MXDsvDE/vfAq8hFyhPpLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J/8yornjzhzUUm28nFX+bGWJtXNnrZinO+PX4LOESbM=;
	b=zwHiB4xqhQTFwiVX00Y9ec5rUfpzgVwKNyEDY4iTkZsjKcZi+mSGqv2EiHkocsg3zyD4
	 UKocw3t2W5mTPWeXF8rhCzb0afm1EdPv230ZUocJgcfUfy5OODdV+9NPjPFgtCTaaxcBC
	 KXucXWEJNVzh/pHae6nbMBMTBnuFcEpRAD0y9NrCYuzvhiwEu6elx2B/kUmv8GvevuD+9
	 rZmW4XBQJxL14yrkpCZ4uIKJoawhKKy8o1MxIFPe/Ev1SlgHb1ziXjYCQlRNZDZfetyCb
	 7x1J3f7qm1Rh5FVjA3q6CWeOqErWzUE8ZqnyzovyCnL+nq+BHsvqwIX1foZ4G4CvPxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TYBc6pXg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0A8606A31C;
	Wed, 18 Nov 2026 16:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TYBc6pXg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BCF1F000C8;
	Wed, 18 Nov 2026 16:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020527;
	bh=J/8yornjzhzUUm28nFX+bGWJtXNnrZinO+PX4LOESbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TYBc6pXghmAjeEqL/dAm/NwKlzV4u8rPjCR4C/bvDI87mI45h7KxCHCpFz/k3nSeE
	 B7EEsas0a3tErN3/hs8MC7mV90kdKuZi8tYqtctos0NQs+58MlIrS/7OzGFd0Z6vHU
	 2u2SQAJHSiDIq+Nj9wSz8FkwVw47yJJ09GZsm78M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b48868c46e62c1c4cb2c@syzkaller.appspotmail.com,
	Paolo Bertinetti <paolobertinetti200f4@proton.me>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1984/2651] ublk: hold RCU read lock in ublk_try_buf_match()
Date: Wed, 18 Nov 2026 15:53:44 +0100
Message-ID: <20261118150357.820206021@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Paolo Bertinetti <paolobertinetti200f4@proton.me>

[ Upstream commit aaf49023041bc1f887a028a164d3bac714b65508 ]

syzbot reports a lockdep splat when I/O is dispatched to a ublk device
with UBLK_F_SHMEM_ZC enabled:

  WARNING: suspicious RCU usage
  lib/maple_tree.c:720 suspicious rcu_dereference_check() usage!
  ...
  Call Trace:
   mas_root lib/maple_tree.c:720 [inline]
   mas_start+0x3cc/0x640 lib/maple_tree.c:1250
   mas_state_walk lib/maple_tree.c:3006 [inline]
   mas_walk+0x1db/0x490 lib/maple_tree.c:4458
   ublk_try_buf_match drivers/block/ublk_drv.c:5639 [inline]
   ublk_init_iod+0x5d2/0x1120 drivers/block/ublk_drv.c:521
   ublk_dispatch_req+0x97/0x9c0 drivers/block/ublk_drv.c:1776
   tctx_task_work_run+0x73d/0xa80 io_uring/tw.c:96

ublk_try_buf_match() calls mas_walk() on the buffer tree without
holding the RCU read lock or the tree lock. Writers are already
excluded because ublk_lock_buf_tree() freezes the queue, so there is
no real race, but maple tree readers must still hold one of the two.

Take the RCU read lock around the walk.

Fixes: 4d4a512a1f87 ("ublk: add PFN-based buffer matching in I/O path")
Reported-by: syzbot+b48868c46e62c1c4cb2c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b48868c46e62c1c4cb2c
Assisted-by: LLM
Signed-off-by: Paolo Bertinetti <paolobertinetti200f4@proton.me>
Reviewed-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/179010105967.8478.2344875677216734809@proton.me
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 959e6594013a8..ca4cb9d760353 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -5738,6 +5738,8 @@ static bool ublk_try_buf_match(struct ublk_device *ub,
 	unsigned long expected_offset = 0;
 	bool first = true;
 
+	guard(rcu)();
+
 	rq_for_each_bvec(bv, rq, iter) {
 		unsigned long pfn = page_to_pfn(bv.bv_page);
 		unsigned long end_pfn = pfn +
-- 
2.53.0



