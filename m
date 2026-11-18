Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053490;
	b=iiLw5O2+a1ZBeuFhTm7dDKiFOc2pj+OV5rFUTxTV/5A4C/NOZdoG3gNs09wRyqXC9mhs
	 3NOEb3+goPWAtGJzAp6OSreNQLdLLp4A9UvnnDf//HmLVViA6fJPTWM8EuVClxEWTvoWo
	 pd7dWNlUuUNMl3OHsyiZQO4U/T1kUebajuaRh2kGBlt7pq2Y53GDqDagtf9hwM2D4op3u
	 Y4h6FJDNQo25fbuCx3IMY/FzQSety/+SNro9+SGwFR+u+xMotOryRbRYAZn3cBlc0BeI2
	 /2a5NO1R6r+RX/46i4wNEUdNZxeM6SMmzTEBgDjd5bMW5c3+UN9LjN9kCWGHDSJUqXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GiE08BMy93iRzgxI2KON6WUM5wR2xGVLjuMOb0pwF8k=;
	b=09U9kyTC6woSOjSLKNk0U8yxNHnZoCQRAxXCZGVnGUNehmInRJRMFwDggjDZkFc6rRFm
	 R4IdHbH2W5w2rVtjREki3GzOM60VLYMRM2YOKs0U1/q0rjfYVS4ufu9xaNbR2AAe0+NI8
	 TBETVDMexCjZDDbzZz59b5Q/EyoE/uq2PeWckB9dxJ2uwRTJC2uOzdw8Yzc3VP/kBKS9h
	 MU8zWlrX1yRo7unE6cX2LmHqsrhDvWm2loY/RpQ0jRm2eoMQg1hvMcoIb+qzpmfj7T+P4
	 v8rYUyNLBfhBjTz/IhFUwQYXe4nA655z9wz66jwgju2oD0b3aii2zinkP9Y6uEx8/Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ektYhxLJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64ED0606A32F;
	Thu, 19 Nov 2026 01:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ektYhxLJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56881F000C4;
	Thu, 19 Nov 2026 01:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053490;
	bh=GiE08BMy93iRzgxI2KON6WUM5wR2xGVLjuMOb0pwF8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ektYhxLJCx2NpAcAvrbMtASPAfiL/gQVcirOVWcW0JHS27gNbNKFbEeA/xA+ucvl8
	 msSsBt0OVDBJA8xAY14Zs5jrs3clRL5hppWEhldYUL0jtU+8Mb171th1vN2hbKYyqy
	 qxyoEqK7carLASKoMy7c2P4DQQmtSah0d0TF+K+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0898/2214] can: proc: reset pkg_stats atomics individually
Date: Wed, 18 Nov 2026 15:42:54 +0100
Message-ID: <20261118150048.209255308@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 12297f855bbd943847cb8893a3614caef5a9c2a8 ]

Commit 80b5f90158d1 ("can: statistics: use atomic access in hot path")
converted several members of struct can_pkg_stats to atomic_long_t and
updated the hot TX/RX and procfs read paths to use atomic_long_*()
helpers. However, can_init_stats() still clears the whole struct with
memset().

can_init_stats() is reached from can_stat_update() in timer context and
also from the procfs reset path. Those paths can run while the TX/RX hot
paths are concurrently updating rx_frames, tx_frames, matches and their
*_delta counters. Hitting the whole-struct memset() in that window
performs plain writes to fields that otherwise follow an atomic_long_t
access contract, which can lose or mix live statistics updates.

This issue was found by source-level API-misuse analysis looking for
whole-object resets left behind after atomic_long_t conversions, then
manually audited on Linux v6.18.21.

Replace the whole-struct memset() with a helper that resets the
atomic_long_t counters via atomic_long_set() and clears the derived
scalar statistics explicitly. This preserves the existing reset
semantics for scalar fields while restoring atomic access discipline for
the live counters.

Build-tested by compiling net/can/proc.o on x86_64 netdev/main.
Runtime-tested with a QEMU + vcan setup on Linux v6.18.21 by driving
concurrent traffic and reset_stats reads, which reproduced inconsistent
exported statistics before the fix.

[Hartkopp] can_stat_update() also read the *_delta counters at the
beginning and cleared them with atomic_long_set() at the end. Increments
from the hot path in between were lost for both the current and the next
interval. Use atomic_long_xchg() to fetch and clear the *_delta counters
in one atomic step instead.

On x86_64 atomic_long_set() is a plain store like memset(), so the
memset() is an actual problem only on architectures with lock-based
atomics (e.g. parisc). The inconsistencies seen on x86_64 come from the
*_delta handling and from the stale snapshots, which are fixed in "can:
proc: skip stats calculation after reset in can_stat_update()". As
before, the counters are reset one at a time and the derived scalar
statistics use plain stores.

Fixes: 80b5f90158d1 ("can: statistics: use atomic access in hot path")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20261027-can-rx-lock-v12-5-eb5afc2d8b9b@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/proc.c | 39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/net/can/proc.c b/net/can/proc.c
index f81f8a698071e..26f43911c51f7 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -76,16 +76,39 @@ static const char rx_list_name[][8] = {
  * af_can statistics stuff
  */
 
+static void can_reset_pkg_stats(struct can_pkg_stats *pkg_stats)
+{
+	atomic_long_set(&pkg_stats->rx_frames, 0);
+	atomic_long_set(&pkg_stats->tx_frames, 0);
+	atomic_long_set(&pkg_stats->matches, 0);
+
+	pkg_stats->total_rx_rate = 0;
+	pkg_stats->total_tx_rate = 0;
+	pkg_stats->total_rx_match_ratio = 0;
+
+	pkg_stats->current_rx_rate = 0;
+	pkg_stats->current_tx_rate = 0;
+	pkg_stats->current_rx_match_ratio = 0;
+
+	pkg_stats->max_rx_rate = 0;
+	pkg_stats->max_tx_rate = 0;
+	pkg_stats->max_rx_match_ratio = 0;
+
+	atomic_long_set(&pkg_stats->rx_frames_delta, 0);
+	atomic_long_set(&pkg_stats->tx_frames_delta, 0);
+	atomic_long_set(&pkg_stats->matches_delta, 0);
+}
+
 static void can_init_stats(struct net *net)
 {
 	struct can_pkg_stats *pkg_stats = net->can.pkg_stats;
 	struct can_rcv_lists_stats *rcv_lists_stats = net->can.rcv_lists_stats;
 	/*
-	 * This memset function is called from a timer context (when
+	 * This stats reset is called from a timer context (when
 	 * can_stattimer is active which is the default) OR in a process
 	 * context (reading the proc_fs when can_stattimer is disabled).
 	 */
-	memset(pkg_stats, 0, sizeof(struct can_pkg_stats));
+	can_reset_pkg_stats(pkg_stats);
 	pkg_stats->jiffies_init = jiffies;
 
 	rcv_lists_stats->stats_reset++;
@@ -121,9 +144,10 @@ void can_stat_update(struct timer_list *t)
 	long rx_frames = atomic_long_read(&pkg_stats->rx_frames);
 	long tx_frames = atomic_long_read(&pkg_stats->tx_frames);
 	long matches = atomic_long_read(&pkg_stats->matches);
-	long rx_frames_delta = atomic_long_read(&pkg_stats->rx_frames_delta);
-	long tx_frames_delta = atomic_long_read(&pkg_stats->tx_frames_delta);
-	long matches_delta = atomic_long_read(&pkg_stats->matches_delta);
+	/* fetch and clear values for 'current rate' calculation */
+	long rx_frames_delta = atomic_long_xchg(&pkg_stats->rx_frames_delta, 0);
+	long tx_frames_delta = atomic_long_xchg(&pkg_stats->tx_frames_delta, 0);
+	long matches_delta = atomic_long_xchg(&pkg_stats->matches_delta, 0);
 
 	/* restart counting in timer context on user request */
 	if (user_reset)
@@ -172,11 +196,6 @@ void can_stat_update(struct timer_list *t)
 	if (pkg_stats->max_rx_match_ratio < pkg_stats->current_rx_match_ratio)
 		pkg_stats->max_rx_match_ratio = pkg_stats->current_rx_match_ratio;
 
-	/* clear values for 'current rate' calculation */
-	atomic_long_set(&pkg_stats->tx_frames_delta, 0);
-	atomic_long_set(&pkg_stats->rx_frames_delta, 0);
-	atomic_long_set(&pkg_stats->matches_delta, 0);
-
 	/* restart timer (one second) */
 	mod_timer(&net->can.stattimer, round_jiffies(jiffies + HZ));
 }
-- 
2.53.0



