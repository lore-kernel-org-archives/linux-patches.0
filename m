Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021561;
	b=md9uR4pSNvjMMXP99gOVpFNEnF2vD7JaupnFvaSHnMmdqQhFhDWBhIt0V2TSxrEMH6sY
	 38s2F0gN11KEOMg59qVMAlaYLv5K0SLliHlt01cT3WFjjbZwFJdmXD/ipCsg+Urofi/xL
	 dES3tjfBkGY71CbxuUwq08e1xgY0NC3AcdEo89ln1xuVM2TD163yMQCgRALT4e/RLYE/P
	 8FfvKiWSBD0bSP87S7UhvCiX0vBgdUS5vBD2hQTJ1XV1WEdxH72Bfupbv7t1gUqFyuMWX
	 olYsPoBqnggLnyEMSqQJ6ulj0AVFizWP4Yreroe0Wz3CXQCM+UJ8FSfhaUwDk8rX0HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=38WPhL7wq3q5Cq4jMeNLCTGtUyi+tBbJJU63MS7q9nU=;
	b=uuAVokq5dtwYvcOm0HNbkAoaK+3N+LSJgTLAYeUPoHqg4KUhGgtDcVkesRwKRicA2+a4
	 fgFMoufxW/odgSkgH56HhmmSXuErLbgVxRhPpr94G7z8LFoqJ8oG28El2PKMLj0bcJXU9
	 r1GFn++TLWbrecUS7BnvBy7KUcE/CN5SkUSW2826imoQVTaxRBW0+YY4mbEoSHbA5eHSW
	 3CRRP+iH5sZYoCoRfI+/hDu4BMEgv6wihle20LUUxu6aV/tYPIQ5TYXbfGB8MEmR2UulQ
	 MQjajbHFI3i/FN6Viym6w2mCpgdLtFgqaof9Y9k/lk2v3lvQH/jbj3AnwIiqWRypCYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T4Qk77oB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C10F606A31C;
	Wed, 18 Nov 2026 17:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T4Qk77oB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25D51F000C5;
	Wed, 18 Nov 2026 17:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021561;
	bh=38WPhL7wq3q5Cq4jMeNLCTGtUyi+tBbJJU63MS7q9nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T4Qk77oBS3lOjiTVtJU8R9efb5f3GOGbBi7aFULUPzJrr8fStzrLFFC9BtIFYA1am
	 DMmjYBeV91/8f0wPWefa/c+Sds/66VfFGrtfvZuTEcjKc7xyrFmtmh9UTCJzDuEGVH
	 /CbD+zT3lQyqcz3iAze+NEWgkBleYTogWTLNWPWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2350/2651] ntfs: fix u16 truncation of the update sequence array count check
Date: Wed, 18 Nov 2026 15:59:50 +0100
Message-ID: <20261118150409.658693497@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

[ Upstream commit b713b69cf79ef52b1737a1a6c09df2522ff875af ]

ntfs_check_restart_page_header() bounds the on-disk system page size by
recomputing the update sequence array count from it:

	u16 ra_ofs, usa_count, usa_ofs, usa_end = 0;
	...
	usa_count = 1 + (logfile_system_page_size >> NTFS_BLOCK_SIZE_BITS);
	if (usa_count != le16_to_cpu(rp->usa_count))
		return false;

The right hand side is computed in u32 but stored in a u16, so the count
wraps once the system page size reaches 0x2000000.  An image claiming any
larger power of two passes the check by also claiming usa_count == 1.

Nothing else limits the value, so ntfs_check_and_load_restart_page() goes
on to kvzalloc() up to 2 GiB for the restart page and copy that many bytes
a page at a time.  The size is only rejected afterwards, by the
(size >> NTFS_BLOCK_SIZE_BITS) != usa_count test in post_read_mst_fixup().

Compute the count in a u32 so the existing check rejects an over-large
system page size instead of being defeated by the truncation.  This adds
no new limit: the array holds one u16 per protected sector plus the update
sequence number and must end within the first sector, which caps usa_count
at 240 and the system page size at 64 KiB.

Widen ra_ofs and usa_ofs as well, as ntfs_check_restart_area() already
does: both are loaded from __le16 on-disk fields and every comparison is
against a non-negative value, so no result changes.

Fixes: 1e9ea7e04472 ("Revert "fs: Remove NTFS classic"")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/logfile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs/logfile.c b/fs/ntfs/logfile.c
index ce38ce87f8fc8..2f27ae7a3927f 100644
--- a/fs/ntfs/logfile.c
+++ b/fs/ntfs/logfile.c
@@ -27,7 +27,7 @@ static bool ntfs_check_restart_page_header(struct inode *vi,
 		struct restart_page_header *rp, s64 pos)
 {
 	u32 logfile_system_page_size, logfile_log_page_size;
-	u16 ra_ofs, usa_count, usa_ofs, usa_end = 0;
+	u32 ra_ofs, usa_count, usa_ofs, usa_end = 0;
 	bool have_usa = true;
 
 	ntfs_debug("Entering.");
-- 
2.53.0



