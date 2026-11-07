Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065114;
	b=iAOeTttHqBTVGeAzCmmBZ/MHR9y4oj1sK8xnr4Ulp2r0FF3n031gHcZO526zwKANFJGy
	 ++3DRVUKgvOg3behsAyGF0fWl52QHuXq4UyYYMCEvD/pb7HCBWzqLNlLrPi+Sc0fhv0Av
	 jpiWMNgbDEySG7KECcnb85RpuVdy49eVrDpsu53csvycfwFNiVyOXWjbVZGd/FsXHkfdu
	 fiqPHKBu60afqaCzrKLA42uNyg0z6pduFHNgnWq86g+WdSua0Lq6hQK3b1LHpKU/eeygf
	 8wuqffXDDojlzrUSfDe0TENJx/27EMrGrjbQMFTlhAZ0lM53WaldEFG/N+FhLePNgtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=36JCE9YV5xJ0PXSgPd0oOVRPjCw0V3FyoEKI7pf4RgI=;
	b=1iBHFzeGeJTG2IGhk+wt+va9uCvwsyd8Efa/kzJuLW5q/pmX4U+zoUnpjytM7kMATBS1
	 S/GnddUVuaMf3KVB0OLIXX2ykv2y3HcrhkbLVHhORd6GdFQzcEgmGFGUjTfuXln/xAV4B
	 smYb+cYLg81mKVR+aeqVgnjMU+F3NDKVsx5PWpwJ2VboLoQs/MiZgqQzu9A9SzAvQjmBL
	 +j/KsAVRSDGAoGBPF6svyo45fAbYZT+gXkLEIa4I61dsFtbhRXanc9r8qzD1bFVtfZEOj
	 iNoLHPBvQn0YGwOye6HAQNERs3SqU6+VvCtIxIhyGag1cdbSiXREXZcfGq8BUIan9UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l03HkA0U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36083606A32F;
	Sat,  7 Nov 2026 15:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l03HkA0U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C471F0089F;
	Sat,  7 Nov 2026 15:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065114;
	bh=36JCE9YV5xJ0PXSgPd0oOVRPjCw0V3FyoEKI7pf4RgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l03HkA0U4Jf/wuIEZ+K6D8rjVZLD/OuTvBhnec7TkAm78QgFK3CGRVvvYXuYu4G+a
	 sTh1LCDRR2F8VE/Yzp+GEV4qMVoaD9OsBH/E18OHzW05TGUb59mIhzAlT4JqkYVbD9
	 9oGD/48Cv5WNqYqC4d3qzZXMn8NXm9vNoiVi7vOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0940/1257] ntfs: flush the block device when syncing a directory
Date: Sat,  7 Nov 2026 08:53:56 -0500
Message-ID: <20261107135005.316693172@linuxfoundation.org>
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

From: DaeMyung Kang <charsyam@gmail.com>

[ Upstream commit 569f514f0ec74c4162241e10b7893bff109f8aca ]

ntfs_dir_fsync() writes directory metadata and calls sync_blockdev(),
but does not flush the block device write cache. A successful fsync()
can therefore leave the directory's metadata in a volatile device cache.

Issue a cache flush after successful writeback and return any flush error.
This matches the regular-file fsync and syncfs paths.

With QEMU blkdebug injecting -EIO for flush_to_disk, fsync() on an NTFS
directory returned 0 before this change while syncfs() returned -EIO.
After this change, both return -EIO. A kretprobe confirmed the flush
error in the directory fsync path.

Fixes: 1e9ea7e04472 ("Revert "fs: Remove NTFS classic"")
Cc: stable@vger.kernel.org
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ntfs/dir.c b/fs/ntfs/dir.c
index df60138f9b2d3..09b890b41c4a9 100644
--- a/fs/ntfs/dir.c
+++ b/fs/ntfs/dir.c
@@ -1182,6 +1182,8 @@ static int ntfs_dir_fsync(struct file *filp, loff_t start, loff_t end,
 	err = sync_blockdev(vi->i_sb->s_bdev);
 	if (unlikely(err && !ret))
 		ret = err;
+	if (!ret)
+		ret = blkdev_issue_flush(vi->i_sb->s_bdev);
 	if (likely(!ret))
 		ntfs_debug("Done.");
 	else
-- 
2.53.0



