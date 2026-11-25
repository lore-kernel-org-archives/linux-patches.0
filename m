Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619515;
	b=OhuIBBOXoCPgGqMO9nrmz1H8TFGQp+E6AeT+aEexU3bfDkFXdzpYMHY+0qMBVjQilCu/
	 FcPjnHS2nsKn7an0kk1x4LioEAkQTIFNLXBUnsRY1Sk4KxaODYLVFSlPMruA7TfLtay1D
	 JX4KuX+hj47WR7HEMioImLMUTL2TAndyxtKVXflJvauXDsWLH1FwXsmtr0yB1tgQixsUP
	 QiwA9WMUER5COgwD4uBqI0fju9q1ZFk3rdQDvdlfZ3uYskt9jd3qKMma0PMuWwBsxv9bW
	 OzE8MuqVZL6zC9DWVKQSueNkGxktOmSWcMM8zbB6Q/DTqtvrTdh3bboBax20i0Oa7TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zp8EnKsGjYDMgazJzdPP8okha89zSfewh6dvqwjtyhg=;
	b=RaaD4gUUWFDvYDAhWeoTM5NDgy/iq2oCe5El9yufryhEr41MgH8x9aB9kO5Kez4TaGy4
	 jGdlHClRqTnhbam0vW5MG04gH4iUzLBJZnSLoje/civwE6RN7FnPzOABrZ+wJttWUx09F
	 N4SC+eO9X7n4DD+8lzxNv5hv4WzIHZRBuCM2ZXTP8mqXK8ohwIlLm3GHfoU1VLbeR5eyc
	 EZaXivOQ5dcFCBChx2n8giW4u9Y2G4z9NZZOg9xGPNei6N7puFtU+l814pUMsCGjLlgQQ
	 /xnv02ztwRTyTthMqJWifrCnyEos0Z6ekJRUeM0GWx17PjNSntBW7cR72FIswScvqGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lgogrfjp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6FB606A31E;
	Wed, 25 Nov 2026 15:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lgogrfjp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04E31F000C4;
	Wed, 25 Nov 2026 15:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619515;
	bh=zp8EnKsGjYDMgazJzdPP8okha89zSfewh6dvqwjtyhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lgogrfjp3d+dW27kJBYXMhLLHyB1JktMaoE6i7HyZx3yf7rbQ4treDiE/qqlI7xSF
	 np5NcV80fgv3zi2hYdBUv+fT0j+0AtOCZCxQFQ9aHX1hwb5IhA7Bqqref7SBq0fjPp
	 AkbwjYrvvXPSPaZooqKI56VI76pjBY7T6Gj7tii8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0621/1005] net/mlx5e: Fix queue stats access to queues without stats
Date: Wed, 25 Nov 2026 15:32:39 +0100
Message-ID: <20261125143836.294397482@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

commit 9a24799e219b1699bb1c144248c8c500b9504db5 upstream.

I am seeing the following mlx5e crash in the Meta fleet:

  pc : mlx5e_get_queue_stats_rx+0x4c/0xc8
  Call trace:
   mlx5e_get_queue_stats_rx+0x4c/0xc8 (P)
   netdev_stat_queue_sum+0x78/0x480
   netdev_nl_qstats_get_dump_one+0xf0/0x268
   netdev_nl_qstats_get_dumpit+0x7c/0x1f8

When dumping device-wide qstats, the core calls the per-queue callbacks
for every queue below real_num_{rx,tx}_queues, regardless of whether the
netdev is up. Some of those queues have no stats behind them:

 - RX stats live in priv->channel_stats[], which only has entries for
   channels that have been opened (stats_nch). real_num_rx_queues can
   be larger, for example after the channel count is raised while the
   netdev is down, or after opening the channels failed part way.

 - TX stats are looked up in priv->txq2sq_stats[], which is NULL for
   SQs that were never activated and for HTB queues while the channels
   are closed.

In both cases the callback dereferences a NULL pointer. The dump needs
no privileges, so any user can trigger it.

Return early for RX queues at or above stats_nch and for TX queues
without SQ stats.

Fixes: 7b66ae536a78 ("net/mlx5e: Add per queue netdev-genl stats")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261104-mlx5e-qstats-null-v1-1-a6a003245cec@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5490,7 +5490,7 @@ static void mlx5e_get_queue_stats_rx(str
 	struct mlx5e_rq_stats *xskrq_stats;
 	struct mlx5e_rq_stats *rq_stats;
 
-	if (mlx5e_is_uplink_rep(priv) || !mlx5e_stats_nch_read(priv))
+	if (mlx5e_is_uplink_rep(priv) || i >= mlx5e_stats_nch_read(priv))
 		return;
 
 	channel_stats = priv->channel_stats[i];
@@ -5522,6 +5522,9 @@ static void mlx5e_get_queue_stats_tx(str
 	 * inactive sqs.
 	 */
 	sq_stats = priv->txq2sq_stats[i];
+	if (!sq_stats)
+		return;
+
 	stats->packets = sq_stats->packets;
 	stats->bytes = sq_stats->bytes;
 


