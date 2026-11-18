Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053079;
	b=pU2gFs3YRiZLLW1Rqwjr4UOq6nTUfIwAi+jFfkhKbQRdK7HDBKakcaL37y8/JhvseA46
	 E1o41DcJ888QIlDNL0BGebw98ZxBPQyHiuB9/vHkVkXwvLzyXGakG3U3zG8G7blThtHwA
	 pMVRkfR2ydjd7GPuJk9PMyxc+nwvysvU1h+F7CwfEvqKUIWW636+9Ze2Q+s6/c2dDwn97
	 LZk7JHoQUZyu5Q9GJ6JXhzZQ4yw+ga7fg6Z41j1LkS3NHlAa3bC0obhxG+9+5eteb4lj+
	 WfSkeZkrGGp54+n/1542QWn5NOXwn1PEKliZzn19VsRATvV6IB/6pFWGN1DLBTfvwzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yRCxmrltfdBgr/4Lc82cPy5Hnpd7z+YLuwzkub1u8i4=;
	b=OHyZfs6z7XoOsch6WleY1j/0I3iwcpwub9XRkd48s1xurQjJ2ldEbTjDxZJdfO6gOhU3
	 xJubZrtWnhFBp0uHppriQQXgL1zv1x9aY90izYh2dlOmXppjomBh6/zLyre8f89WGmmbd
	 PbIriNJFVEFljDIsdXXm9gd2N3jEVzF7FQblCzbsGvWcLZMOUnoD0kQ/aJoPFqAqdPNFS
	 EzuZ2z1q3SmseWh3S8thv0SuHS4e+taDEXdI3caryv9AjoI7lD0kmEsJXKFmX4HW/nGWv
	 1Tt4yTC394K4QVxcZwbp/1GoQo7CNxroi15mIH9P49ghrm2PJOvRveIGNh1y4YlrVEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fLsc1uAP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451AF606A31C;
	Thu, 19 Nov 2026 01:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fLsc1uAP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF5A1F000C4;
	Thu, 19 Nov 2026 01:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053079;
	bh=yRCxmrltfdBgr/4Lc82cPy5Hnpd7z+YLuwzkub1u8i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fLsc1uAPDN59vQyOr2Ua1OOQH+gmBrl8db1ve8SwZLb8UlHKYkGqaETnVcimN7rQb
	 13Yt8+0vCwNe9DludjwLzshdPNaNvVWox8YRCkdC4D8pwu2FqfKOOGkwbEbMvYi/sD
	 U4RI9k+tzVMKs0yrm5djHrsR08aanPWcj1/YkxmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xia Yan <yanxia@cmss.chinamobile.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0732/2214] macvlan: fix passthru promiscuity accounting while down
Date: Wed, 18 Nov 2026 15:40:08 +0100
Message-ID: <20261118150041.116759922@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xia Yan <yanxia@cmss.chinamobile.com>

[ Upstream commit b6743653d134c9ef8436e2db1be1ad4c1e0d0091 ]

macvlan_changelink() adjusts the lower device's promiscuity count when
NOPROMISC changes, even if the passthru macvlan is down. The reference
is acquired in macvlan_open() and released in macvlan_stop(), so a down
interface has no reference to change.

Clearing NOPROMISC while down leaves an extra reference after the next
open/stop cycle. Setting it while down can remove a reference held by
another user of the lower device.

Guard the count adjustment with netif_running(dev). Keep storing the
requested flags while down so the next open uses the new setting.

Comparing changelink with open/stop exposed the unmatched count changes;
the same issue was also described in earlier macvlan reviews. A netlink
test on UML reproduced both DOWN cases before the fix and verified the
expected counts afterwards. Repeated flag updates, two open/stop cycles,
deletion and bidirectional small-frame delivery were also checked.

Full x86_64 builds completed with WERROR disabled for allmodconfig, and
WERROR and KASAN disabled for allyesconfig, including the resulting
dependency changes. Neither comparison showed new diagnostics.

Fixes: df8ef8f3aaa6 ("macvlan: add FDB bridge ops and macvlan flags")
Link: https://lore.kernel.org/netdev/179170088566.434549.4699134797461783473@kernel.org/
Link: https://lore.kernel.org/netdev/20261016003009.2692872-1-kuba@kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Xia Yan <yanxia@cmss.chinamobile.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20261022090809.12019-1-yanxia@cmss.chinamobile.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macvlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index c8c1761908c1b..0755f1dc296c0 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1590,7 +1590,8 @@ static int macvlan_changelink(struct net_device *dev,
 	if (data && data[IFLA_MACVLAN_FLAGS]) {
 		__u16 flags = nla_get_u16(data[IFLA_MACVLAN_FLAGS]);
 		bool promisc = (flags ^ vlan->flags) & MACVLAN_FLAG_NOPROMISC;
-		if (macvlan_passthru(vlan->port) && promisc) {
+		if (macvlan_passthru(vlan->port) && promisc &&
+		    netif_running(dev)) {
 			int err;
 
 			if (flags & MACVLAN_FLAG_NOPROMISC)
-- 
2.53.0



