Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626038;
	b=F5nbAjYCG2x+BURjrAGZR1+Ie7xqiPpMRo8/x0BWDe8kvnfsusm8h8bZilr7rbFKHXLL
	 UtJ2Qgp93ZkiTq4QjVf8aEBRh2DvasacNElqdmXEioyfZwlg24IS+hrBLqrALhsxthHCg
	 YncfezKBtL1RTJQ3HptjPF+IMdkiFy25j3XiLQQHbKzbYeO7iU4uppcU0zXz6HucmPMvj
	 vxx3ZIkxlrJtet3y9Y/lSNsPiCCnKZRasAsIPN9+7C02BR2oizkIVcxnB23M7q1Rr+MVu
	 OAjpIr0WiELMY64qFEa1Xjcn6kSSNQOthGmljunp98fj/PYZzwsRSYl9PdOul1Ds3pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ebBscPcUNCsJWPAT6wrur9xtpCc1XkdIpFJdCy7sUtY=;
	b=ZKWaElPGzf1dhJnk3QL7n7cqOG9cW18ZgfdnUuXVHzgCuBBqTe10uNDoFRDYyfJcr9F9
	 XqaP6I+aoTO2ozgwrpJe2N4dXPFSCZivNuFp8sR0a89YFHfsLZ//VuYjqReAa0UnbL1Hj
	 iuuw5Vzsgfrd3f7RZOvY4W0eG/DPY+zJIB1x5pHd1ULIxlaEtRsJQCZwSSuk35mclx745
	 5v695wjo5Zn3IQT96tZdSFENiilkNMGYVMVe4jxF40P7rAyjGLPnn3M/IoTRwIzfMY9Bv
	 rw8wO6cOo5KqFEmVue/A9e2QbhyrJhrM2cGp3GR/L7mM0FakJgZ/G2pXxTpzJ4JlN6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IFG9VhKi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52A0606A326;
	Wed, 25 Nov 2026 17:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IFG9VhKi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0857B1F000C6;
	Wed, 25 Nov 2026 17:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626037;
	bh=ebBscPcUNCsJWPAT6wrur9xtpCc1XkdIpFJdCy7sUtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IFG9VhKihwDpUPB6WILv5qpFf+jIkwrqbLz4VxMhcS1viBDFmfDsm/DCmDrREI7LH
	 k5Rl5qO4tbXbasIo5hn+73oqnCZIYLN8ZLGeapLNnB//YCeeFfuvnAQlhzF7c5u1+X
	 IsF2dUwf4R1cCBY/fsZkTaCx+gC021ds7WCZ96CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1288484b13bf6af3620d@syzkaller.appspotmail.com,
	wuyuehong <wuyuehong@cmss.chinamobile.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 704/816] dm snapshot: fix discard_granularity unit in snapshot_io_hints
Date: Wed, 25 Nov 2026 15:37:32 +0100
Message-ID: <20261125143905.475140301@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wuyuehong <wuyuehong@cmss.chinamobile.com>

commit d7216d7be2bbfdf3312695b6e41a4fc7c5e22902 upstream.

snapshot_io_hints() copies the snapshot store's chunk_size, which is
in 512-byte sectors, into queue_limits.discard_granularity, which, like
all other members of struct queue_limits, is in bytes.

For snapshots with a chunk size smaller than 512 sectors, e.g. the
16 KiB (32-sector) chunks created by the syzkaller reproducer, the
resulting granularity is smaller than a single sector.  When
dm_calculate_queue_limits() then stacks the target limits into the
table limits:

	blk_stack_limits(limits, &ti_limits, 0)

queue_limit_discard_alignment() truncates that granularity to zero
sectors and sector_div() divides by zero:

  Oops: divide error: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:queue_limit_discard_alignment block/blk-settings.c:645 [inline]
  RIP: 0010:blk_stack_limits+0x1105/0x2d00 block/blk-settings.c:916
  Call Trace:
   dm_calculate_queue_limits+0x70c/0x1510 drivers/md/dm-table.c:1823
   dm_setup_md_queue+0x199/0x4f0 drivers/md/dm.c:2618
   table_load+0x4fd/0x8a0 drivers/md/dm-ioctl.c:1661

The divide fault itself only became reachable when commit e924da7d6622
("block: Drop granularity check in queue_limit_discard_alignment()")
removed the check for a sub-sector granularity in v6.13.  Kernels
before that returned a zero discard alignment instead of faulting, but
they still advertised a granularity 512 times too small.

Use the same chunk_size << SECTOR_SHIFT conversion that
io_overlaps_chunk() already applies to turn chunk_size into bytes.

Fixes: 2e6023850e17 ("dm snapshot: add optional discard support features")
Reported-by: syzbot+1288484b13bf6af3620d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1288484b13bf6af3620d
Cc: stable@vger.kernel.org
Signed-off-by: wuyuehong <wuyuehong@cmss.chinamobile.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-snap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2420,7 +2420,7 @@ static void snapshot_io_hints(struct dm_
 			snap = snap_src;
 
 		/* All discards are split on chunk_size boundary */
-		limits->discard_granularity = snap->store->chunk_size;
+		limits->discard_granularity = snap->store->chunk_size << SECTOR_SHIFT;
 		limits->max_hw_discard_sectors = snap->store->chunk_size;
 
 		up_read(&_origins_lock);


