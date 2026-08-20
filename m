Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E77F19049B;
	Thu, 20 Aug 2026 16:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243479; cv=none; b=BnE9H5ejWomgm6JfuMpmqApwTb5nw3phto2dxrefIFgljTH4ZX/3a7lY84A6VNDgzdnplvzjvdxw5EViC97vxq/QHzaIp+czxJupKrqINOCbbH192xYkN39LgwG2nIvIXrz6QgrTQ6FTRIfLSrL/jIKPulSpp3HFqRtfLV+p6j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243479; c=relaxed/simple;
	bh=G1xMaKKaX8UDyDDdR93RlQfZx1rJbEXO7Q8OnQC9dDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEezM1BYFtVABnKgCPf0Zfc7s46mfBivaOakbJn3SJQ7Y/RiOWSiBX8oIhJsK+9hESA1LPUKimVgxSsIJffBCbm+191HyIUdgX2rehZhlYDR90aR3TF5xLlqOVj6HzQt1B9cDhqPIC/VQbhIlsTL4L1oWneeoSn4R42cBn9xAhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTWcn7x5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTWcn7x5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86B91F000E9;
	Thu, 20 Aug 2026 16:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243478;
	bh=HhYmv5yxTDbw2t/+U0EF7oen++7a070Ddk9GZU2F/RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTWcn7x5Uwsz9xTTqc5fp/f2N20xjLuRR3tpbJPXSgBeMz8vOi1kzA9qG1eC8nBgF
	 qLPuc7zY/Hng0SIEYAlom3PmIo2oj/bgWA9MXqlcLdb6lxrEyRpgcPN3601Qu1nse7
	 fKg8JmSGxrWf30GEv3536QPpIjng6/NrKkRllaHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Skripkin <paskripkin@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/272] fs/ntfs3: Make ntfs_update_mftmirr return void
Date: Thu, 20 Aug 2026 16:54:51 +0200
Message-ID: <20260820145234.479451547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit e66af07ca2b57e01dbf6001ae565ab40037b2df3 ]

None of callers check the return value of ntfs_update_mftmirr(), so make
it return void to make code simpler.

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: 5e7b598660cf ("fs/ntfs3: bound copy_lcns dp->page_lcns[] index in analysis pass")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fsntfs.c  |   20 +++++++-------------
 fs/ntfs3/ntfs_fs.h |    2 +-
 2 files changed, 8 insertions(+), 14 deletions(-)

--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -830,7 +830,7 @@ int ntfs_refresh_zone(struct ntfs_sb_inf
 /*
  * ntfs_update_mftmirr - Update $MFTMirr data.
  */
-int ntfs_update_mftmirr(struct ntfs_sb_info *sbi, int wait)
+void ntfs_update_mftmirr(struct ntfs_sb_info *sbi, int wait)
 {
 	int err;
 	struct super_block *sb = sbi->sb;
@@ -839,12 +839,12 @@ int ntfs_update_mftmirr(struct ntfs_sb_i
 	u32 bytes;
 
 	if (!sb)
-		return -EINVAL;
+		return;
 
 	blocksize = sb->s_blocksize;
 
 	if (!(sbi->flags & NTFS_FLAGS_MFTMIRR))
-		return 0;
+		return;
 
 	err = 0;
 	bytes = sbi->mft.recs_mirr << sbi->record_bits;
@@ -855,16 +855,13 @@ int ntfs_update_mftmirr(struct ntfs_sb_i
 		struct buffer_head *bh1, *bh2;
 
 		bh1 = sb_bread(sb, block1++);
-		if (!bh1) {
-			err = -EIO;
-			goto out;
-		}
+		if (!bh1)
+			return;
 
 		bh2 = sb_getblk(sb, block2++);
 		if (!bh2) {
 			put_bh(bh1);
-			err = -EIO;
-			goto out;
+			return;
 		}
 
 		if (buffer_locked(bh2))
@@ -884,13 +881,10 @@ int ntfs_update_mftmirr(struct ntfs_sb_i
 
 		put_bh(bh2);
 		if (err)
-			goto out;
+			return;
 	}
 
 	sbi->flags &= ~NTFS_FLAGS_MFTMIRR;
-
-out:
-	return err;
 }
 
 /*
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -599,7 +599,7 @@ int ntfs_look_free_mft(struct ntfs_sb_in
 void ntfs_mark_rec_free(struct ntfs_sb_info *sbi, CLST rno, bool is_mft);
 int ntfs_clear_mft_tail(struct ntfs_sb_info *sbi, size_t from, size_t to);
 int ntfs_refresh_zone(struct ntfs_sb_info *sbi);
-int ntfs_update_mftmirr(struct ntfs_sb_info *sbi, int wait);
+void ntfs_update_mftmirr(struct ntfs_sb_info *sbi, int wait);
 enum NTFS_DIRTY_FLAGS {
 	NTFS_DIRTY_CLEAR = 0,
 	NTFS_DIRTY_DIRTY = 1,


