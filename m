Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E573B2C327B;
	Tue, 15 Jul 2025 13:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585944; cv=none; b=pNhxztbVenpXi1Z93djv77ax2jTFZ4tHGt02MUriCeOz+wnF4DpgE+qHy8g9lrmk7mUXAj5qpgv8HMSiZD5XCIbyCdODa1XMywbov5QNqsR7EJghhqsRn0shnbOzwreypVDK7/xXgfJ0IdyaGaLf9a3aOES3C1MwiWOD41pqsJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585944; c=relaxed/simple;
	bh=F3Il8INoHh5usvaza2cNulgIpJ4ZyzDgPvVlAuUAIMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ge3lvIsTa7vFy1vpq+6sFPoYUapdWWCVadCHJk/4MTxCvhg6f4p9ScAayh/uPlal78N1rhgZ/nfTaNvmzRT9TZ6qAm/gCbWMHVEi+iJuZE9LJJALedJ8KcJrnWTpXl6STrE+UaHnvb1D8CKhqx4/2Q1NnUi+pP2fl8JJbdGyBqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCKFDgqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCKFDgqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A9CC4CEE3;
	Tue, 15 Jul 2025 13:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585943;
	bh=F3Il8INoHh5usvaza2cNulgIpJ4ZyzDgPvVlAuUAIMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCKFDgqhZ3JW+xXG2VlNiKZkeUigiw3e+WlPtNxpRmXa5A13DKnz1B17P0FuuhGGA
	 MMlxe0NW96xH+m2ICuT7/mzgdt9Hj7av8rYyJEfP0Xs0lkJYyEgWrFwVOjhkzLpbZH
	 rQ5rmjQFVP8Dr4v1BEd59nkOZ3dwioPBwRqK0RHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/109] btrfs: remove noinline from btrfs_update_inode()
Date: Tue, 15 Jul 2025 15:13:22 +0200
Message-ID: <20250715130801.526154531@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit cddaaacca9339d2f13599a822dc2f68be71d2e0d ]

The noinline attribute of btrfs_update_inode() is pointless as the
function is exported and widely used, so remove it.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 5f61b961599a ("btrfs: fix inode lookup error handling during log replay")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e8e57abb032d7..c80c918485547 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4014,9 +4014,9 @@ static noinline int btrfs_update_inode_item(struct btrfs_trans_handle *trans,
 /*
  * copy everything in the in-memory inode into the btree.
  */
-noinline int btrfs_update_inode(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
-				struct btrfs_inode *inode)
+int btrfs_update_inode(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root,
+		       struct btrfs_inode *inode)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
-- 
2.39.5



