Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016396;
	b=Vhk+a3Yob7EAWXLIOHKuR2AOxkt4rJ6tOPdmdkMI+KGLxVmuDNG6Ukw6sqf5DkIE91zb
	 io/3pB2EOYzsZ0U7mBVbMW0uKsGpdUoWAln48ofJ0b8vc7EejDcYhNdtFi1f+alMZJ7a+
	 BM96qbHztBO7MIyTp3BwvPxG1kOwsFN7MWZKLL2NzhWd7HuRV5Za6bVJIEZmAH4IFdcxA
	 gq6DIK9TKbpHHhdbVmBGEjBEK5xhqxWfRkTF2z+6J9UwrmKsyXLNO/HbcFGG6FReTpPFw
	 g2YxKoMb+eBBTTf2pryMKy9pZhU25n4lxhfdOdNG+PlnKUVREoa7pq02996etOee1uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016396;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pwe7FkRSYBpVRXvopJQWFDF1YTSKUaWY73VguAkUBIs=;
	b=JhYVG1nlKGSOkX/jGl2bNunCG0aD+ucAdvKWyXVIA+WX5R6kIxoOkf+3pzE+DShLAQsc
	 RPnEgp1o9CWKlKNAh8gwoejXV6ASmIR44ttqHKJxHPu5jqbO+JPstzkMgTlSyPFLWZEoE
	 gRLqbVdmgVNORWVInVH3d3rnTbdyInT1VBAGvG3FTV8vkPDkUm6KckuS1WqWw/wK/XnlV
	 eshofffiOnAp0OKZt8ZfDznaff4hCW5E4bwRhcihBbzlP+pyT30J1nMHEg67hBcj4CSjK
	 crD877608SYp/bm9mKNvseRbpDa6laasVnhKnmNBis/cm5G4IL5J75gKPAk7kTtbHag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z07gVijQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB4560A260F;
	Wed, 18 Nov 2026 15:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z07gVijQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DBF21F000C4;
	Wed, 18 Nov 2026 15:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016396;
	bh=Pwe7FkRSYBpVRXvopJQWFDF1YTSKUaWY73VguAkUBIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z07gVijQAxrZvT1bRSHM1mJyeKWGmEMak10aXvKpJx5J4hEJ7Mnnod2wVP6KD1pIR
	 N7mNxcDsYR0/62IWiwvHpgg0tc0iq1rHhrnU05oHwqBX8OG7VwWApBAQUPhDlOZMPW
	 EsiWKZ3biuIY9xW/yUUPXLzHrdy7euvQFBvY/L3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0512/2651] md/raid10: fix missing wakeup in wait_barrier_nolock
Date: Wed, 18 Nov 2026 15:29:12 +0100
Message-ID: <20261118150306.184705136@linuxfoundation.org>
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

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit f00eb0ff45793383d5a62db2d2aea63ada0ccdbd ]

Fuzz testing triggered a hung raid10d thread:

INFO: task md0_raid10 blocked for more than 120 seconds.
Call Trace:
 raid10d
 md_thread
 kthread

wait_barrier_nolock() speculatively increments nr_pending. If a
concurrent writer changes resync_lock's sequence, it rolls the count back
with atomic_dec_and_test(). The rollback currently wakes wait_barrier only
when nr_pending reaches zero.

freeze_array() can be waiting for nr_pending == nr_queued + extra while
array_freeze_pending is set. If the rollback changes nr_pending from 2 to
1, the condition becomes true but no wakeup is sent, leaving raid10d
blocked indefinitely.

Also wake wait_barrier when array_freeze_pending is set, matching
allow_barrier().

Fixes: b9b083f9044a ("md/raid10: convert resync_lock to use seqlock")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Link: https://patch.msgid.link/20260817033340.418119-3-wozizhi@huawei.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1093c798d9dde..186e17e0a6357 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1010,7 +1010,8 @@ static bool wait_barrier_nolock(struct r10conf *conf)
 	if (!read_seqretry(&conf->resync_lock, seq))
 		return true;
 
-	if (atomic_dec_and_test(&conf->nr_pending))
+	if (atomic_dec_and_test(&conf->nr_pending) ||
+	    READ_ONCE(conf->array_freeze_pending))
 		wake_up_barrier(conf);
 
 	return false;
-- 
2.53.0



