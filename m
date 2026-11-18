Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032984;
	b=WWNkGDFy2Z3Hw7aBmqQ220ud5j1anM9kvA0ToMX8fDd5eZYfYHKudXaJMOwuoqapFfE7
	 a3lfcU+Xye0+GzcSHFVU+noZlN6aQMQoPz+hejBEZMqPfeYfd/0Y20wu5tigbWVGXsPcw
	 od56oyf/x7JEaxIufquZ+VRMz1GNr795eGcnjtu1xEDTbb0q2ci8tjW65rVthEnI4dK5j
	 f9vkLQViYqjX/ZtHTh+j2R8udQZgIgnNze++eYLguBS/Gms1OeoQA78hGLTEFtGbVQtnO
	 8i/s+sguVz+tRStSeglmhXesTAiPaa4YHd4P/DZogYyVl4Tr8V+yDU+q1Rud6BENiYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032984;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wJNoWq+NlqA2WIoKjeHDQ/n0duvM0/U465Pc0EEDNsM=;
	b=WTivbqclOiaI9Y0e6jtj9SX8R70rdz+ALndtIw0caFC3EJRlUFz/GLHI1VsKy9hCdXgE
	 zdyIxwrWzhvTuDuMW5b2zkqpRZBqEsG/LRzBi1NfuXjL2SCCVNSXuA/Ym7Z7BzsDeaOwr
	 ebYAygOwUhdGIJE9kXz+mCZ2k21ApipgXc3jc+Aab/Jj2dyVtSqu6QArFvPeaiJsdur2Z
	 2KGUEdkvqmufNNwelW6F3eJxmwn5FVwDDkLOQMeeT+3L8Xnvs043oH/pHDuopSbFGF37h
	 +d+I03NSQkxdS+iW2+exV3znn5QcLPfb9jvuqkrrqAJaZ2n4ncghSLxvycZ6NGoHPQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CyxMrq0K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99734606A31C;
	Wed, 18 Nov 2026 20:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CyxMrq0K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41FA1F000C4;
	Wed, 18 Nov 2026 20:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032984;
	bh=wJNoWq+NlqA2WIoKjeHDQ/n0duvM0/U465Pc0EEDNsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CyxMrq0KHEmCFv/kea5kUK/XRuz0QJA1WCyITBq01JKs2vrJVjy5dvkXpMWU7FzzT
	 JJxdAxBFzIgw25x8KRqqFEqK70cgY53gQHSY7OmWExFOHrlUnalhOwfCFkXnEe4g6L
	 6lVP/kFNN/2Rp8SV113IYLxInR2M/lZJkIpb9VVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1555/1756] maple_tree: Use kfree_rcu in ma_free_rcu
Date: Wed, 18 Nov 2026 16:01:22 +0100
Message-ID: <20261118150111.092112123@linuxfoundation.org>
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

[ Upstream commit 9b60811cb3b42fe9a8e3f0aa3e007cd9cc814a78 ]

kfree_rcu is an optimized version of call_rcu + kfree. It used to not be
possible to call it on non-kmalloc objects, but this restriction was
lifted ever since SLOB was dropped from the kernel, and since commit
6c6c47b063b5 ("mm, slab: call kvfree_rcu_barrier() from kmem_cache_destroy()").

Thus, replace call_rcu + mt_free_rcu with kfree_rcu.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Stable-dep-of: baed735a956f ("maple_tree: fix maple_range_64 crashes in RCU mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/maple_tree.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index c7e3f91fd91c6..41fb935134917 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -179,13 +179,6 @@ static inline void mt_free_bulk(size_t size, void __rcu **nodes)
 	kmem_cache_free_bulk(maple_node_cache, size, (void **)nodes);
 }
 
-static void mt_free_rcu(struct rcu_head *head)
-{
-	struct maple_node *node = container_of(head, struct maple_node, rcu);
-
-	kmem_cache_free(maple_node_cache, node);
-}
-
 /*
  * ma_free_rcu() - Use rcu callback to free a maple node
  * @node: The node to free
@@ -196,7 +189,7 @@ static void mt_free_rcu(struct rcu_head *head)
 static void ma_free_rcu(struct maple_node *node)
 {
 	WARN_ON(node->parent != ma_parent_ptr(node));
-	call_rcu(&node->rcu, mt_free_rcu);
+	kfree_rcu(node, rcu);
 }
 
 static void mas_set_height(struct ma_state *mas)
@@ -5301,7 +5294,7 @@ static void mt_free_walk(struct rcu_head *head)
 	mt_free_bulk(node->slot_len, slots);
 
 free_leaf:
-	mt_free_rcu(&node->rcu);
+	mt_free_one(node);
 }
 
 static inline void __rcu **mte_destroy_descend(struct maple_enode **enode,
@@ -5385,7 +5378,7 @@ static void mt_destroy_walk(struct maple_enode *enode, struct maple_tree *mt,
 
 free_leaf:
 	if (free)
-		mt_free_rcu(&node->rcu);
+		mt_free_one(node);
 	else
 		mt_clear_meta(mt, node, node->type);
 }
-- 
2.53.0



