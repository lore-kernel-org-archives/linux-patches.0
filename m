Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA13E7464;
	Tue, 30 Apr 2024 10:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474704; cv=none; b=mp0wmfz/cW7E7G+Kk/cUeLpIpfAplj/j0FcgjQNadQrBgJK/bMZvy0tR0DHMmHgWGJxqlcZ6xEw5QAog0aRNRIOGuBP9f5kYFhyxc1Qqlcs8jayIdex8rRUKCTdkbLX7iiDHLjtZDzINHsZ69ioUv2epMqrFbeM8krfpwsogyU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474704; c=relaxed/simple;
	bh=SCRCmc9iv0El1vUKO1fTXmCmBxRfM7bLYBkwrk4j2ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPp3b/FX6Kk68wyG4NrlM5Gp8XqjQtHQAWlqH00zw1ztiDagIGADrXUe3KXLGky5XoFDtbOgGBo3P0Rqvnea1DB3T28STKL7JkJcxcncfEajfIFBKPvBdOjER3O9129US6pusCGYO+g88gD4P9VWhT6l5HE5jSUKXHG1HMeQgYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SYsB/PVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SYsB/PVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59681C2BBFC;
	Tue, 30 Apr 2024 10:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474703;
	bh=SCRCmc9iv0El1vUKO1fTXmCmBxRfM7bLYBkwrk4j2ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SYsB/PVlEGRF9NdkZZQf8InAsI6cKfuqi7lOKWOzejyXGoPVgkqhxxGR65FEzdKPK
	 mqEo+QIo3mXJIW7+LPfoi0fnsaGlZxDHyJNl2Uow1EIYKNjNTLmcx8At7NOEOcAZgY
	 YYoPxKCksAKHzjCdIF6aWK8dkq4jB8Ys8Nn5Re0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/138] ipv6: fib: hide unused pn variable
Date: Tue, 30 Apr 2024 12:38:15 +0200
Message-ID: <20240430103049.729902832@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 74043489fcb5e5ca4074133582b5b8011b67f9e7 ]

When CONFIG_IPV6_SUBTREES is disabled, the only user is hidden, causing
a 'make W=1' warning:

net/ipv6/ip6_fib.c: In function 'fib6_add':
net/ipv6/ip6_fib.c:1388:32: error: variable 'pn' set but not used [-Werror=unused-but-set-variable]

Add another #ifdef around the variable declaration, matching the other
uses in this file.

Fixes: 66729e18df08 ("[IPV6] ROUTE: Make sure we have fn->leaf when adding a node on subtree.")
Link: https://lore.kernel.org/netdev/20240322131746.904943-1-arnd@kernel.org/
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240408074219.3030256-1-arnd@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_fib.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index d70783283a417..b79e571e5a863 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1373,7 +1373,10 @@ int fib6_add(struct fib6_node *root, struct fib6_info *rt,
 	     struct nl_info *info, struct netlink_ext_ack *extack)
 {
 	struct fib6_table *table = rt->fib6_table;
-	struct fib6_node *fn, *pn = NULL;
+	struct fib6_node *fn;
+#ifdef CONFIG_IPV6_SUBTREES
+	struct fib6_node *pn = NULL;
+#endif
 	int err = -ENOMEM;
 	int allow_create = 1;
 	int replace_required = 0;
@@ -1397,9 +1400,9 @@ int fib6_add(struct fib6_node *root, struct fib6_info *rt,
 		goto out;
 	}
 
+#ifdef CONFIG_IPV6_SUBTREES
 	pn = fn;
 
-#ifdef CONFIG_IPV6_SUBTREES
 	if (rt->fib6_src.plen) {
 		struct fib6_node *sn;
 
-- 
2.43.0



