Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059386;
	b=x2QCu3PLpZf2BNOuK4XdW8UFTn0YPHesKZZ7V9KsaMo9uzL7GAZzDvxrIL0OwwPDFiZo
	 eQfHkwNHDLzshQELvibxrh3VHkLWj+vV+g/eYVBAOgzwXvqm139euIyJSrMAU3lhCYgTc
	 V5uZKNwOlqgN/JrltFH12IMOgEuqTkbdOcwAo2zZS4wohUF71Q9sbLS8GWbQJfcTqxiOf
	 dKaAXLZDJlHf4mw+hF+HnFJtlZM+8ucU3CLvG8epYiAaL1PzgX9CPhhx+QgFVbzMCEagt
	 r3g1aUO1I1X8wfCPCyRNytH+9wYV//mn4zmYELWQTOlVuE38Ywjcyk0g+/BEuomHaQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xiVioUHEGzIbu0dHAsuJ4UyyZume7wxjSK+Z27eWIvM=;
	b=iti8jO7T5lnyHUSuxtLT6h8ws0VUi4F8fx1YnKzp1d0NViM/HGzfEqSiiNGnqmx1ysnf
	 z/xRjRJhckGMQ1V5vnLRLNLqdPOBjuqD3kmVugphoTcVDt6aQYCmc8a4U31lNjwjPciHQ
	 ZQNhUlnj0TPsbxhUGoxEi/m7QO7yjgRO6vCOGNQNwI4Novior3upC5TVDyFi+pGkwi7N5
	 ppkg//gSWMapWs9w6i0z6x3PbbvybWgHE2GmiUbgangxRqGLqN1d5lNSBuKQUh5bNWERl
	 IyZG7esDIEmyyBw498EKjERDS1sRCh6f1UGUqtk6gd+TkACz6pqXkqGzTDEefIEe9Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vLgeRhIg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDE7606A325;
	Thu, 19 Nov 2026 03:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vLgeRhIg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061B81F000C4;
	Thu, 19 Nov 2026 03:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059386;
	bh=xiVioUHEGzIbu0dHAsuJ4UyyZume7wxjSK+Z27eWIvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vLgeRhIgbN+YsPNKE8oD4CwTpTYSJ5v2oFJhOc+g3QkFSsJ/x10Kh8D8cs6e+xzzP
	 fuWwJ7IoJf0NE1s9DuGu+ROc8yb9ZdOkMGTJ1bS0TEsDfbm49of68BhzQhY9m1milg
	 pU2jvDwbQB0t+LDKK3ufNIqhPZYw443zbZwct2lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaming Zhang <r772577952@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0823/1848] gfs2: reject invalid inode sizes
Date: Wed, 18 Nov 2026 15:47:41 +0100
Message-ID: <20261118145951.143623917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted gfs2_dinode_in() to use ip->i_inode and the shared corrupt label instead of a local inode pointer and inline error returns. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glops.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index a4050468feccb..8e2d3b1f566d4 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -410,6 +410,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	const struct gfs2_dinode *str = buf;
 	struct timespec64 atime;
 	u16 height, depth;
+	u64 size;
 
 	if (unlikely(ip->i_no_addr != be64_to_cpu(str->di_num.no_addr)))
 		goto corrupt;
@@ -427,7 +428,10 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	i_uid_write(&ip->i_inode, be32_to_cpu(str->di_uid));
 	i_gid_write(&ip->i_inode, be32_to_cpu(str->di_gid));
 	set_nlink(&ip->i_inode, be32_to_cpu(str->di_nlink));
-	i_size_write(&ip->i_inode, be64_to_cpu(str->di_size));
+	size = be64_to_cpu(str->di_size);
+	if (unlikely(size > ip->i_inode.i_sb->s_maxbytes))
+		goto corrupt;
+	i_size_write(&ip->i_inode, size);
 	gfs2_set_inode_blocks(&ip->i_inode, be64_to_cpu(str->di_blocks));
 	atime.tv_sec = be64_to_cpu(str->di_atime);
 	atime.tv_nsec = be32_to_cpu(str->di_atime_nsec);
@@ -459,7 +463,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	ip->i_depth = (u8)depth;
 	ip->i_entries = be32_to_cpu(str->di_entries);
 
-	if (gfs2_is_stuffed(ip) && ip->i_inode.i_size > gfs2_max_stuffed_size(ip))
+	if (gfs2_is_stuffed(ip) && size > gfs2_max_stuffed_size(ip))
 		goto corrupt;
 
 	if (S_ISREG(ip->i_inode.i_mode))
-- 
2.53.0



