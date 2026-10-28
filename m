Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215453;
	b=Cj8+wElPFGq8P+MafG3KNGtaEoGoxT4dDBTN19Ytr39d4+GiE9wA0//fBxIgHqkQx17H
	 +Y2VYBGkPtMl4L3ySBJx5X+ch0YnKd9F8ymt0LQQzT0U/1SiAXbYb8nfaBg33cQE6IESC
	 th75JTdndenipeG/78DksYNwRz4RVZI4NtYXrwYgaHjAFT43iiTADUfp+rYfEjf0xfnjs
	 7Ldf7p43bwNMCBqpEjV3KNpe4yml5MrOnZ0m81HrdyX6fzGn7TtxqX3cck7BZddi3XUCJ
	 hZqQkdI+kmk/bmVsNT18a6sWUdx0gr12htGm+KoXEVnSHBq47XSVxSanQ8mJHHJ5HAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VmHvYizKlh8N3MRvg+18Rbccx0IUHW5/XwJB1le/RYc=;
	b=qgpFvwL6sbtDn/Yn/ZyEtKl699bebgQeSWQ2hUBf6jokLIs4t7Ki6+oNcHZlf0+vXLS/
	 tNrnc50ws4R8mjH50q2jFaKBOawNN+VR2/hnvGlP7jSxlW5L3X1y/d078q5QdxX+bpm32
	 uISG76Avdd8neycV4+gXQfm3OFwul4KRfI7H/uJeUJ7zjw984QPOOkCoBi8o+EhfDaCRT
	 rhnnEi2bQOqtMNnn2hXe8ICoAwdcnkGPci5JNme87ZnPRShxMa1QdeJeXAQXRj205ddiu
	 e4MeZ0hK4OtNVLyMpBu1Ew1KHWHE2Z/FOmjLcYDoorVh5pYuzOMEamY5UvRNYoQtX1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TVTtpg7Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D802606A31A;
	Wed, 28 Oct 2026 19:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TVTtpg7Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86D21F01825;
	Wed, 28 Oct 2026 19:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215453;
	bh=VmHvYizKlh8N3MRvg+18Rbccx0IUHW5/XwJB1le/RYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TVTtpg7Z9F3NOKQNfahSIV6I+r72By4iEaC10X3Y59sK6EgJ7qIB0zq+bmJwV1xfI
	 A1V7cMCfdR8iTsUpFYCwQDKmhwKkIf19n/h0zoXAJ8uAEDpyQJ+9IMUqBZXaHbHT6E
	 kziJNl2amCAI9595fgh5mMF9jwcejr5XlTHKhcLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+77026564530dbc29b854@syzkaller.appspotmail.com,
	syzbot+5054473a31f78f735416@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Jun Piao <piaojun@huawei.com>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	Mark Fasheh <mark@fasheh.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1215/1887] ocfs2: add extra consistency checks for chain allocator dinodes
Date: Wed, 28 Oct 2026 17:55:11 +0100
Message-ID: <20261028170527.058440633@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit e1c70505ee8158c1108340d9cd67182ade93af4a ]

When validating chain allocator dinode in 'ocfs2_validate_inode_block()',
add an extra checks whether a) the maximum amount of chain records in
'struct ocfs2_chain_list' matches the value calculated based on the
filesystem block size, and b) the next free slot index is within the valid
range.

Link: https://lkml.kernel.org/r/20251030153003.1934585-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=77026564530dbc29b854
Reported-by: syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5054473a31f78f735416
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 452a8467be81 ("ocfs2: fix UBSAN array-index-out-of-bounds in ocfs2_sum_rightmost_rec")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/inode.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index b9ef61113e07d..44acdce93d6f5 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1585,6 +1585,23 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
+		struct ocfs2_chain_list *cl = &di->id2.i_chain;
+
+		if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(sb)) {
+			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list count %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(cl->cl_count));
+			goto bail;
+		}
+		if (le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
+			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list index %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(cl->cl_next_free_rec));
+			goto bail;
+		}
+	}
+
 	rc = 0;
 
 bail:
-- 
2.53.0



