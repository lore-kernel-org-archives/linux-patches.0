Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064749;
	b=ckb0I98/IK4biTdZ8Nu9TZPkaIVCDXfDgDM/t2rmr2D1HE/ilR0fG08VLZ1UTAM6/rox
	 LNlStKTe+B0kI3Ptb3JkToDcgbhi12msPNjfPlo/WWKpkHSy7aWnrhGBYzSq5iV9NHRYd
	 69ea9HHE+n8FaYD6UclOKrQSn57hXnVslTzj0x9HxsbhCTYOewENgs/M+O5t7TBzHZG5e
	 goRlPseOUOJLL/eLgs4xqFl8sMDfiEo9MoK0B6ke+QwPkZ8Uc+3CRgHZMMEC2SdUGcTW4
	 Wshld6KdOFqUqJJqrHcONCJLKH5uNxVgP6Eqigl67mnf6IlZPtDQD88P5QQZrveQpYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tcEBnYe+yd1vYaC/xIZsCiPuL+AZX/PeLTiuX0aztkM=;
	b=rYh7jwYU3LG7IhtZ1qqTtde6D07xZSCZJ24iwulM3vfu6n/2LE/LF6dZRS9nrDr0ks8r
	 7Aef7TXJsh98xgmpPstvSLuQq29Cbli9do5O7GDqj2O+2gnqPUBSUGv4sHu0zDrsO6JvT
	 2gnkjd04eHeCjzLcCbJzG2H+IvGORePFZv3ZqavOF8U+boFOXxalIIy8A+SJhZBuYR3Lj
	 QHz3yENO6Y7ly1k1mmF4Zs9J/DYx0HDiU3iSLMYqT83Qn3KdNgr4epZD6QnOhLiROZT4l
	 rithP739lffXLUV+0QC3g2KBX3h8DzAAoLI0mcH6nxY1wqUU8LVPBdMmqOxVJ0d8Bng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HW6twKU3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233EB606A334;
	Sat,  7 Nov 2026 15:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HW6twKU3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15871F008A3;
	Sat,  7 Nov 2026 15:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064749;
	bh=tcEBnYe+yd1vYaC/xIZsCiPuL+AZX/PeLTiuX0aztkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HW6twKU3cRH3JpxjfBekN2kPyGqkVtsp3HVoeodmkBfYntB/Yb+sUdzbGFN4Iqt1R
	 Sk5nprQklh/C2FKOAkn1cQNccutTXeccQJTSFyP9Vl5Oh/uPwF/dqg+e8RqxhTiEux
	 J8RznWumcR2IOqizpTnunLjMuEkfzJwxRl8nDNGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kaixuan Li <kaixuanli0131@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0723/1257] f2fs: check every cur_*_segno[] entry on readonly images
Date: Sat,  7 Nov 2026 08:50:19 -0500
Message-ID: <20261107134959.232598171@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 137b123777edc..7a7348b59f97e 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4307,7 +4307,7 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
 			return 1;
 
 		if (f2fs_sb_has_readonly(sbi))
-			goto check_data;
+			continue;
 
 		for (j = i + 1; j < NR_CURSEG_NODE_TYPE; j++) {
 			if (le32_to_cpu(ckpt->cur_node_segno[i]) ==
@@ -4319,14 +4319,14 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
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
@@ -4338,6 +4338,9 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
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



