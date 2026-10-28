Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209301;
	b=u2j0RE2EhhhyyD6PCAM8wQLBHACpqA2pyyU9XZMURRmrXHRnMQMgU8wtdHGw8zrhhjk6
	 MLv8VaOhruSnME96i8eX5RA58dA+kSvl+6I/P48mPOj2D4bKIvWrewy/yTn4UBeI5WMB6
	 RuNF/aJ8sf0lZcnkwJZhwMlI5d0JuRxbfvQEA9p8s1BfxAbBvosOtIIHkSAD1KEGUijP7
	 BMBPBR/T62tcVa/iiE7tTyB+lXPi5K+ACEtyl7Fa+0OBNdgsaM02XwaQBFDUjFj3wWLAs
	 5fO1q3bvkPT190W1SipvR+mU3kexIaGIhC2wZSwqpWrYF02ZTksnRqsAWa5UuGs4V4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UbUoh8MTcT9M+JVpVhh7v7x/nLyDaW14SYF5bfuBCNM=;
	b=jCDkS+kxEgZOYx/biVYjtXLG1X5Ze7VY1q3HxKLdmcCalPCFsjTO9tlxP7rR+/Sf4tWS
	 vjHMJ41SkpIifuW1mcLEFdfqKM9Ac1jQR4ME1j3RR2pDOTuHw2CRjrK52q3HVLmhUjjEv
	 j+e+AGhslX+PZLaQQijrsUL+i+GjgnajXysu3ELxhmzHcIpBkQ6qB1AcQtOv+wd7wc+b+
	 8xR3w0HhxBEdKTWf2M5DhMyBHYpYqVEZ4zVWkaX1D7UNc1xXApf0cnuCx+o8OpJp4nGwR
	 27JxshN6gXRN/Ats9e6sXJiqiva+uyraLlmu7cXNJh3aLsct8hrtIfmQtZ2O/wG+NxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pOnXuazL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788E8606A31A;
	Wed, 28 Oct 2026 17:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pOnXuazL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B011F01825;
	Wed, 28 Oct 2026 17:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209301;
	bh=UbUoh8MTcT9M+JVpVhh7v7x/nLyDaW14SYF5bfuBCNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pOnXuazLgW70Jhc+x2iTe44KTALaECoK4rN7zKkBPxIQq8Hku9ioBrEwKlY6+ofFp
	 52dqGg9jFwUOCmJDuHorRyPlw40Xf2Y6oJXHCgyhd9lPqWqg9eMuhgTiUTum01EJJN
	 CZ/tpULUQuX6kfU+3XTurzJIlK/LJwIv2FkrYNFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Marc Harvey <marcharvey@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 380/516] net: team: Rename port_disabled team mode op to port_tx_disabled
Date: Wed, 28 Oct 2026 17:58:52 +0100
Message-ID: <20261028170012.484741152@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
index 58dfecea5ef96..c91dbd5262643 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -963,8 +963,8 @@ static void team_port_disable(struct team *team,
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
index 32aef8ac4a14d..161b70981c0b0 100644
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
index ef1f566b90a05..a1fadb70dd52e 100644
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



