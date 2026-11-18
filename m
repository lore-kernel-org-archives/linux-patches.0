Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053533;
	b=UImm0edmnO2x/M5kSqsgl24RIUBRJRKmYRsfisYBLWe1iwXgXTXOYXW0/ojdbNRUnR66
	 jVN0/RfZaDvJnusQay18VFQZWhmhGmRB237b3NVYYmBnyqOKAETXGkVwArzbonEQEu041
	 rX/zVMSu0btVqJrNx3EGvvvvaKuVTm4tFJiN/ItSNNOIHTb1os1Ijgu5tOqlTGtCwp8Kr
	 5EXO5oenjGlmS4MVUSEL3RDR74pWJXDR1tCVFI6KcBw92S6eta0jn74PiFMy8VpKZWcyi
	 yYAiMskOV7le5YZeZ80++PhvLEOr0Kw3IN0qQyOG4jZaDnYm1hqos/yRJvxp3GlPqVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ps8clIOgGrPDinZtlTlAx42HR0MgPgJ3m/tfdd8/1h0=;
	b=j3b1dj/Mm4yF/CsltjtkjwgQkT80rGY6UNhnOvS2KU2jGuTJI2A1vUgCJ1T1TSb+HGjk
	 P8GlvT9BDD2uYUQcWHoXTvtLJc8bDtyeQKnHtM94kkgpGKDPwEwYPWpErpXooMUuvSyGL
	 91pWt2VvYY3eL382zgWUyej5cfi0DZRLxDuHysE0GpyVqHYOhfTTCpEZzXxB8Sp3q+VwX
	 Ka4r22XCT/pTB2UyZnNdA5ySZVAHHBftQkzzFn1sQgITU3yjWH8yyrkAmAqgvXyq4lBzK
	 uEf2BjUplXnZbcZiHevCVmQpujlFjW0FuBYV98vK2TaZfko+A44Y17rJUsXhMu+EVyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o4Ki0SN9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516DD606A320;
	Thu, 19 Nov 2026 01:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o4Ki0SN9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18071F000C4;
	Thu, 19 Nov 2026 01:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053533;
	bh=ps8clIOgGrPDinZtlTlAx42HR0MgPgJ3m/tfdd8/1h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o4Ki0SN93d47U/8cdIDOPnQpmHQfVEKeQPgqw5Lhs4FyTDWamoDZr+2PfDRnyrZJT
	 JiIfjrEvCdJxNWUa1wuvf/1J6T+pqGWl9Ftoq/kuiw4lbUFrCOxPkPfURwUbykYZnh
	 tWfvhhltxDmGMHeOoZ/0rXiyNtfMCjtO6GMiKHMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jiucheng Xu <jiucheng.xu@amlogic.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0953/2214] f2fs: force out-place update for all writes on compressed file
Date: Wed, 18 Nov 2026 15:43:49 +0100
Message-ID: <20261118150050.453383802@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 90cb8560af1d0..b8da6784e2c44 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2670,6 +2670,13 @@ bool f2fs_should_update_outplace(struct inode *inode, struct f2fs_io_info *fio)
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



