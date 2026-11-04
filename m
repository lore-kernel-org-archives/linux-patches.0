Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830825;
	b=vJv9XJeOp3d95TT1+Gmtur8FacvxwsgC/auZHGjLzCZbaUf0RUNcT+W/tsuJCoSI4tbO
	 9QhMHIdTjPVDEzC7a419D0+Nz/7ekUxu9Prp4nN1fcrq1uUUfPqFmP5X6SFgj4erb+BOB
	 cv7UVTQPzDKjllELtuFuMRJ/ccdLJSyAtIj1KtGp+GTW612Y4e+ApsAeWH/uk8W7NaY/W
	 gTTPFq6zj0jd5Fd9udJo6Sxl087NMzamHfKwWZBpkNnfXTM6hrmemTnDpdMIHRUOHXTnF
	 b/BF2v/et7XAukXb7FmaFT3zoKXaUkap5TLc57Nc/jBZkizW9ddq28QbGCj5d+lQdMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mLQNRBT4me249sGyybN1OAaHyTdeDeQKv5MIUBKt2FQ=;
	b=eakcw3vUOs6L/M9WucYcz/GybC26x213jYzEiOT7iDvuX8769tE4mHcsZSFXr6QRaPiH
	 0LCmPLfDXuF9XqqzaFaIUf6KS5bKNiRCE0bjzoa3qxgdTmizyGwyIw0lUyXeh9aZcQICg
	 NKhnqcuydu2m8Fbe5G1n1wlk6aAV9bRlFTR6KHc1vPT/8EYLcRkEhSfCZsWRQWj8c9yVV
	 hwixXJgXXHQ/50ysopggig4sJTD9qPHvDM4kksiGGqCC5hmw1vcl/EtbsdIK+xF3gfPXd
	 T4u9tCxtDdcfn0FgNk4cT2xdboeCuWxpllQ7Uf7Q2k/3IZgRm6I6ijCg//vJpw/AvpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Msyc2S/b";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607FE606B2D7;
	Wed,  4 Nov 2026 22:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Msyc2S/b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28551F00919;
	Wed,  4 Nov 2026 22:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830825;
	bh=mLQNRBT4me249sGyybN1OAaHyTdeDeQKv5MIUBKt2FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Msyc2S/bVcOBQB4hroaokyqcAv6Go7Dz55uvWT7eNKMTcaEbgRtkL+eE3BhLjRdBj
	 mVIhyZsuLZaX52P/IPfw9KNOXr8nq1R1S3QSf8EN5+4XDARdmFHIiubrRY4jRia5se
	 3vhuYSBxSusM0tjJhg+uvAE+mSCBF6Ds6quS18gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykola Marzhan <mykola@meshstor.io>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0341/1005] md: skip bitmap accounting for empty write ranges
Date: Wed,  4 Nov 2026 16:01:14 -0500
Message-ID: <20261104211053.511152315@linuxfoundation.org>
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

[ Upstream commit 87c10252e3d6c28769d93bea9e6a9b592e5809d1 ]

mkfs.ext4 can submit zero-sector flush/FUA bios. These bios are WRITE
bios for md_write_start() purposes, but they do not cover any data sector
and must not dirty bitmap bits.

md bitmap accounting currently passes such bios to bitmap start_write().
For llbitmap this reaches llbitmap_start_write() with sectors == 0,
which underflows the end chunk calculation.

Personality bitmap mapping can also turn a non-empty bio into an empty
bitmap range when the requested sectors are outside the active bitmap
geometry. Treat both cases as not started, so the completion path will not
call end_write() for an empty range.

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Link: https://patch.msgid.link/20260802195038.164272-11-yukuai@kernel.org
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03d328506b285..ce3bd127e3bb3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9266,6 +9266,8 @@ static void md_bitmap_start(struct mddev *mddev,
 		mddev->pers->bitmap_sector(mddev, &md_io_clone->offset,
 					   &md_io_clone->sectors);
 
+	if (!md_io_clone->sectors)
+		return;
 	fn(mddev, md_io_clone->offset, md_io_clone->sectors);
 }
 
@@ -9284,7 +9286,8 @@ static void md_end_clone_io(struct bio *bio)
 	struct bio *orig_bio = md_io_clone->orig_bio;
 	struct mddev *mddev = md_io_clone->mddev;
 
-	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
+	if (bio_data_dir(orig_bio) == WRITE && md_io_clone->sectors &&
+	    md_bitmap_enabled(mddev, false))
 		md_bitmap_end(mddev, md_io_clone);
 
 	if (bio->bi_status && !orig_bio->bi_status)
@@ -9308,12 +9311,14 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
 	md_io_clone = container_of(clone, struct md_io_clone, bio_clone);
 	md_io_clone->orig_bio = *bio;
 	md_io_clone->mddev = mddev;
+	md_io_clone->sectors = 0;
 	if (blk_queue_io_stat(bdev->bd_disk->queue))
 		md_io_clone->start_time = bio_start_io_acct(*bio);
 	else
 		md_io_clone->start_time = 0;
 
-	if (bio_data_dir(*bio) == WRITE && md_bitmap_enabled(mddev, false)) {
+	if (bio_data_dir(*bio) == WRITE && bio_sectors(*bio) &&
+	    md_bitmap_enabled(mddev, false)) {
 		md_io_clone->offset = (*bio)->bi_iter.bi_sector;
 		md_io_clone->sectors = bio_sectors(*bio);
 		md_io_clone->rw = op_stat_group(bio_op(*bio));
-- 
2.53.0



