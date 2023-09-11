Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386531170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85460C433C7;
	Mon, 11 Sep 2023 13:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440696;
	bh=sKM4NzcPuRQ3vSF6ZfwfaqQtRmkCo5csv0gnUxvIL3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oOc3A8S/scCgb/cmrS4Csb+fO9Q9JzKMEe/p33ZmAn3Z8SimK9tDQmCX7B+A9XESm
	 cnI2n0iVoYGd56i60aE5XBKzSWpz7nPSEP9JMUIQyo+bRcgiCZ++ZogN6/UOmz9AdD
	 frQPmaL5szPRdUBNRlhn3zK2IyAoHEqIgZTQ1Okc=
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
Subject: [PATCH 6.5 153/739] fs: ocfs2: namei: check return value of ocfs2_add_entry()
Date: Mon, 11 Sep 2023 15:39:12 +0200
Message-ID: <20230911134655.413761672@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 17c52225b87d4..03bccfd183f3c 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1535,6 +1535,10 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
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



