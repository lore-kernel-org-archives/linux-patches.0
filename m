Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065094;
	b=28SaVZDDXnr+VeYmxC5+KYbDT9cu9PPVmw/bKLa7ReLEveRouJE1oZ4bD8/gJE/H/DqU
	 PH73xI9kgA0akbzGFld40eZ8alhB1q23iAQB8hmgOQd5XARqSGieIVOzNRlU/A2vKqqG7
	 6gFsAs3cORCIUrcRKySLPXehsSuVC80smegCKcdZrABHGcm02d8kxZPH860GxiZSRRA5e
	 YWlINsT/d1gOm8cArLRSw82Rv0FhpKensDtnqTl4njZBDm0Myqgh+fiv7viVx8Vbq6wlg
	 ByE4Tya+Gkx8rpeGls/L6bku9u5pBc1QH0xzmI+VQCMSjA6aB3MAFUBzHPcZZ57nruw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p1i7CSxUnMCU1F8RN47sNziS+6oTXgBBNhUuuG3mEhA=;
	b=IsDLBi36OztxFPEF9Uie71qJVe/LdappPvVMA8uMvemvyvzhPw2WxDz2nLJ3I/Q2YgnX
	 yAi+PbDa0S43Cpc2WoSJ1HNI7374GbDkxgvHIxyL1GSCZccu3H9bOBvDGoDEPYaueXpGc
	 1Pxu4i/pfTHNsYUFXiC34DvNupewfzXlAwQ3WXk53jg+YKLyE7EJjfm3ue4Scw9a4fn/m
	 ofmKcDjM2uAuX06HufEbK+n/umMHJrhpzE1rXln7XhdZEnuA3TXZsXV6a1ggT4a14Y7xh
	 fuzqXoTf4EYGfl4cdSkNdsxvlkOqndN6MkicPAhsl0wWABaBqEyNKQj/CNmlzN4YgDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OYT/kBuT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8825606A32E;
	Sat,  7 Nov 2026 15:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OYT/kBuT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6468E1F0089F;
	Sat,  7 Nov 2026 15:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065093;
	bh=p1i7CSxUnMCU1F8RN47sNziS+6oTXgBBNhUuuG3mEhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OYT/kBuTZiGmTW8xSnTIrZK7ZNVJoKJNoxxhd0NFLkSmX3XGiTRK18K6JUc3JVa++
	 5d8eSOxnc3JYtQsoIl8ku4GwQJ7v7Ure4myoX4KQWiMqd6Lq6LNWBT57S7MBtnl6D7
	 tNck6yqwsszxq/rb1k4pa98AkYyTpiAzQbKQZzsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0929/1257] ntfs: do not turn an unmappable runlist fragment into delalloc on write
Date: Sat,  7 Nov 2026 08:53:45 -0500
Message-ID: <20261107135005.015438111@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Goergens <matthias.goergens@gmail.com>

[ Upstream commit 26e51efbcb60b2eeddc3e7488fd214a02586851a ]

ntfs_write_simple_iomap_begin_non_resident() has the same unchecked
retry.  LCN_RL_NOT_MAPPED passes its "lcn <= LCN_HOLE" test, so a
buffered write into a range whose extent record cannot be read is
merged into the runlist as LCN_DELALLOC over clusters that are already
allocated on disk, and write() succeeds.  If the record stays
unreadable, writeback fails too and the data never reaches the disk;
the error only shows up at a later fsync() or a synchronous write.

On the volume from the previous patch, after a read of the file, an
8 KiB pwrite() at vcn 1000 returns 8192, fsync() returns -EIO, and
after remount the range is unchanged.

Fail the lookup here too, with -ENOMEM or -EIO.  That pwrite() now
fails with -EIO.  Writes whose range can be mapped are unaffected.

Fixes: b041ca562526 ("ntfs: update iomap and address space operations")
Cc: stable@vger.kernel.org
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/iomap.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/iomap.c b/fs/ntfs/iomap.c
index c812d7f19b360..b4475963e57a7 100644
--- a/fs/ntfs/iomap.c
+++ b/fs/ntfs/iomap.c
@@ -394,7 +394,7 @@ static int ntfs_write_simple_iomap_begin_non_resident(struct inode *inode, loff_
 	loff_t vcn_ofs, rl_length;
 	struct runlist_element *rl, *rlc;
 	bool is_retry = false;
-	int err = 0;
+	int err = 0, map_err = 0;
 	s64 vcn, lcn;
 	s64 max_clu_count =
 		ntfs_bytes_to_cluster(vol, round_up(length, vol->cluster_size));
@@ -429,12 +429,24 @@ static int ntfs_write_simple_iomap_begin_non_resident(struct inode *inode, loff_
 
 	if (lcn <= LCN_RL_NOT_MAPPED && is_retry == false) {
 		is_retry = true;
-		if (!ntfs_map_runlist_nolock(ni, vcn, NULL)) {
+		map_err = ntfs_map_runlist_nolock(ni, vcn, NULL);
+		if (!map_err) {
 			rl = ni->runlist.rl;
 			goto remap_rl;
 		}
 	}
 
+	/*
+	 * As in ntfs_attr_vcn_to_rl(): a runlist fragment that could not be
+	 * mapped is not a hole.  Treating it as one would put a delalloc
+	 * extent over clusters that are allocated on disk but unknown to us.
+	 */
+	if (lcn == LCN_RL_NOT_MAPPED) {
+		up_write(&ni->runlist.lock);
+		mutex_unlock(&ni->mrec_lock);
+		return map_err == -ENOMEM ? -ENOMEM : -EIO;
+	}
+
 	max_clu_count = min(max_clu_count, rl->length - (vcn - rl->vcn));
 	if (max_clu_count == 0) {
 		ntfs_error(inode->i_sb,
-- 
2.53.0



