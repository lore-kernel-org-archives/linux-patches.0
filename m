Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029685;
	b=hs10gL4QzIVNjgqUfAEcLMnvgrHxyN79am/GcU4uPJvdcQHVI7SuYEkY2tPmaHF0mBb/
	 Ebw8GIhcW/0WH8a/k3Qgbl+CnWJ6H0hV37994I1OECyvq9eITu83HCMN7F8V0HkjMlhyc
	 tnPYNpBbUC0UYRjx/j0U04Oqa+NTsb2xEZs1X4M9gTXgccAltglXfnTK7fsi4Kel04bSg
	 4/wcqRgD3E+UOIJOrsfVERoOMMOKQQidaMyMxpNLSS63xdtcdoLpkdbxAO/hnM91s94ob
	 YyI1W2Cu3Uz8akM56ulhykKuyDShB8+qi7FYLVj7Qeju1lVS9lw2HcnsMOJu5UlN8rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Otbu6ZaK7hKI5vc9PM53G6jkAhWj2Si1Es6gHdRTuOg=;
	b=Fz/aagLiO2XXtUeJlQCFQMRG6rLOPct+obFScrdm7TPhpSz8/LdUij1Cefs71skS85Nv
	 cwHo/JEQ1Q1D8CZ19K7d5obaPCa81Uq1L4Tp4fUEx6how4RBrvmlKnAqeAPeKuXJwMx3m
	 owOhU2LcxLlFdcntGu3Js24mAFxJfLU2m9kyaZU+Eude64KiF4j/LhrLAhMgAB+RCCcHf
	 dhduoXvdk7SeibD+FhyIVL29BkPjf3bxLbDTOWzxnkrSimY6uGiM39D5S2VhQxqVAo7TL
	 wzpTHFrAcquUAj8dlGMmzRotiw0ujR8QMBkj90avvDHcfwbtfl0dgE3pb5JsCxCZu5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJwKdoUP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19F6606A31C;
	Wed, 18 Nov 2026 19:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJwKdoUP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FC71F000C4;
	Wed, 18 Nov 2026 19:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029685;
	bh=Otbu6ZaK7hKI5vc9PM53G6jkAhWj2Si1Es6gHdRTuOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJwKdoUPzPm+jkfcK91DOGiVGO5Ed5nGUMYvC4RUa+oKzYkC1pJ2y9m2at1pezJG1
	 qdIrl1MpbxQdmvj5d071tefj6PoRVSksRTuxzcAfYkGRPGLFqq/a1GAp8dfxuUAy29
	 dK9toLem9n+2woNzeW7dUBPOVY44EtPVFoGBLJV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+50f9bc7ab8eb224b7629@syzkaller.appspotmail.com,
	Zizhi Wo <wozizhi@huawei.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0439/1756] md/raid5: reject a per-device size smaller than one chunk
Date: Wed, 18 Nov 2026 15:42:46 +0100
Message-ID: <20261118150026.215853640@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 370ca0760b18c64592a258bcb057ff0a2531aabf ]

Both raid5_run() and raid5_resize() align the per-device size down to a
whole multiple of the chunk size:

	mddev->dev_sectors &= ~(chunk_sectors - 1);

Neither checks the result, so a size smaller than one chunk silently
becomes zero.

In raid5_run() that is harmless: the array size is derived from the same
zero, so the disk just ends up with no capacity.

In raid5_resize() it leaves the array inconsistent -- mddev->dev_sectors
becomes zero, while mddev->array_sectors and the gendisk capacity keep the
previous. A later raid4/raid5 -> raid0 takeover copies the zero into every
rdev->sectors (raid0_takeover_raid45()), so create_strip_zones() builds a
strip zone table whose zone_end is zero. Any read then passes
bio_check_eod() against the stale capacity and hits the BUG() in
find_zone():

 kernel BUG at drivers/md/raid0.c:318!
 Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
 Call Trace:
   raid0_make_request
   md_handle_request
   submit_bio_noacct_nocheck
   block_read_full_folio
   read_part_sector
   bdev_disk_changed
   bdev_open

Reject a size smaller than one chunk in both functions, so that a running
raid4/raid5 array always has mddev->dev_sectors >= one chunk.

The check is done where the value takes effect, not where it is assigned.
mddev->dev_sectors is written from several places, and none of them can
tell whether the value is usable: the chunk size may still change later.
raid5_run() and raid5_resize() are where every input is final, so one check
in each covers them all.

Fixes: eea136d69f9f ("md: fix buglet in RAID5 -> RAID0 conversion.")
Reported-by: syzbot+50f9bc7ab8eb224b7629@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=50f9bc7ab8eb224b7629
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Link: https://patch.msgid.link/20260916095137.1157801-1-wozizhi@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2dd4a7fb83dc6..99660cf51f533 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8060,6 +8060,12 @@ static int raid5_run(struct mddev *mddev)
 
 	/* device size must be a multiple of chunk size */
 	mddev->dev_sectors &= ~((sector_t)mddev->chunk_sectors - 1);
+	if (!mddev->dev_sectors) {
+		pr_warn("md/raid:%s: device size is smaller than one chunk\n",
+			mdname(mddev));
+		ret = -EINVAL;
+		goto abort;
+	}
 	mddev->resync_max_sectors = mddev->dev_sectors;
 
 	if (mddev->degraded > dirty_parity_disks &&
@@ -8393,6 +8399,8 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
 	if (raid5_has_log(conf) || raid5_has_ppl(conf))
 		return -EINVAL;
 	sectors &= ~((sector_t)conf->chunk_sectors - 1);
+	if (!sectors)
+		return -EINVAL;
 	newsize = raid5_size(mddev, sectors, mddev->raid_disks);
 	if (mddev->external_size &&
 	    mddev->array_sectors > newsize)
-- 
2.53.0



