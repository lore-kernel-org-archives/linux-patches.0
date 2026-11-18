Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041507;
	b=MuUvMtRcZFGdTwqr3AJ5MGqCpmg5NtQvA97zQptpeWeCwFXQX8ep3ifkAlJAIjgY0FDf
	 Ij66RyWm2pobrWNrobtOtK09pzOCgioDTQPt1N1DsDk5K7bNqq2oogEncuVnbvlkHeSFm
	 BNvRWyzSW6rZUXDSNwA4+BS4OQOK8BniOxUC2dBsGc9I0/zaUnrGmklWZBbtWueVuQKvP
	 yoapA0en/TmNQPKmWLZ176H2u3Nb3Cy8z1R+Om7jaZYVVL9iLHfGLC+Qgwu80FpO/CG7h
	 2g1qU8eHvI5hXliAlu4xo8G9NkKzoY6qgpmk7jrQwp7y3HxEC91f7bdPvIsfZTMDZdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eml+NdJZkSdIALfC0p5FzJo0zSjqBwSA+s6s4Tpq/Dw=;
	b=PFXA8UGtkOJplufufsSFl7mk+H1B8nvO651ifagyliA6U9midrJr0zuvURGCZxXjwGHt
	 PnfTobd/NuXY+HdbXLoHSQ3QGof7beIxWr/ARud/+bBSXQrsSu8ijHKVWpykuZMj0qoaX
	 3e1jfmcfO45ZP3XabfPXA0ALidM5A6x+1D0+sxhHcD6/hYCgH7EOiX3a4P3yUORJcgWB+
	 Lvx5Lcngum4o4KJUeqcpKh3lmluLNbVMgbljrarL/L7LkUcgmJdjiR2Pm5XXFm8kSg+6V
	 nOYx/PyJWplQUQUBTFp8NExEammJWQEyMZbkDsOE5m0riXN8YaLn2TAdaV58H4NpgdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jMLj0ea/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A47606A33F;
	Wed, 18 Nov 2026 22:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jMLj0ea/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53231F000C4;
	Wed, 18 Nov 2026 22:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041507;
	bh=eml+NdJZkSdIALfC0p5FzJo0zSjqBwSA+s6s4Tpq/Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jMLj0ea/u62qeiaA8PNmEusVNda6ed4kC46CBIPPX0stRjbr6zQA229O6lau+MjqL
	 FbvmSX6RmMTgIhzQME0eNZ2lsZ4Md1BHHwBSKr2VolNkjtLALry+ILsoDff9H6vyDl
	 seVcDYVruwi/AuCAhqyp6ke2alQlKbWMPOlvF2sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	syzbot+03aaa576f1daa1c1f2f0@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2837/3318] ocfs2: validate chunk and block counts of the local quota file
Date: Wed, 18 Nov 2026 15:57:39 +0100
Message-ID: <20261118150445.732754977@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

[ Upstream commit b10ef5d2c2083ea4c40e963c10a73a154793c5d4 ]

ocfs2_local_read_info() trusts dqi_chunks and dqi_blocks from the local
quota file header.  If dqi_blocks is too small,
ocfs2_extend_local_quota_file() computes a bogus chunk length, extends the
file, and maps logical block dqi_blocks, which is already in the inode's
metadata cache (the header or a chunk header read at mount).  sb_getblk()
returns that cached buffer and ocfs2_set_new_buffer_uptodate() hits
BUG_ON(ocfs2_buffer_cached()):

  kernel BUG at fs/ocfs2/uptodate.c:509!
  ocfs2_extend_local_quota_file+0x45c/0x1100
  ocfs2_create_local_dquot+0x8ac/0xb50
  ocfs2_acquire_dquot+0x614/0xae0
  ocfs2_get_init_inode+0xe9/0x1b0
  ocfs2_mkdir+0x174/0x430

ocfs2_local_quota_add_chunk() has the same exposure.

Reject a header whose counts don't fit the chunk layout or exceed i_size.

Reproduced with a crafted image (dqi_blocks = 1, chunk 0 dqc_free = 0);
syzbot has no reproducer for this report.

Link: https://lore.kernel.org/20260920140710.43938-1-ngocthang2710.1999@gmail.com
Fixes: 9e33d69f553a ("ocfs2: Implementation of local and global quota file handling")
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: syzbot+03aaa576f1daa1c1f2f0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=03aaa576f1daa1c1f2f0
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/quota_local.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index f92f719e000eb..f67fb73f00733 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -245,6 +245,25 @@ static void ocfs2_release_local_quota_bitmaps(struct list_head *head)
 	}
 }
 
+/* Check that the on-disk chunk and block counts match the file layout */
+static int ocfs2_check_local_quota_info(struct inode *inode,
+					unsigned int chunks,
+					unsigned int blocks)
+{
+	u64 chunk_len = ol_chunk_blocks(inode->i_sb) + 1;
+	u64 min_blocks = chunks ? 1 + chunk_len * (chunks - 1) + 1 : 1;
+	u64 max_blocks = 1 + chunk_len * chunks;
+
+	if (blocks >= min_blocks && blocks <= max_blocks &&
+	    blocks <= i_size_read(inode) >> inode->i_sb->s_blocksize_bits)
+		return 0;
+
+	return ocfs2_error(inode->i_sb,
+			   "Quota file %llu has bad info: %u chunks, %u blocks\n",
+			   (unsigned long long)OCFS2_I(inode)->ip_blkno,
+			   chunks, blocks);
+}
+
 /* Load quota bitmaps into memory */
 static int ocfs2_load_local_quota_bitmaps(struct inode *inode,
 			struct ocfs2_local_disk_dqinfo *ldinfo,
@@ -730,6 +749,11 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 	oinfo->dqi_blocks = le32_to_cpu(ldinfo->dqi_blocks);
 	oinfo->dqi_libh = bh;
 
+	status = ocfs2_check_local_quota_info(lqinode, oinfo->dqi_chunks,
+					      oinfo->dqi_blocks);
+	if (status < 0)
+		goto out_err;
+
 	/* We crashed when using local quota file? */
 	if (!(oinfo->dqi_flags & OLQF_CLEAN)) {
 		rec = OCFS2_SB(sb)->quota_rec;
-- 
2.53.0



