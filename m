Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213484;
	b=VG1uXx40/ADua0u7BNsTa7GSoLi/EOBeWN4DimWJgEwgRQNSSRqQ5ascKnGpv7fIKk9d
	 TKWcCez1/DZnkTqxt4uzLOs/mH82SefbzwTpQTC1kIBFxLPjg4zJh4l66zwuhrhQJpTic
	 +al4obaM/sJneiprWGd5IVJHHwDVOTA6g/fhtGfsK32S9XX2wE/g602B2og4xhtj6BIqv
	 624k2aHTPCGdLE/OXKR/GgwVDN1LwaCCuikXiTBPTgbhcFv0TxzYDx8smOsiIq6Ws9JGM
	 nfkMhAVNUAdo3oTy0WflEJy1XpnwHLUvUdH7pRlh7EA5AHxLN6gObQLkuUI4wb/C0Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213484;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wfbTCLduGdpRUR5Grbgi8VPlLZHzRs0CSbXDt6WnhKQ=;
	b=bfsTfLhCub534x4hXKoDqble9HD5R4WMUz0jcVs0oUG40wM+gvnb10QUFRM45/52X0tV
	 /UU8fpjkOssEFjT9wYCxPRtTeZapv2pWM0vbqzGrfnJQJ9XJg6e5kDmvfY9lI5YLlCe4w
	 nxrRRlXp6y7NxmtjOVt/SLzmTmaKx2zHjC1jJ6vBbdgofO07tNc+emU5YyhnW6p4YWbGY
	 MFbUdps0b5ycAKKd3ynhtW8rrhE3TfCdpBOj7Pi3ef38d3C5FzlAB/82OerEbPOHEikjR
	 RmtD+9fiZdMhL69TkLCRDr6rrzqLcVfz/tKVfXFLjrFfZuft9KpjxbUsq9KiMb0ANpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GZSeJphK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA6F606A31A;
	Wed, 28 Oct 2026 18:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GZSeJphK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8030F1F01825;
	Wed, 28 Oct 2026 18:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213484;
	bh=wfbTCLduGdpRUR5Grbgi8VPlLZHzRs0CSbXDt6WnhKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GZSeJphKhUzJUvwlCulovNsKeqo8PaDkKzYPQzr+qBap9NHdL1al6mVx6/Yu9MB/u
	 rxzsdrfWyzAFyqAm/Fqis+rXgLs/40NKeQ2mwP12Z4PSEyYlLrcD+7vsFq2PfepDzD
	 DRusy5DHMbAJ6Y00cEN0ehYnCF/2Ks8O+yilfJTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Marc Harvey <marcharvey@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0521/1887] net: team: Remove unused team_mode_op, port_enabled
Date: Wed, 28 Oct 2026 17:43:37 +0100
Message-ID: <20261028170511.184556188@linuxfoundation.org>
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
index ea2a7cea3f6a0..32ca12211e7e6 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -945,8 +945,6 @@ static void team_port_enable(struct team *team,
 			   team_port_index_hash(team, port->index));
 	team_adjust_ops(team);
 	team_queue_override_port_add(team, port);
-	if (team->ops.port_enabled)
-		team->ops.port_enabled(team, port);
 	team_notify_peers(team);
 	team_mcast_rejoin(team);
 	team_lower_state_changed(port);
diff --git a/include/linux/if_team.h b/include/linux/if_team.h
index 34bcba5a70677..1e378d3a7eaa0 100644
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



