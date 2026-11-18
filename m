Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045005;
	b=iKblTvfqL7amn06kRRl1LXh8Jcyw/4ARSvDJrcVzXyak1xMANGpuoQh0q1gTCZn5Z45o
	 hmEI1ZKVT3ByZ7vcQBIYAQ8FBRySLpaTioP16rke79mWnc4iZzhp9OrU0IUg4EJqRm06W
	 u656/gOeSR/HMBGivpL3UZkK0XpGyy3Tn7a4xm23DkNrFNiUsCAznuSaetXqpWI8/4QA0
	 L2gXd/oB6snpuajHfb+KoJaJajxRlnMyMDevq93nEAsClSn63RjEGta2RX9wct77E8HEi
	 djgCXy4I6vOTjOcF/yX6i29CUB6eKhMWiCGhASMdrucYv5VQ7UyErgH8UW7cCOwJx+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045005;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aw6h4TQlqFUXKD5Hu+Tp+dbS2QcNfdXJD/HBi56JT/c=;
	b=KulXPavxKWt4nOXYlGNn0CuWaVTjeapZ4c4mnHy+fc2BjfHaJMXwGtPcBLoOcV7VygKQ
	 vgqGitoduqzA2Zab5kUdRZS/Yvh/lrYS+CDf4TokMYpjlIICCc9LB3NtbUeyRyCva1y4z
	 rEfWZuM5sA3Cq+qkJ1M+/Bk4VgxmgBNfH2hASeL4WSpI4kLbzFP2LibSc/TPnLYHjlv9A
	 kKDyFdjyqygypukqWAl1buOsponB1M7EMjOKktnBeSnZ2a0pFyBk5MNnR8KGWfaVdQ73J
	 vSwXtyScNZYYYYHbUE/jmCuK/X2rqQ6qtLrwzfYhCdfRw2Hjsfwffk5HPvGWtcL5igA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fL+1xroQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDA2606A330;
	Wed, 18 Nov 2026 23:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fL+1xroQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FDA1F000C4;
	Wed, 18 Nov 2026 23:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045004;
	bh=aw6h4TQlqFUXKD5Hu+Tp+dbS2QcNfdXJD/HBi56JT/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fL+1xroQOUtMzOSdvgImhggX90b300Mjx/Lo6u+srH+LyeLYfwPElA5YTpSPFAzFy
	 2IYzbLpXKZ8kcB9Zv8kv0E+5dVZbdp7sl8PomjjaOftI4Gwot/iWXIRsbhCxONvHK4
	 9xwz/QClmKvXbZeGzyBQeOS+ZDuhU6Jbfr3koJmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0768/2857] f2fs: compress: fix to handle race between truncate and writeback
Date: Wed, 18 Nov 2026 15:30:02 +0100
Message-ID: <20261118150229.211191942@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit c0337e331b065074ce20e4258a578e07dd7e4083 ]

fsstress reports a kernel BUG in f2fs_truncate_partial_cluster():

kernel BUG at fs/f2fs/compress.c:1238!
RIP: 0010:f2fs_truncate_partial_cluster+0x292/0x2a0
Call Trace:
 <TASK>
 f2fs_truncate+0xf6/0x210
 f2fs_setattr+0x6b7/0x770
 notify_change+0x33b/0x520
 do_truncate+0xc2/0xf0
 vfs_truncate+0x153/0x1d0
 ksys_truncate+0x78/0xd0
 __x64_sys_truncate+0x16/0x20
 do_syscall_64+0xbe/0x540

The root cause is that Thread A (truncate) and Thread B (background
writeback or fsync) can race as follows:

Thread A                             Thread B
- f2fs_setattr
 - f2fs_truncate
  - f2fs_truncate_blocks
   - f2fs_truncate_partial_cluster
    - f2fs_is_compressed_cluster
      return 1
                                     - f2fs_write_cache_pages
                                      - f2fs_write_multi_pages
                                       - f2fs_write_raw_pages
                                        - f2fs_write_single_data_page
                                          dn.data_blkaddr != COMPRESS_ADDR
                                          (cluster converted to normal)
    - f2fs_prepare_compress_overwrite
     - f2fs_is_compressed_cluster
       return 0
     - return 0
    - f2fs_bug_on(sbi, err == 0): BUG!

Writeback path does not acquire i_gc_rwsem or filemap_invalidate_lock.
When a compressed cluster fails compression during writeback, it is
overwritten with raw data blocks. If Thread A checked
f2fs_is_compressed_cluster() before the conversion, but calls
f2fs_prepare_compress_overwrite() after the conversion,
f2fs_prepare_compress_overwrite() returns 0 because the cluster is no
longer a compressed cluster.

To fix this, remove the f2fs_bug_on() and retry checking the cluster status
when f2fs_prepare_compress_overwrite() returns 0, so that it can fall back
to f2fs_do_truncate_blocks() to handle it as a normal cluster.

Cc: stable@kernel.org
Fixes: 3265d3db1f16 ("f2fs: support partial truncation on compressed inode")
Reviewed-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 37a684c682c7b..7baefaf13e144 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1191,6 +1191,7 @@ int f2fs_truncate_partial_cluster(struct inode *inode, u64 from, bool lock)
 							log_cluster_size;
 	int err;
 
+repeat:
 	err = f2fs_is_compressed_cluster(inode, start_idx);
 	if (err < 0)
 		return err;
@@ -1202,12 +1203,11 @@ int f2fs_truncate_partial_cluster(struct inode *inode, u64 from, bool lock)
 	/* truncate compressed cluster */
 	err = f2fs_prepare_compress_overwrite(inode, &pagep,
 						start_idx, &fsdata);
-
-	/* should not be a normal cluster */
-	f2fs_bug_on(F2FS_I_SB(inode), err == 0);
-
-	if (err <= 0)
+	if (err < 0)
 		return err;
+	else if (err == 0)
+		/* the cluster became non-compressed one due to race case */
+		goto repeat;
 
 	if (err > 0) {
 		struct page **rpages = fsdata;
-- 
2.53.0



