Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036547;
	b=FrNeE0mZo8QMo4Rz2q5ReNEXMP00hPKUU7gPvY2uNvAK8jndYbz+qw53/OpUONuWkSV8
	 Ewl7erLgZYCYaYci4i0crYMK13m6mAr+ORWuQi3/ed+mTqNEkdXKWEDK6OpdqOnuMyTsO
	 JQEVzHhwT3usRZrSZEu1FzmoYDpbmQBc2EuhrJwmMmEjFT9SuF19No8mhK+fQOAJGGGjA
	 Zf0ClVS+XIzFSJM8OakWhAy1pzN0oCxArGpmN+ypk3d1O14nEc+MhlOhtyNOZN9FMEjTJ
	 DDwycvOgCtMujYABt7EdLAxDudLiXRANOgCqVQXnTWsHg1pQxinOE6yWSkoXH2Ah0EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VxMdUDp9wQnUIyzBTuwDNCm4/nL8LMdNJn87S2O/0mE=;
	b=Drl5zRnf0UjRBtp4ZapGx20w5f45FTY0a5gV8Nmz+1CpV17ycKkoUHIhiiIGScoD3W+d
	 mKRgiGSYR8JFdJthFr5gW0V3GL5Cr7CYhpiZ8q1cI3DL+cwraYTz26VVBVSLzhnBAxzCi
	 yURs7T9kDl2ooIjnKCJbs/yCHfmCnw9w3jPSZgdPcJfl/9I5e3fcgylmsZm7pMpJBcI0/
	 Iy3x0GZyOnaxHjM3GsL3c6tR7JC2KbRqd8HQYZnHnbvSedIlzSJmJu0iHsC1nw54rzRiv
	 TGpdRjuHzPv8I5rILlRYpnvdOuuqJ/DFoFELbkqL+T5EW7C/CGGCsH/HjhcnSRyXkzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=el93i8ay;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89C160A2607;
	Wed, 18 Nov 2026 21:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=el93i8ay
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F671F000C4;
	Wed, 18 Nov 2026 21:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036547;
	bh=VxMdUDp9wQnUIyzBTuwDNCm4/nL8LMdNJn87S2O/0mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=el93i8ayvp9psBaHkKzLjp0r0wqtR0cM4r82kc8/6mQBEDBKCMMl+dlNt3Ez2MYaE
	 iXoY1Zr3HG2ly0n3QGWwRYikeWBr1xzFhPpZfSL22sZI0C9hPNXXJOhWPKPZOYeqP8
	 86+WFEIsiqTGjr50WXUvYVFre8Dq9MnLbCcnvGmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kaixuan Li <kaixuanli0131@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1098/3318] f2fs: check every cur_*_segno[] entry on readonly images
Date: Wed, 18 Nov 2026 15:28:40 +0100
Message-ID: <20261118150352.919457149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaixuan Li <kaixuanli0131@gmail.com>

[ Upstream commit 9c4ee79190c8c23a9fb5c07d3bc87eaac514b2bb ]

sanity_check_ckpt() bounds-checks cur_node_segno[] and cur_data_segno[]
against main_segs, but on an image with the RO feature the goto that skips
the duplicate-segno cross-checks also leaves the enclosing loop, so only
index 0 of each array is ever checked.

An unchecked index reaches __set_sit_entry_type() through build_curseg() ->
reset_curseg(), which writes se->type through &sit_i->sentries[segno]. With
segment_count_main 120 and cur_data_segno[1] set to 200, KASAN reports
three out-of-bounds writes during mount and the mount then succeeds.

Use continue so every index is bounds-checked, and skip the node-vs-data
cross-check explicitly, which is the other thing the old goto skipped.

Cc: stable@kernel.org
Fixes: a7d9fe3c3388 ("f2fs: support RO feature")
Signed-off-by: Kaixuan Li <kaixuanli0131@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index b94dab34e591b..433506ea5738c 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3707,7 +3707,7 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
 			return 1;
 
 		if (f2fs_sb_has_readonly(sbi))
-			goto check_data;
+			continue;
 
 		for (j = i + 1; j < NR_CURSEG_NODE_TYPE; j++) {
 			if (le32_to_cpu(ckpt->cur_node_segno[i]) ==
@@ -3719,14 +3719,14 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
 			}
 		}
 	}
-check_data:
+
 	for (i = 0; i < NR_CURSEG_DATA_TYPE; i++) {
 		if (le32_to_cpu(ckpt->cur_data_segno[i]) >= main_segs ||
 			le16_to_cpu(ckpt->cur_data_blkoff[i]) >= blocks_per_seg)
 			return 1;
 
 		if (f2fs_sb_has_readonly(sbi))
-			goto skip_cross;
+			continue;
 
 		for (j = i + 1; j < NR_CURSEG_DATA_TYPE; j++) {
 			if (le32_to_cpu(ckpt->cur_data_segno[i]) ==
@@ -3738,6 +3738,9 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
 			}
 		}
 	}
+	if (f2fs_sb_has_readonly(sbi))
+		goto skip_cross;
+
 	for (i = 0; i < NR_CURSEG_NODE_TYPE; i++) {
 		for (j = 0; j < NR_CURSEG_DATA_TYPE; j++) {
 			if (le32_to_cpu(ckpt->cur_node_segno[i]) ==
-- 
2.53.0



