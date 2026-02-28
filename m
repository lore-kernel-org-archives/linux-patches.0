Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2113B33F8A1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300914; cv=none; b=UXhvc5J5oaNv3VGoBzshqAexUZ0LxlAd76wGxpNoT+4iI9hU1zSATZF6mJgdmZ6+KMXVdh4jujaIPy3EVjcENkehcTmsu5mfRROCfqyCitTtUdS+AlWf18YHGniq74SFvt2qkMugDspFCEq7O+oyh8OrG89rzTeltXlSVfXsZ18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300914; c=relaxed/simple;
	bh=Cw4qJmTtLEZovdKvYcGXVCpIOdGhiqW7xKdvzdqV3cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyh2CEnfPI/AVRmE+rXcDNFb8G+Uz5LxYqCPiBqHnBnL1BLBO7gjCE7bM/gMTRxqydIsrmIiUG7sudAQ3r9DjZdIODvRDkkAKa1nwsT3UeNX2P1iphN0RRKUxFdldTMu2uGDY0VLgskq4sz+kUgNxAK3hKY9gKCJVYs5xZ430k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F9AIMnHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F9AIMnHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C15DC19423;
	Sat, 28 Feb 2026 17:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300914;
	bh=Cw4qJmTtLEZovdKvYcGXVCpIOdGhiqW7xKdvzdqV3cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9AIMnHalx5TQoE2uM7WBp/07idY4N1HLPzdydPxiiCnCuXEYZBRnVWOu1p4CF8by
	 LjGOJzPtGo0OC4pJ0VKhonoavC0GPkdVa7j+TqI2JznqeBv0u2QnkofESNVg856HqV
	 2HmmJsuPJE01zsOuwPWTZrKH6X4KlxIs9IU8nFG2YBjN4GML0+sH62TVXs53Rj4yFW
	 IX/Rh49LppgSgLfWyU1oL1eImhv1iaucG6mHgCgDUj78m3cxRk5yCCLhn61ExklQvs
	 VZmmjTKH9gVpo+7VSW3s6n/uCmHkr/2Dk+miSQ6Cis3yz9SYfPJ1HYC1oAhcvKvFcA
	 Vmpdc7gO8z3pg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 029/752] hfsplus: pretend special inodes as regular files
Date: Sat, 28 Feb 2026 12:35:40 -0500
Message-ID: <20260228174750.1542406-29-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit ed8889ca21b6ab37bc1435c4009ce37a79acb9e6 ]

Since commit af153bb63a33 ("vfs: catch invalid modes in may_open()")
requires any inode be one of S_IFDIR/S_IFLNK/S_IFREG/S_IFCHR/S_IFBLK/
S_IFIFO/S_IFSOCK type, use S_IFREG for special inodes.

Reported-by: syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=895c23f6917da440ed0d
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/d0a07b1b-8b73-4002-8e29-e2bd56871262@I-love.SAKURA.ne.jp
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 67a7a2a093476..bb819ae608fd9 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -53,6 +53,12 @@ static int hfsplus_system_read_inode(struct inode *inode)
 		return -EIO;
 	}
 
+	/*
+	 * Assign a dummy file type, for may_open() requires that
+	 * an inode has a valid file type.
+	 */
+	inode->i_mode = S_IFREG;
+
 	return 0;
 }
 
-- 
2.51.0

