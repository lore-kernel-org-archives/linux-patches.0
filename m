Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288751E501;
	Mon, 15 Apr 2024 14:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192269; cv=none; b=atT4Bd5kqYC4ndjhB4PGwxzptGaOxi8feXOad2yyLRnzAo6nCSCMtU+vUkTzePuxNOKR2AsJ4fjtEP4zIqLP4SyIdjZhief8B6EJ6cFfGTPipEkamPQbQGNrjbRRVtHFHJZeMHSHXTtGAVwZK3KKyoCSSmotW1zfW/BSRCOoWOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192269; c=relaxed/simple;
	bh=cMb9DXhV50etmzlVCUmijpJ+PHhEocX40ixTfp+0gG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/D9iL1pJ1iSMGb5TtEb/dsycvsE64ojOnwhN9WJfSO2k2qM+4ckDjyUhzwHcHCdhZZ6d14BZL4885WVDH7h0Kzv3EgRXDqrblsW25EzYKLw8I3p84UOlVcbzwE0xYodk3IL1H6FQF8ialSFAm8My0C52XpaEaQcuHanza2IdMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UtFwXKKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UtFwXKKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7864DC113CC;
	Mon, 15 Apr 2024 14:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192269;
	bh=cMb9DXhV50etmzlVCUmijpJ+PHhEocX40ixTfp+0gG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UtFwXKKtIoT5B3bgD8JjiFZxXMlXR9hr9ECGSlAmMtPEA67NROVNn9BArull8mj3D
	 GioQVurLsQhbjrc1GLpWYCgqCro/BDtbKEQXFYSTXg0d63jBJ6WlafojHWGFMEGNYj
	 Mm9j4g8LoR61I7vK3X/PPEOTc8+SW7ROUAZlc7wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 15/45] ipv6: fib: hide unused pn variable
Date: Mon, 15 Apr 2024 16:21:22 +0200
Message-ID: <20240415141942.699346833@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141942.235939111@linuxfoundation.org>
References: <20240415141942.235939111@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bbb9ed6d1ae6f..c0ff5ee490e7b 100644
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



