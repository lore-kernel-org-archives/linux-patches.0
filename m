Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40ABA757E1;
	Mon, 15 Apr 2024 14:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191200; cv=none; b=bDp7KdOsnT/bAMYAE/me8m6DYKLR/gepRAieFwPorTgPRn/HBjcnABjhC3pbtTmu/M305BIVrvkQQXWQhAY9TK7mF8azMZgdFVB3ShROFnlUbhZAK/1ZLpmhhNf4g0vgT+njybPt45xQEVNCxOUqbnBLWY5cZSw5VqhMHhuvI88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191200; c=relaxed/simple;
	bh=RQcc+WN/CnIDElebETgoYXnXuP8KonfI7cp3pr5XKeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VilM4BKkKyuDflJIrnoIavE5a4+xE/YARXoJpp5dpcZoJMr/WGsrZZ5TCprugkaX6LwHu+IMdnrHXIIHYFs8kGV4BUY3WN4WKJg5LcG8wtS7GHWx8F0Vbpf3yHp/bN1lUmBXaRtcYLk3dlH68KAchcDPdMSNJFI9wy7qALYQHOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c02ZeNkU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c02ZeNkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD66C113CC;
	Mon, 15 Apr 2024 14:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191199;
	bh=RQcc+WN/CnIDElebETgoYXnXuP8KonfI7cp3pr5XKeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c02ZeNkUokPzEv5YAwH9pYx8cktwuKlyj7rxR0Y9xKqC7iyXhfMJlmW3DtH0E6i4k
	 KIn5fxFqoO4qy2258w8E08v7hzukbZGiGCPSgG6TtFhtE9huvSsi1j9Id/pTNy5WfQ
	 sTgKLP0sBbuf+f635gNz5Vh7cHdVxUY/6i9YLz/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 066/172] ipv6: fib: hide unused pn variable
Date: Mon, 15 Apr 2024 16:19:25 +0200
Message-ID: <20240415142002.418461560@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 54294f6a8ec51..8184076a3924e 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1375,7 +1375,10 @@ int fib6_add(struct fib6_node *root, struct fib6_info *rt,
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
@@ -1399,9 +1402,9 @@ int fib6_add(struct fib6_node *root, struct fib6_info *rt,
 		goto out;
 	}
 
+#ifdef CONFIG_IPV6_SUBTREES
 	pn = fn;
 
-#ifdef CONFIG_IPV6_SUBTREES
 	if (rt->fib6_src.plen) {
 		struct fib6_node *sn;
 
-- 
2.43.0



