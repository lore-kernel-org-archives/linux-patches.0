Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059650;
	b=rXRiCQXy6kj6IkV1E23Wx/uhKaP9o5Ilwe0wdZgkdadMWDXg3dDgp/WgaSmJ0hbVkqV4
	 luV6PhvQPpy7ZeuZfJVNo3eDSwObB51OKrF5ZGRnKyNeg/kxG/QdhdAPI8+eB64L650zb
	 afoqxmNTVEtZ1QiIg4GR2lB7ibQAsrHLkGdkDNmJC4m9LHkL8Sd0yZGcC/4zgziQgjJZm
	 WsH+1q4r2eYe1Nvybnli5LeeQOLtI8T70zie0/iHcO9aqXiXJeU+8czWUIzm/y73MF39K
	 1tMbvHKxzqi3NTxmlPEQ90nKutPzNdmK0DJAq6Tzfpx7x4iKkARvYNXyyl1L1xLIb+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059650;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YcBGhdH0j5CakMzVX0RGIkAvZBDTqqbNuHfLWlmHxpI=;
	b=B2idKQ1oVwoB6lxxYMln/OQ8VBb4BP1xIKhpHwOKdYKlXYP8+iyqDMO7FQADd7lrgkfJ
	 pbs9aNk/5uRMnp7l4OQxE0nqIeltKtC5+MNkBnecAezQ/eEo+WaVueMdE0mUuwJ1JgmLr
	 5990ciF6JM8gln9Eeh2DdPqnm5eIPJFFW/exdi5AMiZbqwFOZJ0NWyjTNKqLjeEhMkynS
	 wJBRY8ZOPd7Q9F6zBslUkVSL9XQ7Oh+GQGp8lUSm2GvjA3nK/KiWffmEoGCoACARS9RxU
	 kJzBXtWNix7lpNjixqaaBH3NfGKwIhunT5se+lTeTI25mP0b3Fq6oNBZO/PMDO1oB4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rDaEiQrH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6749B606A339;
	Thu, 19 Nov 2026 03:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rDaEiQrH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB061F000C4;
	Thu, 19 Nov 2026 03:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059650;
	bh=YcBGhdH0j5CakMzVX0RGIkAvZBDTqqbNuHfLWlmHxpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rDaEiQrHEutzW12W01zHFGEgwMdtgHf5q7EyFXLQ+ay8zeohdongXKL7hQad/Kw4n
	 RY6jo2+ofjE1aQoFMG8w6JtErogXoRnhi0R1WkTTui0sLzHlR2QD5RbX3eGqimmk2A
	 kHBIG90NpEznP2hI7eR9E9eKhfPXYJbsOK9X+7x0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kaixuan Li <kaixuanli0131@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0916/1848] f2fs: bound the SIT/NAT bitmaps by the checkpoint pack
Date: Wed, 18 Nov 2026 15:49:14 +0100
Message-ID: <20261118145955.199665469@linuxfoundation.org>
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
[ sashal: replaced both F2FS_BLKSIZE(sbi) uses with the existing F2FS_BLKSIZE constant ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index ad0f29f579463..56ee5a097c864 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3030,6 +3030,7 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
 	block_t avail_node_count, valid_node_count;
 	unsigned int nat_blocks, nat_bits_bytes, nat_bits_blocks;
 	unsigned int sit_blk_cnt;
+	unsigned long long ckpt_size, sit_end, nat_end;
 	int i, j;
 
 	total = le32_to_cpu(raw_super->segment_count);
@@ -3148,6 +3149,29 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
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



