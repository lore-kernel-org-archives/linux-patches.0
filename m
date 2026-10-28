Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211351;
	b=UvygV614pVDxp08+BgfGSEXNoAOEZickeHd0v3qcwrr1/dUWn6dJO8CopY30bSHKIjsa
	 P5PyA6nWMmRrbo5z3ttlFoL5j/gVCZJ27yy6AE5D7LGxNQCypvXk5TklUAmRs9i0ZRaoT
	 8laHQ3gXNVbGWo9tbE3Cg2YZId6hGT9l/eCB8y91azUTDV8wHYrvaei+AH01ExryswE5o
	 RrXMzi4Jz1WnVJ0AUvrjTk0s1XyDCTsTK0BlPxmAk04E6EgSx3/izeA1V5jPbEl5GOE1C
	 2bAei96N116CaKb6UtlozyhkaYjoFdj0gWfB4SeDTnNTrPfPMH4pG/jTkdkrsA7mUmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kmgJXrYJr3AaoiJvdeVL9jM3ounko4K0gGpIBHk0XHY=;
	b=3qIFk84DSrLxdxKMLr0AmAai17OubjWY78qFpcPy93MOWELwZsj8e3Lz23P0BRyA1why
	 BGi7QZFJqXXYYX67UCqoj9n1zutGc5kUjz/JgjxwVsldZ7OjNUqH2O5aFk6zMN18epjJq
	 B7La0ptBc/zrC+1JvoSCoUp/fvl53vo9LCK5Qh2gZbXjIVnmYRgcBbVJ/kahtGXqvXx09
	 KQnmoLDAL1uBajVLW3QnSPmlRaRE6gJevBV12JGWTLnYtASQOQZ45QkUm9UGiXKFnmcIU
	 2jOIrZsaJ+CMPsObqk6BJuYiyVxAFqawerv4YRvgolNiGXSfwSU24wWSv5dceQbt1pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A0Rr7Ydd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8923606A32A;
	Wed, 28 Oct 2026 18:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A0Rr7Ydd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261AC1F01825;
	Wed, 28 Oct 2026 18:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211350;
	bh=kmgJXrYJr3AaoiJvdeVL9jM3ounko4K0gGpIBHk0XHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A0Rr7Yddu5D86igbxng0dutA4ownx/SR/s6rSw2rhKFSAitUfg0LW4uUycI+Z6fxs
	 m9o8k8g3KgbP8BMgKONTCCghzCX5YJz11lb5pgvjOvNQTQNXid/qMLq3/9nUqaAUeT
	 ACrqPiO/Ex2I0KxD1td5VinCRm6+mHNMnpzi3xm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 346/571] ipv6: do not warn on route notification size race
Date: Wed, 28 Oct 2026 17:58:13 +0100
Message-ID: <20261028170016.226916546@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
@@ -6270,8 +6270,6 @@ void fib6_info_hw_flags_set(struct net *
 	err = rt6_fill_node(net, skb, f6i, NULL, NULL, NULL, 0, RTM_NEWROUTE, 0,
 			    0, 0);
 	if (err < 0) {
-		/* -EMSGSIZE implies BUG in rt6_nlmsg_size() */
-		WARN_ON(err == -EMSGSIZE);
 		kfree_skb(skb);
 		goto errout;
 	}


