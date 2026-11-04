Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830822;
	b=SsxCcxn7SQJRcYBWMzNBcRgluFZ9NKl6di2J93zufnX/LWgzUPgy7CUegJibaJZNcKaI
	 UyrpEO+NVlKsEJNDNBWLHhPj2V29PwGJE55H2eL92HoeCSfS3gCH7fefiR9E5cWvCdirW
	 ErvWYvSaV2U60so1LZsycZIaWbw2YaFA6uFw5KBaUAypIgnJd2Yz2U7+dFJsHZAIO1D07
	 GU9BKefIQkykbEPQZTBnItZ3gGbCK+LknMNSJ+yscs7UtWx7gnu1f7jzXoVsGHsH1QJMi
	 +VXa5QoppaikLrko6468X0FMXA9xU5OOAX2PhKkeAZ5acBGpv4kjqkwN6aWsujUScMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C8ehrh+z2yM5SGPOo2f08UKTgT6bhaaKIu10qMugurQ=;
	b=K3iC4mVMmuAvHZmCCYk/Ph7+B2fKAtyiBZY/oeQ7MyORIvkfK3CBDiBhwywYp/R40i2d
	 ZaQhWtC5l5RmIb7czNq86W9m5/teBtbXG56P0rBvO/w8zDXWZH4eBVV+hI5CqzSG26B4h
	 TeyAP3BBHl5nYJbY6bPdCoOsP0e8m3i2MMHswHyoNtUiOiEB47xrQpuhV42kvKsCwZXYA
	 4SKYumlhxsdb2Y//5exCElcUNx7/frE24bFHhlDQeDOyZ7MAACQdQUGCCamtK9ViSl9j/
	 uFrcvTHflnYsr513HX90l8R7BO7UROtuIAg51mQbYkOZ6wWQguQ4bQkXcZIpSrldtRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ukdiL9G3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6648E606AC39;
	Wed,  4 Nov 2026 22:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ukdiL9G3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBE31F0093A;
	Wed,  4 Nov 2026 22:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830822;
	bh=C8ehrh+z2yM5SGPOo2f08UKTgT6bhaaKIu10qMugurQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ukdiL9G3KdBrCQDQSWB3FbbBdKSj2gWzUR+xyuSn6D+56jtln5iff3lspryx4cGBE
	 rqSsL9d8wm6k6F4N0tTuGuctVcnX+7WAgro8cRCWZdgWq6wGGvfLb2grulVsmyr6Tw
	 iHWp8hvjECfaomu67cMwu1c0T8DwrMPflzNsdE6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykola Marzhan <mykola@meshstor.io>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0340/1005] md/raid5: reject zero-sector reshape chunks
Date: Wed,  4 Nov 2026 16:01:13 -0500
Message-ID: <20261104211053.482624113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b7da2b83e1938..56d7e05e94ce6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8437,6 +8437,8 @@ static int check_reshape(struct mddev *mddev)
 		return 0; /* nothing to do */
 	if (has_failed(conf))
 		return -EINVAL;
+	if (!mddev->new_chunk_sectors)
+		return -EINVAL;
 	if (mddev->delta_disks < 0 && mddev->reshape_position == MaxSector) {
 		/* We might be able to shrink, but the devices must
 		 * be made bigger first.
@@ -8480,6 +8482,9 @@ static int raid5_start_reshape(struct mddev *mddev)
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return -EBUSY;
 
+	if (!mddev->new_chunk_sectors)
+		return -EINVAL;
+
 	if (!check_stripe_cache(mddev))
 		return -ENOSPC;
 
-- 
2.53.0



