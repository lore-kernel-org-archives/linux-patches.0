Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213493;
	b=1DBvIs1g/5luHZvkXI7yb5Z13IFIt1Pcp2q8KpQexRcZU4qRl4hEUMFkcC/nOo0V5krE
	 4/hxQjNlF6XEmu1SrxE1Lb6+lmRHFQkuDvsqk39xUFEL+ytgds2Iajyv+rFV6dPaPXrnD
	 mHLnBT4htxdLN87Q49moSI7wr2B5JOshSAevBM0Jo7HGrQX2SzfLxrd9ZywOZIPnpEynf
	 8ZNDfvYlGZEYQZ8KH2ujbJaC2NeYdsG+BgB97M5cEH6fqxYfCm/9dSnQgQLoFBQvY5VLu
	 3VUdzqitWgxhEF2z18+yEwEwei/5DgaR6UC7/cQED6AbeqyWu5m12nyost00MEqAlRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6DgCtPWS6L8FvW0ZPjalRBe8i76J4QaM8UmYsoJqOI0=;
	b=XjyP6Jlu/JktEueBOG7kIW9216+PYLUr584OlXXajpEjE1GsEjEFaIFbDfHx9grip5Ra
	 xDpdKdOqm/TJnnZiMwxzf6bwtvCNa3xVkrNqGIf9rohG329rNBNNp/tqEaGnInEz3584K
	 9yCOYJDUc33grEpZz3V/cOg6e667RWt6j6cNOOUnrP5vJbap6sY7dKqd6Z9EQsjgDthRT
	 tbWju4e5AVPKpUJKRchkgq4nbgy6o3dhZjfwDj51EMaVDh6ev/wK+sD5g3BeXgyXh/ZV2
	 q5olGS+1iGcJ4UKB7vGkc22nzT3hpLnk/foYvDigg9mAIKqb0wBAjMdW2IZ4Uid+BxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Bm1IbD/C";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DE9606A31C;
	Wed, 28 Oct 2026 18:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bm1IbD/C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F3B1F01825;
	Wed, 28 Oct 2026 18:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213492;
	bh=6DgCtPWS6L8FvW0ZPjalRBe8i76J4QaM8UmYsoJqOI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bm1IbD/CvIyY71FlmcOD1UecnfZAYAk0fWlXomsidN8FMFSjttzeIyyFUXbCAVNP7
	 rfROKKC2BFqIT2PUurOggFv0YsgMy9efRwK0p7XAi+PPVl6WbJ12SbRDHDhb75l4md
	 Zkzac/9Jr8OBdrfEvzNhCDtZ6or9wxxGef7h21g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0523/1887] net: team: fix NULL pointer dereference in team_xmit during mode change
Date: Wed, 28 Oct 2026 17:43:39 +0100
Message-ID: <20261028170511.233668257@linuxfoundation.org>
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

[ Upstream commit 25fe708bbc59289d3d1ea4b126fbc1b460a072a5 ]

__team_change_mode() clears team->ops with memset() before restoring
safe dummy handlers via team_adjust_ops(). A concurrent team_xmit()
running under RCU on another CPU can read team->ops.transmit during
this window and call a NULL function pointer, crashing the kernel.

The race requires a mode change (CAP_NET_ADMIN) concurrent with
transmit on the team device.

 BUG: kernel NULL pointer dereference, address: 0000000000000000
 Oops: 0010 [#1] SMP KASAN NOPTI
 RIP: 0010:0x0
 Call Trace:
  team_xmit (drivers/net/team/team_core.c:1853)
  dev_hard_start_xmit (net/core/dev.c:3904)
  __dev_queue_xmit (net/core/dev.c:4871)
  packet_sendmsg (net/packet/af_packet.c:3109)
  __sys_sendto (net/socket.c:2265)

The original code assumed that no ports means no traffic, so mode
changes could freely memset()/memcpy() the ops.  AF_PACKET with
forced carrier breaks that assumption.

Prevent the race instead of making it safe: replace memset()/memcpy()
with per-field updates that never touch transmit or receive.  Those
two handlers are managed solely by team_adjust_ops(), which already
installs dummies when tx_en_port_count == 0 (always true during mode
change since no ports are present).  WRITE_ONCE/READ_ONCE prevent
store/load tearing on the handler pointers.

synchronize_net() before exit_op() drains in-flight readers that may
still reference old mode state from before port removal switched the
handlers to dummies.

Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20260521081159.1491563-3-bestswngs@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: b7454f1940c5 ("net: team: stop reusing skb after queue override")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team.c | 45 +++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index b552c79411254..1812b8b2f73a6 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -535,21 +535,23 @@ static void team_adjust_ops(struct team *team)
 
 	if (!team->en_port_count || !team_is_mode_set(team) ||
 	    !team->mode->ops->transmit)
-		team->ops.transmit = team_dummy_transmit;
+		WRITE_ONCE(team->ops.transmit, team_dummy_transmit);
 	else
-		team->ops.transmit = team->mode->ops->transmit;
+		WRITE_ONCE(team->ops.transmit, team->mode->ops->transmit);
 
 	if (!team->en_port_count || !team_is_mode_set(team) ||
 	    !team->mode->ops->receive)
-		team->ops.receive = team_dummy_receive;
+		WRITE_ONCE(team->ops.receive, team_dummy_receive);
 	else
-		team->ops.receive = team->mode->ops->receive;
+		WRITE_ONCE(team->ops.receive, team->mode->ops->receive);
 }
 
 /*
- * We can benefit from the fact that it's ensured no port is present
- * at the time of mode change. Therefore no packets are in fly so there's no
- * need to set mode operations in any special way.
+ * team_change_mode() ensures no ports are present during mode change,
+ * but lockless readers can still reach team_xmit().  Avoid touching
+ * transmit/receive -- they are already set to dummies by
+ * team_adjust_ops() since no ports are enabled.  synchronize_net()
+ * drains in-flight readers before destroying old mode state.
  */
 static int __team_change_mode(struct team *team,
 			      const struct team_mode *new_mode)
@@ -558,9 +560,21 @@ static int __team_change_mode(struct team *team,
 	if (team_is_mode_set(team)) {
 		void (*exit_op)(struct team *team) = team->ops.exit;
 
-		/* Clear ops area so no callback is called any longer */
-		memset(&team->ops, 0, sizeof(struct team_mode_ops));
-		team_adjust_ops(team);
+		/* Clear cold-path ops used only under RTNL.  transmit and
+		 * receive are already dummies (no ports) so leave them
+		 * alone -- overwriting them is the source of the race.
+		 */
+		team->ops.init = NULL;
+		team->ops.exit = NULL;
+		team->ops.port_enter = NULL;
+		team->ops.port_leave = NULL;
+		team->ops.port_change_dev_addr = NULL;
+		team->ops.port_tx_disabled = NULL;
+
+		/* Wait for in-flight readers before tearing down mode
+		 * state they may reference.
+		 */
+		synchronize_net();
 
 		if (exit_op)
 			exit_op(team);
@@ -583,7 +597,12 @@ static int __team_change_mode(struct team *team,
 	}
 
 	team->mode = new_mode;
-	memcpy(&team->ops, new_mode->ops, sizeof(struct team_mode_ops));
+	team->ops.init = new_mode->ops->init;
+	team->ops.exit = new_mode->ops->exit;
+	team->ops.port_enter = new_mode->ops->port_enter;
+	team->ops.port_leave = new_mode->ops->port_leave;
+	team->ops.port_change_dev_addr = new_mode->ops->port_change_dev_addr;
+	team->ops.port_tx_disabled = new_mode->ops->port_tx_disabled;
 	team_adjust_ops(team);
 
 	return 0;
@@ -744,7 +763,7 @@ static rx_handler_result_t team_handle_frame(struct sk_buff **pskb)
 		/* allow exact match delivery for disabled ports */
 		res = RX_HANDLER_EXACT;
 	} else {
-		res = team->ops.receive(team, port, skb);
+		res = READ_ONCE(team->ops.receive)(team, port, skb);
 	}
 	if (res == RX_HANDLER_ANOTHER) {
 		struct team_pcpu_stats *pcpu_stats;
@@ -1742,7 +1761,7 @@ static netdev_tx_t team_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	tx_success = team_queue_override_transmit(team, skb);
 	if (!tx_success)
-		tx_success = team->ops.transmit(team, skb);
+		tx_success = READ_ONCE(team->ops.transmit)(team, skb);
 	if (tx_success) {
 		struct team_pcpu_stats *pcpu_stats;
 
-- 
2.53.0



