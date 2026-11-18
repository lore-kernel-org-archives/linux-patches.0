Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022448;
	b=r9T7q1svAZ2yq+EHxhFkd4NwH2dmMxezyC6awnMBIJ8t/xz4vaQxojXUMeDQI4Sgkz/5
	 ATPzsftScCq2xvLT02x1x/v0KAsAH6tiPDjPqvP/lYMf5rsqHWzdegRWVUJA65ajQ9R9B
	 HyhQutCx9080Iiqai0FeFrv8Faluavdv/22HB4D2tSHyElH/GKqvsBKtc1zNoSZlKEJ0V
	 /WEqLZZJwvQYS+T5JZFALQR5C2JWLCwVDoSXfJS9nrWUfbD+JFKcJi7VaxX95bs1s1tTL
	 oFnAgmWa41NkQD3nHi97uRNXWPph5D9pgFnxGByzkMmKc6ZW7eOVfnwC9yRjpBGMmwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ut1+AhwgPdwsbBCsddpFQjZfqPfYLcABtEZ9FF0KZtU=;
	b=iapx8W35nc8HVgsWQ/D+iIcZA7uuQbCo7zwfsMPsHneCdFh/zhGXfJfX7Z/vdGDNfaVe
	 Xq4iuTMenvGMTikovqga1LJbKqI+2vdz44idlbUHr131FAAFCXIoFnq/IkOHpXv1ZEa14
	 5rSzMg3fCdPse14R3ae9TY/Xw8yCJ7uGJGL4cQB4VuYiK5RJHUnSLIaor8/Ky38Wx+1Px
	 eDkxXPS2lm5m5lAu9XOGKmc859c/4zwplwhD0Ylv/JLWI57VZ+JEG6WDu3WDL3DC2aZZz
	 hEdt1UrJ1BgqapTYMEjt8ub8oKVBlTFPBV4AVkt8wWgNCQBEZHWXSUjhgK7B49o2CLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nbMHW6De;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1A1606A32F;
	Wed, 18 Nov 2026 17:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nbMHW6De
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B951F000C7;
	Wed, 18 Nov 2026 17:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022447;
	bh=Ut1+AhwgPdwsbBCsddpFQjZfqPfYLcABtEZ9FF0KZtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbMHW6De16P7pOzIZ5QeHojQa+2kBuiM5YSAat0iAXtX3vGBxnc9PxP/6M9SsPfnJ
	 GVWhndw2WyhBXOtSTvnGJjP9ffu2mHbg6EmlHXiplM72BG7oOD7a5A3rIL/chNsM8v
	 DyCApxuVW4HHOCgen7kz1p2kVzx8LqPN9gt40J8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	guolingxing <guolingxing@tju.edu.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0017/2151] btrfs: prevent deleting the wrong subvolume by ID
Date: Wed, 18 Nov 2026 15:29:12 +0100
Message-ID: <20261118150122.272852307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: guolingxing <guolingxing@tju.edu.cn>

[ Upstream commit 1960146913b31b288ed2cd607d103ee3b41681d4 ]

When deleting a subvolume by ID, btrfs_ioctl_snap_destroy() first
resolves the requested ID to a name, then looks up that name again
under the parent directory lock.

A concurrent rename can change which subvolume is associated with
the name between these operations. Since the deletion path does not
verify the ID of the resolved subvolume, it can delete a different
subvolume while leaving the requested one intact.

This was reproduced by repeatedly exchanging the names of two
subvolumes using renameat2(RENAME_EXCHANGE) while deleting one of
them by ID. The wrong subvolume was deleted in 9 out of 14 independent
tests.

Fix this by checking that the resolved subvolume ID matches the
requested ID while holding the parent directory lock. Return -EAGAIN
on a mismatch so that userspace can retry the operation instead of
being told that the requested subvolume does not exist.

Fixes: 949964c92843 ("btrfs: add new BTRFS_IOC_SNAP_DESTROY_V2 ioctl")
CC: stable@vger.kernel.org
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
Signed-off-by: David Sterba <dsterba@suse.com>
[ sashal: Replaced goto out_end_removing with goto out_dput to use the existing cleanup path. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9a8902012ae6d..84305ed0dc70e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2413,6 +2413,17 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 
 	inode = d_inode(dentry);
 	dest = BTRFS_I(inode)->root;
+
+	/*
+	 * A concurrent rename may have changed which subvolume the name
+	 * refers to. Verify that the resolved ID still matches the requested ID.
+	 */
+	if (destroy_v2 && (vol_args2->flags & BTRFS_SUBVOL_SPEC_BY_ID) &&
+	    btrfs_root_id(dest) != vol_args2->subvolid) {
+		ret = -EAGAIN;
+		goto out_dput;
+	}
+
 	if (!capable(CAP_SYS_ADMIN)) {
 		/*
 		 * Regular user.  Only allow this with a special mount
-- 
2.53.0



