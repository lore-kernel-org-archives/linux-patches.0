Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC1D481B7;
	Mon,  1 Apr 2024 16:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988105; cv=none; b=YZ/pdkKlE7jGcgX06OLxlPWic3b2KaulRS6Six0gAljPFsB5AY3rWOfXAAASGRaykFRCVyOzhbEVpo32ZTkKvli7Sqou4W9+vF/oX9BFNYCmNS10EaO5v9vlYp/lcLY8e9nLAC82PyjDqNa1WSaxjTkiq3Wo4P0pU8H5nrvKSXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988105; c=relaxed/simple;
	bh=B6JyT9Cd7ELkmqqaK5giG+hmHtj43JKSI2h47S+KAOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upsKVxmmZGy0ApvZVMS/EGRYwnxsPXDk3mDbPHzjHSa0GnyJ2cfrpXm4NapCRrjn19Y8XACJ0fkcryg7sDEuFNLJpa7bqGi6hlTikwHsrkDZL+ASS0Ns0slkK/4Tx5yZapZ/7xp/jvMMexuWfr/VLpuC4jc6bodaxSP5qTJbsE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bEVsZfPy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bEVsZfPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06D6C433C7;
	Mon,  1 Apr 2024 16:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988105;
	bh=B6JyT9Cd7ELkmqqaK5giG+hmHtj43JKSI2h47S+KAOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bEVsZfPy5S89y4Tybh11u5hn5vAP/lgA8JkEIZ0hjMu/vAj92BGvgGhkxOSX4X+jU
	 NWdXcLsIzbrfsO2PAzW+DVmn+C/o5uz31rzdvZ868kMYKpVKUUXr5elCnpnK0GicN4
	 ZPSbD94MJzCS+IEU9uz7ShvM5T//lci9jkZvy9ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 086/432] fuse: replace remaining make_bad_inode() with fuse_make_bad()
Date: Mon,  1 Apr 2024 17:41:13 +0200
Message-ID: <20240401152555.687143385@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 82e081aebe4d9c26e196c8260005cc4762b57a5d ]

fuse_do_statx() was added with the wrong helper.

Fixes: d3045530bdd2 ("fuse: implement statx")
Cc: <stable@vger.kernel.org> # v6.6
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index d19cbf34c6341..d3bc463d9da76 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1210,7 +1210,7 @@ static int fuse_do_statx(struct inode *inode, struct file *file,
 	if (((sx->mask & STATX_SIZE) && !fuse_valid_size(sx->size)) ||
 	    ((sx->mask & STATX_TYPE) && (!fuse_valid_type(sx->mode) ||
 					 inode_wrong_type(inode, sx->mode)))) {
-		make_bad_inode(inode);
+		fuse_make_bad(inode);
 		return -EIO;
 	}
 
-- 
2.43.0



