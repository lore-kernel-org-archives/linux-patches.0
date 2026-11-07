Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061991;
	b=IE8607HoxqzelsBuvTTbK0xVNZMyTmhyR6zRbiZ0Esp2qWst4POAh7LWUPmayLUa5lI4
	 xjHFX/oV4ENGYYZmQXYdQnHioXbQNMz7oIXaoK6OU/Kp8iTgaYYk4daGxby6HIo0s/jAW
	 pgIZRjxq2yexkpnSFuTTONUBi9yMs7grWNe6vKhO52EyOvd2gzFDdb+aN4Vs3FEtSVH8U
	 vxZbCIUtP2lvdnskUFpSROQQ0G6g9qE3FRbq2cWkkuhla71t2B1GeF3kOC9QvNr3kzf2L
	 57rE429ToUFuzZwodjrcrfmqvgUGWZLhuxpt+PD1pZJuC2GBQuTuAa3/Lwc9ZLxCFdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+el2guYJT4k5QXNAZQV2IwmsZ5QC8D7iXdl4jUZTqd0=;
	b=2VKbjNGkAfH8T6fQHIo6e5otNR91b598JzFPln8aKet5Vdeh62p/p/M7Ic1xQzKE5hrm
	 RNU2AQQoJgE6TVuuBZAu9zZuUnm7n+U/pqfkF7e4gsluhi5Jqc7f2frG4+9ypHAUNlahq
	 sZg4xKXFsYqjtrk2hmuEBFmoT+YdrwJodIyjTa3Md6a66R2vs/ZAyrPSldOYX5a1adtsb
	 cme5q2uG/Mo8uzk5VUyXUU4KrZgu33l5BXXF8vgOQR+UjH+qbMVwL0uGHV7d+xH2yanl5
	 RavmgoJ45lnGkPSifbLLKEBFiMpiWr4zlRE61d/B0YEN/ltljZtrCPuLJ/gICZD1yrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cl2LMFBn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7527C606A32E;
	Sat,  7 Nov 2026 14:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cl2LMFBn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C811F0089F;
	Sat,  7 Nov 2026 14:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061991;
	bh=+el2guYJT4k5QXNAZQV2IwmsZ5QC8D7iXdl4jUZTqd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cl2LMFBn/kv80FPFaQk8/lTc3Fym4MwapG7spmS0JVb+rK4SH4H72wP8cs45X2ULZ
	 V5Zz9oA6/yIJQlh9zIWNM245OmbX3hho12m/TXNsWfJAXqx3NgvurqJv31MYwN2iug
	 +VlzYMHAldrkw7dKB3A961lM4MaVYyBd/UcbCFHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jiucheng Xu <jiucheng.xu@amlogic.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0982/1536] f2fs: force out-place update for all writes on compressed file
Date: Sat,  7 Nov 2026 08:49:58 -0500
Message-ID: <20261107135025.234466363@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiucheng Xu <jiucheng.xu@amlogic.com>

[ Upstream commit a64a3fec11e77a3a0dc0009bdc58b925e45a1bb4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 4bbaae47b184e..3bf6820130010 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2669,10 +2669,12 @@ bool f2fs_should_update_outplace(struct inode *inode, struct f2fs_io_info *fio)
 		return true;
 	if (f2fs_used_in_atomic_write(inode))
 		return true;
-	/* rewrite low ratio compress data w/ OPU mode to avoid fragmentation */
-	if (f2fs_compressed_file(inode) &&
-		F2FS_OPTION(sbi).compress_mode == COMPR_MODE_USER &&
-		is_inode_flag_set(inode, FI_ENABLE_COMPRESS))
+	/*
+	 * rewrite low ratio compress data w/ OPU mode to avoid fragmentation.
+	 * If IO comes from compressed write path and fallback to raw write,
+	 * force out‑place to prevent metadata‑data inconsistency.
+	 */
+	if (f2fs_compressed_file(inode))
 		return true;
 
 	/* swap file is migrating in aligned write mode */
-- 
2.53.0



