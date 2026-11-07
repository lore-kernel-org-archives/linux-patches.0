Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060914;
	b=2cDkp1wqvXANMy3ljurSBgJBTzRFN8lmLjMpdu3zyudza/Tiu1YOn4iBK83OH4OyDkgC
	 3X68noOEfUO7xifWUZxdPfYJ+H9V+eSWh1bFC0SIIzBv0UZNLkaDrsJjxtFltVIzEfnf6
	 XSXpahJT8H6Nx8+9RYfarJLx/Qrlq68KYz67G0zeYrdOf29cr499xZ8MWnvBm69EUP+Gt
	 8zQ/OIDPboD/fwfT6PLWeOljXbRT6CBTxQisHcXDW2tcATaGSVFrB56CeaqadBHcbiyVy
	 x/0ecBrzACmJPy5fWjo1EDnT92D3+VIZfKlfzMPcXOYk3BgNjayw/WeIWYRH9zP403Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060914;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V5bmfFCU1QXMAR64dMvb7AVG+2OmzjIthmGj4Y3MqRU=;
	b=MW4+K8pRPTSLd8GYyt77N0tVHHlPcutAoR+hZiIlkCTekv5lFPIShcHzeUfYZUrm9pFJ
	 FzgPXEPgtBR/bTy8XpIBvRR4QcPbSb8BKpfSJBOVgRK7c+9G83DYZwoAijNmMGt3rjcOe
	 941C9Z3ukbz5XNS4YBKbS2V1PzL3VvYKERlionKnZIawCvkVD1yLJv3GLm9ppFzGobtKa
	 05QaFkpUR1y0rTsAGV9LIZ+CuZ880uvXmBWxYINTw0wKGY6+pccClUlSOGqOIEf9H/oS3
	 1q3rd33CKrv3ImZ1VzBBpyGQSl/qo9BBLO0Y8s8+U1ot7g2p9cjCOdYAhiuldmUJiHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ItNi+MX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DF8606D809;
	Sat,  7 Nov 2026 14:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ItNi+MX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A941F0089F;
	Sat,  7 Nov 2026 14:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060913;
	bh=V5bmfFCU1QXMAR64dMvb7AVG+2OmzjIthmGj4Y3MqRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ItNi+MXnPb7IumQh6eHUWMmXGYNM3yabZklukVtD8UrmDqMUamViMidJCoFHi5pr
	 0wlSSvQYFtJXnszYv5ir9GTdSzj1fBov1SlsY1ultcabAUqguizJtO4jxh5b0CCEnL
	 ZGEFWt/Y6AucBR5zDApk6fwa9dkHFy7SBDL99crE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykola Marzhan <mykola@meshstor.io>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0282/1536] md/raid5: reject zero-sector reshape chunks
Date: Sat,  7 Nov 2026 08:38:18 -0500
Message-ID: <20261107135005.583676997@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bd97efd7393f9..36c4cb7326823 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8439,6 +8439,8 @@ static int check_reshape(struct mddev *mddev)
 		return 0; /* nothing to do */
 	if (has_failed(conf))
 		return -EINVAL;
+	if (!mddev->new_chunk_sectors)
+		return -EINVAL;
 	if (mddev->delta_disks < 0 && mddev->reshape_position == MaxSector) {
 		/* We might be able to shrink, but the devices must
 		 * be made bigger first.
@@ -8482,6 +8484,9 @@ static int raid5_start_reshape(struct mddev *mddev)
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return -EBUSY;
 
+	if (!mddev->new_chunk_sectors)
+		return -EINVAL;
+
 	if (!check_stripe_cache(mddev))
 		return -ENOSPC;
 
-- 
2.53.0



