Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215456;
	b=dsvxNF37Z3nS3j7C9jhajpm5TWR32EpT1PQ2rPScbPxkz5bWupaGunYBE0LJv72dHhVJ
	 W0pibAU3zbMsbu4+IeGmH6bHnGyjAtQb/cl9jusPN3EZpsQT/2V76niUchD6YsB1+5jTR
	 aWp0VIDkyNneUDqTcNr6tU9+E5oHkKCKmOEouQChayhYQmL+UoVci57qsjaistqFbU5Cb
	 y2orT+XuP8A5uUJKO+tHz4UlZKQZBsI+8IXaiG4f4YdHze1iW/1maeevCcs1r1ezH8Etf
	 bOfafM8go/5IAEFL+/DaZW6G8S4qeb3uTHm7rZ/9PMZMQO3gKFprNws0yy1J7z0dzCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/I/pZiaKCr+L6fNN/XdSTebDJlgM6ydrSZdfinjOrSo=;
	b=4a1F2TFZ//5Iazm0DaI8RjS6rMvZQ2Y+XPVn2dK4XhAzoeuDaTSwsLzdqDtpxebK1hGc
	 JNBc1J6lFnzJe6inTOJzyIG636pI3DZFZynN6fWYuwUBMxKhZ5FxMpanFFzFnuAA3QWx9
	 q3lzNW5tJhnLMz5FYf07ZZTcMJC2A47h5OwadCLsA+2rEizBLRBCXGDMDoMSu7lkxAkYJ
	 2MeNCqdfqF3YCcBmWof6dGdq//zi0zRfhYb/lKKEASIjEmRzutPwBNu2SuElOQ3zg/CU0
	 cX5HfHqSEcuraEX+CAKf5AXK0oqhSb8zaVZTnMW/3f9jcrxHWpuX+lwO8tGEUZnNXWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XEDpJ8Aq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2983D606A31A;
	Wed, 28 Oct 2026 19:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XEDpJ8Aq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B311F01825;
	Wed, 28 Oct 2026 19:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215456;
	bh=/I/pZiaKCr+L6fNN/XdSTebDJlgM6ydrSZdfinjOrSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XEDpJ8AqGg51cMXxr2sPEQ+wEsmHawcBvQo7R6xsA0rgNn5RWoEp9jPnQUkJKfq+Y
	 jxI4fWlPQzx0KMkajdCEdW+kZSx8zVL9ggATY4m1qAMT65aO8JyTxJ3JLluRigaywe
	 Ff4EuiuzuTT5Wdvsyg2TjCG2P5KNJn/2n9g4uyVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1216/1887] ocfs2: validate i_refcount_loc when refcount flag is set
Date: Wed, 28 Oct 2026 17:55:12 +0100
Message-ID: <20261028170527.081456467@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit 688dab01c3bb14cb559878aaf7019bfba4a79275 ]

Add validation in ocfs2_validate_inode_block() to check that if an inode
has OCFS2_HAS_REFCOUNT_FL set, it must also have a valid i_refcount_loc.
A corrupted filesystem image can have this inconsistent state, which later
triggers a BUG_ON in ocfs2_remove_refcount_tree() when the inode is being
wiped during unlink.

Catch this corruption early during inode validation to fail gracefully
instead of crashing the kernel.

Link: https://lkml.kernel.org/r/20251212055826.20929-1-kartikey406@gmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6d832e79d3efe1c46743
Tested-by: syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/20251208084407.3021466-1-kartikey406@gmail.com/T/ [v1]
Link: https://lore.kernel.org/all/20251212045646.9988-1-kartikey406@gmail.com/T/ [v2]
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 452a8467be81 ("ocfs2: fix UBSAN array-index-out-of-bounds in ocfs2_sum_rightmost_rec")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 44acdce93d6f5..c55eb77e5d87d 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1602,6 +1602,13 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		}
 	}
 
+	if ((le16_to_cpu(di->i_dyn_features) & OCFS2_HAS_REFCOUNT_FL) &&
+	    !di->i_refcount_loc) {
+		rc = ocfs2_error(sb, "Inode #%llu has refcount flag but no i_refcount_loc\n",
+				(unsigned long long)bh->b_blocknr);
+		goto bail;
+	}
+
 	rc = 0;
 
 bail:
-- 
2.53.0



