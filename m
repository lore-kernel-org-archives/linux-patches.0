Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040411;
	b=WuOEsdoB2ZCDD2Gs9Ncg2Ge84Oe0uPBM3kLalqE3ej70gKP2bpGAUzqDfLl+9SqJguW9
	 UHNy6JhKr/6vaU/auI1aTyh5jnDJTBEIGh6ZbjRZbsKh/v5XDVb1SKtzjqTUx4MLwjwyf
	 q2SIQ2xTLgs2LDBng+MkmlzspkoywFaEyzPCmtctX4NlEhBvfjAhuO625cjYzmbYuj8OQ
	 u6Wc0w5yNb+U/gBlqNQASxU1gCkitodEcivYWr0kwNGuoKoQb8EmWudy4OzInLDNv8fBs
	 DPHFfyuEhgK6o2RS824U0/V8IkEZiimRHJKubpn+P8oE8YLLKgnTMPIrQaJOTplzNfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iCQ+dGPhHmEIHx1iX9yP0IoAQ/GZ3axffbSI/3uYyjk=;
	b=mKm2JPsUR7dHRgPmQL4dsQqgUZL+fSO+3t+Ra+ul5dEMhFGr51aMFaDsrd9kK9DLAHQV
	 qmfqdwQ0adtmEQVbrDSeOV7C/OCPsmJHNZF+6SirvcqsuSa9hnxE62b9j2gKC3R2vZ7vo
	 1HUMfshY30UCYfPskfDQMm2LYZUxDEsmHuE7cnIiE+FSMnau9sqFaFSQst3x7e8JnI4vl
	 krfG3sFoYYDT9JGhxqRiAcwtZiBZE0W1IWpNLRKB4BbWUt8yn7VqBrSlxrLuTZDAHtH+S
	 rWJHffbwhjpygFHAVGfdKWQyHRq3Sm8x3StnGnkACHrcfIKHgORDldSmyDsy51Fiytw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TKPZkvVB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119C5606A320;
	Wed, 18 Nov 2026 22:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TKPZkvVB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636941F000C5;
	Wed, 18 Nov 2026 22:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040410;
	bh=iCQ+dGPhHmEIHx1iX9yP0IoAQ/GZ3axffbSI/3uYyjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TKPZkvVBS34tg9W18C0Ur1E2Kw5h65CN6M/yg3r345qgGKRkVOu7SSKOEWTvcBG0f
	 1Bdjuy6SPSsDGo2d3QWQCyFQSta/qCyVu0FOXbonXSNUucYS+GCSl4fFNRJtkQBYdc
	 cpVZdEu7q9bkdp8r2h7lWLacoiQFrECP3fLmEkkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2445/3318] swim3: Fix FDEJECT ioctl for exclusive open
Date: Wed, 18 Nov 2026 15:51:07 +0100
Message-ID: <20261118150434.796436466@linuxfoundation.org>
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

[ Upstream commit ce054fbe9a4bf4ffefef0f8e2504ea54da058ed2 ]

The eject command from the util-linux package does not work with the
swim3 driver: the drive doesn't eject anything and the command fails.
Apparently, ioctl(fd, FDEJECT) returns -EBUSY after fd was opened O_EXCL.
Fix this by checking ref_count for either 1 or -1. Either value means that
the caller is the sole user of the disk.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Link: https://patch.msgid.link/f4cb43726ee6f1cf159a6208f77b4cceea670a3c.1790641175.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim3.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index c2bc85826358e..6ac8f32bb5986 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -886,7 +886,6 @@ static int floppy_locked_ioctl(struct block_device *bdev, blk_mode_t mode,
 			unsigned int cmd, unsigned long param)
 {
 	struct floppy_state *fs = bdev->bd_disk->private_data;
-	int err;
 		
 	if ((cmd & 0x80) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -897,10 +896,9 @@ static int floppy_locked_ioctl(struct block_device *bdev, blk_mode_t mode,
 
 	switch (cmd) {
 	case FDEJECT:
-		if (fs->ref_count != 1)
-			return -EBUSY;
-		err = fd_eject(fs);
-		return err;
+		if (fs->ref_count == -1 || fs->ref_count == 1)
+			return fd_eject(fs);
+		return -EBUSY;
 	case FDGETPRM:
 	        if (copy_to_user((void __user *) param, &floppy_type,
 				 sizeof(struct floppy_struct)))
-- 
2.53.0



