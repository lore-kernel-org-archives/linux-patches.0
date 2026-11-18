Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030378;
	b=XZUFpC/6NxFv16o93LZ89UTgRpQHhydrkXb/AOIkBULlk4HTRMhaABpmc7RXDEmcq3Gr
	 HlNWj1KHR1SUR95VbYBzFaChnlLDWi4P6IyrFx/nAYhdDg7tVUZ7avKDwFxvOb18MxAvJ
	 XAYkU0GsKDUSplWvcmHMFKP12HpnhsxXFUB60W/RXVdsadZ8BJQ8RYxJJyXi3ppiBw9qP
	 DfQLIaBIhEAX6Q+V54Z5pQsCWCLRyb1MsAKD/Ho1Qvvt2EJMTiax6fyOYEFHC6SsELDI3
	 SCZQLWItjXQBPvsEIW2rg47HdHuwSQKxf/j7jiX1O94lNl1bhn2BW7OLrEV31uMc3Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uH49pd8eVesYC/hlBtldzEIUyVwBL8dRGvwzkg7JF9Q=;
	b=xOt3C/JvgEcgXYZF9RM69t4nlgnP0/5idtvasPm3vShE1TADu2jirvP9uhUcBKSuKe+J
	 ZMZdi9NZw7lXee0tc42US4A0PLhOqnIBQjuTBkXLOikDLXsooIepxUCoe8FQySJFCvzzT
	 FVUFuAzQb+7tSRZiI8QjtZdFdTSRovTXaSEqdLUGht3Kzw1bvKUwWRMhz+DDCnvsVqMIa
	 vtBK9T7+81KaEAA3R7CG2mY4mJ/mT9Mt94zm00Jkh1MtfritMdNPfGXPhSebgn69xmFUz
	 GnPlRpgNS3MPrcqfIVLEUCEGquwjP2qk56HD2IT2sKyltyLoAljJd9/+th09V5nCt5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qh5pV5YY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9706606B120;
	Wed, 18 Nov 2026 19:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qh5pV5YY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6BE1F000C4;
	Wed, 18 Nov 2026 19:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030378;
	bh=uH49pd8eVesYC/hlBtldzEIUyVwBL8dRGvwzkg7JF9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qh5pV5YYORWcftyZfCGMqxrOwougSv0sKt7ntrXBNQYBA602ypQp6hrpujm7Pis1u
	 z+w15n6ci22l3AxUzbABjrX+RadJPlGMKc2v9M3ncFvKcmacenaHtURfeodh3xvHjX
	 9TJAvJB4sYOBANgkXZIPRYqAxx3DpZKgWMGnr4R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0682/1756] swim3: Fix FDEJECT ioctl for exclusive open
Date: Wed, 18 Nov 2026 15:46:49 +0100
Message-ID: <20261118150036.397266871@linuxfoundation.org>
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
index 9914153b365b6..64671ef9f18c9 100644
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



