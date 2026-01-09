Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F09C2C21E6;
	Fri,  9 Jan 2026 11:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959922; cv=none; b=rOiDhwa5Q2Gt9cTnOs5ItFnLYtTwaE/zWzuIeA9tssdYgy5WgoTFq95CCiwJr7PUNHuzgPvj0QMtjZ1vD7Xv41KlN/oA9agGDD2uz6iflu692SLw2RylnhU9AjZeuhOFnM7Iywwp0U1MjsksanZ9qL9LEKUEWt5l3XvGtC1DiZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959922; c=relaxed/simple;
	bh=EV5L2FAiVkQOpRsDFAT+kFqZ5UmY+mOCEo6M7BB3FpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XqXD1EWuDcPgJFKLqxTm+e2WW965uxngZeImBBznL6Ken/0GOA2qPHSN1MlfcE2rAQXEHYh6gbtUtiG28DLa6GButD/7rgyCKFJnEa8yBJNptWya325hZS4vHucmRVvRRY421DQcwhBfYjrRS63mefE+D5Lm5LOc4ay/g+OZ1sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xRMSU65c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xRMSU65c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B029CC4CEF1;
	Fri,  9 Jan 2026 11:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959922;
	bh=EV5L2FAiVkQOpRsDFAT+kFqZ5UmY+mOCEo6M7BB3FpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xRMSU65cuHzU8fAaQUQOoZfUd08fwxpbfhZLJ3aepZBepGp4KVds2g9CdY2l7U///
	 7JYDAWZtS+ote4D0lQtjWILboBKykfuCrEQP1p0xrbqk9YASaQhWhXKo/yvVdfo2Gu
	 Uqkjf1R8OcjGH9enZ2Ex+5RbVQw5h/8+PcdEsMOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 223/737] ext4: remove unused return value of __mb_check_buddy
Date: Fri,  9 Jan 2026 12:36:02 +0100
Message-ID: <20260109112142.390547554@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 133de5a0d8f8e32b34feaa8beae7a189482f1856 ]

Remove unused return value of __mb_check_buddy.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240105092102.496631-2-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: d9ee3ff810f1 ("ext4: improve integrity checking in __mb_check_buddy by enhancing order-0 validation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c5f642096ab4e..9721ae0ff92ed 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -676,7 +676,7 @@ do {									\
 	}								\
 } while (0)
 
-static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
+static void __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 				const char *function, int line)
 {
 	struct super_block *sb = e4b->bd_sb;
@@ -695,7 +695,7 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 	void *buddy2;
 
 	if (e4b->bd_info->bb_check_counter++ % 10)
-		return 0;
+		return;
 
 	while (order > 1) {
 		buddy = mb_find_buddy(e4b, order, &max);
@@ -757,7 +757,7 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 
 	grp = ext4_get_group_info(sb, e4b->bd_group);
 	if (!grp)
-		return NULL;
+		return;
 	list_for_each(cur, &grp->bb_prealloc_list) {
 		ext4_group_t groupnr;
 		struct ext4_prealloc_space *pa;
@@ -767,7 +767,6 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 		for (i = 0; i < pa->pa_len; i++)
 			MB_CHECK_ASSERT(mb_test_bit(k + i, buddy));
 	}
-	return 0;
 }
 #undef MB_CHECK_ASSERT
 #define mb_check_buddy(e4b) __mb_check_buddy(e4b,	\
-- 
2.51.0



