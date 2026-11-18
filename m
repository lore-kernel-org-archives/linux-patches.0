Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049271;
	b=DlDRkhfrpLcPGotafk7xI0HNDvdUNBgDoiBwUoWXz+ws5c4PvIBg/ae3U3IqeHJqjX3C
	 yjaTGaTQYUW8J82sHHpoSEuq4ZiKS02lNVD2ipjb80uH8V8tNKIe2k5yCYLoU6vt4Yr7g
	 /lcNo9d59c3GsgHXme6C5FKoZVcoUEcWm9SFQQSCWmfpTbbm3uPV7tp16vVRkYpNdITdW
	 KLACt0aprVuS0E1u8SGY+AXYaN0D2zoMdY+RMftINSJ+EEwvW9078s0xTGgADxsjbfEU6
	 +SBBDiKcmrN9MDwZ5EcSJB94zAkWx4SP6tDkQlSP8xwi1A6ASz/1aBqMmH8fRWaXp0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049271;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oFARAQtePLMfHzgOE139ETJwpKPZY9oqA3tgVB0imaU=;
	b=RSvp5IHGnddQQKFgxAdy8xPFY9m8MDKtgHOTQNFIXC5tj69mlUjNLGgaZcIVZcKS04yz
	 l1THPVzP5aIK6Nf5tw3lmhjHZzECk00pfQBqSEeeyGQCVE7aBkCxT1ro8cKP4hymE6S3C
	 0M3E9cjMWRcxv5Z9bgQpiiyhFa3OLkhzl1ksB2VfEY+5FBuRAEjK3aPS/TbDNM+JkGEaC
	 g2yRwSEMjyPxn1IUsZr2rOmpe5SwTdwNXzReF5wdFJInVcjyfLFRFcWsbRPCNzfYn+TC9
	 h4dHozPzPAQUsg+T3zGtJgZJnOyfA8hVNkTnNt9DqoLjwbc1+8sDJPBGkzQ4vP14VVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PzlRwcIJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7780C606A320;
	Thu, 19 Nov 2026 00:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PzlRwcIJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61431F000C4;
	Thu, 19 Nov 2026 00:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049271;
	bh=oFARAQtePLMfHzgOE139ETJwpKPZY9oqA3tgVB0imaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PzlRwcIJ9S3NnyyIEq5HFXEamIRWkM8vyBssBBFJpXdVtwSyW15ZUPSFDyitcsRf3
	 zhiZAfisPblsNjRdsAieMJgYkcpIatCwNQB91jgE/SAxakj2Xuc1OttsOwqUGuIUoo
	 YWvy+KlitEdn+ghRng9x6HyWIftt7tbtX61RowgE=
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
Subject: [PATCH 6.1 2292/2857] ocfs2: reject inconsistent xattr bucket during defrag
Date: Wed, 18 Nov 2026 15:55:26 +0100
Message-ID: <20261118150324.005016398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



