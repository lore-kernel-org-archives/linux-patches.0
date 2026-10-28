Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213237;
	b=VtLH9brJ0hMYGGt7F0YvxNxfAeGSzxft+x0wcKVhPEkElTPeD61tapq3ZmJ1dy2XOvri
	 ZZAjOidgybu2zNkU9mw5oPMrA7yyWFVgenHjFQQehvYCtSr9x6kSC0g9FvHMNRtXaZLR4
	 0Frys8PPfBMHd3sESN1W/4H9BGvp2xpMPBCQnwIdbkGRSXl3YtdRNo7PYWdJRYZu4wMjZ
	 BIJi4VdGAEJGGCNHIsGRjBeFrqj/IEe82ftLK6FInbAydlndrV6vwl+JyPtPjOqYHtYg2
	 5KsMXvzpWdGfmRNbVr9WsUyf/vadCFM2zJJ4UuZ9429AUWEEN8KzESEXfJG8Jd6F4cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213237;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2B6kaDFKTx29LYX9b95m9oZh8VskGrWFxaZjtWi74pg=;
	b=wi3zlnybXTfu+upRlpsYcijYA7P9tuISg3NYTjO7atqqbwgPyWWYFkd0ZiLzX+D+XZo4
	 ChmGvRijLg3XCj+ahTOOx6WoIl+pCAQPn+uSdfzzd18s2LfdVI4RH8UFQrSpA9d/qGErS
	 0+QpBBxkPY6s9VgeU1L59+DqRDhQmuBzX1zwgJkHKFNg5MvlCpLAwOv+dD+DFYAcMhrod
	 5juQkL8GKX6Yx2Q9DNPlCXkVYPX6SYU2o5wtxTX6fT9fzSBZ5pHqigAE6735zgIuKeugY
	 IUUAo7RAgG5u8ErONl5NJoeKIJmp9Oi0vxkLq3QosyvwocjCTlzf3MAZgIyFzhNcH8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bKdnwKvv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86151606A31A;
	Wed, 28 Oct 2026 18:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bKdnwKvv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58E81F01825;
	Wed, 28 Oct 2026 18:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213237;
	bh=2B6kaDFKTx29LYX9b95m9oZh8VskGrWFxaZjtWi74pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bKdnwKvvUgvQbdZvMHNGTen+axGsteHLPLmxhQ9tczjOL+6iLdrxIScuz+YCTA2pz
	 Q4IYl+xjS3605+9TgG6BcePEx4mvQaNvYCNW2apkf+uZpOCBFLpB4HAjGWnbYbg2Sn
	 WzFW+45RA9Dzj7upVSqOnp0zYmq+rAHR48akx/EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0433/1887] ipv6: do not warn on route notification size race
Date: Wed, 28 Oct 2026 17:42:09 +0100
Message-ID: <20261028170509.086938653@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit c97426ec649d99596d8969e1a052c16b14b7b485 upstream.

fib6_info_hw_flags_set() sizes the skb with rt6_nlmsg_size() and later
fills it with rt6_fill_node().  With nexthop compatibility mode enabled,
a concurrent replacement can grow the group between these independent
snapshots.  rt6_fill_node() can then legitimately return -EMSGSIZE, so
the warning does not prove a sizing bug.

Remove the warning.  The existing error path still frees the skb and
reports the error to listeners.

Fixes: 907eea486888 ("net: ipv6: Emit notification when fib hardware flags are changed")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/netdev/20261007114003.GA1011260@shredder/
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/4012604727e5ba80b69ccd4d08796511397ddaef.1791423190.git.4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6333,8 +6333,6 @@ void fib6_info_hw_flags_set(struct net *
 	err = rt6_fill_node(net, skb, f6i, NULL, NULL, NULL, 0, RTM_NEWROUTE, 0,
 			    0, 0);
 	if (err < 0) {
-		/* -EMSGSIZE implies BUG in rt6_nlmsg_size() */
-		WARN_ON(err == -EMSGSIZE);
 		kfree_skb(skb);
 		goto errout;
 	}


