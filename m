Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209298;
	b=4gHRHc/qxeqdQOts609I8uRmA8nb4xDvtP/dj1fVX+suLPVGZ1btVdsgrMq+LbzeeKAS
	 OE3cLKCYxy1u2YbubiMjPHygtd4SfhA9YSVE5YNUcaH/yyENV5+ePWn6cwncQi9Xa5Hoq
	 35TVIFtkvn9TFZ2/e2unAWIFBqvkAF5DVxTjzym+V8B6XM7Kzqc3fldS507FPbNsP9rex
	 x6x9KeTduLYDTLmVXQpDtBfCIASrsXy66QeVqNMQpvXTxl5iNm1u1HS5iUOZlwKuL7EYX
	 kQzRZJCSu7psb1SPgZftZjYuFCqxUuQResFMmTUNueP/teDQ/hMEyB51brlDS1MpDjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MR1+ValCYULYCOnZDTHo+A+y9hnaIpfLqLxtlCkcOOQ=;
	b=A7BKKKicpk5e6wR5WOb3S8Wio/GXM5i+ZimuUtmhz9XM6Np6WRtBC9QMtI63qYzLnnPE
	 EHEV6MnrwDixekhtpcI0xBAmV0tada8Z7RIttJgePNP5R1sDGwZxA3hSCwUlEaNSXzskP
	 N5ovzYCmaR/zCQMLgK7ARjUOqbtUiJk7ElFSKclau3WUYGlAG3BiyyZhxArFH+ySIc9RY
	 P9s2ToXMOVmjotuNf1+3KFGoAJBJ/qd4CxjnkkDaXJ2B9amrhuDXHmSxNgJgF6Up3bXxX
	 CxmNRE4Wyh8icO02Rzl/H8r2eDY17GmVDNgy2gJ1EBBKfzk2X7RXL2hJ802QCjs1wPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q7qLxvYp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985CA606A31D;
	Wed, 28 Oct 2026 17:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q7qLxvYp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E946B1F01825;
	Wed, 28 Oct 2026 17:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209298;
	bh=MR1+ValCYULYCOnZDTHo+A+y9hnaIpfLqLxtlCkcOOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q7qLxvYprJNxu8EF6PRdp7kiSh/gt5hqIr9Sw5LPKo02XFx+IDBvzLnYETOZ08EpC
	 FyUeOgw6Y3PV+6f453sqkZi4DDUfmjTr0UnrEApr9Q1pOOo6h8s9zRTr1iWqttOjhQ
	 vgGtM0EXI8V51O6YRPLxwJzcHz8okZL055MpIQoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Marc Harvey <marcharvey@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 379/516] net: team: Remove unused team_mode_op, port_enabled
Date: Wed, 28 Oct 2026 17:58:51 +0100
Message-ID: <20261028170012.462165117@linuxfoundation.org>
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
index 0b62e204c7bb1..58dfecea5ef96 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -939,8 +939,6 @@ static void team_port_enable(struct team *team,
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



