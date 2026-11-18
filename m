Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025731;
	b=rjj6ZEjji3pnREg7RcEQZjkoSvAge6+cDtdZZy227/RzZO386MfbH3cbm7++1N/tm1KL
	 dPgYWu2WxCfsZnTXUI7CRBbWqUbMh9XFjqxypK5COUOYGxivUKRmCMsiBR699xEKYs0te
	 //pbjpvBO4jcaBFzUTQ4jhdXSr0NF43Hx6Jq8s++HD3L/q+TeGyD3f2Wb0vBhVjJdlc7y
	 Wn4a7ANaNE1nDyI6ysml5AxZkQt72Rn/6xih1DYwKJJpXSCRGwvFafNJ1LcUsmHRqDqtt
	 +YeyY0N/iu7oRqkjGD+ol05RF2qWcM6D3mMqm6n6Efz8FdueIU2/WoiPvCzMato4fUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LnJlhbllDCl/dUdbVj7Z9RL1PG+NpAac3MgSlC10+DU=;
	b=LE4JIJv2PXG5lH77JIQ2A79sYL/7tku1tE3pymPKQfLH2WYYRMxW0PMahO3BZoMUFcav
	 5GY4XB3wBy3I/lComesL3gOgYTl8LF1vZTJzcrG26fm4ww23uRDDVLPvjIBWNXVVKGLZO
	 Bh+DclnQvkL+MAjoQ1fHw80lmTiEi45gtAa3+BFLFwlAhOYvZGzuUqfCXfv/Kq9CgjZUs
	 Yui5JAN+FmEmwUrPUYkIpDdyy2My3SwIXoZUL0LqRUpMQ37LhGHofsiVweX/xXm5BYsol
	 tUF4ict2zLNXEulmaRwObMaFhUCj43InAvhDUcMJJo2KAcwycoymjT5pQUCKi+35S7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cwMjsz4R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6C6606A325;
	Wed, 18 Nov 2026 18:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cwMjsz4R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4688F1F000C4;
	Wed, 18 Nov 2026 18:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025731;
	bh=LnJlhbllDCl/dUdbVj7Z9RL1PG+NpAac3MgSlC10+DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cwMjsz4RhS54fty8Q0c+bJ/pHNAS+NMZIzDKehu7CwBZFZfYZaHLevfyPrRgRk3GF
	 AZpkNuBj7QXPoZ50CJqtYbuShsCAhIowZ6bAGu42upZcq/dLjYQefN9knICNMWROg6
	 495oigirTwm/58sI6G65JTtutsmB2JcqJSUZdT/o=
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
Subject: [PATCH 6.18 1182/2151] ocfs2: reject inconsistent xattr bucket during defrag
Date: Wed, 18 Nov 2026 15:48:37 +0100
Message-ID: <20261118150205.185700420@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index da31b530b96e0..d86bc4001b131 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4622,16 +4622,22 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
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



