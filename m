Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211590;
	b=Th89rE026qvtyApBYwwsDidIC6bCDu8HrgCo84iU3FS9NcqHYs62rAa6+qKPSxSLYLl4
	 y7SMcAUSJqUGbMs9PcWrL33yCQXFYxaMBg7jCt1BgKL7Xusb+7QMLomglXxOtcBeFwye3
	 QPvj40l0sgKtGQurpM5FYf2BpUwQGYYehARQG12NmA4BmvUXeJTVAmoLyXdjJYgSQLk9r
	 /nsiKj4p3v+4AZaQDh/TxTtis7xfjB23F6ENz/W2DBg1ghW3aOgCG+7j6Bf3ucC7PSauk
	 zBEopS/vP+zlZGcUlrk1elegiOiSYeOBXGCNniEsP9AJj8Yj1rq341vK/E/6hh9Md+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JGxwjcxDawE6k2RorftgHnA+ef0R4ADb1YVSHHOl1ug=;
	b=mHHBE8ScbAiC9mZVSUYH7Sj0d8vFOBXhjONcqGsB5YPZ6RyA638QLDY7p5QqRiKw4gMp
	 qDGalU4RBanrYqPu0oZqzyxeDz3+iJ2kWgHt4Z0ksVLxxArKSShgegys2e2l6dOyf5e/R
	 Q+uc/7xz7IhjJ12CMzcPqhgrrev4dwvATd2qq/Lc8WqmC6o5ifBSCksyMpCtcaCyb//wj
	 uCMl+010jKNRnHTd5chP6yFAlzGABacvT1K/76gSBXhr5HioNAXe9lQuTkigyvPExRAss
	 JeKQW1jiWMJo8ktCm9rHi7D1GUc2/Jbh67Nelfi6lXvR33+ffHNvPbaA5SLw7wJjaRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oLJnZHxF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37062606A31D;
	Wed, 28 Oct 2026 18:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oLJnZHxF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E191F01825;
	Wed, 28 Oct 2026 18:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211589;
	bh=JGxwjcxDawE6k2RorftgHnA+ef0R4ADb1YVSHHOl1ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLJnZHxFYLf+AVtrt8OdtfbWXkVIe1eDwi7v2uN3TyOApx88Ct2UQsPhd3WnN/tGz
	 8JTHcwb97JcWIRpXE0kdOfptMTzLnHrj9tjS7tfIVnlkTcOBFV5KjpudpcrrmN9UtR
	 DjC1wdYUfNtBxMoWISCA83rQGKUdE/YK756/miI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Marc Harvey <marcharvey@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 432/571] net: team: Rename port_disabled team mode op to port_tx_disabled
Date: Wed, 28 Oct 2026 17:59:39 +0100
Message-ID: <20261028170018.271475355@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
index 98500e76f095f..0d2fd43fd00a4 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -964,8 +964,8 @@ static void team_port_disable(struct team *team,
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



