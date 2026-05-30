Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3271274FDC;
	Sat, 30 May 2026 18:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165057; cv=none; b=bRu07B6oMl7K5AIuby19CMjjy1wycQtCDwntiFBEBjjjrakuJPuRN8EITPCSf5OCpmqZveSYQ/OIpY9BRCzxDpIPi9+fJ7qLuB9owyZnX7lR7uX/L64JvJV9vLXL0TdQuAjCP4NsNlaqD9Cl/kMm/uSkhUrrYmFkJWLOpTJ8/bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165057; c=relaxed/simple;
	bh=Wc1JgrDw9joBL95HwH4K4Qut3FvYDhtAmX2AQpK3qHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZu8hmDJsLZkbu0TiykCa+HzmmaBi4r547N2oNzeFXzErbXhoPwn3Qu0nHHmz88efzk/0V092cRDju5TSSf4PGM9ZenlR+VWwye3yM0VHF8oPz+Wr+stD/jhcnkpOwfyynAEqjejiJpa2+uOytPzxZli3D0RvTe4HDqlcG9Eg+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S59t6cFK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S59t6cFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72891F00893;
	Sat, 30 May 2026 18:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165056;
	bh=Oc0bYAPWumeuHSys8o2mYMw7uC8iLlyHo7m+hAdv82s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S59t6cFKObLdVFFNtQloBFs7SylV3hE/NBHm8+qclZZyJ5yOeyrRUNVEWsx+04nlh
	 G9qbedJfCp/DBkgeevrglNXzyRTTpAiqdDC83aN9IZ/q1Qfj51HdnatCpSDjez6q/h
	 hczyXebWx/pYeuN1iq/IGA97ggSTQuQa+XKuwXjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 737/776] netfilter: Make legacy configs user selectable
Date: Sat, 30 May 2026 18:07:31 +0200
Message-ID: <20260530160258.846920784@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e752a07a871fe..2e540786f9512 100644
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
@@ -340,7 +346,13 @@ endif # IP_NF_IPTABLES
 
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
index bc51a77fb6c07..670d23f926e62 100644
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



