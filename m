Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061344;
	b=JFJHW0APJFPyJYgpt5Uun63DWEvZa0aFLvfRqacIVbnrDsC8hsElRYbn9je1APbU8zh/
	 fov76RvkfxCUAazvUIc1Eg5hgJ7J5Z3XIsjMy8lo9SOrImRrnhkJwzG3dlSnDZiyINE65
	 gUGb0sn2YUCkRT1WZ74jLZhh9SGmK8kvO+w4g6vWTgvbuXCfwr6BMZG9laM2T2ekRWDsc
	 dST9s9o4D6m08VXHncT30rIK0BByblqpjAiR0vK7iS25WUsDN2TnDtnJ9/N59nyzGSQ8t
	 GzkjBEoaQl/oBoPellqEWwDbr0J9jcE3YrLc7t45UMpHrT0IBT+RlHVwJGSiLmOOnaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Kpd04h/nk8Imuub/SXnAD7UgiIcD/2cOGIaZv7AxYA=;
	b=4jkR2LjxH2LqnhyLlEEqLKvLjud/4RWX94TVYUwHtoFlgiCyjMv0oUYJZK098WXw4xUk
	 WdZJC04TEiyEDTf3tP4Wj+vhypJCin7R4S1WTlDTyhnIkOsaJatUoidiMMKSZviZTLnb7
	 IwSMMSF61DC2WafIwtCHRk+ATDQqhFi0rX8X5cOkh91yioQpHTH0xYMCJPr5b/dOXuWEo
	 9W3P4wqbLjgvPYvlerqJjEtATCpHI6/y0GlM9uFiAhm8uh9FaCxF8kpJTj+xGzOlTMUNJ
	 2XPnMy7ZRpDrmv5e/5X/QD8glWOEWrIhDg/U6qevngs9s1QsyLs81zivFJRvGaz+t7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="q/Vqzxh3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9133C606A32A;
	Thu, 19 Nov 2026 04:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q/Vqzxh3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4D81F000C4;
	Thu, 19 Nov 2026 04:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061344;
	bh=1Kpd04h/nk8Imuub/SXnAD7UgiIcD/2cOGIaZv7AxYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q/Vqzxh3+fxDcUvXnrwMBp0QDK4DI7XDN1FbK5q2Nkastb59lIOE4s+EZ1dy4heVN
	 znZ6QEVqua9jdRNRvQJYlghDaXZpgR6Yns31U9lsOVGSz8E40XeewlLHdJ3j4t8VOh
	 WwG7M06iIUOF/wp8bWbxLGHq5yJGnj5M13ay/F/s=
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
Subject: [PATCH 5.10 1520/1848] ocfs2: reject inconsistent xattr bucket during defrag
Date: Wed, 18 Nov 2026 15:59:18 +0100
Message-ID: <20261118150022.907341258@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 36bd415e5f95f..9a43c2169798f 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4566,16 +4566,22 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
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



