Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213495;
	b=sLOI7E/JWkp9pO7LtoFC21w9bjA5+Z3KP28lnvsLTuI2LHmW6SoXWnRH23wz6PKhADIH
	 nkrTRAwqY53uZ4ZDPvHy9JrQ974qLzNs23doDMAH0QAKHplVIl+RLkOLRYLvaQ2k7txtU
	 DeAE4Z46QoePybPYuTAqBukxo+J1Xt3TrwH9GG6D1we3/hNDceomvpirMWgJDYttlzu6W
	 +Sf+nOCpsBy349UqHe7VQBIztmWMm+TMlvd+hauoMA9qgtECv9oL+wVuUvioy/eAzL5Kw
	 jX+VML6rvWnq16L1VL766ZMHagOKbL42WxgQv/ZaB3ymjKgXMda9Jfcw8Op0s7+Weqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213495;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LkxWzR03/4qzgIUCNZA8GSksep4dsROmLu57kvaLTes=;
	b=BxoRhm64OUg7Bb8QILZGNjK53GjEUJttMUILGX3ZiH0aSEggNcaJjq1hkSQK9FF2owW2
	 Oeiq9Itg81cWwBrBIwO5sdeSgHekYvCg9xJyTJXKP69OSVIiow6l9oDCCFaj4qHVuHEID
	 QCfGGxJDIzYvHPY5lHWh1njrOy5OrdU7ZeuKeiGtS4wc0q+LWTyjJUBu7G8zbXuLRd2kZ
	 MmMm/+NyLiYBTRrxkUYTnhZQE8iJ2IfZO5YuJuP20IItaFKVuLMOD05yUbi9nz4I58/cU
	 SM+qFY4KbMFOw8arYwJLalsyIcYcJiuIuez1kZNxiqjTR9HpZETj7cC1nXoRdbjsrmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1FHg4Jz5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9174A606A335;
	Wed, 28 Oct 2026 18:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1FHg4Jz5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6A11F01825;
	Wed, 28 Oct 2026 18:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213495;
	bh=LkxWzR03/4qzgIUCNZA8GSksep4dsROmLu57kvaLTes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1FHg4Jz5R8brb3G4dlnOX9cBp1PFmZqOVPjMPpy01tGPOVSDRY0AxC5oQaqr6sexb
	 s3hqlNgq63+WD7iG031Z8sIz74FhqhDmYXIqhIwTc3er8j0j1tFv1KFSWdYB3Sejx1
	 e8csioTP5TgTZHC5WRN8IChh60k2cvwegrZJXWFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+2cf741c3005abc20@bugs.sh,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0524/1887] net: team: stop reusing skb after queue override
Date: Wed, 28 Oct 2026 17:43:40 +0100
Message-ID: <20261028170511.257589779@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit b7454f1940c5e6d92e753853c476a769e452f30a ]

A nonzero dev_queue_xmit() result does not return ownership of the skb.
When an override port's qdisc drops it, the queue override helper used to
try another port or the mode transmit op with the freed skb.

Return the handoff decision separately from transmit success. Select only
the first override port under RCU and stop after handing it the skb,
regardless of the lower transmit result. Keep the existing success and
drop accounting.

  BUG: KASAN: slab-use-after-free in sk_skb_reason_drop
  Write of size 4 by task poc/5040
  sk_skb_reason_drop (net/core/skbuff.c:1240)
  dev_kfree_skb_any_reason (net/core/dev.c:3470)
  ab_transmit (drivers/net/team/team_mode_activebackup.c:49)
  team_xmit (drivers/net/team/team_core.c:1849)
  __dev_direct_xmit (net/core/dev.c:4934)
  Freed by task 5040:
  __tcf_kfree_skb_list (net/sched/sch_generic.c:43)
  __dev_queue_xmit (net/core/dev.c:4831)
  team_xmit (drivers/net/team/team_core.c:1846)
  Kernel panic - not syncing: KASAN: panic_on_warn set ...

Cc: stable@vger.kernel.org
Fixes: 8ff5105a2b9d ("team: add support for queue override by setting queue_id for port")
Reported-by: <co+2cf741c3005abc20@bugs.sh>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20261001182326.572045-2-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 1812b8b2f73a6..874a8b78803c4 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -822,7 +822,8 @@ static struct list_head *__team_get_qom_list(struct team *team, u16 queue_id)
 /*
  * note: already called with rcu_read_lock
  */
-static bool team_queue_override_transmit(struct team *team, struct sk_buff *skb)
+static bool team_queue_override_transmit(struct team *team, struct sk_buff *skb,
+					 bool *tx_success)
 {
 	struct list_head *qom_list;
 	struct team_port *port;
@@ -830,11 +831,11 @@ static bool team_queue_override_transmit(struct team *team, struct sk_buff *skb)
 	if (!team->queue_override_enabled || !skb->queue_mapping)
 		return false;
 	qom_list = __team_get_qom_list(team, skb->queue_mapping);
-	list_for_each_entry_rcu(port, qom_list, qom_list) {
-		if (!team_dev_queue_xmit(team, port, skb))
-			return true;
-	}
-	return false;
+	port = list_first_or_null_rcu(qom_list, struct team_port, qom_list);
+	if (!port)
+		return false;
+	*tx_success = !team_dev_queue_xmit(team, port, skb);
+	return true;
 }
 
 static void __team_queue_override_port_del(struct team *team,
@@ -1759,8 +1760,7 @@ static netdev_tx_t team_xmit(struct sk_buff *skb, struct net_device *dev)
 	bool tx_success;
 	unsigned int len = skb->len;
 
-	tx_success = team_queue_override_transmit(team, skb);
-	if (!tx_success)
+	if (!team_queue_override_transmit(team, skb, &tx_success))
 		tx_success = READ_ONCE(team->ops.transmit)(team, skb);
 	if (tx_success) {
 		struct team_pcpu_stats *pcpu_stats;
-- 
2.53.0



