Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065183;
	b=GWlJblyfOKg3E+uLQZnj1VEYF/zSW0XHIaYGAnuBhk4fvNBYUUW/03P3Bd6jhFOR8Srs
	 V2qs72Y5V8tn5UZ0ABHwzlXhDD57Z4xyZxOghrKhaLCeqOHP3oFstYr1c6ngO5xOb7FpN
	 wat5DdzJAmYIQpm42MCZzXj9IJN5txf2fyuFxDN+Cbg0rdnQDdNzvzJgNtoNrlIAIYjv4
	 FTQ8QKjeamlsm3pe59DMHNpk1uKle+SRyBTWZt2rSLcabV+qrt3Jbu5G+3y3ZxTm7TIs+
	 NB44M2IY/dbHrzht4kZ/vojB5ks1jCWkp5v50Db1r0JZMYyP679wzmujlpY2Y2GG5iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2dx9471HhKEVi0TrX9Q0bSHhMOeMqrhpkv/PqAthfkA=;
	b=Bhv3eOAwE+f2LKcRDA/ysAGN8aUKSndlH8rsI+xRSuF5Km4d2OXKxGIbmmYK4ukjfOol
	 j0wDxhORsVRcNjb4R1j9/s/ztEDygObo+W1xJ8+39pJ20+KhORa0zuxP8wIIrTxfDjXn4
	 wr/WP7qRtGhNp9oRvAA/H8sHqK2kwxniSYrT/z++hckkPTSBjcKgE0FyiUIxvfXvdTA/P
	 T8QAWMktwBoZveCKhzyodi8FYZpnVjaayzDjmpdPfLM9WwGtDH720NxnJCf23MRy5PW9G
	 evPvz9ybzqaEwwhW6V+7jBeu79LM0dKaW3NBcldWrJETIt2pFDZUAQJ/3FuVU7Iv6/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FyJFoylD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC63606A32E;
	Sat,  7 Nov 2026 15:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FyJFoylD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EED1F0089F;
	Sat,  7 Nov 2026 15:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065182;
	bh=2dx9471HhKEVi0TrX9Q0bSHhMOeMqrhpkv/PqAthfkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FyJFoylDj6qMPZY77RSqVzBgg7cCxblgQP7nlahrXQ4xj0U7B+f9VGGjeEgcVtGy2
	 shoDWGmaIajrYU3IxF2Uf2YGl7Nv3j++XN6mblSPeh4AcwbDYUOEdcKAZNRmISCItM
	 1MpTXf6WxBPNy9rkz0xkTaw9UZjxyviiBx1Spa8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0987/1257] exfat: drain in-flight DIO before buffered writes
Date: Sat,  7 Nov 2026 08:54:43 -0500
Message-ID: <20261107135006.625749174@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit acea17f0f4c7742118375e96d3f876be34e449a5 ]

An asynchronous direct write can remain in flight after the inode lock is
released. If a buffered operation dirties page cache while the direct
write is still pending, the direct write's post-I/O invalidation can find
the dirty pages, report a page cache invalidation failure, and record -EIO
in the mapping error sequence. A later fsync() therefore returns -EIO.

Commit 15cdefd0c0522f9d5e12d947fa04f4c11649b699 ("ext4: drain
in-flight DIO before buffered write fallback") fixed the same race in
ext4. ExFAT does not drain in-flight DIO before a regular buffered write,
the buffered fallback after iomap_dio_rw() returns -ENOTBLK or a short
write, or the page-cache operations used to extend valid_size.

Wait for in-flight DIO before these paths can dirty page cache.

A reproducer using concurrent AIO direct writes and buffered fallback
triggered the following warning and made a subsequent fsync() return
-EIO:

  Page cache invalidation failure on direct I/O. Possible data corruption
  due to collision with buffered I/O!

Fixes: 867b9c96dc83 ("exfat: add iomap direct I/O support")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20260629113827.4074335-3-libaokun@linux.alibaba.com
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/file.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 89e2fdebcc2c1..d24f0650bfc88 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -706,6 +706,8 @@ static int exfat_extend_valid_size(struct inode *inode, loff_t new_valid_size)
 	int ret = 0;
 
 	if (old_valid_size < new_valid_size) {
+		inode_dio_wait(inode);
+
 		/* Do not re-zero blocks already covered by zeroed_size. */
 		loff_t gap_start = max(old_valid_size, exfat_get_zeroed_size(ei));
 
@@ -757,6 +759,8 @@ static ssize_t exfat_fallback_buffered_write(struct kiocb *iocb,
 
 	iocb->ki_flags &= ~IOCB_DIRECT;
 
+	inode_dio_wait(file_inode(iocb->ki_filp));
+
 	written = iomap_file_buffered_write(iocb, from, &exfat_write_iomap_ops,
 			NULL, NULL);
 	if (written < 0)
@@ -840,11 +844,17 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		pos = valid_size;
 	}
 
-	if (iocb->ki_flags & IOCB_DIRECT)
+	if (iocb->ki_flags & IOCB_DIRECT) {
 		ret = exfat_dio_write_iter(iocb, iter);
-	else
+	} else {
+		/*
+		 * Prevent concurrent direct I/O and buffered I/O to the same file
+		 * range. Wait for in-flight DIO to finish before dirtying pages.
+		 */
+		inode_dio_wait(inode);
 		ret = iomap_file_buffered_write(iocb, iter,
 				&exfat_write_iomap_ops, NULL, NULL);
+	}
 	if (ret < 0)
 		goto unlock;
 
-- 
2.53.0



