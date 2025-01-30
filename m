Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47661E7C25;
	Thu, 30 Jan 2025 14:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247367; cv=none; b=oHQGl8zxGzR+HWI8dDoB/Kionpotv0z8+vhymr3ZTDOxuGhb9VJxw+/5Q5lFYCmOpEn/yKFwbDcy3gl2QAkbQ06uULvsanSMpnJ2yJqped6rrlBe88sk98eBv6FMzw5Q3QAqWpy4QDM/a+UVUOm+vVvca+HyjfxvdROkSWEOdDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247367; c=relaxed/simple;
	bh=jmTa+mBg+GdIY68vjpw0InxFtykQE7+xshVDSGCMzHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWXgBY7LLsAojSSsdDUQVjqk5atHpfZmZVrWQBklrFm12WF94CbLm4n3ZE46F3Kbfi8Rw2az2wbg2xwdyOUoiQT+1lZs4ODAZmendINYFUiwlB+G9NhcTdNWQxJQynmA8iM9LSp3nASaho5vOaZJ+cCgmKIOyGTCWU//IjQ2qaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=asjjO6O/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="asjjO6O/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9C4C4CED2;
	Thu, 30 Jan 2025 14:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247367;
	bh=jmTa+mBg+GdIY68vjpw0InxFtykQE7+xshVDSGCMzHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=asjjO6O/vg7PPwC/KyMmbMqOsnKC66DSmH7IJ4V2UxWfoTwYc3pL+eoSgPpCT19Ck
	 kdtAMfhzlgh28kNxHVKAyfHNAcN1EJlZB7nIG5BAzDwcOvtpe42iyEQrD4vPlIjiKp
	 BvkUjongpLQUscYi7o7RMRf/+KKxBBvzozjUdMNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 15/49] xfs: rt stubs should return negative errnos when rt disabled
Date: Thu, 30 Jan 2025 15:01:51 +0100
Message-ID: <20250130140134.445811278@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit c2988eb5cff75c02bc57e02c323154aa08f55b78 ]

When realtime support is not compiled into the kernel, these functions
should return negative errnos, not positive errnos.  While we're at it,
fix a broken macro declaration.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_rtalloc.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -141,17 +141,17 @@ int xfs_rtalloc_extent_is_free(struct xf
 			       bool *is_free);
 int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 #else
-# define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)    (ENOSYS)
-# define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
-# define xfs_rtfree_blocks(t,rb,rl)			(ENOSYS)
-# define xfs_rtpick_extent(m,t,l,rb)                    (ENOSYS)
-# define xfs_growfs_rt(mp,in)                           (ENOSYS)
-# define xfs_rtalloc_query_range(t,l,h,f,p)             (ENOSYS)
-# define xfs_rtalloc_query_all(m,t,f,p)                 (ENOSYS)
-# define xfs_rtbuf_get(m,t,b,i,p)                       (ENOSYS)
-# define xfs_verify_rtbno(m, r)			(false)
-# define xfs_rtalloc_extent_is_free(m,t,s,l,i)          (ENOSYS)
-# define xfs_rtalloc_reinit_frextents(m)                (0)
+# define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)	(-ENOSYS)
+# define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
+# define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
+# define xfs_rtpick_extent(m,t,l,rb)			(-ENOSYS)
+# define xfs_growfs_rt(mp,in)				(-ENOSYS)
+# define xfs_rtalloc_query_range(m,t,l,h,f,p)		(-ENOSYS)
+# define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
+# define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
+# define xfs_verify_rtbno(m, r)				(false)
+# define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
+# define xfs_rtalloc_reinit_frextents(m)		(0)
 static inline int		/* error */
 xfs_rtmount_init(
 	xfs_mount_t	*mp)	/* file system mount structure */
@@ -162,7 +162,7 @@ xfs_rtmount_init(
 	xfs_warn(mp, "Not built with CONFIG_XFS_RT");
 	return -ENOSYS;
 }
-# define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
+# define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (-ENOSYS))
 # define xfs_rtunmount_inodes(m)
 #endif	/* CONFIG_XFS_RT */
 


