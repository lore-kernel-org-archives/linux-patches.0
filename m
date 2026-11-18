Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045542;
	b=v4oE8bY+HcIslnpOBErz1zoKsrBaGAaEiY7tsGPOcQ9JVKOfMA90EI1G3Uk7S7SGALrl
	 vAhDEWXCWSoaUEBfWyIDoQBrgeuAVK8JxSqNWlu0opUGhBJNQed+fkEyovmIly++bGvWX
	 RXPezE7He0Vz7mtBmQ7xWkpjmkANF1PKzElvD3au6BV9I3OZIr7I6mdRPugRy9Jx7UL0p
	 K1gP7RGNo7byVun9gZ4yfgaE6QDShN4L46ZPpU3BB9+um0sXXhUEMLJ9fEceXTBW8ztbv
	 gIeLBWfbKFzWIvlOG3YnMtyNCh3U2N+WShPRGblPeVwDgGW3IBaNOWqVeB9iN8kYQpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X6jRO6t2PogRPJdoqfUI3lGP3Xo7yV6GvzAuRsxHnOg=;
	b=BQK+cBBn89hBVONE2nhXdaVkQYVK8Hjt27J/KXf/6/lJ8/2PL0DSdvzwXhyU2xZKN5tm
	 1Wz2JYQKLHVQajyiGgX96j3D8jI//f8tGxoZ1sB3MweDV/XN9ojNZvJ/XCDa26JB8IEUw
	 YTOwx0o1tJOqX6CPDZzZ7n5MycVJ4FUrTBixF+0WecjkuheNcxZ/gM5gvOIKJHYCpzbCh
	 /mOhV+aCZaGBmKbyZ0gT8VaPRgnoxwUWfFgVNCfxdKMgjDz9uwcFA8g1TpbARnZoEDNTg
	 kYm9z5c7p+lPfh5PmPUr82txvLoK6C9LWfi35HFNM8AG+IrLZcytqBLhEfyz8FX2azQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NNQX+DZ8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14561606A320;
	Wed, 18 Nov 2026 23:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NNQX+DZ8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E511F000C4;
	Wed, 18 Nov 2026 23:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045541;
	bh=X6jRO6t2PogRPJdoqfUI3lGP3Xo7yV6GvzAuRsxHnOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NNQX+DZ8cV1QL1srRK7foWzoUcpcCrzYBkKTLHH7Om3/3EI0SpVg1YfYEFQMgsP6B
	 hQNLzf7iHUaczLT9PcHSWyS2Xfils/UWe/fdO59vl47pnX7ZVJ7IeR4YAVxHCa5Alb
	 zS3Ww7O447q1Ge6VHpSqc8k8YfmDOgszllH3126c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kaixuan Li <kaixuanli0131@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0943/2857] f2fs: check every cur_*_segno[] entry on readonly images
Date: Wed, 18 Nov 2026 15:32:57 +0100
Message-ID: <20261118150235.561617966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index a1c33931d175e..1b6d28116a04c 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3611,7 +3611,7 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
 			return 1;
 
 		if (f2fs_sb_has_readonly(sbi))
-			goto check_data;
+			continue;
 
 		for (j = i + 1; j < NR_CURSEG_NODE_TYPE; j++) {
 			if (le32_to_cpu(ckpt->cur_node_segno[i]) ==
@@ -3623,14 +3623,14 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
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
@@ -3642,6 +3642,9 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
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



