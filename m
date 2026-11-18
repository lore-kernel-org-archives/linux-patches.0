Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058825;
	b=oFJ2BZnesaCkHyOysHE4HdqOBR1C5CfIE6esKOkXWVRUfrhn1mT68KnUvrMsd+U7VH1P
	 we4DxSA7N/XAS6z+t8H7l/ZdUi29COp/Tsma5faN6owRdZ80cY1K4dWW/pfOPyXJZ6RHA
	 qkL3B7OfLt4uR0xuncnoKzZktdlLz8Umj7pJ2cjSrmHNnOqR/DF3VH2kLUg10JjjxlBmP
	 n33wRKuWPJfhjot7AWXR4K06ZFbPhJuPTKMbHbi2tebDMTIpdEB7iTPAeFvguMbwDLTIj
	 BxwI3H3GrWA3xVntVHX+OLWLToFjSV0wzltAG+bM1Mu/TfhyXNbYN55wraXiWgtRHWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ICGNUzJKG+O8FfHF8FsQFABid+3p+JlgvDR/sVcMhsM=;
	b=2gs38T7au0jNsH8YxKqxKg+TgSpTWzszeWwXtEfCX87Y0gAFRWhPK0q2XXLMyX/FGA9E
	 FyytrhVVy6y5uRJdZRHDAp8VkgcvlQSpQV8SjSqr7JHQq+YQ4SnAXoyhnB+2ihdZIWTHQ
	 6DCfOXMN1EB/PO0oPe589nSnfxjyvFescXiYTV6RFBCMDpJHzXwDQ3R/jr/vs9/Gn4QOD
	 lLnPQYi/KJuLOubG+zVl7QGaT4U7QlQyiaLLx9ub5luzWOC8QWRhOPBs+w1tAWVLuXjGM
	 C1Tg87rZQLoD5LJwlQUQdsvFVpWetefWfU4C0scuNWLQpOhoJa69QfW26aTIPUR3TTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kLn6id0I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED479606A31C;
	Thu, 19 Nov 2026 03:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kLn6id0I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E791F000C4;
	Thu, 19 Nov 2026 03:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058824;
	bh=ICGNUzJKG+O8FfHF8FsQFABid+3p+JlgvDR/sVcMhsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLn6id0IgBk5UBPFHabvIqs+ALm0S97b2KLtW/sOFGsWUGOY6mCNAyiyoBtsaZ21n
	 jlT9XBh8FuU0Dzn0kLk7LBoZ76wiku9bUmilDCh0djt23nLzuatoHCP/SjgDp9q3Sr
	 hfNt8lC7buBTQ3L6oBTTExqCppOVRU0cl458r7D4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	jjzuming@gmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0572/1848] ocfs2/cluster: remove zero-address nodes from IP tree on teardown
Date: Wed, 18 Nov 2026 15:43:30 +0100
Message-ID: <20261118145939.045681334@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 5dd57e77eff4ba3e85b3df126a55417c88245708 ]

o2nm_node_ipv4_address_store() accepts 0.0.0.0. It sets
O2NM_NODE_ATTR_ADDRESS and links nd_ip_node into cl_node_ip_tree under
cl_nodes_lock, but o2nm_node_group_drop_item() uses nd_ipv4_address as a
membership test. A zero address therefore leaves the rbtree node linked
when config_item_put() releases and frees struct o2nm_node. A later
address store or IP lookup can then walk the stale node and dereference
freed memory.

During teardown, drop_item takes cl_nodes_lock, skips rb_erase()
for the zero key, and then calls config_item_put(). A later
o2nm_node_ipv4_address_store() duplicate check or o2nm_get_node_by_ip()
lookup takes the same lock and walks the stale cl_node_ip_tree entry. Use
O2NM_NODE_ATTR_ADDRESS for teardown so every published nd_ip_node is
erased before configfs can release the node, without rejecting 0.0.0.0
or changing lookup semantics.

Link: https://lore.kernel.org/pm-ocfs2-node-ip-rbtree-zero-address-uaf-v5-e7f64be16b7c3b0988d1@gmail.com
Fixes: 0c83ed8eeb28 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/cluster/nodemanager.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index ca4dc8aa0e5b1..651b43033f4f6 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -627,8 +627,11 @@ static void o2nm_node_group_drop_item(struct config_group *group,
 
 	write_lock(&cluster->cl_nodes_lock);
 
-	/* XXX sloppy */
-	if (node->nd_ipv4_address)
+	/*
+	 * 0.0.0.0 is a valid configured address, so nd_ipv4_address does
+	 * not tell us whether nd_ip_node was published in the IP tree.
+	 */
+	if (test_bit(O2NM_NODE_ATTR_ADDRESS, &node->nd_set_attributes))
 		rb_erase(&node->nd_ip_node, &cluster->cl_node_ip_tree);
 
 	/* nd_num might be 0 if the node number hasn't been set.. */
-- 
2.53.0



