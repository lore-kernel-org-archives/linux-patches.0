Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585912;
	b=1EDEunIkrlbVUBzxxlBqz//mJgSKLmSvNfb8T7YBwSkh8sVusnOMhJqRMWbeNKFkizIb
	 HxlG2vIxKVLRH8YqlszRc+FVeBI94K9lBEcNe3+UXUcUt5kZO+OW4nbhTzuRmqgGJyubZ
	 JEnr7t5AbvdNTvUeTagALnG3eSdqmBEm6aXlEMFmR1obQpKTCMylM4d9F49yIFIaa7V5L
	 6vjlkVNKtz2s+P+z7AfCvFMQJ9bqPEAkYF3Q9FrweXMrnyLFWfWdzqeI1jcTrgZXbz0+4
	 fHU/hFr43F8sJ6vvSnG2Kv63aKiOnZ+JkKJtu9obfZdjctuiobTfeE9ExEgMEzT4+Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8z+iykj+MwAaWyz2gRpOgtyMoQ9GVVEPqHXh6mkgbNs=;
	b=QCAvJ1bjmCKCYfGHEQELmfT/TGzXHegxGgKJOP3IH26HMvM+3teeLrafS2Xyvn7oHlC/
	 Rxwa1bQ/dQl9ZU9uU0GE4VhqqDdpyJFrEUOsju80vCR/OC12wq008hci3gYAAwJUEfj5V
	 cHhjdkC3+tvu0mPXgVcllRdq0NUao5OYXsAHxftQpjPYKQuR8hlZ+lvmg0bXaoLCycTT6
	 Zd1A3/7sX+b4Q/r3kW6fVBiaEtzoNSP62cv6A8e1zyJ2r1iKTSsmL2g/yQvyG4pON8QBB
	 /3SaHrDE2siJtIN5bBC4zNS/HY5beWGgUWCb0Het0L5T71YqWxBIF86OvmaAJkTRElg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Pef/aUoS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8DF6076E09;
	Fri, 13 Nov 2026 16:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pef/aUoS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BDF1F000C6;
	Fri, 13 Nov 2026 16:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585912;
	bh=8z+iykj+MwAaWyz2gRpOgtyMoQ9GVVEPqHXh6mkgbNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pef/aUoSBGrv5Vw4vJ0G0oFzV3nffDyZ8zGlK0RA2DkfnNTOyubgEibPTf2Oc0ziy
	 SRK6uSOQapjsoYC8Tnjb0gNr1Li85o/P63cS/q0dOnOtN8yeKUxQPYbeAKrMXPUzi6
	 x57gpS3P4kSv1tL4Mwsdm3mta50TdFCo1Er/OzZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kaixuan Li <kaixuanli0131@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 476/507] f2fs: bound the SIT/NAT bitmaps by the checkpoint pack
Date: Fri, 13 Nov 2026 10:53:00 -0500
Message-ID: <20261113153813.088849442@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Kaixuan Li <kaixuanli0131@gmail.com>

[ Upstream commit 080833a32fd5dc10b3acf2fa9af9b3213e6cb617 ]

sit_ver_bitmap_bytesize and nat_ver_bitmap_bytesize are used as memcpy
lengths into and out of sbi->ckpt, which is sized from cp_payload alone,
and nothing compares either length against that allocation.

sanity_check_ckpt() has checked these two fields since c77ec61ca0a4, which
added them after a crafted image overran build_sit_info(). That check ties
each length to a segment count; it never compares either against the
allocation, which is the half this adds.

Mounting over-reads in build_sit_info() and build_node_manager(), and the
first checkpoint writes the same lengths back through the same pointers,
so the over-read's contents reach the on-disk checkpoint. An unmount is
enough; the filesystem does not have to be used.

Bound both ends the way __bitmap_ptr() lays them out. The three branches
differ, so a single sum of the two lengths would still admit a small
overflow when cp_payload is non-zero.

Fixes: 39a53e0ce0df ("f2fs: add superblock and major in-memory structure")
Cc: stable@kernel.org
Signed-off-by: Kaixuan Li <kaixuanli0131@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: Replaced F2FS_BLKSIZE(sbi) calls with the F2FS_BLKSIZE constant. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index b9adad85e18c3..b18ea09bcbe2c 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4255,6 +4255,7 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
 	block_t avail_node_count, valid_node_count;
 	unsigned int nat_blocks, nat_bits_bytes, nat_bits_blocks;
 	unsigned int sit_blk_cnt;
+	unsigned long long ckpt_size, sit_end, nat_end;
 	int i, j;
 
 	total = le32_to_cpu(raw_super->segment_count);
@@ -4386,6 +4387,29 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
 		return 1;
 	}
 
+	/*
+	 * Nothing above ties the bitmap lengths to sbi->ckpt, which is
+	 * (1 + cp_payload) blocks. Bound both ends the way __bitmap_ptr()
+	 * lays them out.
+	 */
+	ckpt_size = (unsigned long long)(cp_payload + 1) * F2FS_BLKSIZE;
+	if (__is_set_ckpt_flags(ckpt, CP_LARGE_NAT_BITMAP_FLAG)) {
+		nat_end = CP_MIN_CHKSUM_OFFSET + sizeof(__le32) + nat_bitmap_size;
+		sit_end = nat_end + sit_bitmap_size;
+	} else if (cp_payload > 0) {
+		nat_end = CP_MIN_CHKSUM_OFFSET + nat_bitmap_size;
+		sit_end = F2FS_BLKSIZE + sit_bitmap_size;
+	} else {
+		sit_end = CP_MIN_CHKSUM_OFFSET + sit_bitmap_size;
+		nat_end = sit_end + nat_bitmap_size;
+	}
+
+	if (sit_end > ckpt_size || nat_end > ckpt_size) {
+		f2fs_err(sbi, "Bitmaps do not fit the checkpoint pack: sit ends at %llu, nat at %llu, pack is %llu bytes",
+			 sit_end, nat_end, ckpt_size);
+		return 1;
+	}
+
 	if (__is_set_ckpt_flags(ckpt, CP_LARGE_NAT_BITMAP_FLAG) &&
 		le32_to_cpu(ckpt->checksum_offset) != CP_MIN_CHKSUM_OFFSET) {
 		f2fs_warn(sbi, "using deprecated layout of large_nat_bitmap, "
-- 
2.53.0



