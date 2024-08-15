Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F8A18CBE1;
	Thu, 15 Aug 2024 14:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731303; cv=none; b=u7MnZ8XOQSvYETF8Qbb8JehL9XvdM/O0Ki2GzXbverpIIfKn9U7NpA0A/IQ6xrn0CODWpqW0wzp8QHoPD6rTnYde/RPmVSvZtz+WbLK2MLDnTzbC7oOBk9XESPFM1wUeRM8JZXslvv39KYoq/CGaMfS535tceWfimg+vhBOw3yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731303; c=relaxed/simple;
	bh=W1l4y/8A87jlVdiAEVtGU7A9JdmK6pxqXpOUNKB1PzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqEGCnBjqMUSVcVERitRJCX+rMe6rjk3j4UttBWKHVX9oBoLYCr803Fq4i6e0ku/ClsGBDGr09gVGX+cWusLiiuFO7Y2X1DzAlLF3HhFUFeGLMjd4/6JU/r075+957TQ9/HuVTHr6NZ+odXwkgcmRXZO1S9lGglY1PJjR+pKTgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rmyyaxC6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rmyyaxC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9F5C32786;
	Thu, 15 Aug 2024 14:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731303;
	bh=W1l4y/8A87jlVdiAEVtGU7A9JdmK6pxqXpOUNKB1PzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rmyyaxC6pV3E6XQW3lANMoS+AIdP1ycihXKzQyPVIqeQDGXK+Wul9PYKzC2TAmkDN
	 8JHjvziBxhZWqHr/Nomxa6Ysl9paD1LA7P7XMDjaT7NvC5EEkNhX/dNOZhFuOherUd
	 MIi91SO6eh0nt/IOSGDan8DQbUwOjM4fUXG57N28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Alex Shi <alex.shi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/259] fs/nilfs2: remove some unused macros to tame gcc
Date: Thu, 15 Aug 2024 15:23:39 +0200
Message-ID: <20240815131906.121188328@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Shi <alex.shi@linux.alibaba.com>

[ Upstream commit e7920b3e9d9f5470d5ff7d883e72a47addc0a137 ]

There some macros are unused and cause gcc warning. Remove them.

  fs/nilfs2/segment.c:137:0: warning: macro "nilfs_cnt32_gt" is not used [-Wunused-macros]
  fs/nilfs2/segment.c:144:0: warning: macro "nilfs_cnt32_le" is not used [-Wunused-macros]
  fs/nilfs2/segment.c:143:0: warning: macro "nilfs_cnt32_lt" is not used [-Wunused-macros]

Link: https://lkml.kernel.org/r/1607552733-24292-1-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 0f3819e8c483 ("nilfs2: avoid undefined behavior in nilfs_cnt32_ge macro")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/segment.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 23b24ec79527c..62c83193a5bb8 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -134,14 +134,9 @@ static void nilfs_segctor_do_flush(struct nilfs_sc_info *, int);
 static void nilfs_segctor_do_immediate_flush(struct nilfs_sc_info *);
 static void nilfs_dispose_list(struct the_nilfs *, struct list_head *, int);
 
-#define nilfs_cnt32_gt(a, b)   \
-	(typecheck(__u32, a) && typecheck(__u32, b) && \
-	 ((__s32)(b) - (__s32)(a) < 0))
 #define nilfs_cnt32_ge(a, b)   \
 	(typecheck(__u32, a) && typecheck(__u32, b) && \
 	 ((__s32)(a) - (__s32)(b) >= 0))
-#define nilfs_cnt32_lt(a, b)  nilfs_cnt32_gt(b, a)
-#define nilfs_cnt32_le(a, b)  nilfs_cnt32_ge(b, a)
 
 static int nilfs_prepare_segment_lock(struct super_block *sb,
 				      struct nilfs_transaction_info *ti)
-- 
2.43.0



