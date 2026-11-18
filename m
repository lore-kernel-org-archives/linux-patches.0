Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052147;
	b=Y6lruRKK4UpQTutU43arHP8x7nugOvy7DEHpAaUfi0EGCSDM127RYE0WIURuW2WfmIgh
	 j0xp75Le6vd3m6Yw2Gw8U5GZW955oJb9Z6izv43akHP8kKwlyBi/yMzFt1pHdrBeQ9vM9
	 EgN754jRioAlqT5VPFcblPAtJnhgoilRDjdsDOMjdKY4pR0C2g7eKE0EclzLgDnLjbHwu
	 m/glrRSk+/WamTPoMA6OO13Hdj32rjPrJgBwDs4OzOh1/dhXnqApsJyLbxKD6ngGRXrdt
	 Ee3TY/u4H0RTJdwvJ0Bg2kqWqd5pZlCvSUo5i9wfPuUv6Q4fmf27RuYouRajxzB3PUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hvqzZ3SCIBfJzqCtDFXREdSaiStSkP4IjPfMAG1HrCQ=;
	b=sCKtRhCMZ4vk9K9HUKT9NKMSbEBpJGlCCtjCXQONStV6rVH7GbpXbgERmcoutJHixIjV
	 BBcdHBdJkcf8wZQXNeM9fXEsjVvc6uwdZlsa/8enSY/Rhl3y76S66IXXLyEbOdwXrawIs
	 rb7nri8clYlpgaEs5kA2rpJKpb042VTGtPXp9c4Y96fZS1n54LOIdObj9t5HRbacbZdmY
	 nGfDTULB64TmGc9LfrdlO6zyRXxvGgdHuCLzq6atG1d0Loi3ZKLIAHaUwAEKcvZCar0DA
	 vizffcEL+4yRdf0Ajiq8UiVmYRR456+gRNpWCmFjJIPWKRrxL8E7qanQHXnSM1ccOHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nqTnSsCE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA0F606A31C;
	Thu, 19 Nov 2026 01:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nqTnSsCE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B957F1F000C4;
	Thu, 19 Nov 2026 01:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052147;
	bh=hvqzZ3SCIBfJzqCtDFXREdSaiStSkP4IjPfMAG1HrCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nqTnSsCEWLDyBWO8R0zEv3OUZQI+m9LKgUaplTtWt84xv1WS19Y/Uc2MUbxMulZfe
	 893WXIGqfGCT6Y4Jp3nOlRfJ7LrZTj+3rD3UBBD4HSf14kQd37W+ES8MEAI5UKJug5
	 fp79LTyIC5TMTvgijqjLH3TKFK7QJSRjdQ0zjcV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0458/2214] isofs: fix Rock Ridge CE extent validation on multisession media
Date: Wed, 18 Nov 2026 15:35:34 +0100
Message-ID: <20261118150029.561062483@linuxfoundation.org>
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
index 9b530be5dafa2..bb92e767ef560 100644
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
index d62783616d212..03852349febb2 100644
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



