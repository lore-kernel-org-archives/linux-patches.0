Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061923;
	b=lfcjnjjconk8YgQDMKjaQWlam3rixl41hpA+51ot35hVZVPRg/UfaAa+kW9tmsSYSvIM
	 QREf43nD4AZvaSlyV3JQGqr01Lpu2kQRB5Lk+FVNqk//4G3bWjbpW9rE0rRI/3mD4dAEL
	 TM1wxJ5n67ocDeZgX4bs209KldgqzT/6PTsbbdsvFc0pYvQcBgRCSkltj427KWx5Qxwmu
	 2Vws7Vi8+clNf9tUBGTsKiz/Fekvvh9cUv1qwnO6T8J+QLbUcWmcyA4KgmDxDVvuxtGYd
	 skh+jhJu0ycnAtZkoDrr3JveTxH1SEYi92CBQzdpJkSr25R4bXeDU1XgBZx7VKsHu+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4lCT7k6lt1YlrxGXaR1LTUa2EnIw+ydWGcXmPauke8A=;
	b=egKzhH5oWPg7/fFai7+n+1F3pifUMJiqEBB+SlfO/vkDK21qmyqKq7aTtqjN7GBan6H5
	 fCQTRh2bM4Rro0LykWzI7o/NKvIFeu3HNSKYDuF36m7e4OP1YervS8YsHtPFtEqFyBZ1j
	 MPW6zxoWiqacOStmEzvBQnH+ndmL+u3hMXYHsJjMTXSCYje2ne7YDpp0xBfLHQQITZTqO
	 AMCDNi+HtI+I2s5T/9pitE/FbrT5skto4+JDm6fS2QJUJXj5An/LQzJ50pOxmYZUxfgIT
	 Abtt4dDY+5MW4rjQxDDiIQdFT3WT62KiE63b7E0b6BoJW1bVrehNbLv7nVNtU12sl1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=frMGEjDI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC76606A332;
	Sat,  7 Nov 2026 14:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=frMGEjDI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7431F0089F;
	Sat,  7 Nov 2026 14:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061923;
	bh=4lCT7k6lt1YlrxGXaR1LTUa2EnIw+ydWGcXmPauke8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=frMGEjDIdBwdpshoU5K9EP3kDCAoog57jCtuMY6Dv59OOI+g+RhcZ712KHn08Ui2X
	 Lw0gCi0fTqGHLHeV/MsoaiMraCCjjiS7e4neuxBqAmJPmPJ6CLRq/0c1wPn6kl7NcO
	 ifUlCGWvDLiqKZw/6AAa1g4BxxvsS655zkk+n4ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0929/1536] isofs: fix Rock Ridge CE extent validation on multisession media
Date: Sat,  7 Nov 2026 08:49:05 -0500
Message-ID: <20261107135023.742286519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index f49c4ecd89505..bf0ecfae44069 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -821,6 +821,8 @@ static int isofs_fill_super(struct super_block *s, struct fs_context *fc)
 	if (!sb_set_blocksize(s, orig_zonesize))
 		goto out_freesbi;
 
+	sbi->s_session_start = (sector_t)vol_desc_start <<
+				(ISOFS_BLOCK_BITS - s->s_blocksize_bits);
 	sbi->s_nls_iocharset = NULL;
 
 #ifdef CONFIG_JOLIET
diff --git a/fs/isofs/isofs.h b/fs/isofs/isofs.h
index 5065558375333..a36a634797435 100644
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
index 869b331eff4f6..a4a337301b6f9 100644
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



