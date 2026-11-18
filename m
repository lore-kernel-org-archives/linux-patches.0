Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019881;
	b=5YwRu8JBAXpVBPI1JP3/qTpOF+GZ1cSNiSp3+QLv+YNjT6ZgbEbu3c/gqzETKDh6Qdju
	 LA1pDAtLykpW+LhJBaubKS2MM2gEHTgc32i8N9gPFi2kLIa32nKDlRq2Ogfe2hGa/oHFz
	 bkdjULipvPZkdZrsUkdVxb2ZoaYTnTW7O8zctAXf6iSDppl9MtMe99c0E7ljNwBDSfU+4
	 n8LMim7udMSAoas/kkwNQGl77LvzaADNqpIXXbb9nOwTYN4hDGa+NixHgKNxYRyGs48Yy
	 kbOzm5tPUf5YhdF+tI+NxzmFrCa0zZ5PbtoQSilKJ4PQdORA3wZ4LtOrjusVVpqt2Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I9GEAQqXY6bSSTJSV56fr8ey3rFUp7h65R4OjBO5iGI=;
	b=cYVhyXJhhBruRqvnuzvWo8PdGg3tPvQ542oIc2qpfw5S1+h0GVIp/mOFc4v3G01QzZgv
	 /r1kTdEJhpCtfLFB3egmEqhisanXUgT42hz3Atl3CS8at86qgPApKL8bfIHjX50geaDJc
	 C0qCYp1EbfNdnyVRtAxYQ5YSSNjesoQFmvkWCTJadJJrl+15BfgYeNN6m9aeeKjLDbguk
	 yvmA5EAtMvF7WCay/RsdpuvoTbjy/z4xz63SS/7ozC3titg4qGHMdyfJwQL6BsD137971
	 SoXFtU7VUXj+Y8vCdgaOMFoR9JTljbEEwc53KaCA+Fis2fwlujbNkvBXwduzN++X+9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=giSbJdhN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3437B606A31C;
	Wed, 18 Nov 2026 16:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=giSbJdhN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B34D1F000C4;
	Wed, 18 Nov 2026 16:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019880;
	bh=I9GEAQqXY6bSSTJSV56fr8ey3rFUp7h65R4OjBO5iGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=giSbJdhNR/N8SjhgzrZuWeSnR013q60D2wlfqxWcNSRz4zl8Oerqlrc/Qxw14Oomr
	 kflFTzzXj5Bhs4Y2GLD7oesYYDzhI/pCOksYqwyFtJn25lzNh5AGHR8567TvN0nBof
	 5fplcWMUkQf00aVyC7OEklHbCdBXNCp4N0pGI188=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Christoph Hellwig <hch@lst.de>,
	Pankaj Raghav <p.raghav@samsung.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1754/2651] iomap: follow the alignment requirement for iomap_dio_hole_iter()
Date: Wed, 18 Nov 2026 15:49:54 +0100
Message-ID: <20261118150350.633541138@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 4025185cf953e3f52ab63cf5fec50c1485ee7bb7 ]

[BUG]
On the latest development branch, btrfs with 8K block size on 4K page
sized systems will fail all test cases that run fsstress.

One very short example would be:

 # $fsstress -n 4 -d $mnt -s 1785675805 -v
 0/0: dwrite - no filename
 0/1: creat f0 x:0 0 0
 0/1: creat add id=0,parent=-1
 0/2: write dontcache f0[259 1 0 0 0 0] [816411,3620] 0
 0/3: dread - xfsctl(XFS_IOC_DIOINFO) f0[259 1 0 0 32 820031] return 25, fallback to stat()
 0/3: dread f0[259 1 0 0 32 820031] [483328,81920] 0

Which triggered the following ASSERT():

 assertion failed: IS_ALIGNED(state->start, blocksize) && IS_ALIGNED(state->end + 1, blocksize), in fs/btrfs/extent-io-tree.c:346 (unaligned extent state, blocksize=8192 start=487424 end=565247 state=0x0)
 ------------[ cut here ]------------
 kernel BUG at fs/btrfs/extent-io-tree.c:346!
 Oops: invalid opcode: 0000 [#1] SMP
 CPU: 4 UID: 0 PID: 648 Comm: fsstress Tainted: G            E       7.2.0-rc5-custom+ #431 PREEMPT(full)  7c507bd40d65e4d871e698b22d80f1306bbec543
 Tainted: [E]=UNSIGNED_MODULE
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
 RIP: 0010:validate_extent_state.part.0.isra.0.cold+0x24/0x26 [btrfs]
 Call Trace:
  <TASK>
  insert_state+0x34/0x1a0 [btrfs 6924944583e4bc91a7c5183a1e7908e745a9b0c8]
  set_extent_bit+0x440/0x8d0 [btrfs 6924944583e4bc91a7c5183a1e7908e745a9b0c8]
  btrfs_lock_extent_bits+0x58/0x380 [btrfs 6924944583e4bc91a7c5183a1e7908e745a9b0c8]
  btrfs_dio_iomap_begin+0x319/0xb70 [btrfs 6924944583e4bc91a7c5183a1e7908e745a9b0c8]
  iomap_iter+0x1a2/0x370
  __iomap_dio_rw+0x236/0x8d0
  iomap_dio_rw+0x12/0x30
  btrfs_direct_read+0x15f/0x290 [btrfs 6924944583e4bc91a7c5183a1e7908e745a9b0c8]
  btrfs_file_read_iter+0x42/0x90 [btrfs 6924944583e4bc91a7c5183a1e7908e745a9b0c8]
  vfs_read+0x25e/0x380
  ksys_read+0x73/0xe0
  do_syscall_64+0xe1/0x790
  entry_SYSCALL_64_after_hwframe+0x4b/0x53
 RIP: 0033:0x7fc3f129318e
  </TASK>

[CAUSE]
iomap_dio_hole_iter() is responsible for zeroing out the buffer for a
hole, which calls iov_iter_zero() to zero the range.

However btrfs disables page fault during its __iomap_dio_rw() call, so
iov_iter_zero() can fail at any page boundary.

When the fs block size is larger than page size, iov_iter_zero() may
only have zeroed one page, which is not aligned to the fs block size.

Such one page long range is passed back to btrfs, which triggers the
above ASSERT().

[FIX]
For iomap_dio_hole_iter() round down the copied length, and revert
any excessive range that is beyond the aligned copied length.
Also use @aligned_copied for the size increment and iter advancement.

This should only affect btrfs, which is the only fs utilizing iomap dio
with page fault disabled.

Fixes: 001397f5ef49 ("iomap: add IOMAP_DIO_FSBLOCK_ALIGNED flag")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Link: https://patch.msgid.link/73bd4d9b39e821453028ca8e567eaad2ebe0fc18.1785880740.git.wqu@suse.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/direct-io.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 7f1e85f95a469..9ad1a984d09e2 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -589,12 +589,19 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 
 static int iomap_dio_hole_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 {
-	loff_t length = iov_iter_zero(iomap_length(iter), dio->submit.iter);
+	loff_t copied = iov_iter_zero(iomap_length(iter), dio->submit.iter);
+	unsigned int bs = i_blocksize(iter->inode);
+	loff_t aligned_copied = round_down(copied, bs);
 
-	dio->size += length;
-	if (!length)
+	/*
+	 * If fs block size is larger than page size, page fault failure
+	 * can cause @copied to be page aligned but not fs block aligned.
+	 */
+	iov_iter_revert(dio->submit.iter, copied - aligned_copied);
+	dio->size += aligned_copied;
+	if (!aligned_copied)
 		return -EFAULT;
-	return iomap_iter_advance(iter, length);
+	return iomap_iter_advance(iter, aligned_copied);
 }
 
 static int iomap_dio_inline_iter(struct iomap_iter *iomi, struct iomap_dio *dio)
-- 
2.53.0



