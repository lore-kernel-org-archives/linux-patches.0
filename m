Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044114;
	b=LgbbOxuUj1A7Y1sc85DkphcfwuX0EQe0YubfcElJWS3rZacl57f86gkdOlG6kBn/arRR
	 VFbaOdfHEflZUMl3IpHzzrMPmQnbrxFhI4gc1Tcng261oeLBTUWQOjRVP67ZzuTfxUjUH
	 M3Bqaa8rPmLbFR/5JXdR5eU4+E0CclxKi3Tpb0tSrU008j6H8herXJRpjoe42PCxje3Ok
	 kc4BX8B57I+Qqw26EDPsboLna9DrAk8TZJ0PNtNXPhukvSJm+mFuaQJPRzyzxv4zc0/I7
	 npuP4Zx4eacJV+QgLM0YsVztKCXNspi8L5ISTy8e4CEI2ks5iw8YKqfCThztdqkugFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rEfxvRJo1xq2yehDlkFN456mi1h9aHe1LnTD449dIsE=;
	b=S6FjnuM52qP1ba1E8O74RWSltoayCULLTs3muEB4rbI4JSWRndnj4DAihucL5SR/EIOT
	 55ni9LYCK6YeNlskdAeU4fEA4GE9Q6EEb1LtIXfoQlXgmti001hV+VHsOn9v9rPGWGVnl
	 puB8i4YMSOJxDgWiP5s0xugPqOwJLvPFzb8mJH/adA+agTOOPhxAZhAAvLHUNI8bpEXp8
	 ZFwILlkaCAqdXTOwWpjt4BNsYzT0M2Xkuvn5nZ5BQcIvilmC4vNZs5kIB/GkGmYvhbzZr
	 DSfzzY1iJpTpOTQF468cWAUUwYx7FoTpO3QN5i94C7U3aMhK2AKge1ITbfCnt4bc2yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ut7yfhs3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBB3606A31C;
	Wed, 18 Nov 2026 23:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ut7yfhs3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5922D1F000CD;
	Wed, 18 Nov 2026 23:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044113;
	bh=rEfxvRJo1xq2yehDlkFN456mi1h9aHe1LnTD449dIsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ut7yfhs3ojSLw2NeOQ2aSvw7lbyRTf8bnNy4rEmXWV7q2ShVPS0WufmhrtGksoBss
	 ZLOk30n6sGVRED4PC3tthxdexviozSdMrVrJiqOxigtmpFr8cJijY8IjD40nIDYQKz
	 tAO+RtfJmjzOfJxef+yGXD2fpLNnEYXtWPCb/q7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0415/2857] net: macb: initialize PTP state before registering clock
Date: Wed, 18 Nov 2026 15:24:09 +0100
Message-ID: <20261118150216.326352247@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit e1406330d70e56dd44fa6fbafc86e77e5c80c122 ]

gem_ptp_init() registers the PTP clock before initializing
bp->tsu_clk_lock and the TSU hardware. Since ptp_clock_register()
publishes the PTP character device, userspace may invoke PTP callbacks
before the lock and hardware are ready.

In addition, gem_ptp_init() is called from both the interface open and
resume paths. Reinitializing tsu_clk_lock there can reset the lock while
timestamp processing is using it.

This race is theoretical and has not been observed in practice.

Initialize tsu_clk_lock once during probe and initialize the TSU before
registering the PTP clock.

Fixes: ab91f0a9b5f4 ("net: macb: Add hardware PTP support")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/netdev/20260904030439.3994047-1-runyu.xiao@seu.edu.cn/
Reviewed-by: Théo Lebrun <theo.lebrun@bootlin.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260908103924.607033-1-runyu.xiao@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Adapted for the older function signature by using &dev->dev in ptp_clock_register() and kept the existing per-queue timestamp init loop after registration. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 1 +
 drivers/net/ethernet/cadence/macb_ptp.c  | 4 +---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 61f85b54afc9c..c6e623861089f 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5104,6 +5104,7 @@ static int macb_probe(struct platform_device *pdev)
 
 	spin_lock_init(&bp->lock);
 	spin_lock_init(&bp->stats_lock);
+	spin_lock_init(&bp->tsu_clk_lock);
 
 	/* setup capabilities */
 	macb_configure_caps(bp, macb_config);
diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index 84ba09bfdd303..bd1d2ca855d16 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -381,6 +381,7 @@ void gem_ptp_init(struct net_device *dev)
 	bp->tsu_rate = bp->ptp_info->get_tsu_rate(bp);
 	bp->ptp_clock_info.max_adj = bp->ptp_info->get_ptp_max_adj();
 	gem_ptp_init_timer(bp);
+	gem_ptp_init_tsu(bp);
 	bp->ptp_clock = ptp_clock_register(&bp->ptp_clock_info, &dev->dev);
 	if (IS_ERR(bp->ptp_clock)) {
 		pr_err("ptp clock register failed: %ld\n",
@@ -392,15 +393,12 @@ void gem_ptp_init(struct net_device *dev)
 		return;
 	}
 
-	spin_lock_init(&bp->tsu_clk_lock);
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
 		queue->tx_ts_head = 0;
 		queue->tx_ts_tail = 0;
 		INIT_WORK(&queue->tx_ts_task, gem_tx_timestamp_flush);
 	}
 
-	gem_ptp_init_tsu(bp);
-
 	dev_info(&bp->pdev->dev, "%s ptp clock registered.\n",
 		 GEM_PTP_TIMER_NAME);
 }
-- 
2.53.0



