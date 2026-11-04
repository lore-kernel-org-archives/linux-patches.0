Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830818;
	b=2WH2m5qTOf4aZ2PmP+JX6b4cDfyOwmRNxzXrIsV3rnH3Gs8+uDPnJeoyy9ic7Dkd2O7B
	 zSZjPtQYmTRbqpFlggCkKWpyZwkImS5zmRXvR/Mheb46NC7u2lnOLPwBxz+kf75rXCTSo
	 akMRIbNRinPinVBIT89ltnn1wnPxUBTMPH6qiEOcM/HZ/kEpaUIHTyoWim2aWAsxsdNbO
	 w/46J4A7bZkOF0E5NHjfkAfOEFx5xJn8lB6RMW3U3Y/jSoaEW/zVJhAlxcXtOjRWuPo7U
	 0p/gn70UlcV4bN7v+sFF6blI2pzH8T8t4HwYvDaHTcWpOYhI8OGFjI7Ss0xj+BtSy6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=OvT9hHdc6+HeugCL3xxsqVTXlUtgl8QrCmtKeJpgTs0=;
	b=MgczpfVgP8eyk7yWRdTvtjI2QqEhPdVS56kWs0Px7sfvQnBkMPgWt77vOlamt6xfewWs
	 GGg8NuM23k5aWOBFQh+uaFGFEi0qj6YUY9kx9DPgKEpSnXXvjh8e0bP3ReGtg4CRihPK4
	 cfZW65W6v8VJePr2ATrIHkg96A4hpPfxI3iOn6wzSH+5J4uhZF8ggTy8G4CvgL34zXpG2
	 QLFamGmz2NKE7SbnKPz4b9RiLMAmK7FyrhA06xPKRoJGa5JPjtBQi9oKUYcgb1MWu0wXg
	 w6Rku6uafkY1+/YuHlkvoEs+fy/112GETc4rtFK3Ijg2e5cMT5jSL5wudrB7Y5HODBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UUOrg7rt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83596606AC33;
	Wed,  4 Nov 2026 22:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UUOrg7rt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209481F00919;
	Wed,  4 Nov 2026 22:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830818;
	bh=OvT9hHdc6+HeugCL3xxsqVTXlUtgl8QrCmtKeJpgTs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UUOrg7rtmznvbMLIL07VjmaODGtaibMkWGVSQTrjOyzmDsJ6O1Rpkak6LaZTKoThK
	 cgCeSCbuPDjw4eJijvaHkjQzO++aeLtrlTKUFOXtcmbFXblbW58UcIxvNbQ4lQSlCa
	 LzUViXP9bs37KPsqrwy5r3gw84aAmwk3rmE11e0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Junzhe <junzheyu1@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0338/1005] ext4: guard against NULL s_group_info in ext4_get_group_info
Date: Wed,  4 Nov 2026 16:01:11 -0500
Message-ID: <20261104211053.420861087@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junzhe Yu <junzheyu1@gmail.com>

[ Upstream commit 8f3901fbb40745046e513226ad84e8b84492632d ]

Resend: previous attempt was rejected by vger for containing HTML.

==================================================================

ext4_mark_group_bitmap_corrupted() already treats a NULL return from
ext4_get_group_info() as "nothing to do", but ext4_get_group_info()
indexes s_group_info without checking whether the array exists.

During mount, fast-commit replay runs inside jbd2_journal_load() from
ext4_load_and_init_journal(), which is before ext4_mb_init() allocates
s_group_info. Replaying an FC UNLINK for an inode whose bitmap bit is
already clear takes:

   ext4_fc_replay_unlink -> iput -> ext4_evict_inode -> ext4_free_inode
     -> ext4_mark_group_bitmap_corrupted -> ext4_get_group_info

and faults on the NULL s_group_info base. Userspace only mounts a dirty
ext4 image; this is a supported recovery path.

Return NULL when s_group_info (or the per-block grp_info row) is unset
so the existing caller check is effective during early mount.

Tested on Linux v6.6.145 KASAN: crafted FC-unlink image previously
triggered KASAN null-ptr-deref / panic in ext4_get_group_info; with this
patch, mount succeeds (EXT4 "bit already cleared" may still log). Also
observed on v6.6.144; still present on torvalds/linux as of
f5098b6bae76 (2026-07-26).

A self-contained Docker/QEMU reproducer (craft + mount + patch verify) is
available on request.

Signed-off-by: Yu Junzhe <junzheyu1@gmail.com>
Link: https://patch.msgid.link/65c955b0-716b-4599-b925-59c2782e38b4@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/balloc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index c9329ed5c094e..08556dd45760d 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -331,9 +331,13 @@ struct ext4_group_info *ext4_get_group_info(struct super_block *sb,
 
 	if (unlikely(group >= EXT4_SB(sb)->s_groups_count))
 		return NULL;
+	if (unlikely(!EXT4_SB(sb)->s_group_info))
+		return NULL;
 	indexv = group >> (EXT4_DESC_PER_BLOCK_BITS(sb));
 	indexh = group & ((EXT4_DESC_PER_BLOCK(sb)) - 1);
 	grp_info = sbi_array_rcu_deref(EXT4_SB(sb), s_group_info, indexv);
+	if (unlikely(!grp_info))
+		return NULL;
 	return grp_info[indexh];
 }
 
-- 
2.53.0



