Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FCB274FE3;
	Thu, 15 Jan 2026 17:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499093; cv=none; b=HYoTbNw166Ox2gheTIgOG2xowchyCbtuqDRt0pn4OpwdLCTqlvy7mAEELJozJ2hTcCZqVvdqEvEOlsld3jDVc1W9Y3t1eQcs7FFfpkYBCh9hsHut68mR3QCFKycN1iblDl4iajVxEhFklGa+8LPGBA2RMF9eFLB0iU/k15IVJoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499093; c=relaxed/simple;
	bh=KGbemRA6nLzVvhLJSEwsa1rT3IK6cwDP82FkUMa2c3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U27QDuVYuwTz/rfjwUD2V/yqRqQjqv3r3AUs4wEAbJd0O/w1XyRRNgoXi8qlQDzeEC8sjObv6UY/guQnd2HV3fs2KUPXLJiUZClWVoRikxoSo3jUGl/rftyaPA54WOv+y07BCI3UwvROTES4MBubHi9G5+7moKs2DVp0uYHLleA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrT6CZoV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrT6CZoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FFAC116D0;
	Thu, 15 Jan 2026 17:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499093;
	bh=KGbemRA6nLzVvhLJSEwsa1rT3IK6cwDP82FkUMa2c3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrT6CZoVKrKt+p3xAY72NMzRczrVNA0BMT4XiQ8/+IljLySYNS73e2rj+AQfs2i3s
	 v+A51SIg+4/tEU8WFmB6Gn92p2UAFIpyy/wpfSwEmn78KtfcR8nTDat3VmHgv3npsu
	 UHIWCisSDLnhbCu7SKUGyQZji/KG9P5uq9sonxv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/451] ext4: remove unused return value of __mb_check_buddy
Date: Thu, 15 Jan 2026 17:45:07 +0100
Message-ID: <20260115164234.751059359@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 60c56a39798cc..65042bef41e4e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -602,7 +602,7 @@ do {									\
 	}								\
 } while (0)
 
-static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
+static void __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 				const char *function, int line)
 {
 	struct super_block *sb = e4b->bd_sb;
@@ -621,7 +621,7 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 	void *buddy2;
 
 	if (e4b->bd_info->bb_check_counter++ % 10)
-		return 0;
+		return;
 
 	while (order > 1) {
 		buddy = mb_find_buddy(e4b, order, &max);
@@ -686,7 +686,7 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 
 	grp = ext4_get_group_info(sb, e4b->bd_group);
 	if (!grp)
-		return NULL;
+		return;
 	list_for_each(cur, &grp->bb_prealloc_list) {
 		ext4_group_t groupnr;
 		struct ext4_prealloc_space *pa;
@@ -696,7 +696,6 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 		for (i = 0; i < pa->pa_len; i++)
 			MB_CHECK_ASSERT(mb_test_bit(k + i, buddy));
 	}
-	return 0;
 }
 #undef MB_CHECK_ASSERT
 #define mb_check_buddy(e4b) __mb_check_buddy(e4b,	\
-- 
2.51.0



