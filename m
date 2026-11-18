Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055246;
	b=CrUcGYZunObNo3RtJoXGRqgH2syR33Wp3j+z1XldT55/+GfEqsbfMTob+Bu8VzgLewmr
	 hwj7C5HNKtKjAtK3xvs6ZkArGh/CPLp473nQbA8xszg7pBOa/zZJQq3y5kdH3IV/toUVg
	 pu6+796eH37rtwveYvL4PGqWgVqnAux1bBuUT9+aX/in1bkGnuQ6rfk5zDe2NiHQD2BM2
	 7iHJqitJ6eQaJLeGvw/hog7bn9pI7lzUBkRpAnt4B4l+Z79ol3pAzHTpnSW07DvBndzib
	 ZhNDqTklt33uq/HLSKFIfTY4ALE8Ad1Zq07bvoxKw5T0WMrq3umtoi3U0POWjLEPdqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BeXCqpONNCldal8VlKGSyHYZ5z/lvORoyC66Ic0fMMk=;
	b=Z4icSlD+NEYh9i+o9IWRthljtQNX45hjFknhE0jXXwJmxeLsXB10w5YqrY7wIsDrtOnX
	 y8ARfQqsQbMQY04yhdM05Y7ljfN3m/ViVN/5GCyTRdSKjrJ+xeT29E/6NJhY4+GzTfJ73
	 kFKQJ3fmFIABJFghfRGYRXXzZCrNKsGvsYwUSkOoG2+nEJSC/vrCMKUNnO+CMLYFV8gr+
	 r4mKYkmP49sEt2MXb9A/e4eknSASrJhzgYFDGfTsRx0TkT+DPXC+tnXZfFs+QmEhBMZq1
	 r1ydaudPSoEtnzfSpelDOS6ol60C2pXsGielFHY4fF9R5LfcYT8mypblg+cCrvmZSWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fJaJD8PA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B839A606A325;
	Thu, 19 Nov 2026 02:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fJaJD8PA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1350C1F000C6;
	Thu, 19 Nov 2026 02:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055246;
	bh=BeXCqpONNCldal8VlKGSyHYZ5z/lvORoyC66Ic0fMMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fJaJD8PAL3jpa3hHEFSTwuZ7vdgYrAuvgwxBfojEeaKQleGOdPtAZcnYs9SmGKGFU
	 29rxJeHvCqvZdiaCy3Tm0t7iOEPNAAPyCJUfsowfsPrr3LGN3b670x11xVNZYC5RE+
	 oURMCzB/XvZ/RwqSRyvPkcC4tGPoofdqmNEt3uRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1564/2214] swim: Enable the drive when probing
Date: Wed, 18 Nov 2026 15:54:00 +0100
Message-ID: <20261118150114.629367806@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 57d88c8f4ea34a4dd7c5351bd026e225c7283f3f ]

According to the ISM spec, the MOTON bit "causes the Enable 1 and Enable 2
signals to be turned on to the drive." It doesn't actually turn on the
motor. When selecting a drive, enable MOTON. Disable it upon eject or
release. This fixes detection of the Sony FDHD drive.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/f5bf5b596a33a801faaaaa6dc2844c30d3ee82b2.1788513996.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 77fe8e81dbb17..f956a2e40f70b 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -154,8 +154,9 @@ struct iwm {
 /*----------------------------------------------------------------------------*/
 
 enum drive_location {
-	INTERNAL_DRIVE = 0x02,
-	EXTERNAL_DRIVE = 0x04,
+	NO_DRIVE = 0,
+	INTERNAL_DRIVE = BIT(1),
+	EXTERNAL_DRIVE = BIT(2),
 };
 
 enum media_type {
@@ -310,9 +311,15 @@ static inline void swim_drive(struct swim __iomem *base,
 	if (location == INTERNAL_DRIVE) {
 		swim_write(base, mode0, EXTERNAL_DRIVE); /* clear drive 1 bit */
 		swim_write(base, mode1, INTERNAL_DRIVE); /* set drive 0 bit */
+		swim_write(base, mode1, MOTON);
 	} else if (location == EXTERNAL_DRIVE) {
 		swim_write(base, mode0, INTERNAL_DRIVE); /* clear drive 0 bit */
 		swim_write(base, mode1, EXTERNAL_DRIVE); /* set drive 1 bit */
+		swim_write(base, mode1, MOTON);
+	} else {
+		swim_write(base, mode0, INTERNAL_DRIVE);
+		swim_write(base, mode0, EXTERNAL_DRIVE);
+		swim_write(base, mode0, MOTON);
 	}
 }
 
@@ -446,6 +453,7 @@ static int floppy_eject(struct floppy_state *fs)
 	swim_drive(base, fs->location);
 	swim_motor(base, OFF);
 	swim_eject(base);
+	swim_drive(base, NO_DRIVE);
 
 	fs->disk_in = 0;
 	fs->ejected = 1;
@@ -653,8 +661,10 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	else if (fs->ref_count > 0)
 		--fs->ref_count;
 
-	if (fs->ref_count == 0)
+	if (fs->ref_count == 0) {
 		swim_motor(base, OFF);
+		swim_drive(base, NO_DRIVE);
+	}
 	return err;
 }
 
@@ -683,6 +693,7 @@ static void floppy_release(struct gendisk *disk, fmode_t mode)
 	if (fs->ref_count == 0) {
 		swim_drive(base, fs->location);
 		swim_motor(base, OFF);
+		swim_drive(base, NO_DRIVE);
 	}
 	mutex_unlock(&swim_mutex);
 }
@@ -788,6 +799,7 @@ static int swim_floppy_init(struct swim_priv *swd)
 	if (swim_readbit(base, DRIVE_PRESENT) &&
 	    !swim_readbit(base, ONEMEG_DRIVE))
 		swim_add_floppy(swd, EXTERNAL_DRIVE);
+	swim_drive(base, NO_DRIVE);
 
 	/* register floppy drives */
 
-- 
2.53.0



