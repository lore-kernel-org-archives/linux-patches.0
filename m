Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029671;
	b=1/znNpE//6YdMdN8kVAZDoc2Y3gNssOp5pO/zd+/QryNOUWweIFF2QeqXii+Yus0GKXn
	 qu1wgnswfrn1q9pyQvF2m2vNecNqwDexOA4yxKTK5SPJ/9dzTm6iBr2j6yQ+FokY3uqK4
	 rkjydIio7yL426Y14WDqo5c/2DwY6pxgf626pqAXuOsDQ2R1Rs//QJNd+gG27FmPQ4rlc
	 lnLqNY34IkEoh36rnsUZuf5GVlLG2N4xLLwQwEOXYFsvVpSGTcBVWlBV3xx/bkNYeBRjL
	 119OU3ON3NDr5ohOXKai0I2Bl0mQuw6Viy9NKD1Vh3VAivHic+lyUeOPNBNdfNigIIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dZ/amDhvOm3S5wWs778OFXozKrfPtQRGqY0j/JYreK0=;
	b=C8774vR0Y1durXtipU4/Vspr6X7iWy0g6FuOixmeOZ2gVk/00Wl9eawmZYmScdRuZGG7
	 fuc2UNnAWvFo+hKSF1PVu2S/3nvOKijWaiAjnWpdbdvYfCurwDO33M1BwVtAVdbnc2/ce
	 WZAA42cr6miTZCC8YoCNKiaQ6m4qGiuqzCPd5RIoly7KrXqur2g1/vAdQbc3mxkvyLR/c
	 mCSbCdwohZOt5AVSK3gMoCHODybl9hvvyoJcBm2wYARj1iEmCJskL9Qm6Z3GstNS060Ja
	 Iyk+1f36EsQX8rP9xmRLBjUeGRQ0P/hspEvsDS1q3cR5mBOZN8w4XM8Ley+MXq4L6bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MMmh8Mp0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CC2606A320;
	Wed, 18 Nov 2026 19:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MMmh8Mp0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AB81F000C4;
	Wed, 18 Nov 2026 19:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029671;
	bh=dZ/amDhvOm3S5wWs778OFXozKrfPtQRGqY0j/JYreK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMmh8Mp0N5SyJhBvrgKkCrqa8OCttpeHtDw6umgxiL6sjyeGQuzYq6z8bXpgACxu3
	 KiXIsY157U10j/wh/acqW3k3zAEemR6X8q7fKDcaVntsHArPVzTxJuRFmXp0zAO/6+
	 y5zJE3840wktJJUT3YrGMBuGP01o6WC3wBm4mB14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0434/1756] md/raid10: fix missing wakeup in wait_barrier_nolock
Date: Wed, 18 Nov 2026 15:42:41 +0100
Message-ID: <20261118150026.026059792@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 875759fa86cab..fefec2b51e399 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -993,7 +993,8 @@ static bool wait_barrier_nolock(struct r10conf *conf)
 	if (!read_seqretry(&conf->resync_lock, seq))
 		return true;
 
-	if (atomic_dec_and_test(&conf->nr_pending))
+	if (atomic_dec_and_test(&conf->nr_pending) ||
+	    READ_ONCE(conf->array_freeze_pending))
 		wake_up_barrier(conf);
 
 	return false;
-- 
2.53.0



