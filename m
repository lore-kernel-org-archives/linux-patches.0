Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CACD38DC7;
	Tue, 27 Aug 2024 14:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770293; cv=none; b=P+mHfjv2uwzam6d6XMnp2Q/UToN6bRe+iyTAHx1u8NSMIqhV2VeeS4Ca50nN3YdKqTPN8Y0zXFO2fG2fc75GtOwaCGjzi2tn7bMDLr4LHmdLCn1z9MqSE27F/G5tWjyLlsHfj48gIJEp8u2ayqwsYRKMal8kIRo9CknpRc48zdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770293; c=relaxed/simple;
	bh=opH/8vDOhpGtPBbE7wDQb/TctlNGFa4YxtoeTfEA8Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSogHIYYSc8vMp37yQgSlgZ0SJ1pCdHp07NWUw5ygfL1tuTtGjGjrMQKNIucIgyAvqjRgCS4DiYO/6c8KH3MRuVxVmg0uiVwE2lNOkTjhbu90XLsi9Pudc2AmTSdP+qA/kg1U58KsO1xaxwkpZOmGAJJgXjABw7zSHPCxoYPbjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKkFftTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKkFftTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84EAFC4DE03;
	Tue, 27 Aug 2024 14:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770292;
	bh=opH/8vDOhpGtPBbE7wDQb/TctlNGFa4YxtoeTfEA8Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKkFftTbTb8b37Nj7zQU763+L6HtWatyOZSKeLzdLIO+qwNdM5VqYvywtdV/cEd1K
	 kc6Ky0XLxBmoLjQoCpgQPj+EExS5ciwxV5LGlQt4IFntc+yD6PG7qvp6VwbALaLhMe
	 ZrREj6orCMkUSK/UYL/5SAxj5U9BdXIYXNBfAE74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 184/341] btrfs: delayed-inode: drop pointless BUG_ON in __btrfs_remove_delayed_item()
Date: Tue, 27 Aug 2024 16:36:55 +0200
Message-ID: <20240827143850.415090923@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit 778e618b8bfedcc39354373c1b072c5fe044fa7b ]

There's a BUG_ON checking for a valid pointer of fs_info::delayed_root
but it is valid since init_mount_fs_info() and has the same lifetime as
fs_info.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 6d562f18d3f80..12ff91d6f570f 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -425,8 +425,6 @@ static void __btrfs_remove_delayed_item(struct btrfs_delayed_item *delayed_item)
 
 	delayed_root = delayed_node->root->fs_info->delayed_root;
 
-	BUG_ON(!delayed_root);
-
 	if (delayed_item->type == BTRFS_DELAYED_INSERTION_ITEM)
 		root = &delayed_node->ins_root;
 	else
-- 
2.43.0



