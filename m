Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A251C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB28C433D2;
	Mon, 20 Mar 2023 15:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325295;
	bh=JCI8T55A4wHjY0TLBmAldxULirJVLqvkP2CJlPCh/VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zLdY4NzY7VyNPs1bV34cBsSjH6PwXK3xieGhSXIALEL161plAv0lcrjtzPSLEO3o1
	 I7h8gSptE35dsHhbpgQwK7YOEpKUF1oRLLnWl17t7p6h3zM4GwLH4CIVVmNMzI9fVa
	 B9MU4mysweEL/ecd1sB0TN0mVLMyQp5zSCXlnwDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 97/99] xfs: remove xfs_setattr_time() declaration
Date: Mon, 20 Mar 2023 15:55:15 +0100
Message-Id: <20230320145447.485800119@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

commit b0463b9dd7030a766133ad2f1571f97f204d7bdf upstream.

xfs_setattr_time() has been removed since
commit e014f37db1a2 ("xfs: use setattr_copy to set vfs inode
attributes"), so remove it.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iops.h |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -18,7 +18,6 @@ extern ssize_t xfs_vn_listxattr(struct d
  */
 #define XFS_ATTR_NOACL		0x01	/* Don't call posix_acl_chmod */
 
-extern void xfs_setattr_time(struct xfs_inode *ip, struct iattr *iattr);
 extern int xfs_setattr_nonsize(struct xfs_inode *ip, struct iattr *vap,
 			       int flags);
 extern int xfs_vn_setattr_nonsize(struct dentry *dentry, struct iattr *vap);


