Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211587;
	b=Wrps08RetzHVsIpZkUlZ91TFwRUlhHsTBNISv+Rkv4/ipkdrCp/8Pl95mgiWwdU9DwMq
	 Uv/64DaBecDBJIOfhzKvsOsIxMCcLlRDxZv8akXohrfEgGAqGzZIXIQyMHdXpjwZlSXJR
	 1QVITvdRcOVVnzSMxpQhePZjpVje5xDH88Qdpc/gwIVsOIMidFS3rXYxQ/gHy8+VFA2sv
	 uU6vZiKUPk+ko0xCDhQj+3eeMa9p7vNlCyNaxvVoZJyiLvTfM9/kSAZMvToxY9DA/QG22
	 SnGCVlmYoH13Ih+3i9z240uyJapBX5YtBuvZIj2v8IQicVsIcJ03n1FIgRRO1CLwVSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zHxpvWpGyQSAFd4USBAC463rdFmz3nM2dwYLFdTeSFw=;
	b=usoByeJIPScJkPtpTzs5q1VHQxi5nwKD2ZkZXImzZqZxlsx+54oW8NcqONO5ZwebjXiA
	 zwGaRnuyl1VuLapA3M/O2qWDAFnceK9PvZAW6AF0m8RjZoV05ZYT+95aMsF763vRGZBZC
	 +VRre8nKoWWnlVqZfF/Tqzz3KxreNIWEwtZq/oeqckjD+bYrW/KnjRMm5DnvhwOG+RRzi
	 iAFPtMTqgkdRD6m3etwABiomSh4AUUdnLeNADijSAYZof0AjF7ww/6T1kOJdMdkv/gsXR
	 qemHtnAXe3hST9r9bPHPE1htwuCUzGivO55A5MsksSAs8eCb8Pumo5o3JQnRUW4vG1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aUQTFykd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11713606A322;
	Wed, 28 Oct 2026 18:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aUQTFykd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BC21F01825;
	Wed, 28 Oct 2026 18:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211586;
	bh=zHxpvWpGyQSAFd4USBAC463rdFmz3nM2dwYLFdTeSFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUQTFykd+4Bqdre6jUqsbnFaRFP3+PRVXtLQh7slrVD+bvW11vo3v0Dwmh3ZWg+mS
	 fP579/VUVAzMAtAz7Lh3yW3uQNM1fC9CvGSET0PO4K2uw7Vw9FQUYgf3JpdxtmQMDG
	 fZ+HvMjIxPlcZpxfkTBfUI18gJsN29yqriraO1eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Marc Harvey <marcharvey@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 431/571] net: team: Remove unused team_mode_op, port_enabled
Date: Wed, 28 Oct 2026 17:59:38 +0100
Message-ID: <20261028170018.247678029@linuxfoundation.org>
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

[ Upstream commit 014f249121d73909528df320818fba7693d0ec92 ]

This team_mode_op wasn't used by any of the team modes, so remove it.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Marc Harvey <marcharvey@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260409-teaming-driver-internal-v7-2-f47e7589685d@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: b7454f1940c5 ("net: team: stop reusing skb after queue override")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team.c | 2 --
 include/linux/if_team.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index af5dbdd8f138c..98500e76f095f 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -940,8 +940,6 @@ static void team_port_enable(struct team *team,
 			   team_port_index_hash(team, port->index));
 	team_adjust_ops(team);
 	team_queue_override_port_add(team, port);
-	if (team->ops.port_enabled)
-		team->ops.port_enabled(team, port);
 	team_notify_peers(team);
 	team_mcast_rejoin(team);
 	team_lower_state_changed(port);
diff --git a/include/linux/if_team.h b/include/linux/if_team.h
index 762c77d13e7dd..ef1f566b90a05 100644
--- a/include/linux/if_team.h
+++ b/include/linux/if_team.h
@@ -121,7 +121,6 @@ struct team_mode_ops {
 	int (*port_enter)(struct team *team, struct team_port *port);
 	void (*port_leave)(struct team *team, struct team_port *port);
 	void (*port_change_dev_addr)(struct team *team, struct team_port *port);
-	void (*port_enabled)(struct team *team, struct team_port *port);
 	void (*port_disabled)(struct team *team, struct team_port *port);
 };
 
-- 
2.53.0



