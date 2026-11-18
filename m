Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031113;
	b=PcJTZ5cVfOkE/Xq2VqebYMg7A6SZpIzj/ZRn0xIJnsUFxWwrm7y76zdME/q0A79uqmhW
	 BAJPiiYX1Kt6PxnGdbFyw4TkcuJQn31Apmk2Jkk4xyaqB7LSKDI8MZRisqqBrKfv6UfnH
	 j4iglnSNF09HK8oPLoAnT0xKNtRjzorA/wHO3rAQOt2yznAy9630dZCsWdZM7JOJghYTR
	 FBQpwbPf74uyrfGtPYiWPk+48L9iPpvrUXFb0i3B7l/BsMwJU+31EI2qRu0JrzFqHZgjP
	 1PwuCPZwB7Hmg6RTLvwsd8v+XNeMZPrlmPv1XXoLpDtqc8Lt4jNhQtt261RvO0C+YtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ikrb9ppSZ/ElLqzhPNQvpvf92IEA2z+Cs5TTj+0ahw4=;
	b=qgrMC+XkQ8ecsBHjvUbSYjrSvdhofwUOFhOeCqXKIIExdcex09DBT8yuVzAwcHIkc0c7
	 48MIj69YN9CFqqwTQcSfMK4hLfz6u3/748COBp/Y2MNE7F6pwirN2nBoPhnDaTKTiXch8
	 8k45BmcMka/xiWHVmpqJjC5FBYRb1v/AVf6dcdzDNFwZTeC8cSVVugJ/V9gbvWZ0Qy8KU
	 fq1l9mItGxFr2OxuP1k+cQZwvmtN4L+DL1I0S47NLNrKW852edy6BXrKVfEG/xdOitPbq
	 Z+DoIq0sI4rPk+cMliu6Y+yGmpmTC6Fo82uwTBFjEaYJ0hR5qv5w3WIwdY+9Wi5NlRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tgeDWdad;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068BF606A325;
	Wed, 18 Nov 2026 19:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tgeDWdad
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA401F000C5;
	Wed, 18 Nov 2026 19:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031112;
	bh=ikrb9ppSZ/ElLqzhPNQvpvf92IEA2z+Cs5TTj+0ahw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tgeDWdadGQjOJjSemWCi4MxJAj+95UTv1R+MgYuncB+LMs/VYHqEfxHGXiK3Dw93f
	 yXiqH7YBQVBMj8up4uU8Dnx1SWm2qoS4nU4MiWcghlLxq80yXsdmLBgI5Be144Al/N
	 JdyPewdonKEKHwcL49aASObF27mW5+sY8aXwZri4=
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
Subject: [PATCH 6.12 0943/1756] ocfs2: reject inconsistent xattr bucket during defrag
Date: Wed, 18 Nov 2026 15:51:10 +0100
Message-ID: <20261118150047.587980393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 391998626cf0b..f9f07d9115a66 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4856,16 +4856,22 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
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



