Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043856;
	b=uvDy1PYJz8jRO9w/Gg0JgYqs1xx8UkMbtkHechI63hWHjA5AlJsfWdzvFxOeiFrNUt28
	 eYNriZwL4nJTJNprxChmLqD4kwOShISIwW3usGeXe4lh3ip3cBGlZ+r4ghvAUufATxzuT
	 dbVK1ZqE4hR0bX8X4qBHB4rT+ZCay/1DkwGyBqLogyv0/yl5SW8qcZkQRd3nGpTQfZ7ph
	 Eg/ICdW0mCEAsbbaqOljEcynsWclWSbWto5Wn+VYlqZtVvN4npy/4zm4o2bVlPpfxHQWr
	 KNYtoHMuqx2yxrkjzLHcEMdH2CvyqafTY4SD3H0+OII+QwD/fI+Mgk80EKMwaZyc9rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z7DiquK88U3i2gnMaW5ySkw5sy14+cTWzhcPzr2+2as=;
	b=xZyu3nr686ppg8Sz2Avs5DsD7NmNVa31Q3dD6g7XkaB5fMxL38MWtQzoejhtEv/LxnHE
	 nHmPYm3HXPnfI84KOB3ZDzTlBmBHlup/uAaaEzthLR469L11FHAWiOfOrFQ0U4UJdn/eV
	 qMa++abB1SDWfhmmSGL7HLAnIKQiXiSvOspVGXw51fAF0wjgOvgWnBV02eJDDrAbd/p/h
	 GYlxJBZWiQQ41zY+w7hgfzTJDSsxFKB+Ch0I41+U4Fd64w8FCA2b2xozkNukvX2YBjDzB
	 fxmD/QraAGHFENhuthA/5Y7PATnW7z3OxsPLtyt0tYNPAWHouBs8OpxGG0IfFG/m/iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Imxwkvbv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D34606A334;
	Wed, 18 Nov 2026 23:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Imxwkvbv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EF41F000C4;
	Wed, 18 Nov 2026 23:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043856;
	bh=z7DiquK88U3i2gnMaW5ySkw5sy14+cTWzhcPzr2+2as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Imxwkvbvs2TgXaVxTFq+gYH/ddmPk+GruxEX8HzH+dZEpEsIx95bBKcDPUHknEIIc
	 vjZab/LgsKl2FucM8L+v7aM0KXgMCFtF7qmhV/+UX7N3C9PtwDIFb3ZEt0TJtAiIZa
	 b3UpCSbvZlnNnmSgb4wq3eXymq+/ih+3zW5nnHY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Harshvardhan Jha <harshvardhan.j.jha@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0323/2857] cxgb4: fix use after free bugs caused by circular dependency problem
Date: Wed, 18 Nov 2026 15:22:37 +0100
Message-ID: <20261118150213.075722308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



