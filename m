Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B733A3D903F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301093; cv=none; b=l14qkbR39X0ys13pcsn1M5Bn7uPSWNoO4Gi1mgXKZcpTz/w/0bNiIvO+B+7KXH9Azk+DyUT7+a1zzrLACEWCwZG0I7bUMVpXjhY6nuBD6QS1ucUVWPnk4WEtDbS1zpfHuDfiWaLSNc+zTeeg+qd7fae7RXJc8mjzAAj+eBpHspM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301093; c=relaxed/simple;
	bh=YJ+ogNf6zyqjzCxEVfwlx6rs+5T7BhBQJnkJeuvuT8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IELxPI+dqqq0aW+qNZnVSgMXm+1DByEOXdh94Z4z9tZuLZGJ5QaLWoCK8HYafLpm/5fpUZOmEyL/Jw1kZmpOmTfPAJ2DRTOctyk3/P4Uw2K13IbnkXqbtaSGmN6S+Dgt/RuVu/YfDOt9pQjeU/Sv7GjavGpWhvep/kORjXcZrjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lVABOtI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lVABOtI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99A1C2BC9E;
	Sat, 28 Feb 2026 17:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301093;
	bh=YJ+ogNf6zyqjzCxEVfwlx6rs+5T7BhBQJnkJeuvuT8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lVABOtI7hQMOnrHPsV83evA0y0hDyXS/13AXvoKZBdZGFjS2BlAGmR1HUX3eDphyV
	 2eDOEc9y+GFXJbhK5RfzkOo/14BX9Z4uNw4VpD9B/MtuulwbfatLTn6EFuqMpxsddm
	 y1wrRZTK4KN4tT5p4rSZ9N0Sv6Q8/moO1RIkIBuGfZC/2J4TX3Nr9iOYGBSCkm8NQw
	 7g0gSaGrlMLdJu5XCQnqFryibP7KtUFxcVartY763SOm/cwMFJBKbuaJf9QjOlgx+g
	 xuZbF4TtDSVUJzc2+ubCNICeyuhcVkMK5bJetID8Fv4fV+N2xRqtFEpRkssS0Nnire
	 HEQ3lLcnPWspg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 244/752] ipv6: annotate data-races over sysctl.flowlabel_reflect
Date: Sat, 28 Feb 2026 12:39:15 -0500
Message-ID: <20260228174750.1542406-244-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5ade47c974b46eb2a1279185962a0ffa15dc5450 ]

Add missing READ_ONCE() when reading ipv6.sysctl.flowlabel_reflect,
as its value can be changed under us.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260115094141.3124990-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/af_inet6.c | 4 ++--
 net/ipv6/icmp.c     | 3 ++-
 net/ipv6/tcp_ipv6.c | 3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 0e8f48835869c..3709f213d33de 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -224,8 +224,8 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 	inet6_set_bit(MC6_LOOP, sk);
 	inet6_set_bit(MC6_ALL, sk);
 	np->pmtudisc	= IPV6_PMTUDISC_WANT;
-	inet6_assign_bit(REPFLOW, sk, net->ipv6.sysctl.flowlabel_reflect &
-				     FLOWLABEL_REFLECT_ESTABLISHED);
+	inet6_assign_bit(REPFLOW, sk, READ_ONCE(net->ipv6.sysctl.flowlabel_reflect) &
+				      FLOWLABEL_REFLECT_ESTABLISHED);
 	sk->sk_ipv6only	= net->ipv6.sysctl.bindv6only;
 	sk->sk_txrehash = READ_ONCE(net->core.sysctl_txrehash);
 
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 35b32dcf581ff..54ad4c7578679 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -757,7 +757,8 @@ static enum skb_drop_reason icmpv6_echo_reply(struct sk_buff *skb)
 	tmp_hdr.icmp6_type = type;
 
 	memset(&fl6, 0, sizeof(fl6));
-	if (net->ipv6.sysctl.flowlabel_reflect & FLOWLABEL_REFLECT_ICMPV6_ECHO_REPLIES)
+	if (READ_ONCE(net->ipv6.sysctl.flowlabel_reflect) &
+	    FLOWLABEL_REFLECT_ICMPV6_ECHO_REPLIES)
 		fl6.flowlabel = ip6_flowlabel(ipv6_hdr(skb));
 
 	fl6.flowi6_proto = IPPROTO_ICMPV6;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 59c4977a811a0..2e07dba293b41 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1131,7 +1131,8 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb,
 			txhash = inet_twsk(sk)->tw_txhash;
 		}
 	} else {
-		if (net->ipv6.sysctl.flowlabel_reflect & FLOWLABEL_REFLECT_TCP_RESET)
+		if (READ_ONCE(net->ipv6.sysctl.flowlabel_reflect) &
+		    FLOWLABEL_REFLECT_TCP_RESET)
 			label = ip6_flowlabel(ipv6h);
 	}
 
-- 
2.51.0

