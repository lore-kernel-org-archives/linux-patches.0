Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057500;
	b=G0dsWUmAaofhmJZKCVlNvbL9NQWXPmuG1erRhMcS4IGzD/xHWsAzkg7F9TXlsJxY6VuF
	 +4BYpeWIeVevRmU/ygre0NJisHPWqVhpkW/uk6xi3sYXF2c7EA1upRqnNsnIRWk13OMym
	 a6cG+ERl0idIO4NwiL4REAeDQXAdd0u1eilOwJqnMuQTVZvK1OSnea2X6cUwmdZ/Ftopv
	 /pEik+UeHSGQzg5+B0R+f7xVRUB5LlpWK3znkDj910PcQ/kpm2vwQp4u9rNIaKduhhDJu
	 Dh2c+eCcubSbYRxCwW0Ti1tUStZoz5CxKyV31vvjrqyji2TIyjBBHnFGyo9rYP29PwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xP89QOGorKFosKhlQahhDMryXOWiEWHaHNbhV2BF5CY=;
	b=3YSSa2uB3WyCDcw/+q/3Bo4kxM3a5diaXCNWSn69qEge04ykQVQzURmOQmsWfUjHYxMG
	 lkw4dwT70Ly6+m4U4pcHfqhh/+4sCEL02L9pEGqsUZjh424rzrZjHe4D8kQpWvgNimdXB
	 L6e70eU9dpUzJiiROAiDugp7ob12APJXtif20nAjiXKWmL6XxqqohGOow3ov2rRtndNqw
	 cIK/zMenmJFd+bHpUX9NDzw+jMPrZHeCJ6GUIMmyLleQSRdxsVLL/TCH9FwhozaJy5H/P
	 aiSFiXT34tt2LXOsnZ1Lp4u448BQSJRuA+5rJjEjk2G3qwevaDWqWhqYWBnmSOXs1Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1xcm53Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154C960A2605;
	Thu, 19 Nov 2026 03:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1xcm53Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCAE1F000C4;
	Thu, 19 Nov 2026 03:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057499;
	bh=xP89QOGorKFosKhlQahhDMryXOWiEWHaHNbhV2BF5CY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1xcm53ZzvntqWMhmd4W0lxUQZfIeF7YuQ1o5QPD4F5JErr2gdtOvlew+ECEn2iif
	 umsFaOrYQ1dGYomQxEHCEHfI8My5huCiNxTUl0kRar+34YHcfu2bDcB+DKv6OIxSNs
	 cdnrJnr8AzENzdGfUqYszxUMSVY5IEStl2cPk3ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykola Marzhan <mykola@meshstor.io>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0153/1848] md/raid5: reject zero-sector reshape chunks
Date: Wed, 18 Nov 2026 15:36:31 +0100
Message-ID: <20261118145917.763000229@linuxfoundation.org>
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
index 5e929ceb45805..c0f2a43a3f356 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8128,6 +8128,8 @@ static int check_reshape(struct mddev *mddev)
 		return 0; /* nothing to do */
 	if (has_failed(conf))
 		return -EINVAL;
+	if (!mddev->new_chunk_sectors)
+		return -EINVAL;
 	if (mddev->delta_disks < 0 && mddev->reshape_position == MaxSector) {
 		/* We might be able to shrink, but the devices must
 		 * be made bigger first.
@@ -8170,6 +8172,9 @@ static int raid5_start_reshape(struct mddev *mddev)
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return -EBUSY;
 
+	if (!mddev->new_chunk_sectors)
+		return -EINVAL;
+
 	if (!check_stripe_cache(mddev))
 		return -ENOSPC;
 
-- 
2.53.0



