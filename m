Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019277;
	b=eQogOCpt2KqwE3P6tApl8JQg0uYiGMyNj5AVb9lviMBAxQ/EIfUvd/YFbwLcksNZ+Nue
	 inJLyBeUBJLdUMlF/jDucRqtOR1KDPWAgk9FZ+NPo9UFZF2TekppEAPKaDHfXt7rScZWB
	 IVAO3ovKDSnhRhKCze1suJoropDs/PfTQ9vzVaIela/y74Fky8R7CTbyy4OowzIqQk1IE
	 1yxpN9aULMjGb79DSpBNI9o9WPZMb32GGtO602mFiz4WP0qnwfEDBli/4eXHoznSsj2ki
	 +1BjZvuwn3kySOaSErAfTl2o+FEFWMN9awIJvbSZVsjJdHODzwpgDHNHce+Y8RmUt2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JXnQ74/E5ZlHhd2QFtYJ5UIZGG8pkmcpq24O772p1wY=;
	b=Kytr2nDnp6Uz97tFcTAnXMeBZY5WfO1VXvmKs+6AampB4z2/rcyZ3gqQgJ7o7LTwI9NC
	 OhUodO689UFGCk4ENGghjNHCFWAL2fKlGjcFgxnO13am5KHIxvDoKBsYno4wucVP6TgH7
	 Jdw7MnTDLMHahmhOZoKg7xCCjnin6LYFyyxSpVLcncoUjUnRzo6Tl0g0Of55/Chs0twF8
	 aOzsnquC1ZRgE/bv9uLh2ZuMO2jQKUq8AFma2UcOEOdwRtMvtiA9zPjNlZ3UkusCYyxDP
	 KPc0U+UAa7s8IA6I8yycbMlZkyQYaI5KTghMef9nKvv6g1SNYcBGa3zDrb77QtvnHqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IY5Q1xk6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E842A60A2600;
	Wed, 18 Nov 2026 16:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IY5Q1xk6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138911F000C4;
	Wed, 18 Nov 2026 16:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019276;
	bh=JXnQ74/E5ZlHhd2QFtYJ5UIZGG8pkmcpq24O772p1wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IY5Q1xk6btkZSCdy+Qqhgp0hlDfFkHBJ/nsOnoh98PZYfuN/9UnJhPz0nPrk+Viz/
	 83NQi7KRgd61E+kHFZa25p1ec8X222T+Rv+f5HO5XUNRyInUSbp0vOfnUY8BWZgmb6
	 0nFhyWtkumTKkTYf26RCppis627XtKhZa08oAPQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Vineeth Karumanchi <vineeth.karumanchi@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1539/2651] net: macb: configure ENST registers for all queues
Date: Wed, 18 Nov 2026 15:46:19 +0100
Message-ID: <20261118150343.375298023@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb.h      |  2 --
 drivers/net/ethernet/cadence/macb_main.c | 20 +++++++++-----------
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index d6931c41f39da..c23fd40829870 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1493,7 +1493,6 @@ struct macb_platform_data {
  * @start_time_mask:  Bitmask representing the start time for the queue
  * @on_time_bytes:    "on" time nsec expressed in bytes
  * @off_time_bytes:   "off" time nsec expressed in bytes
- * @queue_id:         Identifier for the queue
  *
  * This structure holds the configuration parameters for an ENST queue,
  * used to control time-based transmission scheduling in the MACB driver.
@@ -1502,7 +1501,6 @@ struct macb_queue_enst_config {
 	u32 start_time_mask;
 	u32 on_time_bytes;
 	u32 off_time_bytes;
-	u8 queue_id;
 };
 
 #endif /* _MACB_H */
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 261a7e87520a4..ab9f6f25cd6a6 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4336,7 +4336,7 @@ static int macb_taprio_setup_replace(struct net_device *netdev,
 	struct macb_queue *queue;
 	u32 queue_mask;
 	u8 queue_id;
-	size_t i;
+	size_t i, q;
 	int err;
 
 	if (conf->num_entries > bp->num_queues) {
@@ -4364,7 +4364,7 @@ static int macb_taprio_setup_replace(struct net_device *netdev,
 		return -EINVAL;
 	}
 
-	enst_queue = kzalloc_objs(*enst_queue, conf->num_entries);
+	enst_queue = kzalloc_objs(*enst_queue, bp->num_queues);
 	if (unlikely(!enst_queue))
 		return -ENOMEM;
 
@@ -4423,13 +4423,12 @@ static int macb_taprio_setup_replace(struct net_device *netdev,
 			goto cleanup;
 		}
 
-		enst_queue[i].queue_id = queue_id;
-		enst_queue[i].start_time_mask =
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
@@ -4455,15 +4454,14 @@ static int macb_taprio_setup_replace(struct net_device *netdev,
 		gem_writel(bp, ENST_CONTROL,
 			   queue_mask << GEM_ENST_DISABLE_QUEUE_OFFSET);
 
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



