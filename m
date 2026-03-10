Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7690387361;
	Tue, 10 Mar 2026 11:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141930; cv=none; b=JXZoBAPnBUta7jLLYdiCmkb5g29TZsx8G1AcJrviup7s+bB3IH9VYfZlEDeigN7pLJh+3Rrh2Cg+2X8wV8EAgOw4kYLGQ39C4h76bx2zXUBZwQTPCUsZ+su/Xj/Amdhu+m1twjBpzAsgZKRDKu2bke1CAwG7suNq35jvAybpNM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141930; c=relaxed/simple;
	bh=wXCBinXL4la0xUday49Xq5V+73RfpP9KB1fUyYLvqd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JG5hwrwybsmz4FZfXysnBkTkK3VelhtS+bg2OrUKVgZkfJ72TG0DYmRIi5jny1JmCiq90gPxqPTFZ+PBpPpzi/ltPNUJntqGI86vl5C9BDAFr7KGTcefi0WgPITa7fb9Hl6OG0pQy07BIRPC7kZhBtyQaoX2tohwwk7R+wNPp3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HEPGvfZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HEPGvfZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044B6C19423;
	Tue, 10 Mar 2026 11:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141930;
	bh=wXCBinXL4la0xUday49Xq5V+73RfpP9KB1fUyYLvqd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HEPGvfZH5oE3VOeR3aKUfFT92yYysRTLlSJMnMuRusNiyN0Z5NIbXSHLYMNuclovs
	 3tnLH+l59W1gQCHQAWbVQLJX4G6QhffIdvYEYcoJvbzUvBkZ4bm6SiZBCT3vYNFmoQ
	 1ijrVcUZf9yaFzqo6rHmid61fJKux9gZqCm2xfavJPuSbMHvyXnU8NEVDjo18JCQnK
	 L8Pjok7XdTBuFxqVKBiG7uZDxUdN1Ct5QE/v78JLsDSOnYq0DIXOeJtR+0cgGAfr8C
	 iaqdhv1yNpqpm6aF9uqAcIAWP6p5C1bfQii1CSSsCyjRKnOkzNiYTwZtu5zmz3SU6W
	 5F8x+cHRdFwkA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 054/314] btrfs: fix error message order of parameters in btrfs_delete_delayed_dir_index()
Date: Tue, 10 Mar 2026 07:15:13 -0400
Message-ID: <bd0192a56ecfbaa15aa212f80e0b4b6fd4b9faa0.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit 3cf0f35779d364cf2003c617bb7f3f3e41023372 ]

Fix the error message in btrfs_delete_delayed_dir_index() if
__btrfs_add_delayed_item() fails: the message says root, inode, index,
error, but we're actually passing index, root, inode, error.

Fixes: adc1ef55dc04 ("btrfs: add details to error messages at btrfs_delete_delayed_dir_index()")
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 59b489d7e4b58..ea48706a3d810 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1676,7 +1676,7 @@ int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 	if (unlikely(ret)) {
 		btrfs_err(trans->fs_info,
 "failed to add delayed dir index item, root: %llu, inode: %llu, index: %llu, error: %d",
-			  index, btrfs_root_id(node->root), node->inode_id, ret);
+			  btrfs_root_id(node->root), node->inode_id, index, ret);
 		btrfs_delayed_item_release_metadata(dir->root, item);
 		btrfs_release_delayed_item(item);
 	}
-- 
2.51.0

