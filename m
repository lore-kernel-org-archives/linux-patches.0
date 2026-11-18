Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053493;
	b=E3dClWTOLSlfMuhhYbJbg6D2UXoQHDH3c/1mrm0Pu7VQf/K2EiITaQEzBSt5QvI40fPK
	 IqG8+a9phiqVY9BkLjGb+TN7Kt03cQGP63ALjU8na2jx4LUN3/XIx+dumFFDCpAxi8UEv
	 ZkT/2M3Dh3w04LqIjzW/CZUqAPJCsncHp2p1aWdA1eM0/1QvkUKEm2zHxfjZwCu4kRKzS
	 7PE8O2eJXMKgItlpehVhG2h64SwN5tOnunONrRDIZI7qrODMeeuzbyJrBEho66hF4rpCD
	 TJkCgFoU4tviXkfmLaqcGrRIoZEPOlfRnGntGSPb7P3E962hWjVfZsR1OlIV/nzsITQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NYpvFokxpF2D+TACBzvuXEyoh/e3TPEADMBqERUlJgY=;
	b=XbGXbSKbrSsKcDNWWg+L2Z2Bk/B9MjKEJGS55Oi7iuuYoP9oE5nT7nNdMCQvNyqtMVGi
	 7e+XuS57Mj2fKSQA+a7w2VOM70qAbMdi6Y9s8n/WAwIwvZv1x5wxbM+z8Sxs6LUqD8/QI
	 aQ/MsslOfzzZlgTvk5x+wu/48jzGjZ81YpwnbK6sAftTP2HFx8gLvfvOQHnBWmAqFEyhV
	 afGxWG3reth9w99x6E7lxfuCVSTlzhMyLSNqtbvylHxQYl411TdjVpxWWRkI3JbfBMjSe
	 qt2hBFFvdimKmLJP/5AqNx9/lqkl+6EpK9uAyWPfVXnw2GR7jrdUJQiymBL2nsZdBog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ri7iwKJr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2AF606A31C;
	Thu, 19 Nov 2026 01:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ri7iwKJr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824B01F000C4;
	Thu, 19 Nov 2026 01:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053493;
	bh=NYpvFokxpF2D+TACBzvuXEyoh/e3TPEADMBqERUlJgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ri7iwKJrp6D+55P80Mq5NdPQiziXv3HI9we5R5Zk99ROZmhspgPCPLlSqyRLCtd2r
	 Kh5JDI1Mi82M9DvRkwcertGM6p8GET74p4fkb1u/+gI/uW863/R9Y8/+y+C525bTFt
	 bW2Ri9iAIz50MPD+N4UDi+JNPZvmYuGa6e82mjfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0899/2214] can: proc: skip stats calculation after reset in can_stat_update()
Date: Wed, 18 Nov 2026 15:42:55 +0100
Message-ID: <20261118150048.250067011@linuxfoundation.org>
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

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit 01b19ed9fa031a649f3dd103ebe6e0102602e542 ]

Commit 80b5f90158d1 ("can: statistics: use atomic access in hot path")
introduced local snapshots of the statistics counters at the beginning
of can_stat_update(). When can_init_stats() resets the statistics, these
stale pre-reset snapshots are still used for the following total/current
/max calculations and overwrite the freshly reset values. Additionally a
jiffies tick between the snapshot and the reset could trigger a second
can_init_stats() call.

Merge the reset conditions into a single check and skip the calculation
for the current interval when the statistics have been reset.

Fixes: 80b5f90158d1 ("can: statistics: use atomic access in hot path")
Cc: stable@vger.kernel.org
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20261027-can-rx-lock-v12-6-eb5afc2d8b9b@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/proc.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/net/can/proc.c b/net/can/proc.c
index 26f43911c51f7..34e567a3fa191 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -149,25 +149,18 @@ void can_stat_update(struct timer_list *t)
 	long tx_frames_delta = atomic_long_xchg(&pkg_stats->tx_frames_delta, 0);
 	long matches_delta = atomic_long_xchg(&pkg_stats->matches_delta, 0);
 
-	/* restart counting in timer context on user request */
-	if (user_reset)
-		can_init_stats(net);
-
-	/* restart counting on jiffies overflow */
-	if (j < pkg_stats->jiffies_init)
-		can_init_stats(net);
-
-	/* prevent overflow in calc_rate() */
-	if (rx_frames > (LONG_MAX / HZ))
-		can_init_stats(net);
-
-	/* prevent overflow in calc_rate() */
-	if (tx_frames > (LONG_MAX / HZ))
-		can_init_stats(net);
-
-	/* matches overflow - very improbable */
-	if (matches > (LONG_MAX / 100))
+	/*
+	 * Restart counting in timer context on user request, on jiffies
+	 * overflow or to prevent overflows in calc_rate() and in the
+	 * match ratio calculation. The local snapshots are stale after
+	 * the reset, so skip the calculation for this interval.
+	 */
+	if (user_reset || j < pkg_stats->jiffies_init ||
+	    rx_frames > (LONG_MAX / HZ) || tx_frames > (LONG_MAX / HZ) ||
+	    matches > (LONG_MAX / 100)) {
 		can_init_stats(net);
+		goto out;
+	}
 
 	/* calc total values */
 	if (rx_frames)
@@ -196,6 +189,7 @@ void can_stat_update(struct timer_list *t)
 	if (pkg_stats->max_rx_match_ratio < pkg_stats->current_rx_match_ratio)
 		pkg_stats->max_rx_match_ratio = pkg_stats->current_rx_match_ratio;
 
+out:
 	/* restart timer (one second) */
 	mod_timer(&net->can.stattimer, round_jiffies(jiffies + HZ));
 }
-- 
2.53.0



