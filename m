Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058186;
	b=seGfhd/MQNy5XsJYkosp/K/1HsCi/AVm/Q1RBikpXKi+xtJDiEiOxY2MmjoCbN3NfD5w
	 KzgtfiNn+g93j3hyTwGVxU8JttaD7A+LI1ne0YEG8UBqshWhs7XIditSIg5gY46hwfbJo
	 CxZq7VZFmhKJRT1GbCmPQmsrW0eBVofSjveKu0r6mwRyvhRrnSdHnXrNiLolKFJmn5t1Q
	 gfnP6AfKK288kuXV9G0tTtPfULjPtXUm0G+vIPrQ0QWcuH2SIxEegDCTjr3vUywplodZ8
	 GseQcchymQnwnTtlVPy3AXzqG85vEMGEmrzSbo5XT+nIpp90X1l07I7VviNChbnOu/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ss5cPXmsjHaxKaS72PmjsF19yQlHKFF4Io2O++hLnfs=;
	b=0cXQ5MWf4mDCembrlb0wSwbh2Chhu8GFHr/9sK+X9neI3riKS2o0QR2LtNTuBY/8Y1Xr
	 tO+9nvh+kv+Z/V9sQ12ZgMFKAYMmvdhPPnaH0d+4hDJ+k+TlToPsGgbP+/0x5+qMEvZwu
	 BDd2Rfnwsb9PAPUwafZtLr890tEAUnIw4K0CqaNiwgNVYtZ0+MaE2ZNojY3rxcsz8ND+t
	 p/f0zynsNmdXmKLzun4n5ZjRnKB9UrmTnQLcC7ZU3EAldYZeftXVxinjG73JrENwR5MNB
	 GDWsyoLPnCRXvbshXbq5pNLATzQNt8FYyf3/z2C0+hSf3p2MdKbg3PkPySO/+xdSuoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1Zy4JiU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58127606A326;
	Thu, 19 Nov 2026 03:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1Zy4JiU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B941F000C4;
	Thu, 19 Nov 2026 03:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058186;
	bh=Ss5cPXmsjHaxKaS72PmjsF19yQlHKFF4Io2O++hLnfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m1Zy4JiUTFH1Z+wYpqAfuIvcDnta0d4449pi8Cuwx+0xnvfiqMv5a9L0vJIyzzTPp
	 5WXfv5GVW/4OXBhdTcJtnbAFzFBWjuSrt8P3kfjCGOpJc/DJHj5cTIfhGytGw4gB7u
	 OSqdKh2jUr6eHEO57chJ2s2w2vwX6lLN7dwExGaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0394/1848] f2fs: compress: fix to handle race between truncate and writeback
Date: Wed, 18 Nov 2026 15:40:32 +0100
Message-ID: <20261118145930.278448622@linuxfoundation.org>
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
index 8dccb59d072b7..e5ef1dbbc6625 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1089,6 +1089,7 @@ int f2fs_truncate_partial_cluster(struct inode *inode, u64 from, bool lock)
 							log_cluster_size;
 	int err;
 
+repeat:
 	err = f2fs_is_compressed_cluster(inode, start_idx);
 	if (err < 0)
 		return err;
@@ -1100,12 +1101,11 @@ int f2fs_truncate_partial_cluster(struct inode *inode, u64 from, bool lock)
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



