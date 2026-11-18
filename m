Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032865;
	b=hF/fm8VZelnhYJyc8hVnxEyAJD3uwSbO34ujA4+OguiZbsMaHyo8homd1rSN44soIXxW
	 2A6oBRjA4phfkNanO0nyN6ESY+dlOH+dy0vTtLbxQA2N7NaxsEdLRi9K08taa+8gIFwnM
	 8tQKRSHEIfz7Hte8fIIfpakNDhUtaZ2Qbh++BdtOAD+0XqPPZEFTlNKaehq/7iV1tyKKJ
	 p6lXQGLi4llCZw4JE0vHID6ZVSLt3NnYc0DGekTnRVH4mgPjmqb4TeW4WV3xyWtNnQDBq
	 E3StnFVgTAgeoWX5rxhMYv+GnQDXq8JeNNMxdt9IvAqTYOz2heMb/keByBG73ltCLCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zq9DPYQzPNHoAx1CGsA7ez624AHYfu292TA1FEGOE+8=;
	b=WLZzy6uxEvZy8R4mKuU7+ldYJ7rxuUR++JdSApzWPI+EwR/J/omJ7Bc+0yvq18czy2lo
	 H/ZV+zq32N28S/Fp3YqYFM0BS/Gu/uszNIk9gED2QLGLZYMz6JPw/BMceIl+dcPut1zuY
	 spXVo9+uL7wo2UF2v3gAwEvzZUx/naJ9dlHI4DxF/97ltybGfyvibpTvWnvMjqkEyVsq7
	 47p+jGqsDnq2QfnfHc3ZGxAn16AuditnIbn6GVdR8B0UeaLWKY6fQKM9TqQqS7GajaYkX
	 1uIWZ4ra95fiM9UaGG5JmcT0vLCfgc4baqiqmxPIQ9bRUkcRW11SGQ//RhLK/3+cR0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VRGRWW3v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2E460A261A;
	Wed, 18 Nov 2026 20:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VRGRWW3v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3623A1F000C4;
	Wed, 18 Nov 2026 20:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032864;
	bh=Zq9DPYQzPNHoAx1CGsA7ez624AHYfu292TA1FEGOE+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VRGRWW3vvHBCB3NeZUM7AEgFQDMwve6cVjVGAxgDzDvDoVTbwXn7aw+RJOHtwMNxA
	 Plex56BapP1KhpR4iifF1tjb04AggUvI3mB+ZLI9NlznwEauTdjpZypORWxGlyOnJB
	 PTKcLFWVd0L7Cx+2t7j1LLdy43WTAvDYGP/3D8p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1556/1756] maple_tree: Replace mt_free_one() with kfree()
Date: Wed, 18 Nov 2026 16:01:23 +0100
Message-ID: <20261118150111.175787046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Falcato <pfalcato@suse.de>

[ Upstream commit 025f93101bb4e0a0cdc0fc4ee264f7905271ad75 ]

kfree() is a little shorter and works with kmem_cache_alloc'd pointers
too. Also lets us remove one more helper.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Stable-dep-of: baed735a956f ("maple_tree: fix maple_range_64 crashes in RCU mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/maple_tree.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 41fb935134917..f18c06c23a0ed 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -169,11 +169,6 @@ static inline int mt_alloc_bulk(gfp_t gfp, size_t size, void **nodes)
 	return kmem_cache_alloc_bulk(maple_node_cache, gfp, size, nodes);
 }
 
-static inline void mt_free_one(struct maple_node *node)
-{
-	kmem_cache_free(maple_node_cache, node);
-}
-
 static inline void mt_free_bulk(size_t size, void __rcu **nodes)
 {
 	kmem_cache_free_bulk(maple_node_cache, size, (void **)nodes);
@@ -5294,7 +5289,7 @@ static void mt_free_walk(struct rcu_head *head)
 	mt_free_bulk(node->slot_len, slots);
 
 free_leaf:
-	mt_free_one(node);
+	kfree(node);
 }
 
 static inline void __rcu **mte_destroy_descend(struct maple_enode **enode,
@@ -5378,7 +5373,7 @@ static void mt_destroy_walk(struct maple_enode *enode, struct maple_tree *mt,
 
 free_leaf:
 	if (free)
-		mt_free_one(node);
+		kfree(node);
 	else
 		mt_clear_meta(mt, node, node->type);
 }
@@ -5604,7 +5599,7 @@ void mas_destroy(struct ma_state *mas)
 			mt_free_bulk(count, (void __rcu **)&node->slot[1]);
 			total -= count;
 		}
-		mt_free_one(ma_mnode_ptr(node));
+		kfree(ma_mnode_ptr(node));
 		total--;
 	}
 
@@ -6638,7 +6633,7 @@ static void mas_dup_free(struct ma_state *mas)
 	}
 
 	node = mte_to_node(mas->node);
-	mt_free_one(node);
+	kfree(node);
 }
 
 /*
-- 
2.53.0



