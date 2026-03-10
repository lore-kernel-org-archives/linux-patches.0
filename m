Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A312F352C4F;
	Tue, 10 Mar 2026 11:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141077; cv=none; b=gCLvk56CJiJKmxbnpKdCpEtvNYsP63Axi/xRg7QAsgJ9QK443dKG2fdbPHpKb6mjwdC8BMQJ/kwOaoxMQyHgp3tfH0mTWEEe+mlwptiCute9SdVnwxUX9YLnMS9kDvO+/z3lMcemPohcl7y882vpUgdWHadD499KOFLP5m+4V8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141077; c=relaxed/simple;
	bh=9qnK0We07Q9hLOkpiF/i34XI9LAsGNIvgdPu4nT8Hkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYJBJtLR5WdH3mCNswFL51wmj8/5F25D8rX4f/FEghISnuH8Tt67+9wDqPFnUIraH9TVnIZeqtfFNm/h3jYbC8f/7iZKOb/ei351bbHZ0Km/m3DMoqRMETHkh+0LwGwp19IWJG9JRuWmV82/gP8uj4OoWvqbAT+a6D9+KegR2Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dc/OtnS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dc/OtnS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E3EC2BC86;
	Tue, 10 Mar 2026 11:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141077;
	bh=9qnK0We07Q9hLOkpiF/i34XI9LAsGNIvgdPu4nT8Hkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dc/OtnS4pqqVG/fgW1ps76VlV3KU8wNS7WCkhPCv4bZhQH/gtVDMyXR0zoMRleL5n
	 1ftoo4s8YTms6A1JGmHWpHAeQYVe0ctGnzZZnAgbm+b3q7FHBpBTQbg1+CMKqpcwiY
	 Sxh79aCh7p/ym+kR/GZLNkDimx12RNzas5sWfU+7XfYIRXDhVBFWyqf6WhQXqG8ntc
	 f0nDWGsHhDdK2ClysEpDdOEbxwqWsdQugGqmXfroC1tNpKFDGUvJBpkG3ogQpG4A2M
	 PVaW27+ll5kx/2Vm3S5HWnfBMipfBquDUeCUCRscGyADFvF8ZkbSXGLHcPiLExiBZE
	 MXF3qKa51R/Bg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 077/311] btrfs: print correct subvol num if active swapfile prevents deletion
Date: Tue, 10 Mar 2026 07:02:04 -0400
Message-ID: <1fbd490fe50e07c269881feee66ecc9a62188b47.1773140655.git.sashal@kernel.org>
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
index a2b5b440637e6..827554963a7c8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4720,7 +4720,7 @@ int btrfs_delete_subvolume(struct btrfs_inode *dir, struct dentry *dentry)
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

