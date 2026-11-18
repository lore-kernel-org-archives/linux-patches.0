Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046758;
	b=JkLZLf9rAwbpNxz7kEyPfUxVmfz4pHobQ5eaR8w6IdlZ8Yo9chtLthJ47bFpePHOMGPk
	 mzSeApqvGgNzI0fZKJPK6OsZhVIZu+C3sgfhp+HJlMvNdOzlewSUM7MU2CM92Otk9n/lO
	 2fQA8OyJI0UbFsHD+2HRaP0UzvYM9+CaVt/myZI19YVNGRBGWZg7mAGPQDd23laaBYDEZ
	 21gTCXhsYKFwmUd81LVQPV5XdMZRZ6SjoOpAX8ksKxA4jJ7eYjIikI6fsywmvvJbygwXP
	 VhiGyrZjSlR4T3JdkBqTDXUUpJXRgR28S1OWxIhd0dAd3+dIAUuVKOPHOCqL5csFvHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oP+r8pAz7g8ebCNElzSkQgkqB0BPfrsPPZJNvlZHscg=;
	b=KH2gcizW77oxXBuaHMOVTvem3qNi0GsYxJTOcA99coCbuz7qXrB7uG03SqpK72hMiH6Y
	 UIXmXuVFX/Y583uY9I8rbLyFchSPUjmnA4Pz+0QR+VB5hY5xKKxbNJARFLRDlWPDrRCdr
	 b60c8pfFNF1hzp2jHwj0+cNnJSuvK//I6aETiF7MwvaI+iq5sz/RWdLIvAeo9rI0nrrkz
	 PHO/MnfNRmQZP+nBgr101aWVS9nPyN0U8ThF7T/lYNW9IrQ+rvQ5PoCBG+0fojOspOpsw
	 Txuqu95PT8ZSY1CcWDhzZmTZS3DHuY+FGc2IllG69weCFSoP2AEPImyhlWh24LokTtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aaCAeplA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38726606A31C;
	Thu, 19 Nov 2026 00:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aaCAeplA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866941F000C4;
	Thu, 19 Nov 2026 00:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046758;
	bh=oP+r8pAz7g8ebCNElzSkQgkqB0BPfrsPPZJNvlZHscg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aaCAeplAFPna1SdyLqZL8nLlBhGDF168B304uJxFCMshvnxS0B4wJ5l1cSAk7jzqd
	 SOdNaQoHPAkxZfb+jwfMHtP8sv9m7iG7BHMBhIZH5Au4mCTwDenb9bDQknc+MDcia2
	 G50GptQlOcHGbsGFwZz5BGJNlk/7dwFTpKV1lZ0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaming Zhang <r772577952@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1378/2857] gfs2: reject invalid inode sizes
Date: Wed, 18 Nov 2026 15:40:12 +0100
Message-ID: <20261118150250.992696728@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaming Zhang <r772577952@gmail.com>

[ Upstream commit 33ed0a0567e0abe66ea65e89dad2e35082890fbe ]

A corrupted GFS2 image can store a dinode size that is larger than what VFS
i_size can represent. gfs2_dinode_in() reads the on-disk di_size as a u64 and
writes it directly into inode->i_size. If the value is larger than S64_MAX, the
incore i_size becomes negative. That negative value can bypass the existing
stuffed inode size check:

inode->i_size > gfs2_max_stuffed_size(ip)

Later, gfs2_quotad may try to sync the quota file and unstuff the quota inode.
gfs2_unstuffer_folio() reads the negative i_size into an unsigned length and
passes it to memcpy(), turning it into a huge copy size and triggering a
out-of-bound issue.

Reject dinodes whose size exceeds sb->s_maxbytes before storing the value in
inode->i_size. Also make the stuffed inode check use the raw on-disk size while
it is still unsigned.

Fixes: 70376c7ff312 ("gfs2: Always check inode size of inline inodes")
Closes: https://lore.kernel.org/lkml/CANypQFaF6bvORKKbRALvEL0k_epFaneFiOQqco4gjdmKVbdURg@mail.gmail.com/
Assisted-by: Codex:gpt-5.5-xhigh
Cc: stable@vger.kernel.org
Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
[ sashal: adjusted context for direct inode->i_state access and existing inode depth and entry assignments ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glops.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index e7904c1c985f6..0fa7b6f1f4218 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -404,6 +404,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	umode_t mode = be32_to_cpu(str->di_mode);
 	struct inode *inode = &ip->i_inode;
 	bool is_new = inode->i_state & I_NEW;
+	u64 size;
 
 	if (unlikely(ip->i_no_addr != be64_to_cpu(str->di_num.no_addr))) {
 		gfs2_consist_inode(ip);
@@ -429,7 +430,12 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	i_uid_write(inode, be32_to_cpu(str->di_uid));
 	i_gid_write(inode, be32_to_cpu(str->di_gid));
 	set_nlink(inode, be32_to_cpu(str->di_nlink));
-	i_size_write(inode, be64_to_cpu(str->di_size));
+	size = be64_to_cpu(str->di_size);
+	if (unlikely(size > inode->i_sb->s_maxbytes)) {
+		gfs2_consist_inode(ip);
+		return -EIO;
+	}
+	i_size_write(inode, size);
 	gfs2_set_inode_blocks(inode, be64_to_cpu(str->di_blocks));
 	atime.tv_sec = be64_to_cpu(str->di_atime);
 	atime.tv_nsec = be32_to_cpu(str->di_atime_nsec);
@@ -467,7 +473,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	ip->i_depth = (u8)depth;
 	ip->i_entries = be32_to_cpu(str->di_entries);
 
-	if (gfs2_is_stuffed(ip) && inode->i_size > gfs2_max_stuffed_size(ip)) {
+	if (gfs2_is_stuffed(ip) && size > gfs2_max_stuffed_size(ip)) {
 		gfs2_consist_inode(ip);
 		return -EIO;
 	}
-- 
2.53.0



