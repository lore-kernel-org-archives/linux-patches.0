Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179AC2BF3E2;
	Tue, 10 Mar 2026 11:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141074; cv=none; b=fMdMgiIZP9X9pVb7RTtbsgIk1Vnd7KocK3XA4L11ib6PQrjoeQ68qg6jsYNli3ly3pjWGF7jd45CFRHf0t2U8LNxsQhhZ6CWUP3N+UkJ2r4xx0H64trCiyddL/2DDoLRgM/KcqeFUokfSHqk2HzqY4ZrRMxfKCmK+gg5odKDMuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141074; c=relaxed/simple;
	bh=7tm2nxLD+eFlSycFophk44daKBlNIbN4f43UrbmnJ30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdwHx8x0Or7bK1zYkoBB+2e4HDYbTrFch7ChsUv1Ft+tms5VQpI9e6Zv7enN1PY4QgxWHXvqOq3e/00aCMgcGS8Hp9fETJMvinKxqTrQU4hQegJaFEwe3qkjHvh8MZXeMWJdhCIPjlvxZVONrmFVYVb4wLVhlhDGbcwa2OJZ9wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eIdEdDUW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eIdEdDUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA572C2BC9E;
	Tue, 10 Mar 2026 11:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141073;
	bh=7tm2nxLD+eFlSycFophk44daKBlNIbN4f43UrbmnJ30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIdEdDUWYI77LOlh3kAZ7gzTJJK1xxeIiBP4B1r+j0uI4Mlr+p//0pbi3gDVWtCFO
	 OWyvcIDIKPw8ZHQxzVFnmCGh6cgyz2+Pz7LtLag3Lp2Rp4IUw3bSg+KDKp0gpn9Adf
	 2HyPjxReqLvCibX3asMt/QyGx2/Rjkh8HPBFJbRailq/cWnzsVNlmygbHG6I9oByjK
	 lGU5hgRnhEiUCw2gNSbV4oad0hAmG6r11ROlQu/uWWcSd16M6OUnmN6zxIPlUNWnTQ
	 gT3Gml1xJv4ugf0XavunkJdGYE6y5AuR6CGVJpisdGyt0p/euah3iejGn4Az+9JAEe
	 MWfODvy1epcTw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 073/311] btrfs: fix error message order of parameters in btrfs_delete_delayed_dir_index()
Date: Tue, 10 Mar 2026 07:02:00 -0400
Message-ID: <87ad158870fb18ad858f31fad3cbe373b058ba5d.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 4b7d9015e0dad..7e3d294a6dced 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1673,7 +1673,7 @@ int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
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

