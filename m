Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214853;
	b=15pB9HGbcXBM+GeqVEbhbGGidMJoGuFUz+TQBHzaYyevMpEKx3ffytSMqFB3RtBggItq
	 f6iIY/yHnr4Fuddpk+ODqMSF7RX+CF7wuGyUNvn0XxwCVTN5eDby06D2SktkVtcZgnZLL
	 2EIX2OsseQNJyK5kp1ZnJP9C+lPiVtd1PWDXhQEOAQqNNPc9rKy8TyOmxlW/Nj66tr2vl
	 twLn1yGxwblnmAm2u3dvi5FGqBC6b9ANiXi8LmXe3aS0LpbVy9fx7LjwWl6iZWB/MfWlj
	 GVIE/pIDgslU1IL02sS0tP7581dQ7kAMQRwNWvZ0/YR43zxgb/M7qZ8eldBacwt2MQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xB5ljG/hCC6H/2Ax4F+e7RTBhitzZVjEtV1+USqQRrY=;
	b=che+XjtkM3xa84Pl/HGqAMZKLm+NheCAolivWeb7fd0dUf32re6DxiNn1RrrTHdWjdF4
	 ZXNPFYN/xHKRQsBniyjZs10kSYPZtUdx4i4Ma6vDW8UHwnkyeQpqjF6tEVcTZUmEHnTGF
	 yJx8QsPmK/vUBZExzmGrLRD3Dk0fVXaur/oUJe/325Pr/IPUm6XL+ngyvxg2fipXTwesx
	 CZ34QJzSq4cW1uPOIWbxh3tcwLOY7Aw/JECvQZaRQ1ug4Yzr8VGYbbF1ogLYBqZPHfE9z
	 NOnpYIjakv6/wOxubtscgeF9uYkV5fMO0ZNub17i8uzi2Ke3uYtXoo/KwoOwtxLwqtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MaGq+7kD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF97F606A321;
	Wed, 28 Oct 2026 19:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MaGq+7kD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5851F01825;
	Wed, 28 Oct 2026 19:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214852;
	bh=xB5ljG/hCC6H/2Ax4F+e7RTBhitzZVjEtV1+USqQRrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MaGq+7kDVGtMYcRVFZudf52BS+jjjl0JTtzd+WQzjtks/oFMATrRL08CxFY+leP/D
	 FZIdeYQ7JsxV7hYCVREw+Uvu4GDeQTfP5h3ai/sH21iQStXPmFp2WFB6xlGbgI5VeI
	 vvaYrkvoDhpw1PtJzggmSVrh9k4Xohrv5woV6Mjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1006/1887] btrfs: do not ASSERT() when the fs flips RO inside btrfs_repair_io_failure()
Date: Wed, 28 Oct 2026 17:51:42 +0100
Message-ID: <20261028170522.306914171@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 8ceaad6cd6e7fa5f73b0b2796a2e85d75d37e9f3 ]

[BUG]
There is a bug report that when btrfs hits ENOSPC error in a critical
path, btrfs flips RO (this part is expected, although the ENOSPC bug
still needs to be addressed).

The problem is after the RO flip, if there is a read repair pending, we
can hit the ASSERT() inside btrfs_repair_io_failure() like the following:

  BTRFS info (device vdc): relocating block group 30408704 flags metadata|raid1
  ------------[ cut here ]------------
  BTRFS: Transaction aborted (error -28)
  WARNING: fs/btrfs/extent-tree.c:3235 at __btrfs_free_extent.isra.0+0x453/0xfd0, CPU#1: btrfs/383844
  Modules linked in: kvm_intel kvm irqbypass
  [...]
  ---[ end trace 0000000000000000 ]---
  BTRFS info (device vdc state EA): 2 enospc errors during balance
  BTRFS info (device vdc state EA): balance: ended with status: -30
  BTRFS error (device vdc state EA): parent transid verify failed on logical 30556160 mirror 2 wanted 8 found 6
  BTRFS error (device vdc state EA): bdev /dev/nvme0n1 errs: wr 0, rd 0, flush 0, corrupt 10, gen 0
  [...]
  assertion failed: !(fs_info->sb->s_flags & SB_RDONLY) :: 0, in fs/btrfs/bio.c:938
  ------------[ cut here ]------------
  assertion failed: !(fs_info->sb->s_flags & SB_RDONLY) :: 0, in fs/btrfs/bio.c:938
  kernel BUG at fs/btrfs/bio.c:938!
  Oops: invalid opcode: 0000 [#1] SMP NOPTI
  CPU: 0 UID: 0 PID: 868 Comm: kworker/u8:13 Tainted: G        W        N  6.19.0-rc6+ #4788 PREEMPT(full)
  Tainted: [W]=WARN, [N]=TEST
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
  Workqueue: btrfs-endio simple_end_io_work
  RIP: 0010:btrfs_repair_io_failure.cold+0xb2/0x120
  RSP: 0000:ffffc90001d2bcf0 EFLAGS: 00010246
  RAX: 0000000000000051 RBX: 0000000000001000 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: ffffffff8305cf42 RDI: 00000000ffffffff
  RBP: 0000000000000002 R08: 00000000fffeffff R09: ffffffff837fa988
  R10: ffffffff8327a9e0 R11: 6f69747265737361 R12: ffff88813018d310
  R13: ffff888168b8a000 R14: ffffc90001d2bd90 R15: ffff88810a169000
  FS:  0000000000000000(0000) GS:ffff8885e752c000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  ------------[ cut here ]------------

[CAUSE]
The cause of -ENOSPC error during the test case btrfs/124 is still
unknown, although it's known that we still have cases where metadata can
be over-committed but can not be fulfilled correctly, thus if we hit
such ENOSPC error inside a critical path, we have no choice but abort
the current transaction.

This will mark the fs read-only.

The problem is inside the btrfs_repair_io_failure() path that we require
the fs not to be mount read-only. This is normally fine, but if we are
doing a read-repair meanwhile the fs flips RO due to a critical error,
we can enter btrfs_repair_io_failure() with super block set to
read-only, thus triggering the above crash.

[FIX]
Just replace the ASSERT() with a proper return if the fs is already
read-only.

Reported-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/linux-btrfs/20260126045555.GB31641@lst.de/
Tested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1427c42007300..428cfb0f9f6de 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -557,9 +557,15 @@ static int repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
 	struct btrfs_io_context *bioc = NULL;
 	int ret = 0;
 
-	ASSERT(!(fs_info->sb->s_flags & SB_RDONLY));
 	BUG_ON(!mirror_num);
 
+	/*
+	 * The fs either mounted RO or hit critical errors, no need
+	 * to continue repairing.
+	 */
+	if (unlikely(sb_rdonly(fs_info->sb)))
+		return 0;
+
 	if (btrfs_repair_one_zone(fs_info, logical))
 		return 0;
 
-- 
2.53.0



