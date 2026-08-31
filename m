Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACFA45629A;
	Mon, 31 Aug 2026 13:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183271; cv=none; b=oj8ifi0JhBZk3ylhJIB13IR30wkAV75Pqptnr38tednlfWfBbhs2CYLSZTOqnj6J/W7/GPOYURYtYTH/3pkXthV5J2X2UzO/HRjDBIx9qvJN0ob4F0lY+WzI8o3xI5zcKfO9Xy4mFCW3xuoP4QzwTA3dfsiEmBjhSCN3g+g+CmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183271; c=relaxed/simple;
	bh=kt5/tRnTkXA2oGJpdrcyT4e7vqOqMTNxGpHtezPoxEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cuEjjOAYGCu9dN1oEMhroCJqpeLQImIOi/lo09gSViAyKC4WwqyAxQ/8DX+KbOPDP1ZJJ4SJOcJ+1i7FLNqVQZi9+c0nxCGw6mA7e2uZvU5ESVgSz9AklJk1WzUG/DQ7/QsKfVZoz5CS8JPkY60oVmspVpl2+iha6Fs6mxGehbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CnIwPp4w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CnIwPp4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BB71F000E9;
	Mon, 31 Aug 2026 13:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183269;
	bh=bhV2gBessWg247+Q/iiQyBsRw0fstCyx4pIZMJ+xrIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CnIwPp4wND3nyuAjtA9DU3mMH9hCONYcKozSYjn8Q/Fu0cQ7YAYX6hje0LRjkwlW0
	 8vrDW14S9rYeV2HN7YvhwQNbxAhWSW1pdJ0y4iZNNfPFH3vHIXQL1v9h8v9Aa0LqCo
	 D2QBUpt4tHXdswPgMCqTEngJYdswmTM2bB48sv97lEWuf0QcP4EncUytwo/SQjXAPm
	 uFpUVF46FIsZTuLyLq1u+2u/8pegKcENbN1BhGnpnvkYfJqoa210w6BP6BrxhEcqSY
	 4pt2xproeILLF2h+QSJ6PyYS59p0S2JYNEP6oua1q2jTVQrV/PE+Uruz89LVsO4VoX
	 +LgARkmyVZHrg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	me@bobcopeland.com,
	linux-karma-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] omfs: handle set_blocksize failures
Date: Mon, 31 Aug 2026 09:21:15 -0400
Message-ID: <20260831133314.4125787-47-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 18c3d6fcb557f920c9143711497625e70153874c ]

omfs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-11-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background git search finished. It found no commit matching
“set_blocksize failures” or “handle set_blocksize” in this tree, which
confirms the OMFS fix is not present in 6.18.44 yet. Recent Christoph
Hellwig changes under `fs/omfs/` are unrelated (`CONFIG_BUFFER_HEAD`,
`remove ->writepage`, etc.).

That doesn’t change the earlier conclusion: the unchecked
`sb_set_blocksize()` calls are still at `fs/omfs/inode.c:480` and
`:532`, and the fix should be backported.

**YES**

 fs/omfs/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index 31218d89b7580..14369efc70d81 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -477,7 +477,8 @@ static int omfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_time_min = 0;
 	sb->s_time_max = U64_MAX / MSEC_PER_SEC;
 
-	sb_set_blocksize(sb, 0x200);
+	if (!sb_set_blocksize(sb, 0x200))
+		goto end;
 
 	bh = sb_bread(sb, 0);
 	if (!bh)
@@ -529,7 +530,8 @@ static int omfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	 * Use sys_blocksize as the fs block since it is smaller than a
 	 * page while the fs blocksize can be larger.
 	 */
-	sb_set_blocksize(sb, sbi->s_sys_blocksize);
+	if (!sb_set_blocksize(sb, sbi->s_sys_blocksize))
+		goto out_brelse_bh;
 
 	/*
 	 * ...and the difference goes into a shift.  sys_blocksize is always
-- 
2.53.0

