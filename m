Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2279930E853;
	Sat, 30 May 2026 17:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162395; cv=none; b=YaWgsO/drsDLB0d7VApFoN57OuFUXloNDp6YTJHdd6fm3S8b83LbwMDTNpMncslGptVY/y9L1pdpLzfx0oDi/fcmtp7mDKQb5ca4xZOXqkIJdqgYRAfFublaGG0DKfHkEAfdr9dKD2YRXR49LUkOlOE8DHLLn8HSRWSen/H4Rpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162395; c=relaxed/simple;
	bh=bmpgBoC0Vqybztt0DZd0nHPJwIH/vWuHCppOSLBjYHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZKcAIChN36WMJh2our3T6mwecVrI1nRn+xo3RgAXc3eyPUX/IHFLSudyA1WUOiH5lwppgFPKStwjzIPXJv9BLwFvD8FbE/xYBuz0xixEMWrSDKMEq0bFS+VV9hFnkXt+OOjRZ1Yj+kIvMaeEEo8Y83mrh145w3P1Y1g+y5Ka8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2kf+8Cl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2kf+8Cl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CF21F00893;
	Sat, 30 May 2026 17:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162394;
	bh=E7c6OL9f5k72e9nzEaY2K9lbItbhCCyYcP4z6UB4EGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2kf+8ClQcBuHE2HFKc3XPHm8FFsLtt1OZSYN+9hJ+APiwx2X55hAcT+tFCt/+r0a
	 whpqPGy5xhkrRdmO4jhfuC14wxFXRB0ejtTHJCpsZ5AB9qqjC8HsJT5hzLOCDEQOgY
	 /FSfzrn0M+N55mo9RgJehsGPPaM1uiEqCbedawOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 909/969] netfilter: ebtables: allow xtables-nft only builds
Date: Sat, 30 May 2026 18:07:13 +0200
Message-ID: <20260530160325.822890326@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7ad269787b6615ca56bb161063331991fce51abf ]

Same patch as previous one, but for ebtables.

To build a kernel that only supports ebtables-nft, the builtin tables
need to be disabled, i.e.:

CONFIG_BRIDGE_EBT_BROUTE=n
CONFIG_BRIDGE_EBT_T_FILTER=n
CONFIG_BRIDGE_EBT_T_NAT=n

The ebtables specific extensions can then be used nftables'
NFT_COMPAT interface.

Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: b4597d5fd7d2 ("netfilter: x_tables: add and use xtables_unregister_table_exit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/Kconfig  | 7 +++++++
 net/bridge/netfilter/Makefile | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 7f304a19ac1bf..104c0125e32e8 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -39,6 +39,10 @@ config NF_CONNTRACK_BRIDGE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+# old sockopt interface and eval loop
+config BRIDGE_NF_EBTABLES_LEGACY
+	tristate
+
 menuconfig BRIDGE_NF_EBTABLES
 	tristate "Ethernet Bridge tables (ebtables) support"
 	depends on BRIDGE && NETFILTER && NETFILTER_XTABLES
@@ -55,6 +59,7 @@ if BRIDGE_NF_EBTABLES
 #
 config BRIDGE_EBT_BROUTE
 	tristate "ebt: broute table support"
+	select BRIDGE_NF_EBTABLES_LEGACY
 	help
 	  The ebtables broute table is used to define rules that decide between
 	  bridging and routing frames, giving Linux the functionality of a
@@ -65,6 +70,7 @@ config BRIDGE_EBT_BROUTE
 
 config BRIDGE_EBT_T_FILTER
 	tristate "ebt: filter table support"
+	select BRIDGE_NF_EBTABLES_LEGACY
 	help
 	  The ebtables filter table is used to define frame filtering rules at
 	  local input, forwarding and local output. See the man page for
@@ -74,6 +80,7 @@ config BRIDGE_EBT_T_FILTER
 
 config BRIDGE_EBT_T_NAT
 	tristate "ebt: nat table support"
+	select BRIDGE_NF_EBTABLES_LEGACY
 	help
 	  The ebtables nat table is used to define rules that alter the MAC
 	  source address (MAC SNAT) or the MAC destination address (MAC DNAT).
diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
index 1c9ce49ab6513..b9a1303da9771 100644
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_NFT_BRIDGE_REJECT)  += nft_reject_bridge.o
 # connection tracking
 obj-$(CONFIG_NF_CONNTRACK_BRIDGE) += nf_conntrack_bridge.o
 
-obj-$(CONFIG_BRIDGE_NF_EBTABLES) += ebtables.o
+obj-$(CONFIG_BRIDGE_NF_EBTABLES_LEGACY) += ebtables.o
 
 # tables
 obj-$(CONFIG_BRIDGE_EBT_BROUTE) += ebtable_broute.o
-- 
2.53.0



