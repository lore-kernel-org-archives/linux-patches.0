Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030289;
	b=Pz8P+KehZzNXJgpAPI3Z03nI9uch8XRUXzIwbScxH63rEBN2vXx3B3vFe2whyzP9eGjF
	 OQpOOqlD/HeNYjiXFPuCLlM4t8wCamNCx/b1bEOlk6721BoYCZpPQNXZia671yw7r+v4J
	 LlGwCVcbpINDJ1wwOFCAVADvTeLDXb/0q/M+DDPs6rSIkXbERNRKkGNupAvNJNE+iGe77
	 fIpstnbEcccSL6K/S6GOLKA/HVKl7sWS6Q8G9yogyzreNWT74a9skB2jClyXPxWlxfhXp
	 gNzlavayHho757KdtRqFFWl/Nc7KwQYlq7fZHf7OHjcPRw8CQivI98DF0XMLH7j1bRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ww3SBvrVyp7iOSzz02fVGWfAcDDlopFsz5ld0gVgUlQ=;
	b=OUGAzSMmeSIRip+Q03qX33Q+5sl+GPpN3zpdk8TAXie8RxN7UP+LCXy1KdDATbiHOZRt
	 +DQzkNnb/pjrQwi6IRRBsP83FbG1I0yAbyBD/CXxFZgXJvWfvU468BQ3ivcOKsJ/+M5FW
	 +XpWBT4n+RqkLR3euNxEtPYfOJetTTgLa9HfgXfMR432Xm+M3pD2XEBOgBPzJDVdLlJmW
	 eJoVrOUq0ULBeg7yQZ3Gxzbk6l1+62GuoOCUCO4Ai1Psv/OXCr3hijk6OoVyyz6JWZKAF
	 rUvC1rK9DueSzWvPhb2T0cdoiywGHCNWqd3aiJo54RtTif2KPdeKc7JMT7M8IlX2ECQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ao4VHUjn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883F4606A7D7;
	Wed, 18 Nov 2026 19:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ao4VHUjn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D321F000C9;
	Wed, 18 Nov 2026 19:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030289;
	bh=Ww3SBvrVyp7iOSzz02fVGWfAcDDlopFsz5ld0gVgUlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ao4VHUjn4quT91i3IYgMPAca5PUrXqEAz51fVboy6sikOTZECDNj6fCkZVqg/Thcy
	 t0JlQCfqjQCg/cxsJVya4YOyKBCGONTKxnPVER6XSQsHZhFrWICEp+zGyFRidm4P6Q
	 dt30edy+LtmRjvYeTFO/ELhjkJYUwDrsxpcqORP0=
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
Subject: [PATCH 6.12 0601/1756] hfs/hfsplus: serialize B-tree close against folio release
Date: Wed, 18 Nov 2026 15:45:28 +0100
Message-ID: <20261118150032.893178919@linuxfoundation.org>
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
index e748d92d84105..c04f0cb6ee7d7 100644
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
index 72c593308bbaa..9754ec76d9251 100644
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



