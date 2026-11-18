Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019004;
	b=h8iVht0MpsD/kg+2kMJe4zzR7pGpsuQ2lmmepqIsI2quE96YjGPK16ExDD1gXp+jp3fn
	 waEHpJ+eaEcpv0tk79NptOgtxAHsqYWzdKcw6CoUNA2vqUOemEez3zQXt2L+YNC/6kVvJ
	 cYsR25hYNpRAoyGNW3+f9oqlwOaPobij7SbQsamaeiYmfZTdUXy4RpqUGVxfD/7UJ8DZ/
	 1zMw/w9EnS8bwVLXcVe7VQk6z825v6OpL9njOIm4yio8kL/Lmkdoq83sNu/mzf3I4t7oW
	 MKAn4C1yCjRZ1s0wDj/tjcP81JTdfImx+jfQMsxK2QaXoMfyEvL/MkX6TFhpC7HXISg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019004;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=53Ov4ORdZw1ZZKebVn0jTGrwLOLwLzMZy2fJGJomkJQ=;
	b=4xs3iZeUkYP13UcJzvCI0SrKFhtxtfN9K/nOaTKVoxEWP1i88Y30Ik2l6mSmw7wH/MYG
	 506UKK4UyNNauw8U1Ut94h9CQ/j6gB/QkgCACeyeVysxVHH+hjMKfKFrs8oSjW2paehaF
	 Tt6JFHeB38f/l336kjRoXfQliK9ToDqZVAgY/+3sVPWLUxu1LhlvIMT6BYx/N9pmAz5je
	 4nQXBXAq9fXf1IwdBhsKkEvCcE8hiVukc4wRLYBUlI2uJBLV38m1Zwwh5P8g31XpW2BF6
	 1em54SxXba+EE5Yi92A9epkvjP/HvfizVQXUBJKbs/cFF9Jwm4wzV/pOYYU/HJOcPXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VibQ0++T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6985F606A31C;
	Wed, 18 Nov 2026 16:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VibQ0++T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6BA1F000C4;
	Wed, 18 Nov 2026 16:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019004;
	bh=53Ov4ORdZw1ZZKebVn0jTGrwLOLwLzMZy2fJGJomkJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VibQ0++TFI+rhunywdfCiD2oBZro7Za4JQ/R7U0jXxxXTdKDVu5JpanQnThKoy+3h
	 NI7ccOkGhLsqWnayXBBODjowSusAp0GayEy+oh1iUjn9Rcn0QfcM1xS7HGGoTNlR+c
	 x3iRwZxrKcJ1SnZ55KgYd+qBwC2qUVzuVTm77Av4=
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
Subject: [PATCH 7.3 1400/2651] ocfs2: reject inconsistent xattr bucket during defrag
Date: Wed, 18 Nov 2026 15:44:00 +0100
Message-ID: <20261118150338.409759260@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e3c50cd120cd1..0b49e6c929c9a 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4879,16 +4879,22 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
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



