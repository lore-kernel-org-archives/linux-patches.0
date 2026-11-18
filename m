Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047173;
	b=S1CCEBg2r2df8fk/Dtkpi6AU6Q4CBVsNPYlPbayDzXz2EvRhtELvKScH4X6AswHamIG8
	 tpUwfPnr7OovOwF7gJe07ltAMXDwYmf4dOXGnUpcQd1Fnn368ytfFssrN/8GYR47Gi9tt
	 l4vBcr+nE4LqL/nAK3pBPZfwcrUyKiZp1m2CfOD0IBUkY25sIFn1NXm7KG18hRc94zWuT
	 b7MuhvTC74Qk3RKuDr0EPOQ9cS3NMEKBD3j3f9xdewWcctTBKET8jYCZAqWa2WiGnV0O7
	 rAs1HGEHsYrbc3zZkrGh6nihgD/0vBd9GjmYxNm1eUOIVLCZpG1qGm5A3WKgaqTHg4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qta1sZn2UrRrGhAXcem5F0US5zaxO6YnyFjdDhFQ8g4=;
	b=3JT3aLSA1kT/0TdR/KM4xae4/GfWgeEvMk3dFzfcwz0qVIJmvWQi/ZpNIkv3vfhx+Ars
	 vF5Odas5OeGRJuYwtNx26XsH7EddkVARhI/QWrTFp3ndW2+WwRSyjvKKmG24YsWTdo58w
	 bJiDuoKywB0ZHvCpcaKYIXHgdEHQKeIjpNGkQ2T3iOCPK261u8z7ElszVNiw2DdQtdQuu
	 m9EuhMDS9x+Hc4VO8VgR/JLPv8PEk+HiHWtPxb2I/tvbbtaHDOgxmgbdwfTGA12nFZcH+
	 AJME0vHO/g6capHE0RyLwcWY8/zofsM4admdKwcWN+aSQHUIT/CEO48H+RQShOH0afw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qGjmVD5c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED27F606A325;
	Thu, 19 Nov 2026 00:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qGjmVD5c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4141F000C7;
	Thu, 19 Nov 2026 00:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047172;
	bh=Qta1sZn2UrRrGhAXcem5F0US5zaxO6YnyFjdDhFQ8g4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qGjmVD5cn3sjuatEbm8clXCw9F23uQ0G3pHJhr3zU0UpHCPd8Y4i9GgI0NJKGtmdv
	 qq/CsUUuepLCo5z9AS6WggcjCuHcw0oMdZUs8apzGLtS4nXyXVvLf+nflFyySZSJk+
	 2ROv/UtjJsslj75tqHD+JbOukeEcjw5BPwTfWnpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1543/2857] ext4: commit super block if fs record error when journal record without error
Date: Wed, 18 Nov 2026 15:42:57 +0100
Message-ID: <20261118150256.880905060@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit eee00237fa5ec8f704f7323b54e48cc34e2d9168 ]

Now, 'es->s_state' maybe covered by recover journal. And journal errno
maybe not recorded in journal sb as IO error. ext4_update_super() only
update error information when 'sbi->s_add_error_count' large than zero.
Then 'EXT4_ERROR_FS' flag maybe lost.
To solve above issue just recover 'es->s_state' error flag after journal
replay like error info.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230307061703.245965-2-yebin@huaweicloud.com
Stable-dep-of: e1a881ea4674 ("ext4: fix fast commit replay failing on a read-only mount")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9be9c264a6977..fee5438e2cf08 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6003,6 +6003,7 @@ static int ext4_load_journal(struct super_block *sb,
 		err = jbd2_journal_wipe(journal, !really_read_only);
 	if (!err) {
 		char *save = kmalloc(EXT4_S_ERR_LEN, GFP_KERNEL);
+
 		if (save)
 			memcpy(save, ((char *) es) +
 			       EXT4_S_ERR_START, EXT4_S_ERR_LEN);
@@ -6011,6 +6012,14 @@ static int ext4_load_journal(struct super_block *sb,
 			memcpy(((char *) es) + EXT4_S_ERR_START,
 			       save, EXT4_S_ERR_LEN);
 		kfree(save);
+		es->s_state |= cpu_to_le16(EXT4_SB(sb)->s_mount_state &
+					   EXT4_ERROR_FS);
+		/* Write out restored error information to the superblock */
+		if (!bdev_read_only(sb->s_bdev)) {
+			int err2;
+			err2 = ext4_commit_super(sb);
+			err = err ? : err2;
+		}
 	}
 
 	if (err) {
-- 
2.53.0



