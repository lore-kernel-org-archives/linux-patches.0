Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060780;
	b=RkAqRaY4RCNSXZ9PCJNfo3LcU1F24RgoRL6OdY+gdcUK9SNsmedefvTZ93pVMwNFlogO
	 PwxdkvuIblnWB2eWrD5sg2mMp5xDIbwE0UGCLgns36NVbj366rOyN6iJMUSXiyqNRHtTC
	 5F/E1o22CDBk+vMJ7h8FKu3w4WJTsqGOgv0ctL5GEQBQNS7NK/qZh1X0B4W4S0K7QhKm8
	 R4+ziWfo/4uGWs+pp+d1zUTP4MuK0laOBoZfsetGTC0D1RPLCPEC8d2YdHXjCIFOWeERo
	 9mbAX3WM0zI1sPgVLnbEqU586zjLmQdjkMejtjbBcy52llUwebPPA7ApiGUQg6zPAaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BDTWTEDF9qjuI1fAvypZVt6ctpRL3RF8ZDclIIWGfHI=;
	b=cfjA5LM47YGLI82XhErPNCrYXyZ68+1egJvmfCeGYeMjn1gPyGlbJ+8eN3eUCKTNHUTO
	 YGu0NYXWUkNyCaDuy4G6mQdpY3soYzR/vGeL6VZK/dNmR4B2Eeag+tPJ/xVnfjDv4fSTB
	 D+zSY/0wUO9cZLVZGEQ6UzOfpkMwNfPXTkMUOjZ1z/J0GobCoD17I6WbQd4nWHs0uXl54
	 80bHMVeFHmEm4Or/ye4HQHnCvS+8lmNQxqH24KTTUJTsti/s5MvgZAo9aIfTtIekwnL7L
	 bqII+r5zFtrwMd5MJc+SJO8x/j1afxGHM0VJuN7TjW+7SJWf+dJeF8aSUSLmNPOUH4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2IA3v/oJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A00606A326;
	Sat,  7 Nov 2026 14:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2IA3v/oJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAE51F0089F;
	Sat,  7 Nov 2026 14:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060779;
	bh=BDTWTEDF9qjuI1fAvypZVt6ctpRL3RF8ZDclIIWGfHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2IA3v/oJjyAMcrQ4fsJDyYddDJXal60BsC06rVI5DlurgzRdVj1LYLV6YsTsa3E40
	 KyaLr6dCv6Q6wc3gh72MEkeTGgUDWVBVPfvsXTF/vxeEU7NTtFOlfuLt5n0b2/auD3
	 A6+na+P+b9BVtkzkJqDtOVHiDF94h69d4A1A9HyU=
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
Subject: [PATCH 6.12 0186/1536] ext4: reject mount if clusters/inodes per group are not 8-aligned
Date: Sat,  7 Nov 2026 08:36:42 -0500
Message-ID: <20261107135002.884249996@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 25aae8165f070..f84502f3b8320 100644
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
@@ -5195,8 +5196,9 @@ static int ext4_block_group_meta_init(struct super_block *sb, int silent)
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



