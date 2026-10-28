Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213490;
	b=r97SNMateKIDoDce7noOZKzCLlM4CY1rsHkiR6D6fmCuJs5yANoIPkgq5D//dRCEp0zE
	 BbreErI83FmeNoLQ15AfB8XP176BFlzNqZ7H2152rJ2gZkNSb+5NzfA32NsaxP9b1R7St
	 N1SDTs39ZDZpRWitzeJONS39e1+5Hf5c0M2EP2fejlw0Le4VKJThZY0HplVCtxk0Ajner
	 EB+e2VjirGYk26NRFFL6r+oamD8/cC+QUYp8ynePmCGh4BCwg8HDc71JxyxxHhjNS3O7f
	 oL37jZTtBYUEk5Pvko7KrPmc4Q351lqulcna9MyA4hmI5mHiiRR1bHAk34+7LXMdDBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YmGmWsj6A5L19Z0P1gjKkzjkWSNkJfclJrxdLPQ/cI4=;
	b=PqGa9t+ptj+50HG8vjTo2Q2UPfWH5Vho1rx+oLZ7jIV2wksuvgefz0EyvfrjSIQYBIgH
	 xTimTG1soXYSKVrXqopbTUzR9lS28ZhFZRJXAULuSR8NdkMF/NJnXAp+BPHVB5P5bzJq5
	 7MYU4X6XhQFOEm9B1lRgiLfsLn1Hgvqj4K9PYhS85qOfjrvZb8oB2Y00nFvzxPNtJi+7V
	 aJqqGDiJ0SEVOVgwJcpLqLR8mFCZ1GLL+1Rlc8gfCkj7Nak8AcA6KGic/iuFb4AXSVt5j
	 N+8e9QwWKD2Es2rBXpLGW0p84UB2CzpAcGkBXossNknUTR90PBZvvhMHRFSjjQ0Gqaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lhxv4COv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3FC606A31A;
	Wed, 28 Oct 2026 18:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lhxv4COv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8131F01825;
	Wed, 28 Oct 2026 18:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213489;
	bh=YmGmWsj6A5L19Z0P1gjKkzjkWSNkJfclJrxdLPQ/cI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lhxv4COvrpJ6myggQfUygrV+iu3CCi91cLOtad32gBsKewo2fqPjprDKQs5ctcxQk
	 /EUpadnzC/xbPGb4lplJUOKz+t3L9azorGLhahg3+IIo3frt8ZDwxGvO0kVadH6EOh
	 tdhpw41xMlh4lTw70MMygrgPA+5ouFvGIzCRFU70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Marc Harvey <marcharvey@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0522/1887] net: team: Rename port_disabled team mode op to port_tx_disabled
Date: Wed, 28 Oct 2026 17:43:38 +0100
Message-ID: <20261028170511.209930940@linuxfoundation.org>
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

From: Marc Harvey <marcharvey@google.com>

[ Upstream commit cfa477df2cc62ba53cb936669886361152b594a7 ]

This team mode op is only used by the load balance mode, and it only
uses it in the tx path.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Marc Harvey <marcharvey@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260409-teaming-driver-internal-v7-3-f47e7589685d@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: b7454f1940c5 ("net: team: stop reusing skb after queue override")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team.c                  | 4 ++--
 drivers/net/team/team_mode_loadbalance.c | 4 ++--
 include/linux/if_team.h                  | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 32ca12211e7e6..b552c79411254 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -969,8 +969,8 @@ static void team_port_disable(struct team *team,
 {
 	if (!team_port_enabled(port))
 		return;
-	if (team->ops.port_disabled)
-		team->ops.port_disabled(team, port);
+	if (team->ops.port_tx_disabled)
+		team->ops.port_tx_disabled(team, port);
 	hlist_del_rcu(&port->hlist);
 	__reconstruct_port_hlist(team, port->index);
 	port->index = -1;
diff --git a/drivers/net/team/team_mode_loadbalance.c b/drivers/net/team/team_mode_loadbalance.c
index b095a4b4957bb..89ee6bee049c1 100644
--- a/drivers/net/team/team_mode_loadbalance.c
+++ b/drivers/net/team/team_mode_loadbalance.c
@@ -672,7 +672,7 @@ static void lb_port_leave(struct team *team, struct team_port *port)
 	free_percpu(lb_port_priv->pcpu_stats);
 }
 
-static void lb_port_disabled(struct team *team, struct team_port *port)
+static void lb_port_tx_disabled(struct team *team, struct team_port *port)
 {
 	lb_tx_hash_to_port_mapping_null_port(team, port);
 }
@@ -682,7 +682,7 @@ static const struct team_mode_ops lb_mode_ops = {
 	.exit			= lb_exit,
 	.port_enter		= lb_port_enter,
 	.port_leave		= lb_port_leave,
-	.port_disabled		= lb_port_disabled,
+	.port_tx_disabled	= lb_port_tx_disabled,
 	.receive		= lb_receive,
 	.transmit		= lb_transmit,
 };
diff --git a/include/linux/if_team.h b/include/linux/if_team.h
index 1e378d3a7eaa0..7a69cd251bfb3 100644
--- a/include/linux/if_team.h
+++ b/include/linux/if_team.h
@@ -121,7 +121,7 @@ struct team_mode_ops {
 	int (*port_enter)(struct team *team, struct team_port *port);
 	void (*port_leave)(struct team *team, struct team_port *port);
 	void (*port_change_dev_addr)(struct team *team, struct team_port *port);
-	void (*port_disabled)(struct team *team, struct team_port *port);
+	void (*port_tx_disabled)(struct team *team, struct team_port *port);
 };
 
 extern int team_modeop_port_enter(struct team *team, struct team_port *port);
-- 
2.53.0



