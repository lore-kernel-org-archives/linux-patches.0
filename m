Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEB72E64E
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9DBC433C9;
	Wed, 20 Sep 2023 12:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211931;
	bh=HySwVNL+KNnt7ICfavRUZ19AtTzqDqu5MaohSDEZSuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRar88AuDKA8oLWvldtb6RTZTuaIV+ZCLUQqZMz4sUnsdrbYgz3leXpiFinq9qRmh
	 hQzyaukR0BEJZeC7oiL8ASmXQPOi2Ya+DRFWTpdkwj68mHk1e/hjIrZp2SnhgYRzqK
	 zAusETkv9imyb28Z2FQR8VqWWFRlxEmeoR7YI080=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Joel Becker <jlbec@evilplan.org>,
	Kurt Hackel <kurt.hackel@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 062/273] fs: ocfs2: namei: check return value of ocfs2_add_entry()
Date: Wed, 20 Sep 2023 13:28:22 +0200
Message-ID: <20230920112848.376074946@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Chernyshev <artem.chernyshev@red-soft.ru>

[ Upstream commit 6b72e5f9e79360fce4f2be7fe81159fbdf4256a5 ]

Process result of ocfs2_add_entry() in case we have an error
value.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Link: https://lkml.kernel.org/r/20230803145417.177649-1-artem.chernyshev@red-soft.ru
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Kurt Hackel <kurt.hackel@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/namei.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index bd8d742adf65a..bb8483510327f 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1538,6 +1538,10 @@ static int ocfs2_rename(struct inode *old_dir,
 		status = ocfs2_add_entry(handle, new_dentry, old_inode,
 					 OCFS2_I(old_inode)->ip_blkno,
 					 new_dir_bh, &target_insert);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail;
+		}
 	}
 
 	old_inode->i_ctime = current_time(old_inode);
-- 
2.40.1



