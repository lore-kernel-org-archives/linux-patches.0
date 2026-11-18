Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059115;
	b=hc/a+e0w8wtYD2RyLvA1qgUszsMwLS5YhfVwKoWzWJM22PgjjUUdpm4t7pQNNz1wxo8t
	 voqWZNtiPQvaEOPA1SQmO7siS8YyzQumtspQ8GxuvtYt1ayK3OvUX5oKkh53ODEgcZxWD
	 R5xRcW/cX5/bCYQqqkzpgwGO5RLRq2RzW7Q66bWoUnSDgjfo+zbPMUicAKPowmC6zv6SF
	 QwC/2dv1a83xU5SgRbz4PiQfofyEb7O6j0AZRnKtleffu/vtGUVD4Izm7rGLiWZ1ICqYL
	 pr8Le3C7qf2Iei/iDhEm79uOHtq3qZE0NAJchpWKuwDPH15dksWrfO6/SrePV5YJW3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qG6hpjrfgaTMT5smtYaObQ9Xx6XK2rOAnbjVfAclQKo=;
	b=jj8Q0O7drql6467q7VFcuEXeQMT9/tPKIHBu6I0Xq3pBomNzNOYRS3vh3s9YPu394R+e
	 ZdKfsqyOn0miOXs/BdudddE14aQLutSgpNn7MW8ugsE946hIbzx5JbK/fFtSBqhGMdl+3
	 gF2BK1/la2YOlLKE3ir9TdvGRwg5zoduckv3bhtkdkS+7ep6hOVfLoGsIrEpqk7HZJorA
	 Co4mw6dK3A+mOHwYW1P0VCSzSiwmrD6rA4p+PhdeSzSNqJEdUCB8nc8B53Sd/VWex4I9X
	 WmDgtuLMt4cclc7D4aZfmXgSwnxFImrTogsB/CAHoWN4aGg0/0pXpgdb8yI8VhTq1iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="h/nyhHEt";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD3760A2602;
	Thu, 19 Nov 2026 03:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h/nyhHEt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A830F1F000C4;
	Thu, 19 Nov 2026 03:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059115;
	bh=qG6hpjrfgaTMT5smtYaObQ9Xx6XK2rOAnbjVfAclQKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h/nyhHEtLSIwyDHHABroSw2+tEsfBJmwN5YpMOmZwRlWfAicvTWp/BepAQ0zPKnXu
	 +fgJUdLALPYKGHdDqT3Nhp+osDRKGzzJ62ddcwLkuVMX9G2AlCr3wLoHJNA9LKWmzT
	 g8JEuzSIllB3QtgBmON3IddSeHlEPxidCFGAbf00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0727/1848] can: proc: skip stats calculation after reset in can_stat_update()
Date: Wed, 18 Nov 2026 15:46:05 +0100
Message-ID: <20261118145946.470953909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d21f4eab1cba9..396a637054da4 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -153,25 +153,18 @@ void can_stat_update(struct timer_list *t)
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
@@ -200,6 +193,7 @@ void can_stat_update(struct timer_list *t)
 	if (pkg_stats->max_rx_match_ratio < pkg_stats->current_rx_match_ratio)
 		pkg_stats->max_rx_match_ratio = pkg_stats->current_rx_match_ratio;
 
+out:
 	/* restart timer (one second) */
 	mod_timer(&net->can.stattimer, round_jiffies(jiffies + HZ));
 }
-- 
2.53.0



