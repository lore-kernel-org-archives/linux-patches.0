Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016530;
	b=ntlKv6IwKzwhCNnHFu1kgzUHgWEuMWT64x3i11DYVXUL7H5UBBdWdbG9b1KgzEH395vj
	 PhrYcYTN3Sd5qMGhw86VYseNN7GNt/qWs+p7GhoxRY/RlfYkQ7qv8pXu/HWspr7687tGo
	 zzUCT3Qx6PgCSf5ZurHgoNlumy8SaQvWS1CfHerunBR4XgVDPT3p9xv/cPe32Pl/7ZnoG
	 UbacuhaPCVoAQOtQbqqOAnzM8mMx0lehTJD3J34aoB5ZInN3b5t5ioDLI1kkUag84cr/X
	 8b0ZIHSuTdt9k7tqUM0U9GaD5tvHEs0turXCQuS2O/BZBRipAKnZtAIORQxNXuKMVpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t3Jj1Pp+y2Cmj7NXr/dIDRUX/4ytNNfN9f/VC8iRAJg=;
	b=lRiSr069a1vdYegEKzGzthBUH6tCL86GKTKMQWN0UTwLt7mhjRc3G3gMpBfZJmcyoZyJ
	 cUfO7TuXfQIFF4sUkIGlPCtr6BAaimO9964guf1AFhCDVt3ObnD07hfqlfE6ey+EZ3Jha
	 HyqGFhXma0o9QnaTlSjDtFLHRu77dVHoQdxGYI+kSIGAoVdRinujEaG5Bo0NTiYBvd4gB
	 wSWW8OTrTQPWfpewCfpMFj78vL5ED8KPnTkVWAMQspc8RPIZc9e6Dpvly580Jsh1whQo0
	 jnPzQSgKpxrkh/CvjUxAd9qv8PfaMp81DQfxbBW/r6SYkT9r6zgGi0R2ywzmBqDPrKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W44hW1hQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38D2606A31C;
	Wed, 18 Nov 2026 15:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W44hW1hQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0D31F000C4;
	Wed, 18 Nov 2026 15:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016530;
	bh=t3Jj1Pp+y2Cmj7NXr/dIDRUX/4ytNNfN9f/VC8iRAJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W44hW1hQaS9pymLVPG1gIQyn5TaW5j1o2KAyaucWygqJe2k3+z0rbKMWSEmvix1NF
	 jSdSPOAc5CEJ3PpMBb0idBO5HluEQa/Xt/xIMl/nj9PHuW9whsiLJByOwowdVfwND8
	 mr/Zv8lA2XnoN01XczDDR/n4qndu0HqXpf70ZFec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+50f9bc7ab8eb224b7629@syzkaller.appspotmail.com,
	Zizhi Wo <wozizhi@huawei.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0518/2651] md/raid5: reject a per-device size smaller than one chunk
Date: Wed, 18 Nov 2026 15:29:18 +0100
Message-ID: <20261118150306.398483882@linuxfoundation.org>
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
index 45b00c9904215..fbc356e442458 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8213,6 +8213,12 @@ static int raid5_run(struct mddev *mddev)
 
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
@@ -8546,6 +8552,8 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
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



