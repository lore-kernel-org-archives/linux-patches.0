Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590726;
	b=sj0Cm1iTtKdD8+1hcErLAmn64sFTm5kg/4GvuN2gbAfCC+ZUz3jTYtOV3BM9LZFaa2Uy
	 QoWGUNlCPB4rQPhMwnGSbgG+i8lkA6Ov19ND7JskacjNEgmK/KN9KiUcjvFjJzHlL1YL6
	 B0GBrNtXVMxAqG0E9TrkXj9SoebOEcy4GL49TsnV3FnGf+0WIWTUTGTE5FPMkz2OUkhfb
	 qmEIxascDfSXQzf8vd4yjv3wLkCPLPfGVOx+SnF65frVEaQokWJzzN57nZnKwV8Z7Onx8
	 YtEauG8lufJlzrqYn4XraFKcfLvFHyKfkk9sRxqbyRfcDACNrIFVPImbrlW6MQh1nNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yvr3gZ3jepReSmZeE8UW6cK/yVX6m2/g1lZ4NtCY6l4=;
	b=44VIZMXkOpW90Udy997k5M6Iwbrny6h1CGi94qHBjaX4+7Zg5gxLj5W2cz3Hs9OtykOY
	 UWRGQqJnxIqcPGyO2vA9m+4GL/09nxhippXrN2BCoejD57VwwLNNx86rch+wvM3xqvAJl
	 tIu7ClrCCkueOobaMzkqDCIniRhdyMwuvlr6Yy27QwmAqjCB2GVeorQ4VaYHVWKTa4+eQ
	 yhhL10F2hC7vqllMjOaIerb3MVIJytcBw6ViFn38zH1cXGq3VGo8CFkMj8A8T+w+QZllG
	 lBAZtkutJGhWIuQW8f6V+MAU+Xs5b5I8CorEPb2sbQZB5pxDpcTe9Ps+nbpZykGLgng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=btXRvCN0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366ED607A5FC;
	Fri, 13 Nov 2026 17:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=btXRvCN0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BF71F000C4;
	Fri, 13 Nov 2026 17:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590725;
	bh=Yvr3gZ3jepReSmZeE8UW6cK/yVX6m2/g1lZ4NtCY6l4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=btXRvCN0xz6ia7SavDQbYaMnyesLOhSX63QKyNqOlens8YrdKStPA5C3guGd9Ipqw
	 M0YsRdZjeKsdZ0qh0JEX4iRgJ++Tm/cXoGIuu7L1PH5Hh+vvjX0huifYbuYu6sro4P
	 HCM/oURG28C+fbeubpqzPQBf7zkjlqOqmFIpTfEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolaos Karaolidis <nick@karaolidis.com>,
	Jan Kara <jack@suse.cz>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 630/686] fs: rotate inodes whose page cache could not be dropped
Date: Fri, 13 Nov 2026 10:52:43 -0500
Message-ID: <20261113153843.185638768@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Nikolaos Karaolidis <nick@karaolidis.com>

[ Upstream commit 8ee09f597763acfd31c62a578ba88b792fc41b24 ]

When inode_lru_isolate() drops the page cache of an unused inode, it
has to unlock the list, so it returns LRU_RETRY and the walk restarts
at the head of the list, where the inode still is. If
invalidate_mapping_pages() could not empty the mapping, the restarted
walk strips the same inode again, and so on until nr_to_walk runs out.
Every walk of that list then ends on this inode, and nothing behind it
is reclaimed for as long as its cache stays.

Before commit 2a0629834cd8 ("vfs: Don't evict inode under the inode lru
traversing context") the walker pinned the inode with a reference, and
dropping it in iput_final() set I_REFERENCED, so the restarted walk
rotated the inode to the tail. Set I_REFERENCED again when the mapping
is still populated after the invalidation, in the same i_lock section
that clears I_LRU_ISOLATING. inode_unpin_lru_isolating() now expects
i_lock to be held, like inode_pin_lru_isolating().

On CONFIG_HIGHMEM kernels this can happen to any unused inode: a folio
is left behind if it is locked, under writeback, spliced into a pipe,
or still in another CPU's LRU-add batch after being read. Without
HIGHMEM it happens to DAX inodes whose only entry is at index 0, which
mapping_shrinkable() lets onto the LRU and invalidate_mapping_pages()
never removes.

Fixes: 2a0629834cd8 ("vfs: Don't evict inode under the inode lru traversing context")
Cc: stable@vger.kernel.org
Signed-off-by: Nikolaos Karaolidis <nick@karaolidis.com>
Link: https://patch.msgid.link/20261016102515.111285-1-nick@karaolidis.com
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Adjusted context for direct i_state accesses in inode_unpin_lru_isolating() where upstream uses inode state accessors. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index ec58d248a7ed9..229ac6ff72cb9 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -581,12 +581,11 @@ static void inode_pin_lru_isolating(struct inode *inode)
 
 static void inode_unpin_lru_isolating(struct inode *inode)
 {
-	spin_lock(&inode->i_lock);
+	lockdep_assert_held(&inode->i_lock);
 	WARN_ON(!(inode->i_state & I_LRU_ISOLATING));
 	inode->i_state &= ~I_LRU_ISOLATING;
 	/* Called with inode->i_lock which ensures memory ordering. */
 	inode_wake_up_bit(inode, __I_LRU_ISOLATING);
-	spin_unlock(&inode->i_lock);
 }
 
 static void inode_wait_for_lru_isolating(struct inode *inode)
@@ -964,7 +963,13 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 		else
 			__count_vm_events(PGINODESTEAL, reap);
 		mm_account_reclaimed_pages(reap);
+
+		spin_lock(&inode->i_lock);
+		/* The walk restarts here: don't retry leftovers right away */
+		if (!mapping_empty(&inode->i_data))
+			inode_state_set(inode, I_REFERENCED);
 		inode_unpin_lru_isolating(inode);
+		spin_unlock(&inode->i_lock);
 		return LRU_RETRY;
 	}
 
-- 
2.53.0



