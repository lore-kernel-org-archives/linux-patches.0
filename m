Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042632;
	b=fc9+K8/eliizo3NSnYUVB0IxCmoxYtm+wrhMvAxfNFLBr0AGGegaLR7Ibc5r4V4/+N3H
	 lIiXxOw/pABpErpHZgERnuXHMIZQc2JtjWjFktfdjGGxP9zGUkc7xQpNWIzgQSLmQ+99h
	 Qf44cdlxOFG27bK9bi4MPw+q84R5GC3HyQK1dfvNiwemlQTvGcBYz+L3emxObxCXVW7Ow
	 1Jfpah8pLRI/AdQBpkrxmEeemYw3iBbJ2WTlUeO17HqNTgYzA/TaVV1QrPzg9SpjvWlNW
	 gaLgMVLKlxkrb4boienE20+s4nd2GCl2ucLoEpZw4sDip9AyDSoHzY87a0DhlF25vHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ezG14OYEQsigg+dhWktTM3ktjtMzjVGHAqMRDzEcKJA=;
	b=FO9ICJnw+zrcnPAJB/88teT8rtBYkZvJQxUKUrd6sdEaeYudr6Ii6WflF6vAxM8I3ZpK
	 nRoReHnNeHp4rA8hGrm4N3v6O3GtWgRlj7FQCAF0OgxYVQg5yl+Ackpwv0VrQ+xoxLxj+
	 HUZfbH9xQJkNRHV00JQcSNnR6jxDSaDrOiQ/8uAM0OrIWMQqDYhgzSJrV1FKJ3NNBrxE9
	 OdEuSpurgGQkFUsSPQbavzHpt4CLKJVlpBjJixD0omf1pXOugR0F/E/oIqzVK5N3NzGJm
	 u8SN2d6v2QFIqO2Xwok3RCBlHmbaLv5EdfuJNsWomIzL9O7bPF8gdfLFvljtpwmWq0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PWsp75Hw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C1C606A32A;
	Wed, 18 Nov 2026 22:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PWsp75Hw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA9A1F000C4;
	Wed, 18 Nov 2026 22:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042632;
	bh=ezG14OYEQsigg+dhWktTM3ktjtMzjVGHAqMRDzEcKJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PWsp75Hwny3aT3+eicZGcqNYVAANzwJxi1CLgQ4T64mmJztvSATFm2hQQ1qmC70pO
	 XoCwVLdS0Fs3hypzP5tBp2+jnrQozXzZmStxgjlpNMXPrsR3/NXO4TF5qhc9tXn3mv
	 o7PymBfvMHxid80rVdLbc80crmSQixUG5klRQcCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3238/3318] bridge: Add internal flags for neigh_forward_grat
Date: Wed, 18 Nov 2026 16:04:20 +0100
Message-ID: <20261118150456.825073352@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danielle Ratson <danieller@nvidia.com>

[ Upstream commit 3a28ccb9dd47d1b6f64c64a94c958a968299aa1d ]

Add internal flags for the neigh_forward_grat feature:

- BR_NEIGH_FORWARD_GRAT: Port-level flag
- BR_VLFLAG_NEIGH_FORWARD_GRAT_ENABLED: Per-VLAN flag

These will be used to control whether gratuitous ARP and unsolicited NA
packets are forwarded when neighbor suppression is enabled.

Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260511065936.4173106-3-danieller@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: fcc00b15cb21 ("net: bridge: netlink: do not clear the vlan info dump error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/if_bridge.h | 1 +
 net/bridge/br_private.h   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index c5fe3b2a53e82..ec9ffea1e46ed 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -61,6 +61,7 @@ struct br_ip_list {
 #define BR_PORT_LOCKED		BIT(21)
 #define BR_PORT_MAB		BIT(22)
 #define BR_NEIGH_VLAN_SUPPRESS	BIT(23)
+#define BR_NEIGH_FORWARD_GRAT	BIT(24)
 
 #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 27f44b4439640..1406dbfc49955 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -183,6 +183,7 @@ enum {
 	BR_VLFLAG_GLOBAL_MCAST_ENABLED = BIT(3),
 	BR_VLFLAG_NEIGH_SUPPRESS_ENABLED = BIT(4),
 	BR_VLFLAG_TAGGING_BY_SWITCHDEV = BIT(5),
+	BR_VLFLAG_NEIGH_FORWARD_GRAT_ENABLED = BIT(6),
 };
 
 /**
-- 
2.53.0



