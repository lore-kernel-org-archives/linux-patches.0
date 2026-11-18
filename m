Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043417;
	b=VBByaUbCW3YrANLXNbt4GbXEMVcP7T7aUcM/JwVvnuVdlPlYFXYpu4veE+0g4s+T2Ac/
	 h1CJqADGoFH+7zEiDqitJSIsCL/rn8s1mb3/SjKMTtj0icJJs95NyANtn7lH7BIE851Mg
	 wKDSmgM9VBG+o3pEtYAq30jodvA84iH90xi//aBoi1EWaM6tzfEzQUeo8syw9VEmEfVLz
	 C0iVzwQMMnNLvEhXJ/7lKWEhgT/4PfK7KM7XF3rCiSbfRiozlmR/tFuovKNHQUQ6RX6cJ
	 cYMS/d5JYvBYUw8f1G9BNpngUWfA1dmwrzxHM5MKgqUxfGla4deJrM6KjKMsH+7Madw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6+S+k5Emk6Vfkx+UF9WENKLeu+bI+vS3MUzzMlcggIk=;
	b=nFNbHBCp2G9Nk1YEyHqDkQtQNS8lqqZ9B3bfIqoUfXLZiebwK8EmiUcS+yFN4+6aAOnc
	 ljbsxV160nihOaoE+P/vLEUB7DAE+prU0L7HJBolPkYxnUxEl44JoHVeJQpCat+fpeAVB
	 UTS0zM3grZ7ihd4ZOXxC7VVOFgExiC3SNc0C/ysTp53NRADG6xehD4StawnxGX4FVX9Gr
	 j6/qJ6v7JkBnZ0nFmipxs5qKdXYVTb3dPDyzedNJPSZ/yIirFcR7VBjTvin9xXeTlV6V7
	 lJo00qwEZtGHJ9xNvr1rZjHhaKDLFq4u+i8hrADfYuH973N8otC4RX7elMrhwswCdgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CwoBSVqP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2E360A5BE5;
	Wed, 18 Nov 2026 23:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CwoBSVqP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979731F000C4;
	Wed, 18 Nov 2026 23:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043417;
	bh=6+S+k5Emk6Vfkx+UF9WENKLeu+bI+vS3MUzzMlcggIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CwoBSVqPyBOrF1JrFDbtH2kL0aYmcv9L09YW9J1jPMbVJMvu2Q7Fm/aJ79mf0ilxX
	 aBoIMe8/Ad6J4YEHWB96b84ty9Pjupitd0Xv4IMfQGdnDcOH31DmH2zu3iCtMQx+fJ
	 cF4EQqB/5MBZPZAoAACaQJFxo6f+dwI05IZ5xH6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Junzhe <junzheyu1@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0204/2857] ext4: guard against NULL s_group_info in ext4_get_group_info
Date: Wed, 18 Nov 2026 15:20:38 +0100
Message-ID: <20261118150208.701830896@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9efe97f3721bc..481a6fcc6838f 100644
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



