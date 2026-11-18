Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030033;
	b=Pvd0RUcVrc3rh6CjQStCnFac391YDf976dVuyw09B6/CAaOKCuQeJf6mkLrgZBQ4/UqL
	 8zDUq/mh3AzwdSnZFV5xnIUSHlzuQIIKgbKhkjY3hAA9BtGg+m2+Q8BD4R0xM9mB+coAI
	 Xxa8K2Zey3VINp0inLe0KJq9AP3FKv9dCNPz9YqR2pGvdOoCrmkHhP8JewUhScN2fybzV
	 r934mhFn/VySkNKuBW5aRgf8PpQtEZiPKl+k+uu+LICmmAniP0WFgPU1ltqo0doIsc9Gc
	 XuBq1aS4e2jowSme47XQ4fW/QMyqzpzPEslGaSXi/6HWdmHqOhDJjUUNb86t8JlC5xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FePQA+VoJ4vqTCHAqwvDgHAGSRcSwZje40JvQh0JwU0=;
	b=nVVp8+MWnxptxNfDacW29PWGB66Y8+MfsDzOhrVYT3kTuplurv+q6DBE1M83G/nxxGqD
	 vmcb3am38j7LUxi4FfhFlL8OGiYSVLEQvI8aVJFLb+9zMOaaXcfUvvYbMxVvOTYqSwbdf
	 MiLhjA1rCemNjFBT5GT7oFD+8h5mGWihQcY3GOxCsf06QM9DxbvsaQL82sEo1oOAEOjuO
	 T6kZFdhpADG5KzvjrI/kORQbH3mGDNITmnF0SXjavfq6FyCi0KhhoR24UIYiVwyElYRUq
	 Sf0hxAYBuCdmdwjwnJmA7jZqTglm4X1jfPnzvRpOIKd45P7BOvwCZsuUhk9Z8ZbWLRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="T6/iwS5I";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF53606A31C;
	Wed, 18 Nov 2026 19:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T6/iwS5I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F761F000C4;
	Wed, 18 Nov 2026 19:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030033;
	bh=FePQA+VoJ4vqTCHAqwvDgHAGSRcSwZje40JvQh0JwU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6/iwS5IeLZ/lmIACsVzmwIUKos3iB0bzmsNOU4BHUIV1OJdo8LPbWH4k+JRlw8bD
	 56RpColra0uuYd0jdDQECZI3ZUikVRgT45YEDGuUHgVRWDGVeBjGC88ifmbTm6Q2zX
	 sR1bjJCrWyRzz95B4337PXFkZtoeDUZvbjCZxt7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0519/1756] swim: Enable the drive when probing
Date: Wed, 18 Nov 2026 15:44:06 +0100
Message-ID: <20261118150029.823724472@linuxfoundation.org>
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
index 83842dc667374..d69dfd6a824a5 100644
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
@@ -804,6 +815,7 @@ static int swim_floppy_init(struct swim_priv *swd)
 	if (swim_readbit(base, DRIVE_PRESENT) &&
 	    !swim_readbit(base, ONEMEG_DRIVE))
 		swim_add_floppy(swd, EXTERNAL_DRIVE);
+	swim_drive(base, NO_DRIVE);
 
 	/* register floppy drives */
 
-- 
2.53.0



