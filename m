Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9231494BD;
	Wed, 19 Jun 2024 13:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803713; cv=none; b=rEWJcPbX3PSgqNdpU3DxHStfzXW1OjXMklFDngYXH57ZNLIB2Ts3tUdi7v8fu6LM4yDW8K6ZZ0tes0H0Sp5OcB2CDi/rPyfedP03gnzE3eopfA1lzZQ2oCDxIFtptM7swu/zhzUUiLQnXKUkT9MEfs0fc3MCt0QVnstNPOVlFCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803713; c=relaxed/simple;
	bh=xJ2HdYr3h8Z3zUdXlxsCreuiF/omIe1Vyu+rNNId0gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMX0dZ2oGo3uNOHuzfx4NTPJn6W2ijtpGi4p/o9R9tTKNFuNAy1NRWRKAmNSigoD2ISdKCIpvrphZzNsCFRXJVrq4cr2Vd9BIXJYJg2oaVG4ICfCm+3l+Fs3iDJJoyfnd67M5tQkW8KJKlGpWRQDL79VSznJoNq8STgH9xV3gMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=otyyLVIV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="otyyLVIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD49AC32786;
	Wed, 19 Jun 2024 13:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803713;
	bh=xJ2HdYr3h8Z3zUdXlxsCreuiF/omIe1Vyu+rNNId0gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otyyLVIVayaWBOwiqU2NO7rIbwkuP3+QoLmipiL+qY1CIXMX7dejY1ZY8okMzFri8
	 k9Cwsz725fqIpsmnpOy7kkKoFx0kfiRH7D5CdjL8LRt2z/pxxeW7LNJIJ2DpVu/riO
	 s1jhGmpgoetd6EQdEsqea3GGGZujfkk1i6v3BT+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/217] btrfs: remove unnecessary prototype declarations at disk-io.c
Date: Wed, 19 Jun 2024 14:55:22 +0200
Message-ID: <20240619125559.735232799@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 184533e3618f4d0b382c1ef3de0ce34e849005d7 ]

We have a few static functions at disk-io.c for which we have a forward
declaration of their prototype, but it's not needed because all those
functions are defined before they are called, so remove them.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: fb33eb2ef0d8 ("btrfs: fix leak of qgroup extent records after transaction abort")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5756edb37c61e..0111eda33aa9c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -51,15 +51,6 @@
 				 BTRFS_SUPER_FLAG_METADUMP |\
 				 BTRFS_SUPER_FLAG_METADUMP_V2)
 
-static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
-static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
-				      struct btrfs_fs_info *fs_info);
-static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root);
-static int btrfs_destroy_marked_extents(struct btrfs_fs_info *fs_info,
-					struct extent_io_tree *dirty_pages,
-					int mark);
-static int btrfs_destroy_pinned_extent(struct btrfs_fs_info *fs_info,
-				       struct extent_io_tree *pinned_extents);
 static int btrfs_cleanup_transaction(struct btrfs_fs_info *fs_info);
 static void btrfs_error_commit_super(struct btrfs_fs_info *fs_info);
 
-- 
2.43.0



