Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675FA148302;
	Tue, 27 Aug 2024 15:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772321; cv=none; b=W4XOlJgNUXlD0QPaiE27qg1KnshtyOO/HzifXtS441t61pVVPwifJCC/0U64Y/iJIer/mMx1flkzzOCxFzGn6VvWRST9edqB9PyZvX5Gub5MTgFYjQw5OmgvpmRfcqoGJwSQit0xfIZ1tOa+R7QJSEaiG3Hr3oOaDZJs0Cj1jr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772321; c=relaxed/simple;
	bh=m2ME+3V3pGeSr0pa7muPNxsnl2K9NEw/ALKN7z0SEkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jl1Si6XqS3Nfv4I6YaF9KdEEMCzCH4c2X/iC3m9mdTpsJIavUjsl7hfHLUUQkO8HpimOygJ+SFCwQ62VDGRGxaCPq2HKnsFnDLhBFv1FCvHJoAaL3dLiNFYwoc0oG2SW3C605vtLwd7aAySwEaBoJaAMFa0lHZlYcLvOT/mhxzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mh8DaKkR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mh8DaKkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DE6C6107A;
	Tue, 27 Aug 2024 15:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772321;
	bh=m2ME+3V3pGeSr0pa7muPNxsnl2K9NEw/ALKN7z0SEkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mh8DaKkR0092PBGrSfvg6huck618xVajjyM93MhV0d5MLhXDuZscCXUutEo311KSV
	 eqPmQjrxKEnosgJ598u1p4cTukxAQv4hVO/YrKvOpuv8zIhE8bD+GBx/v1rVZKAwy7
	 fPUysgOW7hgtIbJ1WMxKa9Pe32MOlO7EmfgOS1dY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 180/321] btrfs: delayed-inode: drop pointless BUG_ON in __btrfs_remove_delayed_item()
Date: Tue, 27 Aug 2024 16:38:08 +0200
Message-ID: <20240827143845.081655917@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1494ce990d298..948104332b4da 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -420,8 +420,6 @@ static void __btrfs_remove_delayed_item(struct btrfs_delayed_item *delayed_item)
 
 	delayed_root = delayed_node->root->fs_info->delayed_root;
 
-	BUG_ON(!delayed_root);
-
 	if (delayed_item->type == BTRFS_DELAYED_INSERTION_ITEM)
 		root = &delayed_node->ins_root;
 	else
-- 
2.43.0



