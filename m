Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055871;
	b=Pcatm6VaKZftry20yzbfJne7zVtU3qjPGN04Z8c7B6YIVasbqMEiIVxA+5fGD58p8Qsc
	 z9dkS3mM9v7GA3jpFbLxjjo2Mm7lx99QSlbfnme/Xn5tbOU/u8HjGR5P5DtdfQEjqxLB5
	 R7E6fQ4FLZkkCZjGanSdkQgS6ZvZukSmt+hbFhUICHSPG7ua5zDwagBbuXo14zRcwAzaF
	 DZ31IOtbCy38ma/pBBdhaZM5kpItRY6DOi+8YkgWTXJ8ULmDz62aSQD6Htp46WykJJH1B
	 az1ZsIJVPFc/ef5hfOGXDtQg2nuifdCT/lg9yrXXxvTMRDFFC52v/snAlTwXCZ+iJyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KdsJCg3/GOJHa0+pIPwgOfRQihw4AyrvsshRmT7KjWI=;
	b=jJr4k8BJM/rb9ryJY2DODdLOYIz7791juYbnCENE1MU5WCXenRNQkIqou/o0ES6+55Rd
	 bZHI9KJQJGf3CA8nxFEOoQJgB1arfEOyDUfP17tQ3ErCGBdDBLhdpXc2RbkwY600W4zPW
	 yMjHWnE1NqSfAFQ6aeMX1YjlFdj2xStxGEhXmzxKcuPNOJyddi8ojNJwhccK23aOoJBpZ
	 cPmH8kwNs9oi+jciForvD3Og7pF1FdUIYvJJoxFxGYjVzlVonASoKuPVKHzURF/dcRfaI
	 rWwUENgkQsWB3nmRvCxWMFvE2mkugLhgF/Kfva6ZHDSmqu105JcEXTk8Jpay3Daki0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQBWQdg4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C22606A31C;
	Thu, 19 Nov 2026 02:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQBWQdg4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9DF1F000C4;
	Thu, 19 Nov 2026 02:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055871;
	bh=KdsJCg3/GOJHa0+pIPwgOfRQihw4AyrvsshRmT7KjWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQBWQdg4rybOJ7bv2DUQClylyoVoajJP8izzfVLmizzVQULLBCcZP1rKdSL2dPoUr
	 LBx/xh/JCva10fsTO4urwUZRCcIEKtFrskxYAUiBVzzbpGRgRG6jqmiwJv989F1Zj4
	 PUMecNC0ueOk2rye3qq+UAGtr/E6mXVXnzNrj8uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Changwei Ge <gechangwei@live.cn>,
	Heming Zhao <heming.zhao@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	Jun Piao <piaojun@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1787/2214] ocfs2: reject inconsistent xattr bucket during defrag
Date: Wed, 18 Nov 2026 15:57:43 +0100
Message-ID: <20261118150122.957553868@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit bd40b997f04542869afeabe94f2cf1a016fc9bfa ]

ocfs2_defrag_xattr_bucket() has two mlog_bug_on_msg() checks that assume
the name/value pairs in a bucket are disjoint and that xh_free_start is
not below the compacted region.

ocfs2_validate_xattr_bucket() only checks each entry in isolation, so a
corrupt bucket holding overlapping entries, or one with an inflated
xh_free_start, passes validation and then hits BUG() in defrag when a
setxattr triggers it.

Defrag works on a linear copy of the bucket and does not touch the real
blocks before the copy back, so the checks can return an error instead of
calling BUG().

Link: https://lore.kernel.org/20260903131313.2396208-3-joseph.qi@linux.alibaba.com
Fixes: 012255961c9e ("ocfs2: Enable xattr set in index btree")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index df29b1807c37f..6a462fef115fc 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4564,16 +4564,22 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 			memmove(bucket_buf + end - len,
 				bucket_buf + offset, len);
 			xe->xe_name_offset = cpu_to_le16(end - len);
+		} else if (end < offset + len) {
+			ret = ocfs2_error(inode->i_sb,
+					  "Defrag check failed for bucket %llu\n",
+					  (unsigned long long)blkno);
+			goto out;
 		}
 
-		mlog_bug_on_msg(end < offset + len, "Defrag check failed for "
-				"bucket %llu\n", (unsigned long long)blkno);
-
 		end -= len;
 	}
 
-	mlog_bug_on_msg(xh_free_start > end, "Defrag check failed for "
-			"bucket %llu\n", (unsigned long long)blkno);
+	if (xh_free_start > end) {
+		ret = ocfs2_error(inode->i_sb,
+				  "Defrag check failed for bucket %llu\n",
+				  (unsigned long long)blkno);
+		goto out;
+	}
 
 	if (xh_free_start == end)
 		goto out;
-- 
2.53.0



