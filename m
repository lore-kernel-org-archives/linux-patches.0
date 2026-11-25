Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622568;
	b=2NUf1zrmxOnuyRgBqG+fc818rXvOB/PUlpIf1uptFvY7mTqI+KB2VrZe4SyDoV0qA6kI
	 b2QQGb0AxfFcwv4Pn2/8m9gvAoYBmoc+rA0GhE1sZLYVf8l3Dm7uMGxlYxn1BNN7CSXyM
	 iinNgP/Ql9G0sQp61urmbWQnkXqlZUKdh4jlQHa3jCGTYEYkvYoeJKd9dGO6U/SOAJXkV
	 UxfCU55Z0l1tIxV1J2szXaLilT4tsdOX+mBitlWtubEiMgbky7ohL9NwXuOjEWQ3+2P4u
	 rdh/ghQC8S4kNCk3ELP/vLHBLZP4o3p8HwoOpKLuYJNGHf3fnWi09M6rzI4sFpAMiig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Xyc4QST2RP8mOXGSVyO8OUvdRyYD43mfI6ogt8JB5ho=;
	b=l/h3vRTxftTuZuMXSkUvy+441xha9gi31wMZYfIZNzXTMSjx6hGRkazHs8u/u5upqTfc
	 LC/GyVrlmTChh8gvwiGS+mrvDLwzjv/aGDyhRhb17OUa2D2c3paUydKhZpdenhojPS5fr
	 1LpZFdZhbYZ80K4kiAGhIhetQIpvj9cfPQ/yeWIMP0ICYXlMIDiYon1XT9uYq+pc0An/F
	 SsweL/p8/IAvYVN0c/ExDHgPwRopFY2mMlpYKVcv5zCOSqDt1LSw5E8egk7hZ1QZJ9vGZ
	 XRxXELucvKSBYShYJKpJmsSj9fWctvnXnC08Ju48hG3EsX/P75zcnmdS9nweZRNBgEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nSqeTjtC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12909606A32A;
	Wed, 25 Nov 2026 16:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nSqeTjtC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602C81F000C4;
	Wed, 25 Nov 2026 16:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622567;
	bh=Xyc4QST2RP8mOXGSVyO8OUvdRyYD43mfI6ogt8JB5ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nSqeTjtCjDxBGpEwRMbDwiqbRL6kPNI2Wux4JPusk6cWlUNN8wC53YvnoS0m3uPgN
	 SMcyVyIsNP4pwlxXX6wpv/AqqtHpjY7R82w4CRIbnFlJdEh9BWw9Sats3HS87rRJRi
	 /beYEuAqdVRrYhxNJSH90PGGY37KUfl8luCizLlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Vineeth Karumanchi <vineeth.karumanchi@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 578/990] net: macb: configure ENST registers for all queues
Date: Wed, 25 Nov 2026 15:32:25 +0100
Message-ID: <20261125143835.631021364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineeth Karumanchi <vineeth.karumanchi@amd.com>

[ Upstream commit 04a943067baa670fef3c1424ea616a2ed87d3d19 ]

When a taprio config only covered a subset of queues, the driver
programmed the ENST registers only for the queues named in the config
and left the remaining queues holding stale register values. This
produced an inconsistent hardware setup that affected the scheduling
of the configured queues.

This was observed on a GEM instance with four hardware queues, all
enabled:

Initial configuration:
- All four queues are enabled.
- enst_on_time_qX registers are left at their reset value (0x0001FFFF).
- Only q0 and q1 are configured with valid, non-overlapping ENST
  schedules (T0 and T1 respectively).
- Traffic streams p0 and p1 are bound to q0 and q1.
- ENST is enabled only on q0 and q1.

Observed behavior:
- During T0 on-time, both p0 and p1 packets are transmitted.
- During T1 on-time, both p0 and p1 packets are transmitted.

With the unused queues (q2 and q3) explicitly programmed with
enst_on_time = 0x0:
- During T0 on-time, only p0 packets are transmitted.
- During T1 on-time, only p1 packets are transmitted.

Leaving the ENST on-time registers of unused queues at their reset
value (0x0001FFFF) disrupts the scheduling of the configured queues,
whereas programming them with 0x0 yields the expected ENST operation.

Program the ENST registers for every queue unconditionally. The
per-queue configuration array is now allocated for bp->num_queues and
indexed directly by queue_id; unconfigured queues are left
zero-initialized by kzalloc_objs(), so their registers are cleared.
Indexing the array by queue_id also makes the queue_id field in
struct macb_queue_enst_config redundant, so drop it.

Fixes: 89934dbf169e ("net: macb: Add TAPRIO traffic scheduling support")
Reviewed-by: Théo Lebrun <theo.lebrun@bootlin.com>
Signed-off-by: Vineeth Karumanchi <vineeth.karumanchi@amd.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20261005110855.1669249-1-vineeth.karumanchi@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Queue index is computed with hweight32(bp->queue_mask & (gate_mask - 1)) instead of upstream's order_base_2(gate_mask), since sparse queue masks are possible here, and kcalloc replaces kzalloc_objs. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb.h      |  2 --
 drivers/net/ethernet/cadence/macb_main.c | 23 ++++++++++++-----------
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index a6602aae3f9d3..008d7dc670099 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1458,7 +1458,6 @@ struct macb_platform_data {
  * @start_time_mask:  Bitmask representing the start time for the queue
  * @on_time_bytes:    "on" time nsec expressed in bytes
  * @off_time_bytes:   "off" time nsec expressed in bytes
- * @queue_id:         Identifier for the queue
  *
  * This structure holds the configuration parameters for an ENST queue,
  * used to control time-based transmission scheduling in the MACB driver.
@@ -1467,7 +1466,6 @@ struct macb_queue_enst_config {
 	u32 start_time_mask;
 	u32 on_time_bytes;
 	u32 off_time_bytes;
-	u8 queue_id;
 };
 
 #endif /* _MACB_H */
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 1eaf9be483153..112b1785e817e 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4232,7 +4232,8 @@ static int macb_taprio_setup_replace(struct net_device *ndev,
 	struct macb *bp = netdev_priv(ndev);
 	struct ethtool_link_ksettings kset;
 	struct macb_queue *queue;
-	size_t i;
+	size_t i, q;
+	u8 queue_id;
 	int err;
 
 	if (conf->num_entries > bp->num_queues) {
@@ -4260,7 +4261,7 @@ static int macb_taprio_setup_replace(struct net_device *ndev,
 		return -EINVAL;
 	}
 
-	enst_queue = kcalloc(conf->num_entries, sizeof(*enst_queue), GFP_KERNEL);
+	enst_queue = kcalloc(bp->num_queues, sizeof(*enst_queue), GFP_KERNEL);
 	if (unlikely(!enst_queue))
 		return -ENOMEM;
 
@@ -4318,13 +4319,14 @@ static int macb_taprio_setup_replace(struct net_device *ndev,
 			goto cleanup;
 		}
 
-		enst_queue[i].queue_id = order_base_2(entry->gate_mask);
-		enst_queue[i].start_time_mask =
+		/* Map the hardware queue to its index in bp->queues (the mask may be sparse) */
+		queue_id = hweight32(bp->queue_mask & (entry->gate_mask - 1));
+		enst_queue[queue_id].start_time_mask =
 			(start_time_sec << GEM_START_TIME_SEC_OFFSET) |
 			start_time_nsec;
-		enst_queue[i].on_time_bytes =
+		enst_queue[queue_id].on_time_bytes =
 			enst_ns_to_hw_units(entry->interval, speed);
-		enst_queue[i].off_time_bytes =
+		enst_queue[queue_id].off_time_bytes =
 			enst_ns_to_hw_units(conf->cycle_time - entry->interval, speed);
 
 		configured_queues |= entry->gate_mask;
@@ -4349,15 +4351,14 @@ static int macb_taprio_setup_replace(struct net_device *ndev,
 		gem_writel(bp, ENST_CONTROL,
 			   bp->queue_mask << GEM_ENST_DISABLE_QUEUE_OFFSET);
 
-		for (i = 0; i < conf->num_entries; i++) {
-			queue = &bp->queues[enst_queue[i].queue_id];
+		for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
 			/* Configure queue timing registers */
 			queue_writel(queue, ENST_START_TIME,
-				     enst_queue[i].start_time_mask);
+				     enst_queue[q].start_time_mask);
 			queue_writel(queue, ENST_ON_TIME,
-				     enst_queue[i].on_time_bytes);
+				     enst_queue[q].on_time_bytes);
 			queue_writel(queue, ENST_OFF_TIME,
-				     enst_queue[i].off_time_bytes);
+				     enst_queue[q].off_time_bytes);
 		}
 
 		/* Enable ENST for all configured queues in one write */
-- 
2.53.0



