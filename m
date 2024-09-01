Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E5F181334;
	Sun,  1 Sep 2024 16:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209628; cv=none; b=UIRwvcnXHMEWslU8FfBNpvtpqgfxA8X66HFiLKvj0dFMpiDB7Ox5RIWBuaRsmPU1guUO+4bphb8k/fXwUrvtohqHdrgzcpCwtex2eCPccvIqd9P1K+Ei3+6OhellMF+JajHF7MIZ7nvdzej0ii1nxBr+h0d0yMfPeYB4AoeGOYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209628; c=relaxed/simple;
	bh=DEpKeUiVL1pOBZEHyt1gkaLZIHPaiy3rIJBJyYmzEmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KewPUfdOVavlyYSAlROTQF1300KAkwmZfwqeBFmA7UM+I0FkHp87ctm87lqNvlKyYi+lcIJJgaKFajanTnFvF7oBUv7dAG5cFZb668hMsJhvTTonQri+ry6bn/YZE123npmKY0r64fLjZ50dBtXccm/0wd51ikDzLXu21lLqFlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xesSFSMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xesSFSMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA71C4CEC3;
	Sun,  1 Sep 2024 16:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209628;
	bh=DEpKeUiVL1pOBZEHyt1gkaLZIHPaiy3rIJBJyYmzEmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xesSFSMMqsu6bv3/0Iz1uSa44S39Mh+Pg62dBY3xnc7HBS4BKSq3iaP3TlzeMFdGK
	 e7HYWmOyOjRlEFajxaCVaKwrF+/qInkA8WRfcpy9b4DWpZFHFBVIr2tgGzf0DOIQ7y
	 pZnp6CkDSY7250iEA5RwPrV35tr7LbiSpkKjFFMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/151] btrfs: change BUG_ON to assertion when checking for delayed_node root
Date: Sun,  1 Sep 2024 18:17:04 +0200
Message-ID: <20240901160816.526197570@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit be73f4448b607e6b7ce41cd8ef2214fdf6e7986f ]

The pointer to root is initialized in btrfs_init_delayed_node(), no need
to check for it again. Change the BUG_ON to assertion.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index cdfc791b3c405..e2afaa70ae5e5 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -986,7 +986,7 @@ static void btrfs_release_delayed_inode(struct btrfs_delayed_node *delayed_node)
 
 	if (delayed_node &&
 	    test_bit(BTRFS_DELAYED_NODE_INODE_DIRTY, &delayed_node->flags)) {
-		BUG_ON(!delayed_node->root);
+		ASSERT(delayed_node->root);
 		clear_bit(BTRFS_DELAYED_NODE_INODE_DIRTY, &delayed_node->flags);
 		delayed_node->count--;
 
-- 
2.43.0



