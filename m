Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056274;
	b=roPKc03va0PguFRdBf4a7akWsUgJcQCrt6tGhpNpJ2N8hHTiLJtBGDLVat+S44exb0Uf
	 wAquQCyRr7ZOhRZZBnMxIOOWyKs/0jvAqFbtyIv5+tIk4RbB8vt63GvFVhrdheNDqcsNH
	 k+PlX0x50yHEK8FUIjj3ULhWKPw9BqvqRld4fZ/VmSDwwDJ4tFe1ijR5ryUkt5dMk349s
	 gdZuXsmJUq2DVZ+GddFio2FroM+YwfKAy/zZIK9q6+I90FnNLeYQyqFTesZuZSWqxoCzY
	 DZBZjkrkhCdmAfBI/RKtxanZf+7Ss6kx5currLGwRYyw6pqMKbCu57dG2mp945TIeVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HWJHFvz3Chp8CAc0Qh/abKdhp3Dv9N5Co9cTOdYJTQM=;
	b=PJiQl0fEoVIsi4dFH2Rl/HopNoSDsNDAj59Zs7GQJ3CeKfHG03CuQoq7mqvbyN+Jo7SS
	 qoFRwDK+cvyjPhHG51233xQg0AAjZ/8Hy0APyPJGGmpHfxb1qGgWuRoMku8e/Ip3jCM4f
	 SSNawho+2SFDsNDXm574KlMeOtgUf+otQGHndHQwm40cXL34W08eDiidhktxk5zbBLmwE
	 2g6qi6zm6V53Gvrnub4Y9KIIy6rTiZq7hFVy7r5VyAreV/YwVXNMa9Y/fonjIoNYHvj54
	 WEEq0OgTin3LrvE4fNILFyeAAooNefjLLmy+kGCs3lZZvJKw1pS3HhnncQdUZed6XUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TcevXbD+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8155D606A31C;
	Thu, 19 Nov 2026 02:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TcevXbD+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5B51F000C4;
	Thu, 19 Nov 2026 02:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056274;
	bh=HWJHFvz3Chp8CAc0Qh/abKdhp3Dv9N5Co9cTOdYJTQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TcevXbD+tX7bQ8Cn6KbFQPJ9HnQuedKC8OZ2UucPKEfugOLn11I2dAXG5TkU89frB
	 vcPNsHyZZ2eETklqf0Fpv0fGpzwiwGShgtPSXEUX+GjlFbbNTsbq6FcOTN7BkZtgqS
	 it9Il+1L/+E6CANaU4YnAprnGfMHgVmUDEZYtsuc=
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
Subject: [PATCH 5.15 1902/2214] ocfs2: validate chunk and block counts of the local quota file
Date: Wed, 18 Nov 2026 15:59:38 +0100
Message-ID: <20261118150127.236645087@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cc78b646a9146..bff16c78fd383 100644
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



