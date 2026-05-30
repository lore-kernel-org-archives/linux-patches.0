Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421893403F9;
	Sat, 30 May 2026 17:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162405; cv=none; b=rN6mydFDMHmJkpAJJU0ulEUJ8tikXqV0sPczQkHgP6o5Z6/FOTxdaPSHr0SZuVDOIE1UlkNssBmYKdn3eayzBHn6fP1qQG46hPJ6dduR/hZX8L6LMLidP0dhx+s5KTsSvK23eExY7wUs3os1wejK90ZJ1B9aOGHYJW3fhLuBZms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162405; c=relaxed/simple;
	bh=JWtP2hkYT0QfVZovaPJhzCxvVROfC+CrT/mX4k9r3rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gex7MjtBy0ia4z4qkLkT943/cBIbRft2ywHRRpHSiWscQ/2wT7HCueS8EWceg/d9GfD8kT0nhtwXrtDj9q9NXaaDtcvVbp7fmfKQXcifZM4YC+cNsZIYYZEvETQv3xeYStIUCzP2cIzacRToXxCdg/NR36NSmH0G33Wu1iFEcr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBElI2b6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBElI2b6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B021F00898;
	Sat, 30 May 2026 17:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162404;
	bh=ClIschycb6WdQUlK3v6fI5g2Jfvz36MwoMJQwEsTJMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TBElI2b6RmlYPlf6xpAkSkRxbNuZIO84Xvnu4SzyHsnpvj8o4l8azDhDsUvAuyYQ6
	 cmNb1S3lEMUCO6zyYMxCpOK+OGKzMJUAg15Pz4jDfdtw12/SAh9s7znhsnQZsuzxJq
	 wgnOOfmwQR4qk+hGl/t+891IktSJlLBdqF6U64MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 912/969] netfilter: Make legacy configs user selectable
Date: Sat, 30 May 2026 18:07:16 +0200
Message-ID: <20260530160325.913225001@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6146ef5fc728f..1d0a89a67acf5 100644
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
@@ -332,7 +338,13 @@ endif # IP_NF_IPTABLES
 
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



