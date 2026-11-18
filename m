Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040026;
	b=efkmg9Kj2q+cjZeTRPD8Bh3sMmaLTuW7I57XQu6qtjabsweowmfUTT/zF6iJevi0m5Tk
	 UOxVHiUGdArYs8DTiWpnnDA1BeLF0B4Dh0frwRxalSdQ9pDw+sDBwqi9WZ/qWFkXyBhKf
	 hi7P/7cJcZuyZTATbHK4dIos+O7MVp8ps616D5CxfUeUEXnj+chZ7wMTwwLpTQAnfGNkk
	 ms8Mtpfp5uVEee1ksaeLbWIs6akWp2YJbw+NrybZ9Cg3zUpC7mA452ClGkGGSEOEJAN1J
	 U80nDSdFT0o+OntntZKJgBl6cDGwBQSUvNDgQPf1Ol7ou6ATN4R331Z/c6r1MN1Ecrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=srn4RNm8+1GzBb0goaUfQfnema878esiSWGmeLpQflo=;
	b=mhHYjvaUTm6bmUzQqsitkICWo4oQkox3NerzUqJdYA1i/IBJwVi7wUXe/Xk1yzhxwSZ/
	 mugLQ9qXvftXA24PxUV4ePrr2aqH0m2/VH3pEmkU/xHKi1JvlJh75W9jJ6Qq/uhKJCSwu
	 FDLoRr4ZsBvxWBsOLcTadSf7tDbbpHmBI6UaBwUHj0QKH56DwIbqo6Krpx3IrrUqwXv6t
	 r+VIQpKOGdBMy3cmpPP5He6+x6B8DHFBOHIGeSgC3hMuQ4EmYPRHFdcrylong4fLU1gCF
	 5gYHlbkmr+fy6PG9ExtbU/Zsr5ZI5PMD9uSBw7jPEdVCvWZiju+Yk2rZ/BDdRcR6PqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QAlmzOuV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7F2606A31C;
	Wed, 18 Nov 2026 22:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QAlmzOuV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE871F000C4;
	Wed, 18 Nov 2026 22:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040026;
	bh=srn4RNm8+1GzBb0goaUfQfnema878esiSWGmeLpQflo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QAlmzOuVxCMlhy6xH/1H/2gLk26wFrnmnx9p3dGPUL+pSYZTd6uxq5yOEKzTtD7De
	 q3btf6WNB55dO8TOSM5lCHN9XO2bqyfNi9Q9Xl7BYEEjG01H0gx8wCnSFxLEIjrtKY
	 fds11uaBMglAWBgONr2pxdI8pFX1pVQU/GyIZG0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2309/3318] swim: Enable the drive when probing
Date: Wed, 18 Nov 2026 15:48:51 +0100
Message-ID: <20261118150430.966926672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 73d360854ebea..061285df459b4 100644
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
@@ -652,8 +660,10 @@ static int floppy_open(struct gendisk *disk, blk_mode_t mode)
 	else if (fs->ref_count > 0)
 		--fs->ref_count;
 
-	if (fs->ref_count == 0)
+	if (fs->ref_count == 0) {
 		swim_motor(base, OFF);
+		swim_drive(base, NO_DRIVE);
+	}
 	return err;
 }
 
@@ -682,6 +692,7 @@ static void floppy_release(struct gendisk *disk)
 	if (fs->ref_count == 0) {
 		swim_drive(base, fs->location);
 		swim_motor(base, OFF);
+		swim_drive(base, NO_DRIVE);
 	}
 	mutex_unlock(&swim_mutex);
 }
@@ -801,6 +812,7 @@ static int swim_floppy_init(struct swim_priv *swd)
 	if (swim_readbit(base, DRIVE_PRESENT) &&
 	    !swim_readbit(base, ONEMEG_DRIVE))
 		swim_add_floppy(swd, EXTERNAL_DRIVE);
+	swim_drive(base, NO_DRIVE);
 
 	/* register floppy drives */
 
-- 
2.53.0



