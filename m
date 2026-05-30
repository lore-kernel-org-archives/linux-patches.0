Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B6933A9DA;
	Sat, 30 May 2026 17:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162398; cv=none; b=hSb2/6NWGXJOnRW9pmsMvCLrhQvAA+8OCPrAC20noP5heZyrQgowZzWMZtgGbWpiEgSvcG2xauuvWr/beOnbqKP3xSsE2sZC5cqsLRnPUXfkBeAgkvU8nOH7fndSZwQ6qC3R2Xqmqiu/kllwtFU4W+TT27vEBgbwhKYMLAYNAQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162398; c=relaxed/simple;
	bh=6gwCw1cQPYUREz48HDN8EJ1xyaJWH2Rfn1e5BUV3lrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTzQb26fJa5Dqm8olIJEs7zwIFTcmqDl14u70c0D4frCWn8Cl784qCNZZj1zq13sKXKfEoLv0XtZ3ovlRUzN/NwWdrDE+osIWajPZHQh+xNE8NG8UGTKhe79F/CjSXVShE7wfoiBEXO/CZJMQ+k4iUOuWUfcISv82CSQFLA/XYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vayxBJ9c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vayxBJ9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EF81F00893;
	Sat, 30 May 2026 17:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162397;
	bh=TW2y0AR25E+JOWyJe5nzVM52R4LYQ5ZCCvKgEKgyymU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vayxBJ9c1CSFyQYf7cxPNwBjZkWV4NZrNYgKDy1aMvckL3onuoDZDQXke3SCDHHvI
	 IxxKGgGfgpopuJbDzx9xqdryFXXTkPvKE8CcvWfOanFC8MbF9Hl1S1qS6/CSt044JE
	 DCO9fMoLXpIBBuIDrmgIdWDVmQU/lALjtj/lqZQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 910/969] netfilter: xtables: fix up kconfig dependencies
Date: Sat, 30 May 2026 18:07:14 +0200
Message-ID: <20260530160325.853138028@linuxfoundation.org>
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

[ Upstream commit 749d4ef0868c5d8a98e07073791b2198178c93b4 ]

Randy Dunlap reports arptables build failure:
arp_tables.c:(.text+0x20): undefined reference to `xt_find_table'

... because recent change removed a 'select' on the xtables core.
Add a "depends" clause on arptables to resolve this.

Kernel test robot reports another build breakage:
iptable_nat.c:(.text+0x8): undefined reference to `ipt_unregister_table_exit'

... because of a typo, the nat table selected ip6tables.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Closes: https://lore.kernel.org/netfilter-devel/d0dfbaef-046a-4c42-9daa-53636664bf6d@infradead.org/
Fixes: a9525c7f6219 ("netfilter: xtables: allow xtables-nft only builds")
Fixes: 4654467dc7e1 ("netfilter: arptables: allow xtables-nft only builds")
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: b4597d5fd7d2 ("netfilter: x_tables: add and use xtables_unregister_table_exit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 5ee86c7ae4dcb..0f60a740d117d 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -217,7 +217,7 @@ config IP_NF_NAT
 	default m if NETFILTER_ADVANCED=n
 	select NF_NAT
 	select NETFILTER_XT_NAT
-	select IP6_NF_IPTABLES_LEGACY
+	select IP_NF_IPTABLES_LEGACY
 	help
 	  This enables the `nat' table in iptables. This allows masquerading,
 	  port forwarding and other forms of full Network Address Port
@@ -343,6 +343,7 @@ config NFT_COMPAT_ARP
 config IP_NF_ARPFILTER
 	tristate "arptables-legacy packet filtering support"
 	select IP_NF_ARPTABLES
+	depends on NETFILTER_XTABLES
 	help
 	  ARP packet filtering defines a table `filter', which has a series of
 	  rules for simple ARP packet filtering at local input and
-- 
2.53.0



