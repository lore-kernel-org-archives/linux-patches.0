Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DED617555;
	Sat, 30 May 2026 18:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165050; cv=none; b=BERdTQf32X86/uljJlGe9S2lbyKSlPB1vz6jxe7/QpWZ72vi77V9bykt/JaUF4FLb8mGgG9edY1fGqMNBUgzB8Wutu6iksr/0PQIy4Kxbo3hr45lHhzfAD563jtLVs2bd4zREcD0+sqSts831lZEkdMBlY8lyx6PrBdCZuE7CSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165050; c=relaxed/simple;
	bh=gokGWRQxU3f4ccBiRKVYKYVI3Yz+FTlnPNlvzHp335g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEFYB0FT2gSysb+B27MAU1nOH9PVAXWu0ANUCxO7Io8h9KmwsVci9aWc5MzTmX8JP9F6RjWNigTMWHE8pWijy/QWr2ALhPzgHn3DjcekEQctj8zcEg3qKzUpwdZZGuiyi+Rkbu/b2nRBNmfhGSjdN4bo3tV9ONTHSWO/wncrzqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+37Z2WA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+37Z2WA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4EA1F00893;
	Sat, 30 May 2026 18:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165049;
	bh=BGaRW3g+gMCRi8BJgzUMNDnz0NrPTO6zqvQg1yf4v4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P+37Z2WAFodQsC157xcxF4L6mbfruizYp3HPGtionWT+/jh8gbP1mwgdljDXdCTSU
	 hWzZVk9bj9623JO6CGpf3aMBMK9/dz597Upq8jO3luJoZlt8vFYQs40ssXJa+8MTd5
	 qO1+5/KeLMNYxN1IAa7CkwLPAaaHud0iEtpYdDKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 735/776] netfilter: xtables: fix up kconfig dependencies
Date: Sat, 30 May 2026 18:07:29 +0200
Message-ID: <20260530160258.799106951@linuxfoundation.org>
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
index 7c2b8a652016d..18f60e675c438 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -225,7 +225,7 @@ config IP_NF_NAT
 	default m if NETFILTER_ADVANCED=n
 	select NF_NAT
 	select NETFILTER_XT_NAT
-	select IP6_NF_IPTABLES_LEGACY
+	select IP_NF_IPTABLES_LEGACY
 	help
 	  This enables the `nat' table in iptables. This allows masquerading,
 	  port forwarding and other forms of full Network Address Port
@@ -351,6 +351,7 @@ config NFT_COMPAT_ARP
 config IP_NF_ARPFILTER
 	tristate "arptables-legacy packet filtering support"
 	select IP_NF_ARPTABLES
+	depends on NETFILTER_XTABLES
 	help
 	  ARP packet filtering defines a table `filter', which has a series of
 	  rules for simple ARP packet filtering at local input and
-- 
2.53.0



