Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2177B35B133;
	Fri,  9 Jan 2026 12:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961860; cv=none; b=gv6Nzi3xcmUgaBFtQBEWlWFsWB1jJkTboCVacrkkdwpRnK48Jkd1UaA5uFJEBZCyAmOQ+RqmzJDS3Z4wzzmNsY67RGwNpUGltiZHuObngBLaOrny0E2MEWE5niEDdu90aFCB3TfveHG0ZNhDKNWQSrZ1/V/M8BujkCKnTpAUiEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961860; c=relaxed/simple;
	bh=0ff8Z1SxuHFLkO80nLZMOPL11JOJx4xdc3ka3QTlcAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TiBcmIFwzaZe+vr5FjXzvliNnlIZtfztdDGdUV4ItxWHn+ba2YUJqJ22u4G5SK9y7R2w41vx3NEXeV4udae6xRduBrBR+uacYvtvPK1ES5zZ3MLTYS0e//UPFAyf9aATx3sUh6pMfRXJKC/vrZ32gpmQlGhHyuSk903g3+lD2HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2JIJqM9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2JIJqM9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567B4C4CEF1;
	Fri,  9 Jan 2026 12:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961859;
	bh=0ff8Z1SxuHFLkO80nLZMOPL11JOJx4xdc3ka3QTlcAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2JIJqM9LiMhWj/poRFBBtoYLSEncYD2AB/2QtEsXxdx+Fz8+OELBfV8sBE7QwbNZ
	 rwS69YK+DqrwUV/D9x4Uv/oJEY1S11HaRHlyP47S9hv07vBk8iDqytbyV8YGYhWg37
	 rQCxQO1WPBdXAbYnaPLt0pw6myd+h87K7QS+lLIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 161/634] ext4: remove unused return value of __mb_check_buddy
Date: Fri,  9 Jan 2026 12:37:19 +0100
Message-ID: <20260109112123.508303130@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1dc25e7b922ad..db302f617da72 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -666,7 +666,7 @@ do {									\
 	}								\
 } while (0)
 
-static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
+static void __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 				const char *function, int line)
 {
 	struct super_block *sb = e4b->bd_sb;
@@ -685,7 +685,7 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
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



