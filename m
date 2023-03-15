Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7564431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4146C433D2;
	Wed, 15 Mar 2023 12:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883447;
	bh=rPtILoKWWoEcQJdETmkVJ7BPNe8f0QkGJY0nTXYW2Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPbF7w0vopxvSmtVsSxhWzJG1YdAhQe85OsQw/7mLLGoEmhY0Vzeexbxgj3f9fr68
	 XIKC0hg2BNbl6OdzeFNCBDkBiyigUo1oZEwUSW5Ujaga8Qolthix3nOrOJ4fzv7J4y
	 wVCs3nicB6CgFM2dCH+kxJYEFmBMVTMOwKuOMnm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5.15 140/145] xfs: remove xfs_setattr_time() declaration
Date: Wed, 15 Mar 2023 13:13:26 +0100
Message-Id: <20230315115743.538740594@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iops.h |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -13,7 +13,6 @@ extern const struct file_operations xfs_
 
 extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
 
-extern void xfs_setattr_time(struct xfs_inode *ip, struct iattr *iattr);
 int xfs_vn_setattr_size(struct user_namespace *mnt_userns,
 		struct dentry *dentry, struct iattr *vap);
 


