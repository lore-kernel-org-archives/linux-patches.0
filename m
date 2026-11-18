Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038106;
	b=GVixvx/ZU6NCy9stYN8B4tQ0iZuVETCh0pgmJ6/RArdQ+NJ046gEDLrUZ3eT6ZBztIWu
	 okP5/MM4+Le208w5MCF6WTsk/QAt9/OBjiOB0/bs7MnWiazfWYNnGomJryvvXscjlJe+o
	 vBVoZynsbjtxYtJ2lBCuviaqDo1dgXaYCtpFfYbKpC3MmubVzgrbf/5KcQ+5n3wQC6h/d
	 G55BD+cVvGAKbgRaS3u4xygsEKdaulbZZqdrd/JOUWNZrFW1yPGRBvK+cQe1JUpNrlslE
	 ohvY+3AGtixZTV7B2e60DMNwwS2KEgNrFAJoK4JZ+cx/wSkEEaSjuu8PpbTbTVDVaLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038106;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mhY9JmQsnuXkSjxy9fVkDf+fkHAJxskgUUaCK5PF8rk=;
	b=tF/bjKilT6Yzou8w/W3ZIymgTKQYCZNl+6sJCRthVhIPPBhsojn3DNDkOjLFeBM+t/vN
	 cxzo4xMlRDNFYWhy1UlextBtTW6biC5+E9U0jNYWhNE8bA3Ny20b9Nyn3Q3thKOA3A7uy
	 K24hFIjcXERXNcklcO9C7biroibxHcGaYsnFFj0TVD0YvA+EzmXjiFawBctZC50Qjg+Mw
	 aFUZmy+0hv9aOAUkoyVwmdOKzPNrYTHZLXKGYIxxv+Asy65emv7n3gP4heIuzZvaoQ+jL
	 x4n3asqiHYeD36hEmOZ7tJtOKEeyQWxAd+8S9aFx6X8LQ/CBy677d+NfvWHMpPK93tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XRhQTsnE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDE1606A320;
	Wed, 18 Nov 2026 21:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XRhQTsnE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8831F000C4;
	Wed, 18 Nov 2026 21:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038106;
	bh=mhY9JmQsnuXkSjxy9fVkDf+fkHAJxskgUUaCK5PF8rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRhQTsnEXnEx6cugW7Cnu3+lCpxPGHEp2OzHRi9oKFZSoLhEWIONo9DCv8WuRft+v
	 f/0cxtFUP5Jd4xNCudcN2/yAzoDrOhPU+CHf5hChJVSdEWS6JzI8s+gMMu6N6IaxbU
	 /MGYTK5KkrlT9waZJVWrEkva8UAcxtiKbjlMu6q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaming Zhang <r772577952@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1628/3318] gfs2: reject invalid inode sizes
Date: Wed, 18 Nov 2026 15:37:30 +0100
Message-ID: <20261118150410.580076820@linuxfoundation.org>
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
[ sashal: adjusted context for direct inode->i_state access instead of inode_state_read_once() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glops.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index f575cd8ff47c1..0be93498e3308 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -412,6 +412,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	umode_t mode = be32_to_cpu(str->di_mode);
 	struct inode *inode = &ip->i_inode;
 	bool is_new = inode->i_state & I_NEW;
+	u64 size;
 
 	if (unlikely(ip->i_no_addr != be64_to_cpu(str->di_num.no_addr))) {
 		gfs2_consist_inode(ip);
@@ -437,7 +438,12 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
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
@@ -475,7 +481,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	ip->i_depth = (u8)depth;
 	ip->i_entries = be32_to_cpu(str->di_entries);
 
-	if (gfs2_is_stuffed(ip) && inode->i_size > gfs2_max_stuffed_size(ip)) {
+	if (gfs2_is_stuffed(ip) && size > gfs2_max_stuffed_size(ip)) {
 		gfs2_consist_inode(ip);
 		return -EIO;
 	}
-- 
2.53.0



