Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214542;
	b=m63xH7tli6JkENiW9D4jbIMoQ2GvwBqa6d2ThdfP85S859UNAy3wmzqN6d7tJEPPZY7r
	 +mwU0/1z34sip6OROP/lHNTjznc1hbTAQduRO5Xzx4dWYwo2b6wsZ+PtuQ+sOTHRApVp6
	 dKpwR9BCrxMEIY4IrVFpFB651MI/r8qjmA1prjtI6d81oLjkrRuW9lYaxQlgkdO1ItLiQ
	 O/xhR/PYvVjb0eNMg4z2Ja5XMstQi31Fs2+1L753/Xsa8rGBxTWAwrgYEw5da/vRiuLGJ
	 1uVRNEGemgeycWSCeWzq3GvMkhy18RhVcSayGrFHaIkkTxEalYMJ6yISMUR6oDnxlYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dVltU4hgDWHYmWrfsMnAc4frWZ1cXUlfT3dszolZp7U=;
	b=gY4I5QkHDNCvi38to2lPPYKpULNM23t8sZ27ojN/gU9DkMeZUPpw1cNaFhLc35Uxr2Qw
	 pofOGehaoAse/hlejR7UxKMxdcf1fkBDquuVwxRRgGMGBj9VDv3czb7bUkrS+EW6t5rep
	 EUIzQDPdGBgdf4evFz8wY+I8YxnM3VSzs/OY6QuR6Yod3OsKN6a+wPNUeOX7udx4IXbwg
	 KqH6Wy8bqGOCwr3JbW4QAMz+tUsxvfIMOJwVfTuEwqcyYQIWZYghxDNFGaKauY6UhqyT7
	 +0enDOVLV77XEExWMUf880APrQ3yjfUPJohjPcGiFFnbAGlALa89bvrBpwrnnsXhLPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OXWjULu0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B7860A2607;
	Wed, 28 Oct 2026 19:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OXWjULu0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32811F01825;
	Wed, 28 Oct 2026 19:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214541;
	bh=dVltU4hgDWHYmWrfsMnAc4frWZ1cXUlfT3dszolZp7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OXWjULu0hvtXy0t2xCzLWaJy5iEhXD9rVWXyrj1dXhn2NNEc90OqFXCHF4qGTgnE4
	 60Xz6YZJyNdeknaFQ/PGinUjePwA9LYR86R30NRX3jjrRWGe1hh0qKiw4OQJ06NfZX
	 nmJzRCFHIohpsZo/HubnGNg0cD5tRzZDjAsg7ttM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0893/1887] lan966x: Fix sleeping in atomic context
Date: Wed, 28 Oct 2026 17:49:49 +0100
Message-ID: <20261028170519.739400984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 0216721ce71252f60d89af49c8dff613358058d3 ]

The following warning was seen when we try to connect using ssh to the device.

BUG: sleeping function called from invalid context at kernel/locking/mutex.c:575
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 104, name: dropbear
preempt_count: 1, expected: 0
INFO: lockdep is turned off.
CPU: 0 UID: 0 PID: 104 Comm: dropbear Tainted: G        W           6.18.0-rc2-00399-g6f1ab1b109b9-dirty #530 NONE
Tainted: [W]=WARN
Hardware name: Generic DT based system
Call trace:
 unwind_backtrace from show_stack+0x10/0x14
 show_stack from dump_stack_lvl+0x7c/0xac
 dump_stack_lvl from __might_resched+0x16c/0x2b0
 __might_resched from __mutex_lock+0x64/0xd34
 __mutex_lock from mutex_lock_nested+0x1c/0x24
 mutex_lock_nested from lan966x_stats_get+0x5c/0x558
 lan966x_stats_get from dev_get_stats+0x40/0x43c
 dev_get_stats from dev_seq_printf_stats+0x3c/0x184
 dev_seq_printf_stats from dev_seq_show+0x10/0x30
 dev_seq_show from seq_read_iter+0x350/0x4ec
 seq_read_iter from seq_read+0xfc/0x194
 seq_read from proc_reg_read+0xac/0x100
 proc_reg_read from vfs_read+0xb0/0x2b0
 vfs_read from ksys_read+0x6c/0xec
 ksys_read from ret_fast_syscall+0x0/0x1c
Exception stack(0xf0b11fa8 to 0xf0b11ff0)
1fa0:                   00000001 00001000 00000008 be9048d8 00001000 00000001
1fc0: 00000001 00001000 00000008 00000003 be905920 0000001e 00000000 00000001
1fe0: 0005404c be9048c0 00018684 b6ec2cd8

It seems that we are using a mutex in a atomic context which is wrong.
Change the mutex with a spinlock.

Fixes: 12c2d0a5b8e2 ("net: lan966x: add ethtool configuration and statistics")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20251105074955.1766792-1-horatiu.vultur@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../microchip/lan966x/lan966x_ethtool.c        | 18 +++++++++---------
 .../ethernet/microchip/lan966x/lan966x_main.c  |  2 --
 .../ethernet/microchip/lan966x/lan966x_main.h  |  4 ++--
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
index 06811c60d598e..df10a0b68a08e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
@@ -294,7 +294,7 @@ static void lan966x_stats_update(struct lan966x *lan966x)
 {
 	int i, j;
 
-	mutex_lock(&lan966x->stats_lock);
+	spin_lock(&lan966x->stats_lock);
 
 	for (i = 0; i < lan966x->num_phys_ports; i++) {
 		uint idx = i * lan966x->num_stats;
@@ -310,7 +310,7 @@ static void lan966x_stats_update(struct lan966x *lan966x)
 		}
 	}
 
-	mutex_unlock(&lan966x->stats_lock);
+	spin_unlock(&lan966x->stats_lock);
 }
 
 static int lan966x_get_sset_count(struct net_device *dev, int sset)
@@ -365,7 +365,7 @@ static void lan966x_get_eth_mac_stats(struct net_device *dev,
 
 	idx = port->chip_port * lan966x->num_stats;
 
-	mutex_lock(&lan966x->stats_lock);
+	spin_lock(&lan966x->stats_lock);
 
 	mac_stats->FramesTransmittedOK =
 		lan966x->stats[idx + SYS_COUNT_TX_UC] +
@@ -424,7 +424,7 @@ static void lan966x_get_eth_mac_stats(struct net_device *dev,
 		lan966x->stats[idx + SYS_COUNT_RX_LONG] +
 		lan966x->stats[idx + SYS_COUNT_RX_PMAC_LONG];
 
-	mutex_unlock(&lan966x->stats_lock);
+	spin_unlock(&lan966x->stats_lock);
 }
 
 static const struct ethtool_rmon_hist_range lan966x_rmon_ranges[] = {
@@ -450,7 +450,7 @@ static void lan966x_get_eth_rmon_stats(struct net_device *dev,
 
 	idx = port->chip_port * lan966x->num_stats;
 
-	mutex_lock(&lan966x->stats_lock);
+	spin_lock(&lan966x->stats_lock);
 
 	rmon_stats->undersize_pkts =
 		lan966x->stats[idx + SYS_COUNT_RX_SHORT] +
@@ -508,7 +508,7 @@ static void lan966x_get_eth_rmon_stats(struct net_device *dev,
 		lan966x->stats[idx + SYS_COUNT_TX_SZ_1024_1526] +
 		lan966x->stats[idx + SYS_COUNT_TX_PMAC_SZ_1024_1526];
 
-	mutex_unlock(&lan966x->stats_lock);
+	spin_unlock(&lan966x->stats_lock);
 
 	*ranges = lan966x_rmon_ranges;
 }
@@ -614,7 +614,7 @@ void lan966x_stats_get(struct net_device *dev,
 
 	idx = port->chip_port * lan966x->num_stats;
 
-	mutex_lock(&lan966x->stats_lock);
+	spin_lock(&lan966x->stats_lock);
 
 	stats->rx_bytes = lan966x->stats[idx + SYS_COUNT_RX_OCT] +
 		lan966x->stats[idx + SYS_COUNT_RX_PMAC_OCT];
@@ -696,7 +696,7 @@ void lan966x_stats_get(struct net_device *dev,
 
 	stats->collisions = lan966x->stats[idx + SYS_COUNT_TX_COL];
 
-	mutex_unlock(&lan966x->stats_lock);
+	spin_unlock(&lan966x->stats_lock);
 }
 
 int lan966x_stats_init(struct lan966x *lan966x)
@@ -712,7 +712,7 @@ int lan966x_stats_init(struct lan966x *lan966x)
 		return -ENOMEM;
 
 	/* Init stats worker */
-	mutex_init(&lan966x->stats_lock);
+	spin_lock_init(&lan966x->stats_lock);
 	snprintf(queue_name, sizeof(queue_name), "%s-stats",
 		 dev_name(lan966x->dev));
 	lan966x->stats_queue = create_singlethread_workqueue(queue_name);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 8347def40f9d4..4a85cd5ebcce0 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -1182,7 +1182,6 @@ static int lan966x_probe(struct platform_device *pdev)
 
 	cancel_delayed_work_sync(&lan966x->stats_work);
 	destroy_workqueue(lan966x->stats_queue);
-	mutex_destroy(&lan966x->stats_lock);
 
 	return err;
 }
@@ -1197,7 +1196,6 @@ static int lan966x_remove(struct platform_device *pdev)
 
 	cancel_delayed_work_sync(&lan966x->stats_work);
 	destroy_workqueue(lan966x->stats_queue);
-	mutex_destroy(&lan966x->stats_lock);
 
 	lan966x_mac_purge_entries(lan966x);
 	lan966x_mdb_deinit(lan966x);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index ff5736d2c7a6b..3f8b724eac47e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -231,8 +231,8 @@ struct lan966x {
 	const struct lan966x_stat_layout *stats_layout;
 	u32 num_stats;
 
-	/* workqueue for reading stats */
-	struct mutex stats_lock;
+	/* lock for reading stats */
+	spinlock_t stats_lock;
 	u64 *stats;
 	struct delayed_work stats_work;
 	struct workqueue_struct *stats_queue;
-- 
2.53.0



