Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028620;
	b=XMFdCEmfFIWYFZxh8ej+OCQJmX7jYWctZQ47V4bPfc1VFc6s7M+jnl48xxE6sD8/5RPV
	 LzqRE4QLG7JgtOD2EZsIMaMyB2BdDkIWk2I9fV+EzfpKEsqQlshj9rA/eAmZf/+fpBKx6
	 f+TSxiyeLJ3X3BPObrfqv876d3GOW0LcNSQVl/ql1GR5dSqs4Hr+FmBkmoIodtMW5O2tB
	 O16p9kP7woiYfMQ5NIoyDR8e/zxDZDMEsngXdvkgSpMl++isxcM2GdTqaOJvkyNRUH5iK
	 BtBG6EE9UuFnU6iQuolMgLYg05V0+YsEodV149qPj1o3OLujYVWAhwEGNaCfGbCz7EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f0QraEpJkeEpsRx0GZyzeiXKN+O7KW4NUZju0mjfauw=;
	b=JHODKK1yae74wHdPhpV99mxURUGPGYHNjehZnrjlItWvz4+sgryuaFBNlUFCM5xEO3EE
	 YGVyyv3COehC9YjYZA3wM0SSUGYyShNukOPWJBsYbvaTl5cRbQ8NpUpYu24RiXP2Aoxqk
	 /UzZaraLDeEC1HKkiVyWTFIN8RiC4GjY9yWdqoMfw9C7j5aESUILdUVg/0I269EYrAw+2
	 By1ixhbxj1cuE8L16cL4vmozIlv8ES6MJM4w9t0bmhxkk1qmrWwZtEQcz+WabL3GZvU4+
	 8Z9/zkBhj5nMzwN8jIF84CsoooKmR+8GLgfZ+dAFv5brILbhCjukWAaO7Lcvf7Wt+4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g8nHGmO8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B391606A32A;
	Wed, 18 Nov 2026 19:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g8nHGmO8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC38D1F000C4;
	Wed, 18 Nov 2026 19:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028620;
	bh=f0QraEpJkeEpsRx0GZyzeiXKN+O7KW4NUZju0mjfauw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g8nHGmO8ZwEIyI/fV5ghaZsMF/3kEAl0blphVfV3oxUWihYYvtXKSqg3p/JY6VxBJ
	 yUQzpeyUTbgwzsH+6bzKJNJlb2RFGqtaWOGp5ENKybbtY1iMhGua5duKELYsc4krT7
	 MMRhr17axBNbKR4hWrOaU6lmcg/v52bV4mO1MwSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0023/1756] f2fs: fix to update superblock crc in sanity_check_area_boundary()
Date: Wed, 18 Nov 2026 15:35:50 +0100
Message-ID: <20261118150008.821278500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit f8f956c7ec8c0285d7a80bed497d2f7adcbded15 ]

This patch fixes the bug reported by Sashiko:

We should update superblock crc along w/ raw_super->segment_count in
sanity_check_area_boundary() if sb_checksum feature is enabled.

Cc: stable@kernel.org
Fixes: d440c52d3151 ("f2fs: support superblock checksum")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: Added sbi as the first argument to f2fs_crc32() to match the older checksum API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index ec3e20cd6c5eb..facf7647b5095 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3571,6 +3571,12 @@ static inline bool sanity_check_area_boundary(struct f2fs_sb_info *sbi,
 		/* fix in-memory information all the time */
 		raw_super->segment_count = cpu_to_le32((main_end_blkaddr -
 				segment0_blkaddr) >> log_blocks_per_seg);
+		if (__F2FS_HAS_FEATURE(raw_super, F2FS_FEATURE_SB_CHKSUM)) {
+			__u32 crc = f2fs_crc32(sbi, raw_super,
+					offsetof(struct f2fs_super_block, crc));
+
+			raw_super->crc = cpu_to_le32(crc);
+		}
 
 		if (f2fs_readonly(sb) || f2fs_hw_is_readonly(sbi)) {
 			set_sbi_flag(sbi, SBI_NEED_SB_WRITE);
-- 
2.53.0



