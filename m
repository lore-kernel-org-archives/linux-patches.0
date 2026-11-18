Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048487;
	b=tIWE4/5oGAIhF/fEfvcS+a/V4dwz08WGVknM4vhyc6Jo6gTLrZbYifyE6I4gxKFPR2Bi
	 3wIK8LKcjGZCVKQRFsr2srP2pVGRjAn/5JpoOcwWyiWmvjnZDVRYwd5uZHWTu47tpTA+6
	 9venNnmSVKMBJ7Onc33e79mSRW2pm616Furrg8djTOf0z9sGNDL8Wz5iXWd3H1L7uLyFW
	 e9J8MFc8ywbQV+cZqce6yvO1M/SU5jKFxn6TchlOuJ2GB86JvLm5wMQj46DVUJw8jQhiU
	 3srOOL/8XnqsTfUe2XbUn1nzmtwxoaXI1jRKFvEKHFYOqK7YEeBemVVY3JX3MSJqsXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=URyjl6VwluCtBfqXN9JaEygAxQv3sqI/0JAxszGBcyM=;
	b=caYZ8zPpCOgqwyZ9JbdTt4UCByIopNglPsj54g7Y8hnZamQLVaugBjH6xYnFSeGHmLCY
	 1+yWX0Sf6rRbio0Bm5SDZzOUtcSi1rLHu55Yy78FeCC2tJpdEdIUpkEpiMngZ6FJ7Z1Qa
	 pr2RXuYr9c72FJ29+fPP06d4U2DlfOFZQtZmVGZEe4xlI0KFzbmrI/em9pwoICeT6pN7k
	 D74LKPR175Hhlpko74sHD9gxrsNywNHoG2OEABh3vqzQVPFIiMCsNVvb1gtc7Yj1Hg3Xw
	 7pvXQILg3qrVRDdC9tHXgnsGVLObEwSvMfV5Qhzw1DlCdHUvy7T/zccmdyT6TJiJdlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uE2VkQF8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762E7606A320;
	Thu, 19 Nov 2026 00:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uE2VkQF8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7111F000C4;
	Thu, 19 Nov 2026 00:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048487;
	bh=URyjl6VwluCtBfqXN9JaEygAxQv3sqI/0JAxszGBcyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uE2VkQF8X8KN2Q4+6jZ4jWdileF3dIFRxt0kSqr6hOpBnpGX/I7/9vj3TnAdnx/Ps
	 pU6Qkn42egm59BhqSKO4fqyB8uiJG3QQcKlaMlkPC0sN3jYdnqo1vaY0FgXlGmsfIS
	 WbxgE+LHJm/OgyguyJmWyOSWNzYIm7WCjDDp4P3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2012/2857] swim: Enable the drive when probing
Date: Wed, 18 Nov 2026 15:50:46 +0100
Message-ID: <20261118150313.841926433@linuxfoundation.org>
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
index fd050d06ad3c0..f0aef4b963443 100644
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
@@ -311,9 +312,15 @@ static inline void swim_drive(struct swim __iomem *base,
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
 
@@ -447,6 +454,7 @@ static int floppy_eject(struct floppy_state *fs)
 	swim_drive(base, fs->location);
 	swim_motor(base, OFF);
 	swim_eject(base);
+	swim_drive(base, NO_DRIVE);
 
 	fs->disk_in = 0;
 	fs->ejected = 1;
@@ -654,8 +662,10 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	else if (fs->ref_count > 0)
 		--fs->ref_count;
 
-	if (fs->ref_count == 0)
+	if (fs->ref_count == 0) {
 		swim_motor(base, OFF);
+		swim_drive(base, NO_DRIVE);
+	}
 	return err;
 }
 
@@ -684,6 +694,7 @@ static void floppy_release(struct gendisk *disk, fmode_t mode)
 	if (fs->ref_count == 0) {
 		swim_drive(base, fs->location);
 		swim_motor(base, OFF);
+		swim_drive(base, NO_DRIVE);
 	}
 	mutex_unlock(&swim_mutex);
 }
@@ -803,6 +814,7 @@ static int swim_floppy_init(struct swim_priv *swd)
 	if (swim_readbit(base, DRIVE_PRESENT) &&
 	    !swim_readbit(base, ONEMEG_DRIVE))
 		swim_add_floppy(swd, EXTERNAL_DRIVE);
+	swim_drive(base, NO_DRIVE);
 
 	/* register floppy drives */
 
-- 
2.53.0



