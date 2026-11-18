Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024511;
	b=dfTBG2wqifDLSujZ6NDVGRH5UI19rmwN6NQG7BF+BWgpwRHykOe2t4TB8QTOeureVRua
	 f3bY+VhQT2uqcMwvfj9F/7CglxNvFm4GAYpwmF8NXp7JU1Dpd1AhvPhfeOei+YQQKnR37
	 iKkOFL/wzWaddYhBQkAw//map2rJK2dPReJ+rMFwe+kRkLsYDrKeqL8xKKCAAfFOkRysE
	 hJ3JvqcUFqxgdRd4Guz7xFq+K/RnyoW53yiFgfOeI4nIhQaURXwT8sIsl0VTb61UaeM0L
	 btrAvsUdtV6xGStVmyQQ97zY98L5FHfs0EdO7MAc4LVBNHC8/6VdTRCXZk9TzMLUaLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q16z/AaIwHbX7VkJA3MnRX7g1MtwjahqM6hUYA/rm28=;
	b=X+hYK8aRBkl3ozqBgNCLwje5L7Uc1JEXy98xCWmftVnW4ZJ7ldiLEdDQCIox54lwTuIk
	 JhzD3vUXoRcIhoxRQ7V55Lb/Le1X5p7uVaRNpr9+leB1F98N3ddcZ7iATR72ztPiI9VP1
	 1Kh87YheS2+M0zJRHIlD8MI0tPuLP6WgVW369LFkebRSTo+nk2V5Wl0jRYrLXlYy2+NGi
	 Yx1LO2uiiLDDSVhG5TeWgUzdVBkf6c4BtpxKXBEJheAZGVZLa08o8kfnpUQgkYYqmTcl2
	 dGKur7lrzrfr6FR/RS1mtFrmPPs18h6MeiMSybQ44enc0bCn2yRRcuBzctaUzkYF2Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qQSB6EIU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6348606A31C;
	Wed, 18 Nov 2026 17:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qQSB6EIU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B561F000C4;
	Wed, 18 Nov 2026 17:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024511;
	bh=Q16z/AaIwHbX7VkJA3MnRX7g1MtwjahqM6hUYA/rm28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qQSB6EIUJsw8klSRR9GoKuc26okoahAC7vKscP3gciYpUysavWGmp7uZx6EFzj6bg
	 U028qsh7v4m17TpPORDYb9fQhlQr1gCZ5OdF9WpnIvRu3M3s3fSNFe9ic7LwaipKn1
	 vJS6dzfNO8RZAubO/z3S1viqCB8AU84RT60QQ5yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d729df28d933979e017a@syzkaller.appspotmail.com,
	syzbot+2eac7d175baf21e6a5d5@syzkaller.appspotmail.com,
	syzbot+7155b2fe09e033c91381@syzkaller.appspotmail.com,
	syzbot+adeb387cede15eb11607@syzkaller.appspotmail.com,
	syzbot+ae7f2423f3648100506d@syzkaller.appspotmail.com,
	Kyle Zeng <kylebot@openai.com>,
	Bruno Produit <bruno.produit@trailofbits.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0752/2151] hfs/hfsplus: serialize B-tree close against folio release
Date: Wed, 18 Nov 2026 15:41:27 +0100
Message-ID: <20261118150149.418386388@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bruno Produit <bruno.produit@trailofbits.com>

[ Upstream commit dce0e0248205bb3dc5b4c6793cd2ecb453152259 ]

B-tree nodes with a zero reference count remain in the node hash until
folio reclaim or tree teardown frees them.  The folio release callbacks
remove nodes while holding hash_lock, but hfs_btree_close() walks and
frees the same hash without that lock.  Reclaim can therefore unhash and
free a node after close has loaded its pointer, causing a use-after-free
or double-free.

The following syzkaller crashes seem to be the same UAF in
{hfs,hfsplus}_btree_close() (or {hfs,hfsplus}_bnode_unhash()) and follow
the same pattern, but do not contain a reproducer to confirm.

Detach each node with hfs_bnode_unhash() while holding hash_lock before
inspecting and freeing it.  Drop the lock before hfs_bnode_free() so a
large tree is not freed while holding a spinlock.  Apply the same fix to
the matching HFS+ implementation.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+d729df28d933979e017a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d729df28d933979e017a
Reported-by: syzbot+2eac7d175baf21e6a5d5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2eac7d175baf21e6a5d5
Reported-by: syzbot+7155b2fe09e033c91381@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7155b2fe09e033c91381
Reported-by: syzbot+adeb387cede15eb11607@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=adeb387cede15eb11607
Reported-by: syzbot+ae7f2423f3648100506d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ae7f2423f3648100506d
Assisted-by: Codex:gpt-5.6-sol
Reported-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Bruno Produit <bruno.produit@trailofbits.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Tested-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20260921153729.600313-1-bruno.produit@trailofbits.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfs/btree.c     | 7 +++++--
 fs/hfsplus/btree.c | 7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/hfs/btree.c b/fs/hfs/btree.c
index b8be01809b631..7c2872f1f6c69 100644
--- a/fs/hfs/btree.c
+++ b/fs/hfs/btree.c
@@ -180,15 +180,18 @@ void hfs_btree_close(struct hfs_btree *tree)
 		return;
 
 	for (i = 0; i < NODE_HASH_SIZE; i++) {
+		spin_lock(&tree->hash_lock);
 		while ((node = tree->node_hash[i])) {
-			tree->node_hash[i] = node->next_hash;
+			hfs_bnode_unhash(node);
+			spin_unlock(&tree->hash_lock);
 			if (atomic_read(&node->refcnt))
 				pr_err("node %d:%d still has %d user(s)!\n",
 				       node->tree->cnid, node->this,
 				       atomic_read(&node->refcnt));
 			hfs_bnode_free(node);
-			tree->node_hash_cnt--;
+			spin_lock(&tree->hash_lock);
 		}
+		spin_unlock(&tree->hash_lock);
 	}
 	iput(tree->inode);
 	kfree(tree);
diff --git a/fs/hfsplus/btree.c b/fs/hfsplus/btree.c
index 229f25dc7c49c..28bf3692691dc 100644
--- a/fs/hfsplus/btree.c
+++ b/fs/hfsplus/btree.c
@@ -265,16 +265,19 @@ void hfs_btree_close(struct hfs_btree *tree)
 		return;
 
 	for (i = 0; i < NODE_HASH_SIZE; i++) {
+		spin_lock(&tree->hash_lock);
 		while ((node = tree->node_hash[i])) {
-			tree->node_hash[i] = node->next_hash;
+			hfs_bnode_unhash(node);
+			spin_unlock(&tree->hash_lock);
 			if (atomic_read(&node->refcnt))
 				pr_crit("node %d:%d "
 						"still has %d user(s)!\n",
 					node->tree->cnid, node->this,
 					atomic_read(&node->refcnt));
 			hfs_bnode_free(node);
-			tree->node_hash_cnt--;
+			spin_lock(&tree->hash_lock);
 		}
+		spin_unlock(&tree->hash_lock);
 	}
 	iput(tree->inode);
 	kfree(tree);
-- 
2.53.0



