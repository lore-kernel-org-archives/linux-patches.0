Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046587;
	b=DlFVdnyMUiVnmpv5xho3AMxarUZgLOvgyxDSyDTfDR9J5cJkXyAd75RdwBMNoLRR7nMW
	 sl1VI4UaU13pGZj8vE8qoGDdjK23rlJeA3xbRtfGK1Ce7yuC16WamqlP+ldcVpdb+D3RW
	 NtuGqb4Dgfze0Ku/B5ku6Jr/NnrvCN3sQ0GC1aJTeMFCy0xdse8pcN/70w/fY6JKxTH4O
	 nh4AV+kAFhqktPPCp0b9lL2bFtlrbqrpDzoyLmlkekHgFs5yv/O1zm7Ljjv0LH5fSmDAT
	 i2R0ulPeMrxAvk3ZRDUNlWkwbyAeJG2q59u1Vuh0wZwm3FvOHcc1zXr8FWL8ZQukpjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wwawvkCRQExSo/TRYXRZNv3n0+z5+LkUg7+1qUqPm1Y=;
	b=eSO2NB1ND+PRJGKazAUM0AnbVj3DYdYhDmkVU1oXzFneWBCy+dZhz+A2DkRC65xh9/Jy
	 nLyaehWci7LN0HG/rjVAxf9qKl0udxyAApBu7W6h9YNjy/b7XnzNGcbkPOtH1Vm/H9klK
	 3xOd+G6wjCWZ6UQhzbsU0d5OPQAcwG8F62KTv79RAu4wUFd7WlXPcRWs7rBYOD/Cmbk81
	 o0wqrNv2FXzXwYs/ZQ0PrT0nkac9N0BGozSaq3lsjbR9uEd7Oyll4821fxJaYEAM0MJyx
	 7u7FSJZQPlQk55uFSS6VujvCeggolcwqZNxxkncIXdJR/Abwcu9GbfEDc8QyijUDsBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ajGk/DWf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DEC606A325;
	Thu, 19 Nov 2026 00:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ajGk/DWf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029A41F000C4;
	Thu, 19 Nov 2026 00:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046586;
	bh=wwawvkCRQExSo/TRYXRZNv3n0+z5+LkUg7+1qUqPm1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ajGk/DWfmEqXVuF0xVoxmyhkA8vM9hLa2Y0t/NuHbCqSbmVVmUgFzPo3IdK7mXG2H
	 hlfo/Y/uX6fA0byA2QgMsIEtv6BsUVUq/Jfr3wutP0smdH8zwR20K5d4gSXMXAzlci
	 HC7WFeTHcCH8X+Oc03ySgru1XPEt05OLQg1XCS0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jiucheng Xu <jiucheng.xu@amlogic.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1332/2857] f2fs: force out-place update for all writes on compressed file
Date: Wed, 18 Nov 2026 15:39:26 +0100
Message-ID: <20261118150249.397923617@linuxfoundation.org>
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

From: Jiucheng Xu <jiucheng.xu@amlogic.com>

commit a64a3fec11e77a3a0dc0009bdc58b925e45a1bb4 upstream.

For compressed file, compressed write may fail and fall back to raw
write.

-Thread A                                         - Thread B
  - f2fs_write_multi_pages                          - f2fs_down_write(&sbi->cp_rwsem);
   - f2fs_write_compressed_pages                    - ...
    - f2fs_trylock_op                               - ...
     - f2fs_down_read_trylock(&sbi->cp_rwsem);      - ...
   - f2fs_write_raw_pages                           - ...

Thread B acquires the lock first, which causes Thread A to fail lock
acquisition and fall back to raw-data write.
IPU_FORCE is enabled on small-capacity storage devices (< 16GB),
so f2fs_write_raw_pages() overwrites the original compressed data
in-place.

The in-memory node has been updated with raw-data addresses, while the
node metadata stored on eMMC still remains in compressed state.
If a power-cut occurs before the node is flushed to disk, on-disk
inconsistency arises: disk data is raw, yet metadata treats it as a
compressed cluster, leading to decompression failure.

To eliminate this risk completely, force out-place update for all
write operations on compressed file.

Cc: stable@kernel.org
Fixes: 4c8ff7095bef ("f2fs: support data compression")
Signed-off-by: Jiucheng Xu <jiucheng.xu@amlogic.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
(cherry picked from commit a64a3fec11e77a3a0dc0009bdc58b925e45a1bb4)
Signed-off-by: Jiucheng Xu <jiucheng.xu@amlogic.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 6384ac931bb7d..4a0bf44b3a545 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2662,6 +2662,13 @@ bool f2fs_should_update_outplace(struct inode *inode, struct f2fs_io_info *fio)
 		return true;
 	if (f2fs_is_atomic_file(inode))
 		return true;
+	/*
+	 * rewrite low ratio compress data w/ OPU mode to avoid fragmentation.
+	 * If IO comes from compressed write path and fallback to raw write,
+	 * force out-place to prevent metadata-data inconsistency.
+	 */
+	if (f2fs_compressed_file(inode))
+		return true;
 
 	/* swap file is migrating in aligned write mode */
 	if (is_inode_flag_set(inode, FI_ALIGNED_WRITE))
-- 
2.53.0



