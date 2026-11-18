Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033122;
	b=LtpQzPC74E3HpwDAMqmHf4C/VZaMrms9ytVFYxEQlrMl5msRgP6ipogwijJtR4wlt6N6
	 jlBV3MnH0fmvjAw/Eqn7FVrjW8GGyc4QZ1dkfnK/x4wfuQ+0XvSYQOmJyGgxD3hUSK9qr
	 PFFUw6IGeA+gTLf0Cmd0vDqiiun7YfUCELfJB+Teg37pmbm049tZj0kOZXaP3TokfLMHd
	 rZ8gju7STFScG8HXqN9rm2/xEz6EOSKunrjsrD0i3GZSZHyEWRkL3vGZyBPdMI5Uif296
	 rJNpFxfm5GTOM5kJ9LwlJMyH8N+IyB/acnlwOg4XPDOPUjEc0YX0opvQq/EpPqmvFBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HO/mTBEF6BUkWGPw9MTA1HynHNOWJoWhDJr8G1BpSVo=;
	b=rdcgiq6ygxHmj3jU7F8AdIHyyLm+0Axn853bwR4xPnhBCmLyriK1NkZKOOeDCAklS6sG
	 ZoKoGMUIBspZQEO/o7A85C0WKxdUFf3faNOGaCdjDtkLwUKrPKdgh5PaHTKYO2q1RhdT3
	 BN8Fos+OHYpe7Qs7M7EEU1Zo4jGIHYxooxq0cOvSsSqrzRrFCAiwVyUkJpoKF/LZ9dh5B
	 P/YfDpLIe/MEb/FEI5ZnyXdUkZsWV3gTLWCHcn5VTbKtklmbbl29hdUiy5AN/3Nv92LaJ
	 +Ib8OVHW2+QzdMaP5dh9gDy6qac/8qojEEQbN96UfH+qdBW23V5j9GJcYYnsDC5Jk8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UmqIJ0bf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F247B606A320;
	Wed, 18 Nov 2026 20:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UmqIJ0bf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1C11F000C4;
	Wed, 18 Nov 2026 20:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033121;
	bh=HO/mTBEF6BUkWGPw9MTA1HynHNOWJoWhDJr8G1BpSVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UmqIJ0bfwI5x56eo8Jt1GkNkhazhac/biVFYvfOpA/D6hqTEhpPO/nGUgglcJ016F
	 h+OWcPCiO3APNL5eMGq5iOS0Tir0E3S3J1FmXMAQRhjZvftZ+6BHbHlJ4P9XAdZ47G
	 LRX2ycVPT2JC+ZW0gs3A6WKWtxIGf6AxI4bGDY9A=
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
Subject: [PATCH 6.12 1656/1756] bridge: Add internal flags for neigh_forward_grat
Date: Wed, 18 Nov 2026 16:03:03 +0100
Message-ID: <20261118150115.646081486@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 22bd82aaca73f..4a7353de27981 100644
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



