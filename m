Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052769;
	b=sme9eldRbYysDJwoyXHULRpEsQlnnmBpKbrSelASZdfJ+uNBSeQ/N9cjxyzyG01nPRKf
	 vn6G6J8LOtanG+Ar4wBCKOVWZPQ814EwyuKxlwaToXesCHd9CtVhKNrAHUqIX/L5JCMdA
	 nGAW5rrYnxDIu+Swle53fJVg+iyDP8JdjyV+CcZKUoytJzg0OCFl+FGs/+x8HWTGg2vHC
	 X1WGq8ySmGrZ1zg95MyikVNYaU1Bpeb3Qrfd50GEwO0zfV3B7pG5Ktwit2JdKSZ4JMCHN
	 /pA0ftV9Yh24EjdIHCzUZik/0oIDuWZCZjwpu7z2rmt98fY8llvPxqUkyHu5D8arYXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CHTlbDyurO1J3TjL4IwK8XWkKQ+vJSaS/czn35I42MQ=;
	b=dqMB7LIc8uhJqVTald02ffUNBR312r30JAUKiBfUpsYotEjXjDkUTrm3MH5ioI+yXzGO
	 jaQLuFD5LOrMz67dODA2Pldzx+ZhPm+ogg8ei6kXWcISmoReEloLHhUPU5M0P6WZbFPYI
	 YG95FjKqVDLSqq1Zt9TZGkN7nU/03fv7B4XN1uc4fsjokPlo6w0ZUUajEfRVw6qat0TJt
	 rw/4GqFYaF1mAt6yKgptUTah+PVUdbWWWH03cSIM0kwVORLpkVpbnA/9ZLLblnEHEMt1z
	 Byuy3JB5+h+cZetjrFALTeSf2PYGz0HMQxeWM1THhgV42vb8Tdqhh3vth1uzdEt0HFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WAjtFzz1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACEF606A320;
	Thu, 19 Nov 2026 01:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WAjtFzz1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D9B1F000C4;
	Thu, 19 Nov 2026 01:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052769;
	bh=CHTlbDyurO1J3TjL4IwK8XWkKQ+vJSaS/czn35I42MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WAjtFzz1WH9f2jPybyh1whbWRkKt9S6q2O1Zu4uEjNrx5oOkwIT1kBoHMKaXgkWY3
	 TH2lTJuhjQO1eq9z2+ga49EzLWIeprmjAt4D52qASZ8XENYFpDxNROYwKlyjnOCDcp
	 i74VyPoWYtAxLqxuIKXgvZxPHxo95GVZnX6Xgfyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kaixuan Li <kaixuanli0131@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0633/2214] f2fs: check every cur_*_segno[] entry on readonly images
Date: Wed, 18 Nov 2026 15:38:29 +0100
Message-ID: <20261118150036.671341502@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a40dc08b3a1e8..405e17984adef 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3529,7 +3529,7 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
 			return 1;
 
 		if (f2fs_sb_has_readonly(sbi))
-			goto check_data;
+			continue;
 
 		for (j = i + 1; j < NR_CURSEG_NODE_TYPE; j++) {
 			if (le32_to_cpu(ckpt->cur_node_segno[i]) ==
@@ -3541,14 +3541,14 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
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
@@ -3560,6 +3560,9 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
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



