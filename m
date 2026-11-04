Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829658;
	b=Itx6oVgq40GN7rBZ9Ik2mSyMYtwtXZtoMl+wajgy/wkw0//uKRxYVHCB40fJo/qdEnqs
	 ahi9Pbek0z8ZQOVZShN5LBiiRCT4YY/+xy7Gw89APhPxwEGYLJJF8BcT8vL8b6DKc1bBm
	 EA13sPIekUnVu1/o0mUJCOlM5g3m18ofTSG4vVXwnxqXKM/7dHlDVCMgNQ9zh8yK9I44q
	 Sal1JC9lKlOlmpU4m72EDxDGugd0GopTQSSASgulc0vy3ocRMYC1FYXtWy3Eza6YPjFTf
	 wStMgIAljQJ7Lf/qLIN7hEUnHkjMh6/v94ciEBKUn4xam+oL5LdpaGD3f9H0MHXE+OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oGqBK3EV4pZrduj6srq0qlMIv4aicsKMF83HsXTYUQY=;
	b=cloIyru2L20n+7x0KSh9vapZN4eaDEj5rZgkQH5NwrmCElbNW7sHUXwYla2wdtJTigs5
	 4QdRwAdXkdlT3pE+RSKr2umiZnK9mUKPtTw0JcyvG+kmTykfMVqygh3p9F8zQpL05J8Rk
	 mEEYcw90XRSDaO4dria5SqruR8BWDfmib6RtAsAgiu/DD4S0cW2MLhGTUP3ICxue2Ym5V
	 X2b1ZYzYUoFpBSagN+s0a5otbU8Tw4E82p3GsNvfIx5bgztk5DeMskYARfxREWrAhg9Xn
	 0MibVkk8sFZhkpD5DLRCREbzaMtYsRRG7YwhXWCVsxPyCDpvGOyXUq/C25Vw1WLXcvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LTkALTDf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E97606B2F0;
	Wed,  4 Nov 2026 22:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LTkALTDf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177FD1F0093A;
	Wed,  4 Nov 2026 22:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829658;
	bh=oGqBK3EV4pZrduj6srq0qlMIv4aicsKMF83HsXTYUQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LTkALTDf7Ryl27CCL0Yqe0laJfotR0LUpTrd2fM5wgiXUon2JhVo4ZK3dnCNXlK3V
	 2Ag4NPufMp2s951mY26xriH90lMjmXDwzPEAY+waadi/gg0MUVu9YBfJBOz0ZkNp00
	 Ip2BznF8N51IgUgjgwkSJSnBebC70iALLd0QMOIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodore Tso <tytso@mit.edu>,
	Sashiko <sashiko-bot@kernel.org>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0223/1005] ext4: reject mount if clusters/inodes per group are not 8-aligned
Date: Wed,  4 Nov 2026 15:59:16 -0500
Message-ID: <20261104211050.065398135@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Baokun Li <libaokun@linux.alibaba.com>

[ Upstream commit d42dc7726a003262b73ffef2b744ff57a5488799 ]

The block and inode bitmap checksums are computed over a whole number of
bytes: ext4_inode_bitmap_csum_*() use EXT4_INODES_PER_GROUP(sb) >> 3 and
ext4_block_bitmap_csum_*() use EXT4_CLUSTERS_PER_GROUP(sb) / 8 as the
length passed to ext4_chksum().

If s_inodes_per_group or s_clusters_per_group is not a multiple of 8, the
trailing fractional bits are excluded from the checksum.  Those bits are
then unprotected, and any incremental csum update path that assumes a
byte-aligned bitmap can compute a checksum inconsistent with the full
recalculation, corrupting the on-disk bitmap checksum.

Reject such filesystems at mount time by adding the missing " & 7"
alignment checks alongside the existing range validation.

Suggested-by: Theodore Ts'o <tytso@mit.edu>
Link: https://patch.msgid.link/h3n7jlfhyna64dn5o76qxcspnhxdddcs6crpxftmy7gnl7b3sx@jenszfpcsnit
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260508121539.4174601-1-libaokun%40linux.alibaba.com?part=10
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20260608111150.827117-2-libaokun@linux.alibaba.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3f5e9d825a5e6..b4ff7e692986b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4439,8 +4439,9 @@ static int ext4_handle_clustersize(struct super_block *sb)
 		sbi->s_cluster_bits = 0;
 	}
 	sbi->s_clusters_per_group = le32_to_cpu(es->s_clusters_per_group);
-	if (sbi->s_clusters_per_group > sb->s_blocksize * 8) {
-		ext4_msg(sb, KERN_ERR, "#clusters per group too big: %lu",
+	if (sbi->s_clusters_per_group > sb->s_blocksize * 8 ||
+	    sbi->s_clusters_per_group & 7) {
+		ext4_msg(sb, KERN_ERR, "invalid #clusters per group: %lu",
 			 sbi->s_clusters_per_group);
 		return -EINVAL;
 	}
@@ -5238,8 +5239,9 @@ static int ext4_block_group_meta_init(struct super_block *sb, int silent)
 		return -EINVAL;
 	}
 	if (sbi->s_inodes_per_group < sbi->s_inodes_per_block ||
-	    sbi->s_inodes_per_group > sb->s_blocksize * 8) {
-		ext4_msg(sb, KERN_ERR, "invalid inodes per group: %lu\n",
+	    sbi->s_inodes_per_group > sb->s_blocksize * 8 ||
+	    sbi->s_inodes_per_group & 7) {
+		ext4_msg(sb, KERN_ERR, "invalid inodes per group: %lu",
 			 sbi->s_inodes_per_group);
 		return -EINVAL;
 	}
-- 
2.53.0



