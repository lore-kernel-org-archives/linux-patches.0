Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040975;
	b=t2lYVwSrH1nnxj9fp4c6UNCKMM/ilfAF/Njfvj+75aH0q6hnf773aBQpbNJarHOWkSps
	 LKg9buEbmBNAOSn6Kf1fIwgeL5gNI+P53IIeUjYq/fNafLS8vC/Qvv1oYa+YZzeolb1f5
	 uKAGW+RRMtjFPkR1mM9J7t08Ta9LYxYgC2h50MYnkgDAxoQG7tV9lsewD0ZI/8BJ8uX+R
	 wnbjc3pzlH93ZvUoIPD/7Jk223bvKEbN3G0Aq48s+4d8p8okI53qjj31PLDJjZli7m2fs
	 UQzLOt6zlMnA16TgIGsAvLD73HHfFblIgRqCs4pj5qisfe2xKr2oVvyWXCFeRVA5RTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040975;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FvJurA3ZHq2vzsP3f7zJZYr734W8IK2sGAKy7x+nHUU=;
	b=dh1D4uho1xwya8Q6SnIdE7K4LKONP3vTrLG2eWdmFsaB8cYzAqu4oqT8egoboQedTkYC
	 MhqG4L0/RjssGFOpv6oanndxlO7EkR0j8LnAjGRZ2MpwgH/I/EPwo5dojnaJ8c70lua9F
	 hjs59o6+zARjD389Yz+t2sRvQAvDj04gQdkDbuWLbSL0QPqBvjAssYDS4iKznf8MDDV+i
	 8gqFNUGJ6CoDBpLMN8v8qA3wncSBYJgC5OIi/bBulktxg8KmawC4o+E2XG3JG7OWoBQHf
	 uMeOPGG0WwcpEAO+1H4ZbPkiv7ApBPlJRDbHXB9OELNuTeorGsMpz8dlcCVLNoTM/lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRbn4fDd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E61B606A320;
	Wed, 18 Nov 2026 22:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRbn4fDd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011EC1F000C4;
	Wed, 18 Nov 2026 22:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040975;
	bh=FvJurA3ZHq2vzsP3f7zJZYr734W8IK2sGAKy7x+nHUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRbn4fDdDiJp7Api5plXL/JC2USMw2p4+17HAGwOAsTXYorTVKYyrdyj8n4ciOVQs
	 xhNQzZ93OTKdFYgoW8SgjoTFxqp2dCVaD8ugo5DbiEZExsTokNTczQUwp1DZi4mJhy
	 9h2bBOQyhpSq64HJOWmRCI046pTZzAcrMoq+p4y4=
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
Subject: [PATCH 6.6 2648/3318] ocfs2: reject inconsistent xattr bucket during defrag
Date: Wed, 18 Nov 2026 15:54:30 +0100
Message-ID: <20261118150440.492790505@linuxfoundation.org>
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
index e0f2939978709..33715ab472989 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4865,16 +4865,22 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
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



