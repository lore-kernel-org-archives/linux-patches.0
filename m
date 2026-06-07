Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5561E98E3;
	Sun,  7 Jun 2026 10:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827048; cv=none; b=uMRDUMp+ET3szkyi1EGC4xkPAF2Lz7qMZhUxm9kqXivPzemp/gFyF0Jr5kbecGnARPF/6fQRb2Io+IYgA8WPHUKbClwLnfG5o7mY+mWOMl/VUq1dbyC6Q/eHm0yGl+iDZErhFWzP4wC16oZkVmfL7q7C2luR/L+lMM0b4IifnSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827048; c=relaxed/simple;
	bh=YZobfAfVzdRap0qfp+Djeip5ggpIQvjHLmL8pkqAFwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npdawHDpHacU2N5fpo8TZQ1aUCBSbAeSJ0Dkt6i31DwvalEj6/4g2uKhSbMUu1idF6/PSLAx8JjXrgiocL3buNKttLvqZEvWZ5lyT5V6eCpWdieQsMn9Ff/vAZTcTV0UxokMBy7DQz3Uiuoed4Y9AZKYOwy9XGY02RstR36cQPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mDVeUBqz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDVeUBqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796191F00893;
	Sun,  7 Jun 2026 10:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827047;
	bh=Dvq2j1nW3gBRhbuH2uAKA+oi0pfLMnDiKhy2ALgcqzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mDVeUBqzKEKFFjXmQEQbGJKELMvSd59M2QtA8pFtZ6Ns/IZv2avdRVAMOXgFLSVnW
	 r7uL4MMCl3MrmsZ6RvLoOPfYgUL7wsBHiYiY46vrUbH25BsJVe7NgCCea+lRUp3sSK
	 jFS3Wotzdxwum813e363d3+nwOMLyWqbK8k0E50Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Marc Harvey <marcharvey@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 035/315] net: team: Rename port_disabled team mode op to port_tx_disabled
Date: Sun,  7 Jun 2026 11:57:02 +0200
Message-ID: <20260607095728.821332708@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 25fe708bbc59 ("net: team: fix NULL pointer dereference in team_xmit during mode change")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team_core.c             | 4 ++--
 drivers/net/team/team_mode_loadbalance.c | 4 ++--
 include/linux/if_team.h                  | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/team/team_core.c b/drivers/net/team/team_core.c
index 712d8043e66e17..11c8e6551dd357 100644
--- a/drivers/net/team/team_core.c
+++ b/drivers/net/team/team_core.c
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
index b14538bde2f824..b27e44a4df5f6e 100644
--- a/drivers/net/team/team_mode_loadbalance.c
+++ b/drivers/net/team/team_mode_loadbalance.c
@@ -655,7 +655,7 @@ static void lb_port_leave(struct team *team, struct team_port *port)
 	free_percpu(lb_port_priv->pcpu_stats);
 }
 
-static void lb_port_disabled(struct team *team, struct team_port *port)
+static void lb_port_tx_disabled(struct team *team, struct team_port *port)
 {
 	lb_tx_hash_to_port_mapping_null_port(team, port);
 }
@@ -665,7 +665,7 @@ static const struct team_mode_ops lb_mode_ops = {
 	.exit			= lb_exit,
 	.port_enter		= lb_port_enter,
 	.port_leave		= lb_port_leave,
-	.port_disabled		= lb_port_disabled,
+	.port_tx_disabled	= lb_port_tx_disabled,
 	.receive		= lb_receive,
 	.transmit		= lb_transmit,
 };
diff --git a/include/linux/if_team.h b/include/linux/if_team.h
index 0d550d44a1c230..cd5acf40040d2e 100644
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



