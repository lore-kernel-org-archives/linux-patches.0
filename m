Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022600;
	b=h1WVDpNov7gmzzZpN7B9U6u45FQTBZttTU/SZQ4FN3WL0hllTihdWLYoRKBxGMGS3tRB
	 vG/CqEEkDRlpUZQwcUQOTH6rcYrG5uqgYmOcxmh1tVTw2I6ZNmbzOGA3Ttb0w8E+Y//yl
	 vYLoCKp4wwtRAZN5ZOP4+j8PLsa+45xACLfUxAzKnLuqrV5QVebByi9pCDzO3ZoJJQJj2
	 8bFKI/Mit/3yRotUwIW8Mx7+3jG2SGARxdkbi19S5mf1LLX2gEXcSm0cjcOV8h6mJIsew
	 vKYG8pRkaREGyU0/apF/KfuQ2yHgvYDjYV3ghEHSGnSOEuyKIQAmRIW8m4Wvy2lJlWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8oAvywCKM1LYAt7GdF5z5qOgiVdvAxI1i8RDD4p89ik=;
	b=LyPW4ZSEmFLpDufyJ0AQ7DZ6SAM47W54jn5NxzfvFEM2wyeCAkm3Lluwj9Ac+qfLfLj7
	 EeeJpalQmnLUDRPn+FjUZJesiP+Vq0WmTCjTyvDMdQcu38ZS+awU6irR8mVdUwnDQwVq0
	 RNSPXDiVoxSrRPeJfrfklSBmbqaJd44sBTcJ9Qbu7DJZqYkXs3DE8gGRYFzayShFaGOEK
	 hdgihkkFKBNW5cIN3LffHdv2mXT9CiANg4drhxg/LVvpm/+d0oa3HltH+EgdPJpVf7cUY
	 jSBx/JcN2SGlpJg2OIdN3I7wUkeWVfmBhjf+KtUG+LkGeR5DCyLqrpr0hgBsUFiy4TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FwpM1gui;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DBE606A31C;
	Wed, 18 Nov 2026 17:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FwpM1gui
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BA81F000C4;
	Wed, 18 Nov 2026 17:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022600;
	bh=8oAvywCKM1LYAt7GdF5z5qOgiVdvAxI1i8RDD4p89ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FwpM1guibgYKGaQjLlWTyTL9MWSOrH/uadcdm51NqxQrKZAeOOtolQs+ksg6hztEn
	 Uzzdq4mz7PzhQZnu9/H8WkUvbaydNx6pdHlqO3+UCr3u8fsTZnf+iJX8Uhpcl3jp/L
	 nef017BRnoTbs39Pp5IyFE8l7fJecwxoZ7r71ssA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Fenski <bartosz@fenski.pl>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0071/2151] btrfs: raid56: do not verify the content if there is no data checksum
Date: Wed, 18 Nov 2026 15:30:06 +0100
Message-ID: <20261118150124.348467623@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit d00b85308abee300dfb7e1ac642f38bab9ec7492 ]

[BUG]
There is a bug report that fio can fail to sync the data on a degraded
RAID56 mount:

  # mkfs.btrfs -m raid1 -d raid5 -f $dev1 $dev2 $dev3
  # mount $dev1 $mnt
  # btrfs balance start -d $mnt
  # umount $mnt
  # btrfs dev scan -u $dev2
  # wipefs -fa $dev2
  # mount -o degraded $dev1 $mnt
  # fio --name=degraded-write --directory=$mnt --rw=randwrite --fdatasync=4 \
		--bs=4k --size=512M --randrepeat=1

The run will fail at fsync:

  fio: io_u error on file /mnt/btrfs/degraded-write.0.0: Input/output error: datasync offset=142254080, buflen=0
  fio: pid=2064, err=5/file:io_u.c:2008, func=io_u error, error=Input/output error

[CAUSE]
With extra debug output, it shows the problem pretty well:

  rbio=2876243968 faila=0 sectornr=0
  rbio=2876243968 error=0-15 csum=2 bio=15

The first line shows the rbio's full stripe logical, and stripe/sector
number when verify_one_sector() failed.

The second line shows more detail about the rbio, the sector range [0, 16)
is corrupted, which indicates the first data stripe is corrupted, matching
the missing device.

The important part is that the csum bitmap shows the data csum is only
for sector number 2, meanwhile the failed verification is at sector
number 0.

This means we did the checksum verification even if no corresponding
checksum is populated.

[FIX]
There is already a similar check at verify_bio_data_sectors(), but
unfortunately there is no such check at verify_one_sector().

Add the missing check to skip the csum verification if there is no
corresponding data checksum.

Reported-by: Bartosz Fenski <bartosz@fenski.pl>
Link: https://lore.kernel.org/linux-btrfs/a72409af-45ef-45df-9970-2e38bcb22ea6@fenski.pl/
Fixes: 7a3150723061 ("btrfs: raid56: do data csum verification during RMW cycle")
CC: stable@vger.kernel.org
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[ sashal: Adjusted context for the existing struct sector_ptr-based verification using btrfs_check_block_csum(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/raid56.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 4d4852f2ba7eb..20eef417b8441 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1788,6 +1788,8 @@ static int verify_one_sector(struct btrfs_raid_bio *rbio,
 {
 	struct btrfs_fs_info *fs_info = rbio->bioc->fs_info;
 	struct sector_ptr *sector;
+	const unsigned int total_sector_nr =
+		stripe_nr * rbio->stripe_nsectors + sector_nr;
 	u8 csum_buf[BTRFS_CSUM_SIZE];
 	u8 *csum_expected;
 	int ret;
@@ -1798,6 +1800,11 @@ static int verify_one_sector(struct btrfs_raid_bio *rbio,
 	/* No way to verify P/Q as they are not covered by data csum. */
 	if (stripe_nr >= rbio->nr_data)
 		return 0;
+
+	/* No data checksum for this sector. */
+	if (!test_bit(total_sector_nr, rbio->csum_bitmap))
+		return 0;
+
 	/*
 	 * If we're rebuilding a read, we have to use pages from the
 	 * bio list if possible.
@@ -1808,9 +1815,7 @@ static int verify_one_sector(struct btrfs_raid_bio *rbio,
 		sector = rbio_stripe_sector(rbio, stripe_nr, sector_nr);
 	}
 
-	csum_expected = rbio->csum_buf +
-			(stripe_nr * rbio->stripe_nsectors + sector_nr) *
-			fs_info->csum_size;
+	csum_expected = rbio->csum_buf + total_sector_nr * fs_info->csum_size;
 	ret = btrfs_check_block_csum(fs_info, sector->paddr, csum_buf, csum_expected);
 	return ret;
 }
-- 
2.53.0



