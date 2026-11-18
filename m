Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023754;
	b=lb31ln2AnRlQGpMQx1T0/mOakvkiIziR47Ux/EhU8vzN8UIwHJdTzleL+A/fUON9qqHs
	 mgR2gPaN39gR+6tocQEjEGtwasA6G7v0vTWRp9v8IVC90+wNHna81ZrxI8YvCZ40jms1G
	 GoXhb6MIa+wqCKASzhovSuD/W71ZtYWu/OIMSnJ9WZU7ddHu+Wr/sRHyrdkhswrBqTGS+
	 4NOrm3kitmEh5TA27wssHgy9olXVa9lLoPlwzShzVpYEPf+753l4r34PMsSnwLKx4aTcd
	 ZBMJRwh5Do2LGrNGv1bGG4L9epKEHOj2Pbf81/QObDuXUU2R7lmsBaCVY3bM9B/lKqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZBFa0hLLx9UiJXAsotbbFW175DMj+9PPPWdtPvaZq08=;
	b=tE6WlNOA8EF+//A2b2Ud4VkLFqmY3jab1aYGsoQnmotWksFYm/w7A0k3I6mPgCZ7313r
	 RJoh5qbpjNIp+6kcWNx/QM891JFBlShqyJp+sY2L96851i0+GG5lqXU7nYCR7Eogs1cM0
	 26BlV8zvyDWKfpL0kz25vSruSJbgFlkkJlVaDlu1pSuBU3OoKsnT1r5T3QjqpgejtgBfO
	 kVbICqtPHG93yoImlvHrHCw1KE8EOFhmmOA2kpXFS/4i0OMN0Abi7dazmDXf3S9md6Fk8
	 cVP/WHYy3sxnOi6PMBi+sFMBdvQX90Gv17IrrVRrpXub8hDxsdI3jUyez/LVHUaQB0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hgNP7zsl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53325606A320;
	Wed, 18 Nov 2026 17:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hgNP7zsl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73171F000C4;
	Wed, 18 Nov 2026 17:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023754;
	bh=ZBFa0hLLx9UiJXAsotbbFW175DMj+9PPPWdtPvaZq08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hgNP7zslpaZ3ElOTnqYCvuMiA01mANwVAV7hZNXZcNG2vuHQoG3WZLniDdZzuWpXh
	 A6hOrN/u+po2vw/RGCgGZii5JAM8+egtJIvM+QzHcPq0a30uuloRfq3bnFkV3f7PxI
	 IBq24JMwWHhMGAj5/xgOZJ3iZkAAnOadHITNg5Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+50f9bc7ab8eb224b7629@syzkaller.appspotmail.com,
	Zizhi Wo <wozizhi@huawei.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0483/2151] md/raid5: reject a per-device size smaller than one chunk
Date: Wed, 18 Nov 2026 15:36:58 +0100
Message-ID: <20261118150139.642833420@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 42602ac28d903..d427b24314c91 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8056,6 +8056,12 @@ static int raid5_run(struct mddev *mddev)
 
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
@@ -8388,6 +8394,8 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
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



