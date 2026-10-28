Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212076;
	b=zw76X7dkdCFySQ05cUDDWwlXavE/K5XmbjbWfPBeZHZ8n7drmalxUletUBVupiBjjzHU
	 3oXvIbE4YgRuLZp1fl/HyYwTsS0V0EwsqQ05YM0X9szFe/NEJoYBv//0hFSp6Mp/rEnYD
	 Tih4ZHC8e2fOEsjSxOOBE63l3jaONdHx2/d4p4vLfU7g949o6oestHTnXV/RySjFRzGbE
	 zDHY/JS4tIfCQrSk87WqnnNz8vX6gXmqQiMIIDj1lcqD/uGe+kiB8iEZ9F4aW3aDsrm6d
	 7QO+J8/qCvoug/xzdP6Kgmv6C7kLwFhtfcJajqtJOGRfC+CH2wfv5eUPj3mGIO4krEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y0d0tizauPebhBwpcmbqEYZiIrXs2E3Tr9+ZsOw99M0=;
	b=PYGxVW4GYpAYqQ10QvnzvVDIxYnNQFUxTc6oZ4GjCsEcBBvVOn4V4V9KZHHLJWiuyutD
	 MjfWSXipsjA/AiClMKvRQak8MBwZ/qCHXWTX/J+ymbzvgsnxsrcvVhn1xGkQy3oMEEQ/+
	 VAMIa86DD43KWOUkotIlWD6Xxu968wd4jLDAa+BDMV1wNISIUvKEzB0bD5Aj76tVK9pqj
	 Pp8E/h3pKupvb/R6Vmz+/NRXgfqbd5quXkf7jIaKhDw5VTc6PZ09jc/ZJrQXQbDp3R7JG
	 rFtEZH1lsLKtcvK39NCNxOwKJ4o0NEnF8BJ8y2dFFw0RUrT+NfD8D9xkHvn2Us5V2vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bIIYjT4U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10969606A320;
	Wed, 28 Oct 2026 18:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bIIYjT4U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6932D1F01825;
	Wed, 28 Oct 2026 18:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212075;
	bh=y0d0tizauPebhBwpcmbqEYZiIrXs2E3Tr9+ZsOw99M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bIIYjT4U9yfYED1sUQHhAe22bsKh986LF03c+6Jf2ykNw/3qwBo5FvJOu/Ok9Fg0F
	 aKQvRuCX/58aAI+lpOmtw8QfnZLw2yoVKloDyyTXPPsEeJbymXTyPsWWKPZYNxY6mq
	 QC497KvYbxJmHUoyGg8Pd/EKPiRXWugN/OLIoaq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0030/1887] ocfs2: validate dx_root extent list fields during block read
Date: Wed, 28 Oct 2026 17:35:26 +0100
Message-ID: <20261028170459.912537465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

[ Upstream commit 775c17386a6fd695f999d4cda90e3931386570dd ]

Patch series "ocfs2: consolidate extent list validation into block read
callbacks".

ocfs2 validates extent list fields (l_count, l_next_free_rec) at various
points during extent tree traversal.  This is fragile because each caller
must remember to check for corrupted on-disk data before using it.

This series moves those checks into the block read validation callbacks
(ocfs2_validate_dx_root and ocfs2_validate_extent_block), so corrupted
fields are caught early at block read time.  Redundant post-read checks
are then removed.

This patch (of 4):

Move the extent list l_count validation from ocfs2_dx_dir_lookup_rec()
into ocfs2_validate_dx_root(), so that corrupted on-disk fields are caught
early at block read time rather than during directory lookups.

Additionally, add a l_next_free_rec <= l_count check to prevent
out-of-bounds access when iterating over extent records.

Both checks are skipped for inline dx roots (OCFS2_DX_FLAG_INLINE), which
use dr_entries instead of dr_list.

Link: https://lkml.kernel.org/r/20260403090803.3860971-1-joseph.qi@linux.alibaba.com
Link: https://lkml.kernel.org/r/20260403090803.3860971-2-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: bc70726ddad5 ("ocfs2: validate directory-index entry counts when reading metadata")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/dir.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index c85ad5999e848..b758f11738c65 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -580,7 +580,7 @@ static int ocfs2_validate_dx_root(struct super_block *sb,
 		mlog(ML_ERROR,
 		     "Checksum failed for dir index root block %llu\n",
 		     (unsigned long long)bh->b_blocknr);
-		return ret;
+		goto bail;
 	}
 
 	if (!OCFS2_IS_VALID_DX_ROOT(dx_root)) {
@@ -588,8 +588,32 @@ static int ocfs2_validate_dx_root(struct super_block *sb,
 				  "Dir Index Root # %llu has bad signature %.*s\n",
 				  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
 				  7, dx_root->dr_signature);
+		goto bail;
+	}
+
+	if (!(dx_root->dr_flags & OCFS2_DX_FLAG_INLINE)) {
+		struct ocfs2_extent_list *el = &dx_root->dr_list;
+
+		if (le16_to_cpu(el->l_count) != ocfs2_extent_recs_per_dx_root(sb)) {
+			ret = ocfs2_error(sb,
+					  "Dir Index Root # %llu has invalid l_count %u (expected %u)\n",
+					  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
+					  le16_to_cpu(el->l_count),
+					  ocfs2_extent_recs_per_dx_root(sb));
+			goto bail;
+		}
+
+		if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
+			ret = ocfs2_error(sb,
+					  "Dir Index Root # %llu has invalid l_next_free_rec %u (l_count %u)\n",
+					  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
+					  le16_to_cpu(el->l_next_free_rec),
+					  le16_to_cpu(el->l_count));
+			goto bail;
+		}
 	}
 
+bail:
 	return ret;
 }
 
-- 
2.53.0



