Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043420;
	b=LafGO2pmwXAl2yoHfsSnJS42C38rEBOCJjdTFWeLJQ7pyaWG5b5WA6ZdM/DSxLGNHWMf
	 0SPsi1TV7b+4wWU8xEorCY6XW6pfmCON1sf9YJjrfSbR5nCPvSLnRw+keMNf1M8j+hbGC
	 OfylcfXAYMQQ3HuJPyKmss02Mt2nLq1Mc1yZEcveevWCbpTdJhOhVUrKwCbiTZYxnavlP
	 R/GA1Lp6SZNlupDHtmovysqmiiAx7Dyf/UAuyyHC4OCHGue7C40JQCfMBbGsHkFYCLYYb
	 iy8ypioAH1gWmpjW8k/boC6a/bFeAAqA3KiCch3g4+nlpvjGKRn4PUHdxC+fREYvUWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8ogt7epiu/FfmhYWvprtwmw7T3zIWu4evF4LcjluNc8=;
	b=ORa5/y89mSvSL+XgboRP1XCeXETHfLFQOcL/laT+oxgSkGroagGW21qdE5uk8S1Htt5/
	 xPADJBSCGtBWFZe1gpoMvM1TjaNC7r7sTCWkTEFglp8gBDcc83k38MtVVimHAzGiIsy50
	 Mu8Oxkqk2mWG+65J108dv/O7glwG8Kg2s0TygiyRjcZb6PyOcVz4I6FAdn2xso2BKWO+t
	 t+gvgHKGM4mNtSF96/UdmHwnHUFiIyvWtbINLZmy6Mq1UdJHvIvcW8UJuVQIU2+VrvCvX
	 mb8H98QfZbT4VSuMo6RBMVPVrFzZFP6cI6vgSeyhdwXwpoAOEYt7E/zl+Pc8mC3eM3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hpFwJt2R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1938960A6F6D;
	Wed, 18 Nov 2026 23:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hpFwJt2R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2771F0093B;
	Wed, 18 Nov 2026 23:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043419;
	bh=8ogt7epiu/FfmhYWvprtwmw7T3zIWu4evF4LcjluNc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hpFwJt2R6tK/lwWFS22fGS/dfkjUecb8g38uiaLEqiKQlbFCzWvMG5reYngIStXOt
	 T9xsVjGUx6UhodmU0yUZPAMnHsf200P7Aznejo0B0IBP5egTUaOXaK7kuYokrPfhpy
	 zaZQS/YiJex70QPE0zTRpIbh6aNPCtlLIf3eIb+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykola Marzhan <mykola@meshstor.io>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0205/2857] md/raid5: reject zero-sector reshape chunks
Date: Wed, 18 Nov 2026 15:20:39 +0100
Message-ID: <20261118150208.735666709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 092cf1d0008ee..663b95b82360e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8476,6 +8476,8 @@ static int check_reshape(struct mddev *mddev)
 		return 0; /* nothing to do */
 	if (has_failed(conf))
 		return -EINVAL;
+	if (!mddev->new_chunk_sectors)
+		return -EINVAL;
 	if (mddev->delta_disks < 0 && mddev->reshape_position == MaxSector) {
 		/* We might be able to shrink, but the devices must
 		 * be made bigger first.
@@ -8518,6 +8520,9 @@ static int raid5_start_reshape(struct mddev *mddev)
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return -EBUSY;
 
+	if (!mddev->new_chunk_sectors)
+		return -EINVAL;
+
 	if (!check_stripe_cache(mddev))
 		return -ENOSPC;
 
-- 
2.53.0



