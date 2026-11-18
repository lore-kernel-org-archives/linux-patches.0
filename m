Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031483;
	b=Tdu9yfRSJJVGibRiAb4sGlBehsrgKL0mTlzGXfNhAIClkunfME/t67VF1Ez58IyOTWFu
	 26f7VywG8CVaifngjZlvT+GzuxwdobN0bGvtUoBzzDH38w5EM87LUMwuvxxVUEUVqElYF
	 v8igNIYcp29jGXwrAEwZGB9vlloBfwwa3GGbK7TuPE1+jH6fdF9Fq+cvfUe24TAG4oZUq
	 V2oP/B4yP6zC/2KDGRUmJs/la31MjbZAeK0QdQ72CWQbFbNG6/X4jH6+Zf/o4ahURaQvy
	 1eOeOrdbv0d4YGLSGqczxmMUjLGD1Kh4oQR4gFDMD86LyJi2upUcqxZ3hXvch/MDO8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2t4OVVp7vqIFYGEmnRp0AX54AGDCc29XSHhoyc37mrM=;
	b=TmS8J4W/msD1PXF3nkFqYrVoidLzp2u+RFk/eCzT2kGGUPMGYkfa8JahrusXWCalZ2aq
	 mllm7oOLaYULmuvHlTdxzviXiQ10kXcWIzRJqlqI/yD5TXdLpWkeJMBkIx4ztaUuLJG6Y
	 4OHxzvJ8uGEaFslMx4zF/ILcIEnQpbNdgXDc1fP2tYu7HbPkxrEfSk1YgAVWxLltKM21g
	 H+Blwc4peVevWntCN64dWBIBGsZszOe0U5W4vYHguJUajQbbFmst0DLMVOUma+JVXM4GF
	 yb8N6t9TVINy3eoz3p2LV5Gj48ouYiBXknLqUrcWPZtxP6Hy/XcjIobD/sFNRdB3MTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wgZsEi76;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BA5606A32A;
	Wed, 18 Nov 2026 19:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wgZsEi76
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9851F000C4;
	Wed, 18 Nov 2026 19:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031483;
	bh=2t4OVVp7vqIFYGEmnRp0AX54AGDCc29XSHhoyc37mrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wgZsEi763L1ZBhAgRpSAzJOX/2zHzC3zNGdWBErWey/69eWV2uu7wHJABXcu3vyuQ
	 x/NS4KBynN2xHCwrIt4tlrlVTQY83PGK/OmzJZX7btOC26BbeZ6I+0V8DGv7hdRIih
	 UFbgKhv64uycnMaiAKEyIFITUZz44Y1CejTF8oLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	c.f.a@posteo.de,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1076/1756] btrfs: qgroup: do not treat "ret > 0" as error when deleting a qgroup
Date: Wed, 18 Nov 2026 15:53:23 +0100
Message-ID: <20261118150053.068128896@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit dd906477cc2c33c82ec17e6301bd4be4ea588565 ]

[BUG]
There is a bug report that when removing a child qgroup, if removing the
qgroup requires a rescan, it will delete the on-disk relation and qgroup
items but not the in-memory qgroup rb entry.

This makes all later qgroup rescan to fail.

[CAUSE]
The call chain looks like the following:

 btrfs_remove_qgroup()
 |- __del_qgroup_relation()
 |  |- quick_update_accounting()
 |     Which returns 1, showing this operation will require
 |     a qgroup rescan
 |- if (ret) goto out;
    Which skips the del_qgroup_rb() call, leaving the in-memory qgroup
    rb entry still intact.

Then later qgroup rescan/update will always fail and mark qgroup
inconsistent:

 btrfs_run_qgroups()
 |- update_qgroup_info_item()
 |  |- btrfs_search_slot()
 |     Which returns -ENOENT, as the qgroup info item is already
 |     deleted.
 |- qgroup_mark_inconsistent()
 |- return -ENOENT;

[FIX]
Do not treat "ret > 0" as an error.

Reported-by: c.f.a@posteo.de
Link: https://lore.kernel.org/linux-btrfs/14846642-85d3-4afb-ad99-1b74b22f5f90@posteo.de/
Fixes: 9c8b35b1ba21 ("btrfs: quota: Automatically update related qgroups or mark INCONSISTENT flags when assigning/deleting a qgroup relations.")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 57552c414b43a..68b2df4355766 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1865,7 +1865,7 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 					struct btrfs_qgroup_list, next_group);
 		ret = __del_qgroup_relation(trans, qgroupid,
 					    list->group->qgroupid);
-		if (ret)
+		if (ret < 0)
 			goto out;
 	}
 
-- 
2.53.0



