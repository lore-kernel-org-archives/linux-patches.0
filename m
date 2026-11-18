Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051638;
	b=bWd8Cu0pehBkNxau11MpxE7VPrckAjCNqVuA9Cbm0aIxLlXaAZSEpQ6BhZTMD0jVOjoz
	 MAjGJnYsDaLLpbQ0Vlcsa8IeOKgnYHfgzLnWp5CAuivmbg49DmIeJso+2zxtN92LRc/sO
	 vLt7QQ8lkSz2TlOlTxeXveS4FaRPuSIMB3ncSlS3d5w0CyyRCVdP7rdNp7rVMnobvzvRJ
	 nzx1Doztvcw7/d4ntd/AQTiLiuTuJzhOCJkaMC79J/NkAWmvE6Lqpo+cHUVSwGhWvlNB4
	 8SL5+acaoal9fi/132IZaXxBYWucJ74iCVQPbKL27lRxFSDOf5kYTUrJ7vymSPuxeHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BGQWx7TyF2WiMZd/I/OtQ1m81a9p2ljdVy1Kr2Ayxx8=;
	b=HWVulnGPW73wYlXGq4xkWR0cvu5W+bqpnrG0VdNfi1A/Up+j8kqR10PxoIjmC3VXxAr9
	 R+3rgX2TgRRu+f/9hG2EfOFa0NNRyclKcBuJ0h3un4ImDyXgMDKZrAXvVHywVQmExXhz9
	 rgRYkZBxvBIoQ6RQ8EJh5sz0PfKzs76cBSn0QHcUKP8ZXFjNv5oT8edEm/NcWn6Q4EeH4
	 DGYDDVKBQRXtaIE5lKRwW35qoTAtTaTOIVB2CSnOnbv48NV8itiNZHHFuRhEHUHkQQMmN
	 I/CLSBplw1nJOrHKdYvD57LjI23mjYKLf2ObdfGh1s73qYs3aX3vHH4GRgFqWdmo45w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1PX3OrRh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E70606A332;
	Thu, 19 Nov 2026 01:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1PX3OrRh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231FF1F000C5;
	Thu, 19 Nov 2026 01:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051637;
	bh=BGQWx7TyF2WiMZd/I/OtQ1m81a9p2ljdVy1Kr2Ayxx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1PX3OrRh2xwANP23ooex6pQxUdseMVK/peIdXI+4p/7O/4LCibAu7v8dpN5bg5VEe
	 fqVKBjPVl7F20FSrOVLZHyTomn2MufVXEC7X7Y1deqFu7c1wWhzTLQt8MOp7/3y/dj
	 D/OtieXJNJyemAbqSLgXcz0o+KbmBZEAVyG+MrSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Harshvardhan Jha <harshvardhan.j.jha@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0279/2214] cxgb4: fix use after free bugs caused by circular dependency problem
Date: Wed, 18 Nov 2026 15:32:35 +0100
Message-ID: <20261118150021.220084632@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit e50b9b9e8610d47b7c22529443e45a16b1ea3a15 ]

The flower_stats_timer can schedule flower_stats_work and
flower_stats_work can also arm the flower_stats_timer. The
process is shown below:

----------- timer schedules work ------------
ch_flower_stats_cb() //timer handler
  schedule_work(&adap->flower_stats_work);

----------- work arms timer ------------
ch_flower_stats_handler() //workqueue callback function
  mod_timer(&adap->flower_stats_timer, ...);

When the cxgb4 device is detaching, the timer and workqueue
could still be rearmed. The process is shown below:

  (cleanup routine)           | (timer and workqueue routine)
remove_one()                  |
  free_some_resources()       | ch_flower_stats_cb() //timer
    cxgb4_cleanup_tc_flower() |   schedule_work()
      del_timer_sync()        |
                              | ch_flower_stats_handler() //workqueue
                              |   mod_timer()
      cancel_work_sync()      |
  kfree(adapter) //FREE       | ch_flower_stats_cb() //timer
                              |   adap->flower_stats_work //USE

This patch changes del_timer_sync() to timer_shutdown_sync(),
which could prevent rearming of the timer from the workqueue.

Fixes: e0f911c81e93 ("cxgb4: fetch stats for offloaded tc flower flows")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20230415081227.7463-1-duoming@zju.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index dd9be229819a5..d3541159487dd 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -1135,7 +1135,7 @@ void cxgb4_cleanup_tc_flower(struct adapter *adap)
 		return;
 
 	if (adap->flower_stats_timer.function)
-		del_timer_sync(&adap->flower_stats_timer);
+		timer_shutdown_sync(&adap->flower_stats_timer);
 	cancel_work_sync(&adap->flower_stats_work);
 	rhashtable_destroy(&adap->flower_tbl);
 	adap->tc_flower_initialized = false;
-- 
2.53.0



