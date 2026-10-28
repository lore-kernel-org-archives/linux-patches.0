Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214825;
	b=0hPye31RGPl1J2Y8fM31vSsUd7D05e6j1w98djSeHmBScdAuasaAh5NVJB+w8LUDYAVy
	 jiletXgVR9LL5eUfK0894IusAgVE/8bKTrgga8kn9veR/GuRwKre4EnrAXV5/zAbctCYV
	 kelugEllaabUcq9SahZuhpSwwp4bFCF0ysmtBBN4KtEWL9orfYkWDv5K1iQ/MMx/JoCs7
	 reyuVB4vhwo2Dn+MP5grWSNCEYhjhX3aH88VnQ+JPQWB8BoifDwEouApuWX/kQjmhF4Oi
	 vmEdiYW4nFGXPRcxoP4L8EW5GXXlzTCkI20QxHdK0bHgk/abUzSndBNgoann1rbK6wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kOuEtKxxiWTmZpW8MCtBWcc9AKwJ+fMXrX9hKw4qNj0=;
	b=tjN+hV7/gWi8oMv4kJLwolh6yGFU+RcmIAw/ub7Sw9FM45mOiEDSUA/jV28NJlEpCx3/
	 iLoSvi69vc+X7PahQ3+lN/c+XplxyL7IMMyFUM7jiFp9KRCilHr7QjQ5DEezHrz08JOHV
	 UZAqz4vfl+1YcQZ/Ta0pvipWA0bwa7Mgs0TECoVQRIaYv/+zxYGNBjgZJVf703YyeQqAb
	 SKlGyR7e1LlaOzdIS00zzRN27BNZKxUf2KBWJeWc3+QS4TrWVdFGOMBpiFeMWBL/igjAC
	 0nmgQtpll8enIKjEWgxuVOipz8G6Hwkky/u3NWgk+IBUbeJ/AdnhQjXVEJsLLb03VxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0o4NOkyO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3454606A320;
	Wed, 28 Oct 2026 19:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0o4NOkyO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0513B1F01825;
	Wed, 28 Oct 2026 19:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214824;
	bh=kOuEtKxxiWTmZpW8MCtBWcc9AKwJ+fMXrX9hKw4qNj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0o4NOkyOEv8sSHkLPDOCv2kDMmG7+hm3oEELJZ8fNZU4LvhIrnCviAjEQmvelcNQ4
	 jKL0kbs5kxlVDcEWB+fcIwSgRSKowSVZeh5X3FinDH1kXRYt+FI/dx3+JVS1DK9ycf
	 psCKF3hZYppC070uZU5d/O300qOldodQO0xWkReA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <kohei@enjuk.jp>,
	Simon Horman <horms@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0951/1887] iavf: fix out-of-bounds writes in iavf_get_ethtool_stats()
Date: Wed, 28 Oct 2026 17:50:47 +0100
Message-ID: <20261028170521.046938990@linuxfoundation.org>
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

From: Kohei Enju <kohei@enjuk.jp>

[ Upstream commit fecacfc95f195b99c71c579a472120d0b4ed65fa ]

iavf incorrectly uses real_num_tx_queues for ETH_SS_STATS. Since the
value could change in runtime, we should use num_tx_queues instead.

Moreover iavf_get_ethtool_stats() uses num_active_queues while
iavf_get_sset_count() and iavf_get_stat_strings() use
real_num_tx_queues, which triggers out-of-bounds writes when we do
"ethtool -L" and "ethtool -S" simultaneously [1].

For example when we change channels from 1 to 8, Thread 3 could be
scheduled before Thread 2, and out-of-bounds writes could be triggered
in Thread 3:

Thread 1 (ethtool -L)       Thread 2 (work)        Thread 3 (ethtool -S)
iavf_set_channels()
...
iavf_alloc_queues()
-> num_active_queues = 8
iavf_schedule_finish_config()
                                                   iavf_get_sset_count()
                                                   real_num_tx_queues: 1
                                                   -> buffer for 1 queue
                                                   iavf_get_ethtool_stats()
                                                   num_active_queues: 8
                                                   -> out-of-bounds!
                            iavf_finish_config()
                            -> real_num_tx_queues = 8

Use immutable num_tx_queues in all related functions to avoid the issue.

[1]
 BUG: KASAN: vmalloc-out-of-bounds in iavf_add_one_ethtool_stat+0x200/0x270
 Write of size 8 at addr ffffc900031c9080 by task ethtool/5800

 CPU: 1 UID: 0 PID: 5800 Comm: ethtool Not tainted 6.19.0-enjuk-08403-g8137e3db7f1c #241 PREEMPT(full)
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0x6f/0xb0
  print_report+0x170/0x4f3
  kasan_report+0xe1/0x180
  iavf_add_one_ethtool_stat+0x200/0x270
  iavf_get_ethtool_stats+0x14c/0x2e0
  __dev_ethtool+0x3d0c/0x5830
  dev_ethtool+0x12d/0x270
  dev_ioctl+0x53c/0xe30
  sock_do_ioctl+0x1a9/0x270
  sock_ioctl+0x3d4/0x5e0
  __x64_sys_ioctl+0x137/0x1c0
  do_syscall_64+0xf3/0x690
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
 RIP: 0033:0x7f7da0e6e36d
 ...
  </TASK>

 The buggy address belongs to a 1-page vmalloc region starting at 0xffffc900031c9000 allocated at __dev_ethtool+0x3cc9/0x5830
 The buggy address belongs to the physical page: page: refcount:1 mapcount:0 mapping:0000000000000000
 index:0xffff88813a013de0 pfn:0x13a013
 flags: 0x200000000000000(node=0|zone=2)
 raw: 0200000000000000 0000000000000000 dead000000000122 0000000000000000
 raw: ffff88813a013de0 0000000000000000 00000001ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffffc900031c8f80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
  ffffc900031c9000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 >ffffc900031c9080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
                    ^
  ffffc900031c9100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
  ffffc900031c9180: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8

Fixes: 64430f70ba6f ("iavf: Fix displaying queue statistics shown by ethtool")
Signed-off-by: Kohei Enju <kohei@enjuk.jp>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 31 +++++++++----------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index f4ac2b164b3e9..630d93e0512d8 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -333,14 +333,13 @@ static int iavf_get_sset_count(struct net_device *netdev, int sset)
 {
 	/* Report the maximum number queues, even if not every queue is
 	 * currently configured. Since allocation of queues is in pairs,
-	 * use netdev->real_num_tx_queues * 2. The real_num_tx_queues is set
-	 * at device creation and never changes.
+	 * use netdev->num_tx_queues * 2. The num_tx_queues is set at
+	 * device creation and never changes.
 	 */
 
 	if (sset == ETH_SS_STATS)
 		return IAVF_STATS_LEN +
-			(IAVF_QUEUE_STATS_LEN * 2 *
-			 netdev->real_num_tx_queues);
+		       (IAVF_QUEUE_STATS_LEN * 2 * netdev->num_tx_queues);
 	else if (sset == ETH_SS_PRIV_FLAGS)
 		return IAVF_PRIV_FLAGS_STR_LEN;
 	else
@@ -367,19 +366,19 @@ static void iavf_get_ethtool_stats(struct net_device *netdev,
 	iavf_add_ethtool_stats(&data, adapter, iavf_gstrings_stats);
 
 	rcu_read_lock();
-	/* As num_active_queues describe both tx and rx queues, we can use
-	 * it to iterate over rings' stats.
+	/* Use num_tx_queues to report stats for the maximum number of queues.
+	 * Queues beyond num_active_queues will report zero.
 	 */
-	for (i = 0; i < adapter->num_active_queues; i++) {
-		struct iavf_ring *ring;
+	for (i = 0; i < netdev->num_tx_queues; i++) {
+		struct iavf_ring *tx_ring = NULL, *rx_ring = NULL;
 
-		/* Tx rings stats */
-		ring = &adapter->tx_rings[i];
-		iavf_add_queue_stats(&data, ring);
+		if (i < adapter->num_active_queues) {
+			tx_ring = &adapter->tx_rings[i];
+			rx_ring = &adapter->rx_rings[i];
+		}
 
-		/* Rx rings stats */
-		ring = &adapter->rx_rings[i];
-		iavf_add_queue_stats(&data, ring);
+		iavf_add_queue_stats(&data, tx_ring);
+		iavf_add_queue_stats(&data, rx_ring);
 	}
 	rcu_read_unlock();
 }
@@ -416,9 +415,9 @@ static void iavf_get_stat_strings(struct net_device *netdev, u8 *data)
 	iavf_add_stat_strings(&data, iavf_gstrings_stats);
 
 	/* Queues are always allocated in pairs, so we just use
-	 * real_num_tx_queues for both Tx and Rx queues.
+	 * num_tx_queues for both Tx and Rx queues.
 	 */
-	for (i = 0; i < netdev->real_num_tx_queues; i++) {
+	for (i = 0; i < netdev->num_tx_queues; i++) {
 		iavf_add_stat_strings(&data, iavf_gstrings_queue_stats,
 				      "tx", i);
 		iavf_add_stat_strings(&data, iavf_gstrings_queue_stats,
-- 
2.53.0



