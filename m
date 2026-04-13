Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D25826F293;
	Mon, 13 Apr 2026 16:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096756; cv=none; b=IfRtk1JoVQxHD+BRNQ3loXudxDgAR95BEHXpCuE+F63sJiyl7Y4Lb1RJS9U6kiI60fyggXDVEH12nGmKNT6Kj+sWXJ8bjFaDfdreuXifBS75r9TUZmw5ASuf0bF0ezqkZcXjfKN9WsSAQN5qMakcHV6A68FnOz1idj333p8EhtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096756; c=relaxed/simple;
	bh=EkRlO0bex6DW/78ravCFS1t+Cf95Tw3aALPoH9RlMPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xr2ZVO2KA/+WcWBndMAXkdVzRrPym5iRz1Mf8c4j3xkFbWio1npVjYKWDPGOvkujLbrWsP5Wvjf0iH7fWZvBCGxQ0nfr9Q+20beRE/czqQERh1DLbmgduAqtQd8N40nxbkxq6N4lxxiR46kn1r06u3gAC7sFu9qsTH8pRrHSF/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSsjN99H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSsjN99H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FBAC2BCAF;
	Mon, 13 Apr 2026 16:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096756;
	bh=EkRlO0bex6DW/78ravCFS1t+Cf95Tw3aALPoH9RlMPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSsjN99HqCeTA815ritC5naXTpIuXlVQTpKdf3U37rQoDJhR1WxpP1R9EIgb7oGOo
	 9LAQbpVGVf0PlzYV3Iw9m/RzaYhkgjPgLkmurLDqYtsBOBCLti0CHA72W6KkCic1ek
	 P4cEDo/v9gyDycA7ooDy1WbxYMNxc4An3XLpSV2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Daniel Vacek <neelx@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 18/70] btrfs: remove unused flag EXTENT_BUFFER_CORRUPT
Date: Mon, 13 Apr 2026 18:00:13 +0200
Message-ID: <20260413155728.866573478@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vacek <neelx@suse.com>

[ Upstream commit c61660ec341e65650e58c92d0af71184aa216ff0 ]

This flag is no longer being used.  It was added by commit a826d6dcb32d
("Btrfs: check items for correctness as we search") but it's no longer
being used after commit f26c92386028 ("btrfs: remove reada
infrastructure").

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 316fb1b3169e ("btrfs: fix incorrect return value after changing leaf in lookup_extent_data_ref()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c     | 11 ++---------
 fs/btrfs/extent-tree.c |  6 ------
 fs/btrfs/extent_io.h   |  1 -
 3 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5de12f3a679df..2dab2ce94cc40 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -225,7 +225,6 @@ int btrfs_read_extent_buffer(struct extent_buffer *eb,
 	ASSERT(check);
 
 	while (1) {
-		clear_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
 		ret = read_extent_buffer_pages(eb, mirror_num, check);
 		if (!ret)
 			break;
@@ -454,15 +453,9 @@ int btrfs_validate_extent_buffer(struct extent_buffer *eb,
 			goto out;
 	}
 
-	/*
-	 * If this is a leaf block and it is corrupt, set the corrupt bit so
-	 * that we don't try and read the other copies of this block, just
-	 * return -EIO.
-	 */
-	if (found_level == 0 && btrfs_check_leaf(eb)) {
-		set_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
+	/* If this is a leaf block and it is corrupt, just return -EIO. */
+	if (found_level == 0 && btrfs_check_leaf(eb))
 		ret = -EIO;
-	}
 
 	if (found_level > 0 && btrfs_check_node(eb))
 		ret = -EIO;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c052c8df05fb4..568fe9f702b74 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3517,12 +3517,6 @@ int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	trace_btrfs_reserved_extent_free(fs_info, buf->start, buf->len);
 
 out:
-
-	/*
-	 * Deleting the buffer, clear the corrupt flag since it doesn't
-	 * matter anymore.
-	 */
-	clear_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags);
 	return 0;
 }
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 4126fe7f3f10e..0eedfd7c4b6ec 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -38,7 +38,6 @@ struct btrfs_tree_parent_check;
 enum {
 	EXTENT_BUFFER_UPTODATE,
 	EXTENT_BUFFER_DIRTY,
-	EXTENT_BUFFER_CORRUPT,
 	EXTENT_BUFFER_TREE_REF,
 	EXTENT_BUFFER_STALE,
 	EXTENT_BUFFER_WRITEBACK,
-- 
2.53.0



