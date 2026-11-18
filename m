Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054371;
	b=rtfeiAvCWAqpWav+uwIb6zKEJMtNe2rvP5kAIsa28pK1BG5wq5OmE69syfHvZmaOcWhF
	 MSKunMmO7Bm8YebniQgL7nR39LYFOEVIceSHjwkkO0t9Ebo4ATnvccBgzUi98rsp+LKVS
	 9Vv9GKID1KPg5S7zHUP6mnQdV2FfyDAZlXvLAXO9zO1qoouziepVgXoy2IJ1kimw48YY7
	 CXm5H3J13Fl4l7iukMmv4VXn8fnI234N7HAvPy45M0unkIP1OfHVmu1nBBmnNmyUry7pr
	 MszlCSzLOcYqC87v8LSCGcdDZHO5+sJMM7D1OYKOUJ92TStWosqw9607fAYu2hM21GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QRls/vm5ZB3w63M7rtBsf4AFRfLkXqaiFjk2P4NRczU=;
	b=18flqTd/fBZ4HkaVCYzxO+pL1lxCJd9owcA0R14fJRF6aI7o4JvrJXJ38D8D1R3vmBl0
	 TF4rHEqB7pygPz6RdiOnZJfPw+SE0IIoUQak1Q0dw5f5KMNpaRUaP1Tku9Fh/D6slTLiZ
	 gcRWKVtSOKhIgP8F+eTdzjHTc7aG/Hom1ZjaF4K2TBFN8wlcwo8AABoA1czVjCBGgoWD1
	 ZXnRkubehoSpxTP39EuNAxUwJ4MI35bCRy79PtPsWO5nXSBTXEe9JT0EGHVFqi8EfqEZ/
	 QBy3q0LukL0Fb/xHp7q/cqsmdNNThYg12Kd5VAu90wDAEflAVHc7hIqsxLQTDKh0o9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UcQbIDVH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55399606A31C;
	Thu, 19 Nov 2026 02:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UcQbIDVH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647C31F000C4;
	Thu, 19 Nov 2026 02:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054370;
	bh=QRls/vm5ZB3w63M7rtBsf4AFRfLkXqaiFjk2P4NRczU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UcQbIDVH0nwLEV6siu/v/Zojrou+Sd+ORc1nkc2gRHEvIPz23PZKAMyCWPsKmRmxt
	 HklrcHpQUVqa9nuBkl5SjJoOcxTKVAI5Rok/wfuucpK9NipJRE24fKJJwPP62e+dCq
	 GDMNqHSZEgOImScZNvrD6sFcrbABtfzwH47cFZ6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ollrogge <nils-ollrogge@outlook.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1209/2214] assoc_array: dont chain a new shortcut onto an existing one
Date: Wed, 18 Nov 2026 15:48:05 +0100
Message-ID: <20261118150100.192705216@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 48691075b0adc590a6831390723e3603dfca76fc ]

When a full node's leaves and the new key all share the node's segment,
assoc_array_insert_into_terminal_node() replaces the node with a
shortcut to a pair of new nodes.  If the node is itself the target of a
shortcut, the new shortcut is installed as that shortcut's next node,
and a shortcut leading to a shortcut is something nothing expects:
assoc_array_walk() indexes the second one as a node, and
assoc_array_apply_edit() hits the BUG_ON() in the loop that adjusts
nr_leaves_on_branch, on that same insertion.

Deletion gets a node there.  When the subtree below a shortcut shrinks
enough, assoc_array_delete() collapses it into one node below the
shortcut, and the leaves it collects can all share that node's segment.
The next key that shares it too takes this path.  Eighteen insertions
and a deletion are enough: sixteen keys that agree on bits 0-11, one
that leaves them at bit 8 and is deleted again, and one more that agrees
with the sixteen.

Have the new shortcut replace the one in front of the node as well.
assoc_array_insert_shortcut() gives it that shortcut's back pointer and
parent slot, so the caller installs it where that one was, and excises
the old shortcut along with the node, which takes a second entry in
excised_meta[].  The new shortcut's index key comes from the new key up
to the new skip level, so it covers what the old one did.

Found by a userspace test doing random insertions and deletions on keys
that share long prefixes; a targeted case builds a shortcut, deletes
down to the collapse and inserts one more key.

Fixes: 3cb989501c26 ("Add a generic associative array implementation.")
Reported-by: Ollrogge <nils-ollrogge@outlook.de>
Assisted-by: LLM
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: David Howells <dhowells@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/assoc_array_priv.h |  2 +-
 lib/assoc_array.c                | 24 ++++++++++++++++++++----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/include/linux/assoc_array_priv.h b/include/linux/assoc_array_priv.h
index dca733ef67503..37a9f76e1505b 100644
--- a/include/linux/assoc_array_priv.h
+++ b/include/linux/assoc_array_priv.h
@@ -80,7 +80,7 @@ struct assoc_array_edit {
 	struct assoc_array_ptr		**leaf_p;
 	struct assoc_array_ptr		*dead_leaf;
 	struct assoc_array_ptr		*new_meta[3];
-	struct assoc_array_ptr		*excised_meta[1];
+	struct assoc_array_ptr		*excised_meta[2];
 	struct assoc_array_ptr		*excised_subtree;
 	struct assoc_array_ptr		**set_backpointers[ASSOC_ARRAY_FAN_OUT];
 	struct assoc_array_ptr		*set_backpointers_to;
diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index ddab703561875..0a210e12d18e9 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -679,9 +679,10 @@ static void assoc_array_split_node(struct assoc_array_edit *edit,
 /*
  * All the leaves, new and old, want to cluster together in this node in the
  * same slot, so we have to replace this node with a shortcut to skip over
- * the identical parts of the key, leading to new_n0.  The caller then splits
- * the leaves between new_n0 and new_n1 at the shortcut's far end, for which
- * this fills in the segment cache.
+ * the identical parts of the key, leading to new_n0.  If the node is the
+ * target of a shortcut, the new one replaces that shortcut as well.  The
+ * caller then splits the leaves between new_n0 and new_n1 at the shortcut's
+ * far end, for which this fills in the segment cache.
  */
 static struct assoc_array_shortcut *
 assoc_array_insert_shortcut(struct assoc_array_edit *edit,
@@ -726,6 +727,20 @@ assoc_array_insert_shortcut(struct assoc_array_edit *edit,
 
 	new_s0->back_pointer = node->back_pointer;
 	new_s0->parent_slot = node->parent_slot;
+
+	/* A shortcut has to lead to a node, so a node at the end of a shortcut
+	 * is replaced together with that shortcut.  The new one holds the index
+	 * key from the root, so it covers what the old one did.
+	 */
+	if (node->back_pointer &&
+	    assoc_array_ptr_is_shortcut(node->back_pointer)) {
+		struct assoc_array_shortcut *above =
+			assoc_array_ptr_to_shortcut(node->back_pointer);
+
+		new_s0->back_pointer = above->back_pointer;
+		new_s0->parent_slot = above->parent_slot;
+		edit->excised_meta[1] = node->back_pointer;
+	}
 	new_s0->next_node = assoc_array_node_to_ptr(new_n0);
 	new_n0->back_pointer = assoc_array_shortcut_to_ptr(new_s0);
 	new_n0->parent_slot = 0;
@@ -807,7 +822,8 @@ static bool assoc_array_insert_into_terminal_node(struct assoc_array_edit *edit,
 		/* The node only contains leaves and all the leaves cluster in
 		 * the same slot, so we need to insert a shortcut to skip the
 		 * common portion of the key and split the node at the
-		 * shortcut's far end.
+		 * shortcut's far end.  The shortcut goes wherever its back
+		 * pointer says, which may be further up than the node.
 		 */
 		new_s0 = assoc_array_insert_shortcut(edit, ops, index_key,
 						     node, level, new_n0);
-- 
2.53.0



