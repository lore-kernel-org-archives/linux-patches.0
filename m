Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782B62580F6;
	Tue, 25 Mar 2025 12:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906126; cv=none; b=RkThifliXzQ5sTrC6RHD1CmKRTPM+LD7aZKBG9O5ku7GH8Rb8tTpqaWAyOAh3fOKqt9JkfbeWQeUWo8E7xHS/wP33HJYmbjNIDHcFWG7nSWLeozux7lRJWuD4lgIf6gW/wcsiyRfcYUZ03yXwmjzXbmTA3lvBqWDqm+ySVeijcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906126; c=relaxed/simple;
	bh=KzOJOF1Nz9lB0gU59DAOjny+L5kN5Qe2OprHnBMpquo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1PS1b2HCIpMZLY0ae9U7R8jJtQUVTMGuKQtvn7BMvP95pt/sfDvrEJP/98hNGauDnGB1H2BZKCwWAIq0e9lmIl92W5IOHs14Ob8MpR2QpkU7zInZTgKIQo/3uc+0JcoZlFdIUGK5GKF5x7n38ehNoijLIANWFIUiwyYuLNlG5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ws2dLz+b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ws2dLz+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5AFC4CEE4;
	Tue, 25 Mar 2025 12:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906126;
	bh=KzOJOF1Nz9lB0gU59DAOjny+L5kN5Qe2OprHnBMpquo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ws2dLz+bIpkvvokGla5BGVsvwtA5yDfAUHRHJDCR0FNEeRDxdhTzYIIuvM1FKNlmx
	 3PaYLk+l1eQ8IJM26wr4i7H8dIva5WXvQAG1KU1v5OaXAT7NEdBkLwTRzh7JF3nKpL
	 i7UswAcvTj5lwOUBIMNmMt7pcTo/O9KqHZGbUT6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 28/77] Revert "gre: Fix IPv6 link-local address generation."
Date: Tue, 25 Mar 2025 08:22:23 -0400
Message-ID: <20250325122145.090221659@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit fc486c2d060f67d672ddad81724f7c8a4d329570 ]

This reverts commit 183185a18ff96751db52a46ccf93fff3a1f42815.

This patch broke net/forwarding/ip6gre_custom_multipath_hash.sh in some
circumstances (https://lore.kernel.org/netdev/Z9RIyKZDNoka53EO@mini-arch/).
Let's revert it while the problem is being investigated.

Fixes: 183185a18ff9 ("gre: Fix IPv6 link-local address generation.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/8b1ce738eb15dd841aab9ef888640cab4f6ccfea.1742418408.git.gnault@redhat.com
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index db07d3bbaf379..8360939acf85a 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3189,13 +3189,16 @@ static void add_v4_addrs(struct inet6_dev *idev)
 	struct in6_addr addr;
 	struct net_device *dev;
 	struct net *net = dev_net(idev->dev);
-	int scope, plen;
+	int scope, plen, offset = 0;
 	u32 pflags = 0;
 
 	ASSERT_RTNL();
 
 	memset(&addr, 0, sizeof(struct in6_addr));
-	memcpy(&addr.s6_addr32[3], idev->dev->dev_addr, 4);
+	/* in case of IP6GRE the dev_addr is an IPv6 and therefore we use only the last 4 bytes */
+	if (idev->dev->addr_len == sizeof(struct in6_addr))
+		offset = sizeof(struct in6_addr) - 4;
+	memcpy(&addr.s6_addr32[3], idev->dev->dev_addr + offset, 4);
 
 	if (!(idev->dev->flags & IFF_POINTOPOINT) && idev->dev->type == ARPHRD_SIT) {
 		scope = IPV6_ADDR_COMPATv4;
@@ -3505,13 +3508,7 @@ static void addrconf_gre_config(struct net_device *dev)
 		return;
 	}
 
-	/* Generate the IPv6 link-local address using addrconf_addr_gen(),
-	 * unless we have an IPv4 GRE device not bound to an IP address and
-	 * which is in EUI64 mode (as __ipv6_isatap_ifid() would fail in this
-	 * case). Such devices fall back to add_v4_addrs() instead.
-	 */
-	if (!(dev->type == ARPHRD_IPGRE && *(__be32 *)dev->dev_addr == 0 &&
-	      idev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_EUI64)) {
+	if (dev->type == ARPHRD_ETHER) {
 		addrconf_addr_gen(idev, true);
 		return;
 	}
-- 
2.39.5



