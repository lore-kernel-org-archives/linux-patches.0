Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215570;
	b=emfQAxsyJkldmsg4ua509G5IM4wCHwZ5z15SWPCwunOz4xS90a+RkK5q9UStFZjf38zg
	 k2TshOl7MxXlQT1msxnFkx3o7xg+eiXwjEx+4m3QKsA2pu9mtrCTORQse6PdusgQLH/0u
	 N92vg1jRfP40Z9Pa0ULmPI9gq2a3wCgnM/2GUnsfeeaQZLnZBz2HI6+x5WQKlGP4uKP2l
	 gtu+ONEn8xHnG3wYw2+LiJsWhPvsr518G175Sxo4jBvL5ZYTz4FwRdTSOhH9cFlVrk8q1
	 67plYF6vzH5Y9yqNAhQCN1pu6IN9hxg+mWTTpPW0MWw/R19S4u5d7BbSCpcrKv1kskw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6/+G9nI/H4gljH9suwdimdZPVi0ITZAQlNKVaKdQFfk=;
	b=Wr0JU4D/rQfESegNupuyQ1rTa3SKbnhufKgei4FtzUrf2LZRLBnmhuE9smWzsx4YC3nN
	 mulK/sF6EWpKbxv7tM6kkSFd1A4Be28HStzRE00t7iJ+rTysXlpn42+PBkah1jqQSj4RC
	 ifS0B6ZzPG/JcMAmBtG4LdisWiy9RN4E2g5hgJsZrruZFraDUsNNnPWVuWWkyAyF10y4b
	 ZmU9cTtWgkQ3+S0KT8fmpvteSg0letdEnjRA91lrGCjW9XTZyRtxUYJphr8NDb2f16Dfr
	 aWqfWFaSbofw5fWCLKtak2fBajtbwzqgPPZ/nh3b3pQP7ha5P9sYzG3BXYh8eHQs0NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jomfpUWQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4CF606A31A;
	Wed, 28 Oct 2026 19:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jomfpUWQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064711F01825;
	Wed, 28 Oct 2026 19:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215569;
	bh=6/+G9nI/H4gljH9suwdimdZPVi0ITZAQlNKVaKdQFfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jomfpUWQWmGCsgMZMIxZziLMWv7ya5ny8t9kgOvlHlf9dIIx4Ru6ji9RkRU1i0ueE
	 hmRQ0mdm8x54OZ/tcWTiShQiaQPIMjTcf3IDFC8XEsWkTV7ikOHGWjHxtZajeQ5dij
	 jrbUG66h+9+sGJf+whQonEnC6963AqdIiIkjxmMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ad6118a7584b607c67f2@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1255/1887] ext4: validate donor file superblock early in EXT4_IOC_MOVE_EXT
Date: Wed, 28 Oct 2026 17:55:51 +0100
Message-ID: <20261028170527.984638133@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit c143957520c6c9b5cd72e0de8b52b814f0c576fe ]

Reject the EXT4_IOC_MOVE_EXT ioctl early if the donor file does not
belong to the same superblock as the original file.  Currently, this
validation is performed inside ext4_move_extents() by
mext_check_validity(), but only after lock_two_nondirectories() has
already acquired the inode locks.  When the donor fd refers to a file
on a different filesystem (e.g., overlayfs), this late validation
creates a circular lock dependency:

  CPU0 (overlayfs write)            CPU1 (ext4 ioctl)
  ----                              ----
  inode_lock(ovl_inode)
                                    mnt_want_write_file(filp)
                                      sb_start_write(ext4_sb)   [sb_writers]
    backing_file_write_iter()
      vfs_iter_write(real_file)
        file_start_write(real_file)
          sb_start_write(ext4_sb)   [blocked by freeze]
                                    lock_two_nondirectories()
                                      inode_lock(ovl_inode)     [blocked]

With a concurrent freeze operation holding sb_writers write side, this
forms a deadlock cycle: CPU0 waits for freeze to complete, freeze waits
for CPU1's sb_writers reader to exit, CPU1 waits for CPU0's inode lock.

Since EXT4_IOC_MOVE_EXT exchanges physical extents between two files,
it fundamentally requires both files to reside on the same ext4
filesystem.  Moving the superblock check before any lock acquisition
is both semantically correct and eliminates the circular dependency
by ensuring that cross-filesystem donor fds are rejected before
sb_writers or inode locks are taken.

Fixes: fcf6b1b729bc ("ext4: refactor ext4_move_extents code base")
Reported-by: syzbot+ad6118a7584b607c67f2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ad6118a7584b607c67f2
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://patch.msgid.link/20260608152521.1292656-1-yun.zhou@windriver.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ioctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a6d5a4e37a285..8cee51df4bbdf 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1348,6 +1348,11 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			goto mext_out;
 		}
 
+		if (file_inode(filp)->i_sb != file_inode(donor.file)->i_sb) {
+			err = -EXDEV;
+			goto mext_out;
+		}
+
 		if (ext4_has_feature_bigalloc(sb)) {
 			ext4_msg(sb, KERN_ERR,
 				 "Online defrag not supported with bigalloc");
-- 
2.53.0



