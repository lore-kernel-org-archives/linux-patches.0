Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058091;
	b=t+h/zlvyOjUhFxg+9fptXD+jOM0f+BANgfPVN1mIwf+VLd1m9TRihEucf7DbSG4NdEZk
	 hm5D+ZkUpnTUAt7je0epsOOVtQPrnUECpoIAIVrQoTfGiNyL6/Sty8+5PkL2ZTkr4mSiA
	 3uh4KSainFmQEQ5xAog7ceNyvPifn0vk+Unz2d9MqKDNlI5OzSl1dTkImzcgXdES8myXk
	 0WK0jRA3cZUbjXl93SiaHwvsWZMk3TMHSrFaz1h74XwtGNPSRcwE5BykzxsT/YRAl99kz
	 jOS+fqkVZO8GGl/cEnbnt4QINrItMHKs4ZVPXLE4S/5Qgi+aiqrr1m4xDs98BdQLMcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0qjmssWvAKcRkSTa4Hnjj+3417z3BhQ9pTLJTmCV7G0=;
	b=cwzf8vbhuEyYDy077wTUhIQE+M8bpg4XVbQjK7bqmbKs3nqbqSu/pc31ME8RC6xh+n0O
	 9kY8tSC9XIqWc/UlGIUUgfXZ+cr0w00egaLtddm8cbau0nXo/q4l4zkoFL/yM598KOah/
	 Lz4aj9yYZj6n+FejAXMIBexvmzV+MIG7grs6LkuFmGQZMuDmp/tFW19CY3GGnfw6BXpQ4
	 BW58rrg9lBjBMjB2PXV5zth7zdP9NFzzcPbXwICTVFlc5kcRj/V4LavIJ5vqngA9Odejg
	 Z8QMrwgvm0SvU4d1iUul2t6jJRSqc0xoDhvaw8h0by/HQ2uspkPHriD5UGyRKfZ9Umw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N8EQK6pf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89348606A31C;
	Thu, 19 Nov 2026 03:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N8EQK6pf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA521F000C4;
	Thu, 19 Nov 2026 03:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058091;
	bh=0qjmssWvAKcRkSTa4Hnjj+3417z3BhQ9pTLJTmCV7G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N8EQK6pfF3Oyu0/lCW3zI00ENGhyc4BQY9BXyjG2Yucdv1MvbUEK67zvRHOWqeohj
	 zH7nsDC9AKMZreWf59/Z685OGmhS5OACDjsAlZEdrJV8ZyszQ3C2F4SQkyO9pezCyM
	 /oqSM3e9GRtVvBzDg4hodHs4+kh773xDK/Y0wdso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0363/1848] isofs: fix Rock Ridge CE extent validation on multisession media
Date: Wed, 18 Nov 2026 15:40:01 +0100
Message-ID: <20261118145928.349855935@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index eb905f8d6c488..ab367a4c98bbb 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -861,6 +861,8 @@ static int isofs_fill_super(struct super_block *s, void *data, int silent)
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
index 1cb7705053999..d3bfac1c82c12 100644
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



