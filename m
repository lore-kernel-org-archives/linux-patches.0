Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DF3304BB3;
	Thu, 28 May 2026 20:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001496; cv=none; b=dyuGzsU6qVYa7U2YoErVdEb9IwWXjql1BZmzydMsc9uBJZVyNRTNt152YaMz6G8Z3DAehypi+u1tR5XDDuxg8QxYyKo195M+uj7cSzd05JsJACih1sLNJ5DkNK8wS5iWPrL303FrBJOlC2qjR0147ry7pm2XtoF1H69HuerahpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001496; c=relaxed/simple;
	bh=Whv72rUznSuglj6HOuV6RSMASt40wJ9kjGggB8V3OZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t36yYS3Pz5EbnU1mW9xIz/8gthaOwaCpGtXUol/bzXR/PN/VZwtlXwZx54g3sXgMm0vRufAluMTYlgsjGSiQN1tnIUsikMu2ZMoV+y+bU4vLsNjXR1PCjf3LvUDf5zKLajd7ZHERuVOVhKkoQVG86UiZhTV/waM9Dsa5nF7bYfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GhgWHlxN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GhgWHlxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF8A1F000E9;
	Thu, 28 May 2026 20:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001495;
	bh=6rqMVWas3AeXRtqK5hl/icjk5C6JHlOQR7uozjDJB4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GhgWHlxN01VmVU1anYxTT01QQOmDB/rEiOa/OaLb9XQG3ZTiu01RQvMy4//6gtIg3
	 16GkfC4SNxfee1VvjY9SGRhGpKUG7qfP1WI/B1Bli8TvK0HQt5YwnM6mVv6N5ig9zD
	 HMyCldSBUSW/q0kjjLTt8Ik2WKYh80YjJ1IFXLWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/186] netfilter: Make legacy configs user selectable
Date: Thu, 28 May 2026 21:49:52 +0200
Message-ID: <20260528194931.965894599@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 6c959fd5e17387201dba3619b2e6af213939a0a7 ]

This option makes legacy Netfilter Kconfig user selectable, giving users
the option to configure iptables without enabling any other config.

Make the following KConfig entries user selectable:
 * BRIDGE_NF_EBTABLES_LEGACY
 * IP_NF_ARPTABLES
 * IP_NF_IPTABLES_LEGACY
 * IP6_NF_IPTABLES_LEGACY

Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: b4597d5fd7d2 ("netfilter: x_tables: add and use xtables_unregister_table_exit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/Kconfig |  8 +++++++-
 net/ipv4/netfilter/Kconfig   | 16 ++++++++++++++--
 net/ipv6/netfilter/Kconfig   |  9 ++++++++-
 3 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 104c0125e32e8..f16bbbbb94817 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -41,7 +41,13 @@ config NF_CONNTRACK_BRIDGE
 
 # old sockopt interface and eval loop
 config BRIDGE_NF_EBTABLES_LEGACY
-	tristate
+	tristate "Legacy EBTABLES support"
+	depends on BRIDGE && NETFILTER_XTABLES
+	default n
+	help
+	 Legacy ebtables packet/frame classifier.
+	 This is not needed if you are using ebtables over nftables
+	 (iptables-nft).
 
 menuconfig BRIDGE_NF_EBTABLES
 	tristate "Ethernet Bridge tables (ebtables) support"
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 1b991b889506a..ef8009281da5c 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -12,7 +12,13 @@ config NF_DEFRAG_IPV4
 
 # old sockopt interface and eval loop
 config IP_NF_IPTABLES_LEGACY
-	tristate
+	tristate "Legacy IP tables support"
+	default	n
+	select NETFILTER_XTABLES
+	help
+	  iptables is a legacy packet classifier.
+	  This is not needed if you are using iptables over nftables
+	  (iptables-nft).
 
 config NF_SOCKET_IPV4
 	tristate "IPv4 socket lookup support"
@@ -318,7 +324,13 @@ endif # IP_NF_IPTABLES
 
 # ARP tables
 config IP_NF_ARPTABLES
-	tristate
+	tristate "Legacy ARPTABLES support"
+	depends on NETFILTER_XTABLES
+	default n
+	help
+	  arptables is a legacy packet classifier.
+	  This is not needed if you are using arptables over nftables
+	  (iptables-nft).
 
 config NFT_COMPAT_ARP
 	tristate
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index f3c8e2d918e13..e087a8e97ba78 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -8,7 +8,14 @@ menu "IPv6: Netfilter Configuration"
 
 # old sockopt interface and eval loop
 config IP6_NF_IPTABLES_LEGACY
-	tristate
+	tristate "Legacy IP6 tables support"
+	depends on INET && IPV6
+	select NETFILTER_XTABLES
+	default n
+	help
+	  ip6tables is a legacy packet classifier.
+	  This is not needed if you are using iptables over nftables
+	  (iptables-nft).
 
 config NF_SOCKET_IPV6
 	tristate "IPv6 socket lookup support"
-- 
2.53.0



