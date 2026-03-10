Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C2F3876AA;
	Tue, 10 Mar 2026 11:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141934; cv=none; b=YA/ighPeUbWgsita/SO+g26OaFUWrKFlBqZDo+pTW65GEft9GQEykMlG2Vg13hbIMf13ohI7HD4y8oSZNplhwGZbpRimdZS6+jnaVgrQvtJNa3NnIq65mryKQdgLXY/hfYiVGzOybFOHTrPtn9Xtk5VqJP85IclatkGrFX5IBmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141934; c=relaxed/simple;
	bh=t1cOE4oReu187dp9oGYR1wO33XThwn8p4n4LjGee/j4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ra2k4Wsq7nlrGpUrmJy+DYtzk0wLHy6EjaEpqJ45aW4LzlfFZugtWEAlSMOSRFt93X8ygg3DIyuLMwWUEN0ubLn2rBje6aD9ioVOzYsjKbYDKhh8PWg1NUVv/zeg9fket8vigZ+VGU6c1zcZCqHSGnvb33XloQIDqOXAwlGQ6HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M2hrIDEu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M2hrIDEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F7BC19423;
	Tue, 10 Mar 2026 11:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141934;
	bh=t1cOE4oReu187dp9oGYR1wO33XThwn8p4n4LjGee/j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2hrIDEu250f8st31g7PzyEvg5SOHESHpFCDykq8iL3FoSaAtzflROnCHfa+lJfDL
	 ryPgU1nOPduNfj0UNJvNJKCX0iNa2uMrbzyXCgHtArEefQkyp23vxzNJ39x6Ynv5pH
	 Hg3IF7586YRoH4HX7MpUL+T1yARw9yHz6ot7SdkJw6cvCLzWYcTsSVpKdc5J9DbE0+
	 2jCq6rz/hRlakgLlVs8CcEomZYN4h+zz8fW8CgKxooYceGstJhLV25dIvCk2cKphew
	 NYt9D40WvKxOo0Fww/pt14WFDi/PT7anJOFtR6lehUmlE7VEhF5kcxLIQK5f7vLO6F
	 E6uFh7boWfbGw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 058/314] btrfs: print correct subvol num if active swapfile prevents deletion
Date: Tue, 10 Mar 2026 07:15:17 -0400
Message-ID: <a91800b0e292904159df962b7f6a9b71a10c728d.1773141555.git.sashal@kernel.org>
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

[ Upstream commit 1c7e9111f4e6d6d42bc47759c9af1ef91f03ac2c ]

Fix the error message in btrfs_delete_subvolume() if we can't delete a
subvolume because it has an active swapfile: we were printing the number
of the parent rather than the target.

Fixes: 60021bd754c6 ("btrfs: prevent subvol with swapfile from being deleted")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 47e762856521d..2799b10592d5a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4658,7 +4658,7 @@ int btrfs_delete_subvolume(struct btrfs_inode *dir, struct dentry *dentry)
 		spin_unlock(&dest->root_item_lock);
 		btrfs_warn(fs_info,
 			   "attempt to delete subvolume %llu with active swapfile",
-			   btrfs_root_id(root));
+			   btrfs_root_id(dest));
 		ret = -EPERM;
 		goto out_up_write;
 	}
-- 
2.51.0

