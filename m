Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034071;
	b=DmklV9iyNXiFMfbL5hIOWMUU4NzootlYcp1sbHj89jAcgdOuMjQ86Qq6yNCLDv0lRPpr
	 I3QpWsNgicNrO6EXujZLi3UBdjegAJuQKfc2/9twbTWTxCx7xPOVfwGIff0DDHYqEWuik
	 UFQ3YVIAJlgnwDI4uYDYQ9USBbB/a936dWASmq6vtUs3Og/QlgivK95WLiwu0tANw353G
	 AKSLe9c8AhO+ROvIf1h89t2aTLHKBvfqpXXChBsODvlSujfUmucmCfbWiqdhF4tCoQ3Lq
	 T2oA7EsDFDGULZ5ggQpsGHMu5filnD3YIBsBmp3jZgp5Qji8eGPFiFpL0oWZ+RRlJSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FMTbfllIiuKsRdYv1/BdDzB3s4NqLu7m3M9GbiGBJ1w=;
	b=HEsGMuQwfAqRokNRvfL7XuaP/UDNafbsNnuEToY7QYEVWDNi642VjRAnD5nW14hjRpoB
	 YYqk5DPZHG/EusJmBMwrn4FoCahWHvcHII1jvzg9GxgY7WhQ16hHWxaBa+hoZCqWkjZAN
	 V6GVUKSf14J6j2NFQM63jjzn0qrtDMiqDEVLUf+bbLHgmstyqNpJ2dr1qgW4h8PIlkngu
	 jRUfP4ns78w8WVYjEvbVLy7Q9iyDlkhjC51XnVSGfw0cZJQleJ+04WJgN7D+gK7EnKVtV
	 ib19BtZd3e0k/zsYVhj2vuzwu8dsxEDdsWv71g4i/LLy6x3IMHYdGZabEWCpSdYfJJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FIJtGz6u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6520606A325;
	Wed, 18 Nov 2026 20:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FIJtGz6u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFB61F000C4;
	Wed, 18 Nov 2026 20:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034070;
	bh=FMTbfllIiuKsRdYv1/BdDzB3s4NqLu7m3M9GbiGBJ1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FIJtGz6ujZF0KmbFvW4/HFoPjXOkRColF5no+PVP8LfxqS6qx5fb5qMoVDiKv5wdM
	 p+ACW1t8gShFXdb2174bUioHf5EuG+nLBs6juRc93rcuqTAY5VL+xpvgYoXGadjYgU
	 NAMws3zjk065EQoceD1lQmqQu45PQ5ZZIKT9Al54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykola Marzhan <mykola@meshstor.io>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0238/3318] md/raid5: reject zero-sector reshape chunks
Date: Wed, 18 Nov 2026 15:14:20 +0100
Message-ID: <20261118150322.255184416@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai@fygo.io>

[ Upstream commit a41bb2ee1aca486853e84920565e50c15f86fa5d ]

Sashiko reported that RAID5 can accept a reshape chunk size that becomes
zero sectors. chunk_size_store() stores the sysfs byte value as n >> 9, so
writing a value below 512 bytes sets mddev->new_chunk_sectors to zero.
RAID5 then accepted that pending reshape geometry and raid5_start_reshape()
installed it into conf->chunk_sectors, letting reshape code divide by zero.

Reject zero-sector chunks both in check_reshape(), where normal sysfs
requests are validated, and in raid5_start_reshape(), so assembly/resume
paths also cannot install zero chunk geometry.

Test script: in QEMU, create a plain three-disk RAID5 array with 64K
chunks, write/read back a small pattern, write 1 to
/sys/block/md0/md/chunk_size, add a fourth disk, and run mdadm --grow
--raid-devices=4 --backup-file=... . The script scans dmesg for divide
error/Oops/KASAN signatures.

Bad kernel, eb29914412c3:

  echo 1 > /sys/block/md0/md/chunk_size
  mdadm --grow /dev/md0 --raid-devices=4 --backup-file=/root/md0-grow.bak

  Oops: divide error: 0000 [#1] SMP KASAN NOPTI
  RIP: raid5_get_active_stripe+0x863/0xc10
  Call Trace:
   raid5_sync_request
   md_do_sync
   md_thread
  Kernel panic - not syncing: Fatal exception

Fixed kernel: echo 1 > /sys/block/md0/md/chunk_size bash: echo: write
error: Invalid argument chunk_write_rc=1 grow_rc=skipped RESULT:
REJECTED_ZERO_CHUNK_NO_OOPS

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Link: https://patch.msgid.link/20260802195038.164272-5-yukuai@kernel.org
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ac14655c85d66..d6035fc6232aa 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8507,6 +8507,8 @@ static int check_reshape(struct mddev *mddev)
 		return 0; /* nothing to do */
 	if (has_failed(conf))
 		return -EINVAL;
+	if (!mddev->new_chunk_sectors)
+		return -EINVAL;
 	if (mddev->delta_disks < 0 && mddev->reshape_position == MaxSector) {
 		/* We might be able to shrink, but the devices must
 		 * be made bigger first.
@@ -8550,6 +8552,9 @@ static int raid5_start_reshape(struct mddev *mddev)
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return -EBUSY;
 
+	if (!mddev->new_chunk_sectors)
+		return -EINVAL;
+
 	if (!check_stripe_cache(mddev))
 		return -ENOSPC;
 
-- 
2.53.0



