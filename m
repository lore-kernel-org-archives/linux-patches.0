Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065321;
	b=VLG85SSGM9ktCyOJN0zzlSuOISh0G4ACqlCIm03mNdU3g4RltqrHIfNcXn7FlQGfUwcu
	 rlcdyD9gMXkc32/Jh9eZQQja6m3JQ7S66kOsaFELBB7ypgRsIG4VPUc8bXeHb3n4+7o8i
	 MpNjRK4uY9kz4ISqc7QuqQNvsbi9ni8z5/E3NYlPcDX3scogpCbdXk6dkG4kPMy7h3+mv
	 BTR0tZu9xVsF6zB1CT9kpIDvqBaBvSYQ9lJbPiPGWwz6s3CmGLNVAlkwVJhYL0mRxDeJC
	 xIGoqDwMNXWfXZ24Sn5imzVawGAbhkA8XOP+Ba5f8twsLDTaZwWEhYwiWI2IxtxMRZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065321;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FeW/p02qHj5gQDY7kKOGJPb/VGl+VPDGGSGBXiaY7J0=;
	b=LWT6Vjc62k17TakDW5o6WB9A1YSacjc8O52IPgh7LA8C9EZITBLodEBUgZgU+pQ9k4dD
	 oQ/ds4dYFNrhYjmjjGdj1qNGqEGKEUv9/QaW+LKkNctL/+q+dyOb1PxRksbDSiwD1i3D9
	 vPRPMaicQ35baYbrBXt8R0qiN22XZ6mOF9shuTmXeJbUh5nwIOdv/KPpzAkwWFMWVfhdL
	 e9I4AGgElfBCXRBrf9oNNlV/1iurgIY5HjVM0jr4U3E9EozDjmpQ6agFkIqhtocRjscu0
	 BA7OBsxWaMVPHBah0MOEBDj1sHmKM1XyNAoInwmeNWR8/A0uunBsfUINH9QcAm568Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HqKvUBz7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DB7606A32D;
	Sat,  7 Nov 2026 15:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HqKvUBz7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB9F1F0089F;
	Sat,  7 Nov 2026 15:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065321;
	bh=FeW/p02qHj5gQDY7kKOGJPb/VGl+VPDGGSGBXiaY7J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HqKvUBz7iXK+UeehbtHLaCLR/XkPM0vpCKodlwzILvTx6Ieao0ly6BFaS2tu6g3WW
	 mf/GWa7V9Fw+I9O7YUj4ex4sZkLSiKMGc1LvBtyB0cJPQm/qbQp6L7+7JiYMCrGeuP
	 Rpau4CR+irn3xxWInkyC55HkHLpdy+4gRZtUwxn0=
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
Subject: [PATCH 7.3 1066/1257] ocfs2/cluster: remove zero-address nodes from IP tree on teardown
Date: Sat,  7 Nov 2026 08:56:02 -0500
Message-ID: <20261107135008.718056149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ced4fe6d3b592..91f8fcc6193f4 100644
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



