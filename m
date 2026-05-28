Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB6D2F1FEF;
	Thu, 28 May 2026 20:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001491; cv=none; b=lO0+rr3RrFWLu+nyLyjBVieKbkTIuFViWj3+QLjrU7yJYtmR75uu3xu+PutDlbRnmMpU78RR4Qhu7BAOq78/6FhBH9LoG9o7Fbhx6xuQDWjsjHJsbPeL7JVZ884GVFP2Aac19YQ7qCkLRaQQGJY1LTZLMgYqGYbanR7vrhl/4po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001491; c=relaxed/simple;
	bh=vSDkuEkT2ODEUrPKb9ZbOHFsp+WemlTbYJ0jzVl7FrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OV9imAu2uwfTR+lS5CvCVPcHsYIBZcvQCMW2vKF12nWhPs+bkROGrEkLMd0ZBzVfwby/AiBVKdVrYYenEu4mtX+xfrILxWuSkFucbyjgFLd+b4nZWCgbLBLdfAAZP8CxdiLE9zvbqH4IR0pARUkA06n655s/5NpZGbNluP0XHZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IzRUB3e2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IzRUB3e2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988EF1F000E9;
	Thu, 28 May 2026 20:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001490;
	bh=K87B1GrV/GcZ2EP8gpAKZK/0KusLpJwbcJxw1/o9xzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IzRUB3e2aWeJzMduXR/ZxCzW7g+y9thJPiNIr/VlMf1YHEQwLm3gAbvp1tc7RTUqh
	 9+6OYJMoWHIcpGERY4CFzrkIvfObhHxb87TO2sx8QA8ROy6+wlmESAzXw86PrXcUgb
	 0rX41/RgESS0nqcvhMtLxpD/4bgcCTgvs8jxVKY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/186] netfilter: xtables: fix up kconfig dependencies
Date: Thu, 28 May 2026 21:49:50 +0200
Message-ID: <20260528194931.910324123@linuxfoundation.org>
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
index 7835230872818..8f6e950163a79 100644
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
@@ -329,6 +329,7 @@ config NFT_COMPAT_ARP
 config IP_NF_ARPFILTER
 	tristate "arptables-legacy packet filtering support"
 	select IP_NF_ARPTABLES
+	depends on NETFILTER_XTABLES
 	help
 	  ARP packet filtering defines a table `filter', which has a series of
 	  rules for simple ARP packet filtering at local input and
-- 
2.53.0



