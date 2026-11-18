Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051355;
	b=Tt8ZLnfstCu8r2U02lqKMUCHBqCzh+v6p+L9A7Y6P/3FHh8CHmkRQMGqKcQJNqMllLxL
	 Ga75KCnhVAljqZNHpt3QqdKAWO46zZsfRqjK6AM5vvwEEJWN+gvjb1Lr1VIk13VvkZeRk
	 NDEl8MmaVkgArLJBkYZhcRBSg6rr5MUsBLoo8fz4AyO8X38HWl7QGfTwO0F8koihzBNQo
	 Ewa6UuOcaW0ExOAJ0pzv5FlSuzR77hVGym/LogeY5qk/cDlhHT+HgX0v+1YRa0NvUyS/e
	 NYDZ0h6CBoVEEtKgjU0kKin96EUn7Sqza2klYJQxs7a9mirfUFNrc/mW8cEwD/Yqzgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=X+hdWFj5NYCGz5lzDtSbR/JRrfv+ux6AJREoF7Hr9bg=;
	b=UOnUOvgNJCl8j9p2POuhfen8kVclpWhJaReV/QL9swO/pRiiv786a0eP6BVPldWfV9Tm
	 2nrYhglRkdwiZJAbCibfAGC00HhAsYFJhSHTSYGLdXjSbj+H5aZhBCgGhEd/h64R2uYcG
	 suhEVev6l3QbauwG+rJEgnLwAFXpOUYahATVGCTLZWgHQ+3x9l3Tp7KJCXPKoWNSNje0W
	 41cbJ4zndQI7/T04L9dFbSr2y4m4WAx56NT3l+PWoyI1mw6GNfIOwzIpq7bh1N8z/RvfK
	 IveHvNClzMR4OfoxbKBESCcRyppTDEFvzYINWy2OEG3fzHwbdlifXTMTBoA74nrcSew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L0WBTtde;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3EA606A32C;
	Thu, 19 Nov 2026 01:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L0WBTtde
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14E01F000C4;
	Thu, 19 Nov 2026 01:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051355;
	bh=X+hdWFj5NYCGz5lzDtSbR/JRrfv+ux6AJREoF7Hr9bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L0WBTtdej96NP7XrlUHY6sa6Mu5+ES4qIsKLxhRU1bkZzXQzSgy+465DeSI1rhwzv
	 xyUM0RfVXs4grhVEqVc3cr3kI2guc9Wtgh2dTj+3FM+fSB7DxvVjA722hpFsNaFczF
	 3ffsY1DFdf9Xj38aDVczXp86uAvI5Awbl9o57lj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Junzhe <junzheyu1@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0180/2214] ext4: guard against NULL s_group_info in ext4_get_group_info
Date: Wed, 18 Nov 2026 15:30:56 +0100
Message-ID: <20261118150017.243641317@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d6872b71657b6..660d8aa23db0f 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -327,9 +327,13 @@ struct ext4_group_info *ext4_get_group_info(struct super_block *sb,
 
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



