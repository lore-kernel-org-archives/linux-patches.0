Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620296;
	b=J2wq3AnuQF1pjkgF/UNtDui6La4I+8Bb59p5M7HuRktY+P4xMsq7RsbyL1idMOieymmI
	 kBCHncLhQZUOxT2wuoQQIL/UU7jjtC/JefcrAvwDEzGTEIEQ+zGYZ6WlpNnGKsBYM/+UJ
	 yhhWRJ1TVn93aVOWXscMmSrB9VbtWek8CCgEpuUtKOAikc3HYJa5CGX4ifbFgcnjWbsEM
	 p4DjuMMfQPfB8l6+OEOBtsKfwl0QyP+8bx+VimSL8+M5m1souBErRypMWdf9ifUFfNQjw
	 o1WqvunPVx/40BJ1faHbseG0Aqa5DJSM3FNho2OvJZqd9V8G4jtXt2dLY8OSQDv4/Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620296;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GhxaZjG1j7HL18hOTEZvlKdrOp1h/E+JuWcsSwGjvSc=;
	b=KI1jCEB5A0C+ZvZOkTdkr11jDMA79ijz4zgEzthi3YSwBdU/BtMV98+iBkcDgPPiQLT8
	 YdBj2WjntV5Ot1XtK3++CjFZqXCD4+esDyXyPfV6SgqNmHhnAEGsqYPAywdrit2pau1lm
	 dM/khhNsbdzM8C/vxBogfO/ZHPpAmyecvtS0DExSM6tj2q2HaBC5c7rESswtmeZzU6otq
	 4EEX/1N5peWK2NJDwOVxUVU6En62SN8DBwB7gjMG4lBqau8rlUEkuO8NU3i3yCSYyHUa6
	 0CHeHdhFQt3wZZn/UZhUfkow+SU9/5qYG7zjRWmzV1ECMZqLJ+4IXSFhUYYiKVKwT1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zFGLGxKD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3CA606A323;
	Wed, 25 Nov 2026 15:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zFGLGxKD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976E91F000E0;
	Wed, 25 Nov 2026 15:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620296;
	bh=GhxaZjG1j7HL18hOTEZvlKdrOp1h/E+JuWcsSwGjvSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zFGLGxKDR1ATdGFbWInibOaUpGaaFZXQqzolSKx96BGCjnmx0sSrlIuCHHds58f6V
	 TOYfQtM7wcdTdEmyrVWnErLeTM0OFsY0iGJeAz8NGjGclZJKFwi1aebVuYAdS4wrWh
	 h4J23xfAebTcsHwUnxHnOEJGqbRsn70SAoB2m6pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1288484b13bf6af3620d@syzkaller.appspotmail.com,
	wuyuehong <wuyuehong@cmss.chinamobile.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0870/1005] dm snapshot: fix discard_granularity unit in snapshot_io_hints
Date: Wed, 25 Nov 2026 15:36:48 +0100
Message-ID: <20261125143842.087666457@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
@@ -2414,7 +2414,7 @@ static void snapshot_io_hints(struct dm_
 			snap = snap_src;
 
 		/* All discards are split on chunk_size boundary */
-		limits->discard_granularity = snap->store->chunk_size;
+		limits->discard_granularity = snap->store->chunk_size << SECTOR_SHIFT;
 		limits->max_hw_discard_sectors = snap->store->chunk_size;
 
 		up_read(&_origins_lock);


