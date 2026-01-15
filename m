Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334022D0610;
	Thu, 15 Jan 2026 17:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497627; cv=none; b=WPBqP0ZGyfUGNLIz45/5dg5QFsKREnk6SSTjEkSqTYERz6ks86H+rYTDQS5ObmHauCq+cT5NhRlWXddApg9BWUXahzBumgXQxSOIrN9dwSgo73C4qFour8T5lp3NkJ6TTGaNTul3jtOX573ukJTbOVPkf5lpYAK4JFbeXov8FMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497627; c=relaxed/simple;
	bh=o2Fbx8fq5dkBBr4YvHOe+xZgITaY9quwCXr2Fc/LVLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PeE7GsjECMcqpm/wlSNfY8Je22QmTbeV3j9lvLTk5pPke8uTA9+NpND1NbTtrg2uT2XO/PL8QZ9VWXYdNdFle58uAxZSy2PtEz0J9PFglb8ZsYSlpL/FkK9RSfm029AAcA2YUKi0GtTBGA0/qHOoDvORZUn2npNxGibPIzauvE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=axBOZLzV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="axBOZLzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6AC5C116D0;
	Thu, 15 Jan 2026 17:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497627;
	bh=o2Fbx8fq5dkBBr4YvHOe+xZgITaY9quwCXr2Fc/LVLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axBOZLzVGFud8hfNpdzWOBm50XFUPL5n3k3XvZix9Yx4O1CaRLDE4KgY68kgBN1Iu
	 XnS9/qMlAHDqAFjaP8N26PvnEK/tOv+4Vjg9nweyUR+bKcXOnfLd2/o/llU05uKzqL
	 xDcTha1HBQmhhWgoTGtH33wZgfVQ/EhjhES/RT5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/554] ext4: remove unused return value of __mb_check_buddy
Date: Thu, 15 Jan 2026 17:43:34 +0100
Message-ID: <20260115164251.615413238@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1a8d72c5e327a..93ff3220511e7 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -663,7 +663,7 @@ do {									\
 	}								\
 } while (0)
 
-static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
+static void __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 				const char *function, int line)
 {
 	struct super_block *sb = e4b->bd_sb;
@@ -682,7 +682,7 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 	void *buddy2;
 
 	if (e4b->bd_info->bb_check_counter++ % 10)
-		return 0;
+		return;
 
 	while (order > 1) {
 		buddy = mb_find_buddy(e4b, order, &max);
@@ -747,7 +747,7 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 
 	grp = ext4_get_group_info(sb, e4b->bd_group);
 	if (!grp)
-		return NULL;
+		return;
 	list_for_each(cur, &grp->bb_prealloc_list) {
 		ext4_group_t groupnr;
 		struct ext4_prealloc_space *pa;
@@ -757,7 +757,6 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 		for (i = 0; i < pa->pa_len; i++)
 			MB_CHECK_ASSERT(mb_test_bit(k + i, buddy));
 	}
-	return 0;
 }
 #undef MB_CHECK_ASSERT
 #define mb_check_buddy(e4b) __mb_check_buddy(e4b,	\
-- 
2.51.0



