Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE288615A;
	Tue, 17 Dec 2024 17:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456217; cv=none; b=kQvCE6ZbYDBs+pN9KsJrfcqhoE6Xy7C81qwTpJ/m1guN36dvtOPnqv1+6fQZDYm+zTsWFzy/WDGwhc13aCh3VBVL1adBUz9yBOzx8EXjatHSP6zpg04+GPEWtWlHY5QCkFYhyvRL7/cA3qOaMQLvHXdfgsN52M9Goy0LzZMbYNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456217; c=relaxed/simple;
	bh=O76CdUblm8bpZ2Feq8oFyGzuJfC2BDgRpiDT/xKB85M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYAfilGTmE5MA0hYHqxggEgyCT8mHlWPJvrzUxqPjd720A3bjPLFKBxu34M/3n/vFKModBvSt0zp+ymHsYDdUu4KJVVBCHnGmcfQTTMHttBi7THUREaX1gH2k0pzQWkrBZIwjrwwq6kMV0sMOcYunGKqV/SsxNo6oPBKL3nnSEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xdIABiPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xdIABiPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A49C4CED3;
	Tue, 17 Dec 2024 17:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456217;
	bh=O76CdUblm8bpZ2Feq8oFyGzuJfC2BDgRpiDT/xKB85M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xdIABiPnbUbzlTiweOmbfQSHeiqYGGuV3WI31tyoQqb9lKKpbXCLUz/zH/n8qxtyn
	 qU88F5Oa29OU/TBJ7/jygFLszWL2QOg6G/VFyrnDtbJmQHRbaB8IhMx032BJ41hbAB
	 qClZL+ZftUgc61QQ3Fg57QNrLdRY10mZw99yzmNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/109] net: rswitch: Drop unused argument/return value
Date: Tue, 17 Dec 2024 18:07:52 +0100
Message-ID: <20241217170536.222682353@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit c7e0022390d43788f63c7021ad441c1f8d9acf5f ]

Drop unused argument and return value of rswitch_tx_free() to
simplify the code.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 0c9547e6ccf4 ("net: renesas: rswitch: fix race window between tx start and complete")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/rswitch.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index ae9d8722b76f..b783516eb9e2 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -760,20 +760,19 @@ static bool rswitch_rx(struct net_device *ndev, int *quota)
 	return 0;
 }
 
-static int rswitch_tx_free(struct net_device *ndev, bool free_txed_only)
+static void rswitch_tx_free(struct net_device *ndev)
 {
 	struct rswitch_device *rdev = netdev_priv(ndev);
 	struct rswitch_gwca_queue *gq = rdev->tx_queue;
 	struct rswitch_ext_desc *desc;
 	dma_addr_t dma_addr;
 	struct sk_buff *skb;
-	int free_num = 0;
 	int size;
 
 	for (; rswitch_get_num_cur_queues(gq) > 0;
 	     gq->dirty = rswitch_next_queue_index(gq, false, 1)) {
 		desc = &gq->tx_ring[gq->dirty];
-		if (free_txed_only && (desc->desc.die_dt & DT_MASK) != DT_FEMPTY)
+		if ((desc->desc.die_dt & DT_MASK) != DT_FEMPTY)
 			break;
 
 		dma_rmb();
@@ -785,14 +784,11 @@ static int rswitch_tx_free(struct net_device *ndev, bool free_txed_only)
 					 size, DMA_TO_DEVICE);
 			dev_kfree_skb_any(gq->skbs[gq->dirty]);
 			gq->skbs[gq->dirty] = NULL;
-			free_num++;
 		}
 		desc->desc.die_dt = DT_EEMPTY;
 		rdev->ndev->stats.tx_packets++;
 		rdev->ndev->stats.tx_bytes += size;
 	}
-
-	return free_num;
 }
 
 static int rswitch_poll(struct napi_struct *napi, int budget)
@@ -807,7 +803,7 @@ static int rswitch_poll(struct napi_struct *napi, int budget)
 	priv = rdev->priv;
 
 retry:
-	rswitch_tx_free(ndev, true);
+	rswitch_tx_free(ndev);
 
 	if (rswitch_rx(ndev, &quota))
 		goto out;
-- 
2.39.5



