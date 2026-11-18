Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035798;
	b=FplhOpQDgnsABPlL2NjMGDccxQEhJyEYigbvtxqNDEcv0YzEWw8zIXh+Cmx/n9t2aqcK
	 3i966mzPo4l8/8iPMoa0ehVRE9c9HsUP2d/WGEPIasaw128SEmh5WlRRVPO9qjxLjNhvI
	 SAP7IwIjPprxSJgLVVTFOmiwTEGwqkV4X7LFLgD2qQ4S4hUthMltaK36Wbc3WChQohNhZ
	 CaKeA27idpNrmwb+pKqtK6NwX4JcxEVG6WLQAg3Z9S6c6BunASYGMn2HlcEF/HyB+7TPe
	 +casTxdPerfYuNZk6xFy/kNm8OUHN1xbRS/FMj9tNTqA+vHkViG0k6Zuj1zUQeI0+XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035798;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iwRIqxtGO/ZTfmRv9rZv1gUFvdvZqLRuX6p5g1KOZeA=;
	b=hPxFYgesbIYy1HyaZIdhZVT7dYSKUtr+UtUXebvYFeEX4+MbPPMx/j/ZqFeq3FtpeM39
	 1zl3a7bZSXZZ42HEDxicJxpYqJmVgFQL3lBizdDZTWs1/4W2tFbKfEiMxys08sn7WcUks
	 lUQgENDIY+vkF62fl3WMyyEkH+1M5agrfk18m7sWUGJWEb8c1s1I0dO1z0LGwC3mojyFM
	 aPLU6BjbWQCPBUtnXa/vmL7OdHn4kj0TLxSpLDVlo1DZGQQZP1G/uJdsfkfKJmhGYprAG
	 XqfdQPXrbGmibqbExXLgVHZbPN0gAStXsJHIaXroFtshTBfUn0YOFjTZkkRTH+jK3Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vVX+1rf+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5E7606A31C;
	Wed, 18 Nov 2026 21:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vVX+1rf+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9F31F000C4;
	Wed, 18 Nov 2026 21:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035798;
	bh=iwRIqxtGO/ZTfmRv9rZv1gUFvdvZqLRuX6p5g1KOZeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVX+1rf+rpxgB+yiZ2iDLZYeKiNmNeblYroyvAEduPRg2vvyHXFwTqilqtoqB8eGK
	 u7mCM8rpj71+oMeYwz0znSJzZT6R099jMLEQULLhBPmDYDs8BPIQcU2lA2EjIMRZhW
	 YA/Jqx0Jo8mF1gSuCUYTcFgPauBpK1N8Ds0cMq/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0829/3318] isofs: fix Rock Ridge CE extent validation on multisession media
Date: Wed, 18 Nov 2026 15:24:11 +0100
Message-ID: <20261118150343.969966088@linuxfoundation.org>
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

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit 43de050fa4a31f7e7a73cf8974dcf6037e161a39 ]

Commit a36d990f5913 ("isofs: validate Rock Ridge CE continuation extent
against volume size") compares the CE extent directly with s_nzones.  The
extent is an absolute block number, while s_nzones is the number of blocks
relative to the selected ISO session.  The comparison is therefore wrong
when a multisession disc starts at a non-zero block.

isofs_get_last_session() selects the last session on multisession
media, and its volume descriptors describe a volume beginning at that
session's LBA.
For example, a session beginning at LBA 45447 with 64 blocks can contain a
valid CE at absolute LBA 45467.  The existing check rejects that CE, so the
ER continuation record is not read, Rock Ridge is disabled, and the mount
falls back to Joliet names.

Save the selected session start in filesystem-block units and validate the
CE extent against the half-open interval [session_start, session_end).
Scale the session length to the same block units and retain a separate
block-device limit.  The lower bound is intentional: accepting arbitrary
blocks before the selected session could make a CE read data from a
previous session or another filesystem on the device.

Only apply the bounds check when cont_extent is non-zero.  A zero extent is
the in-memory sentinel indicating that no CE continuation was found, rather
than a request to read block zero.

For a single-session image, session_start is zero and the effective volume
boundary remains unchanged.

Build-tested with:

    make CONFIG_RUST= CONFIG_RUST_DRIVERS= fs/isofs/

Fixes: a36d990f5913 ("isofs: validate Rock Ridge CE continuation extent against volume size")
Cc: stable@vger.kernel.org
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Link: https://patch.msgid.link/20260907082602.3777551-1-liubaolin12138@163.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/isofs/inode.c |  2 ++
 fs/isofs/isofs.h |  2 ++
 fs/isofs/rock.c  | 11 +++++++++--
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index e7de6f3a5443b..d074400627b03 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -862,6 +862,8 @@ static int isofs_fill_super(struct super_block *s, void *data, int silent)
 	if (!sb_set_blocksize(s, orig_zonesize))
 		goto out_freesbi;
 
+	sbi->s_session_start = (sector_t)vol_desc_start <<
+				(ISOFS_BLOCK_BITS - s->s_blocksize_bits);
 	sbi->s_nls_iocharset = NULL;
 
 #ifdef CONFIG_JOLIET
diff --git a/fs/isofs/isofs.h b/fs/isofs/isofs.h
index dcdc191ed1834..3459cefe1003c 100644
--- a/fs/isofs/isofs.h
+++ b/fs/isofs/isofs.h
@@ -35,6 +35,8 @@ struct isofs_sb_info {
 	unsigned long s_firstdatazone;
 	unsigned long s_log_zone_size;
 	unsigned long s_max_size;
+	/* Session start in filesystem block units. */
+	sector_t s_session_start;
 	
 	int           s_rock_offset; /* offset of SUSP fields within SU area */
 	s32           s_sbsector;
diff --git a/fs/isofs/rock.c b/fs/isofs/rock.c
index 1a88f396f9685..88c4dd291fa67 100644
--- a/fs/isofs/rock.c
+++ b/fs/isofs/rock.c
@@ -9,6 +9,7 @@
 
 #include <linux/slab.h>
 #include <linux/pagemap.h>
+#include <linux/blkdev.h>
 
 #include "isofs.h"
 #include "rock.h"
@@ -84,6 +85,10 @@ static void init_rock_state(struct rock_state *rs, struct inode *inode)
  */
 static int rock_continue(struct rock_state *rs)
 {
+	struct super_block *sb = rs->inode->i_sb;
+	struct isofs_sb_info *sbi = ISOFS_SB(sb);
+	sector_t session_end = sbi->s_session_start +
+		((sector_t)sbi->s_nzones << (ISOFS_BLOCK_BITS - sb->s_blocksize_bits));
 	int ret = 1;
 	int blocksize = 1 << rs->inode->i_blkbits;
 	const int min_de_size = offsetof(struct rock_ridge, u);
@@ -101,11 +106,13 @@ static int rock_continue(struct rock_state *rs)
 		goto out;
 	}
 
-	if ((unsigned)rs->cont_extent >= ISOFS_SB(rs->inode->i_sb)->s_nzones) {
+	if (rs->cont_extent &&
+	    (rs->cont_extent < sbi->s_session_start ||
+	     rs->cont_extent >= session_end)) {
 		printk(KERN_NOTICE "rock: corrupted directory entry. "
 			"extent=%u out of volume (nzones=%lu)\n",
 			(unsigned)rs->cont_extent,
-			ISOFS_SB(rs->inode->i_sb)->s_nzones);
+			sbi->s_nzones);
 		ret = -EIO;
 		goto out;
 	}
-- 
2.53.0



