Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10932676EB;
	Tue, 25 Mar 2025 12:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905797; cv=none; b=uAJFOUbSfOlCKQJaItt1401CMwdGL8TTyY6lrIW/f+U9i8HwwcPIII5nW6QPFasliM0mpDzt7r6vqUxOcbYG+6AGlVDdO1hHs9qDVZVj5ALw6Ya+Czbiy+p/bm/lkU1hDTmb2CmcB6mSUClir5x2VYq9nCQFuzaK4UCiBE2RupM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905797; c=relaxed/simple;
	bh=xIWC0/sm9Z8JjvwGvu4KDrdTN5IaqJcD8FckwfZjD2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQvTvTdWKCwC/aOK54arJBRdyOyQBQfzBsQ3zgJhyy5kUSwQvS3+OwQ22YKu5/vebV8IVGAYvu1DNYInuTWSsHV2566NdnJhHjDtwS3ImDybLJTAq+sh/XLvv1H2kY+ToRMrLG4LtA1fVXo/BLXBXcNnrzfMS1f7JgiAJnj9ZxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/8aRf0i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/8aRf0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DA0C4CEE4;
	Tue, 25 Mar 2025 12:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905796;
	bh=xIWC0/sm9Z8JjvwGvu4KDrdTN5IaqJcD8FckwfZjD2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/8aRf0iuTroVBnFTq0KaNXEkwAX0oyANee1ZejFndH7XVzKmLROrKVxlJzTrTQSy
	 98uxt4g7Fuc+ZAptXB1zPvMBhcClmmUFGFhlmxVFD8xI8qw+UrCdSFSUuQO00llKu9
	 Q1QmeXNp1Ad4ZRsYqahCXGR4PVCKMaXfOVFcv2yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 167/198] Revert "gre: Fix IPv6 link-local address generation."
Date: Tue, 25 Mar 2025 08:22:09 -0400
Message-ID: <20250325122201.029621073@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 69fb4d7c9c98e..f52527c86e71c 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3162,13 +3162,16 @@ static void add_v4_addrs(struct inet6_dev *idev)
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
@@ -3478,13 +3481,7 @@ static void addrconf_gre_config(struct net_device *dev)
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



