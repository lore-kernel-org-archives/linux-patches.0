Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048913;
	b=crpJbpLh9M/Z1SB/EtYBeoX/eWqxplsVDq5HQa3kZm151chegPiZczvNqBx6qG8BhLjW
	 Pl1ASeQcow7vmYkGDn67DYWN1rKXsHVAXKn78xPVRyHLO5JcMbsHCeXy8WxeuE1KcJ+pu
	 eHFKcVJIA0Ae/57Yov43r+F6YLfyMxu7SdiptgiqA4PF3AfNtxQ3ZD1xq+Lu9iRFFAdwf
	 wwFcnF7yc/MDnnfdpwclYobV/W5mT4X3mCKLEGrwL8kXFTfP6P98ebWtlzM2s4ohJYiW2
	 klb0POtUo6Dgt6kxT0ST5hCwiuU1vwHdCaTpJrjMmMOuKO0P1erYwBf0Hqn32wvUEjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H+WhkM11Lwt25z7kwcmvDX94OdMkXFIWVygPTsr772E=;
	b=bNLEsa3MRyIAvajcPrIJy/lsq5uWKvf5OcfKpbwtY/2PILfoZrOMIH3Q7BuoJi3iDRDN
	 ms0JmYfyN2dtEYlX0LPG1n3qyOvAdtMyQT9z9PmENyHMMdy1T7G9M2eqxg6amzG2PXzsT
	 hNY8EXevTbZip2eY+LiDZeMt9uzQSmJeIYt64hwyK1KF3oDuruL2o8ofNX6n6nTJ6kKqd
	 X0edUgn2urQI4BUghI3N5mEFyoViqyFlSl4iI/enFOjrcXJGb0Xp6jfBMrOkO8ghDkECo
	 Dn8Rh4N0mTN+oqX3nuPuwKLnKAW9gXydZo33Sq9drJ524PVahRNQ72jSMuhbYmMEvDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ND0ezNz1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6A5606A31C;
	Thu, 19 Nov 2026 00:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ND0ezNz1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDCD1F000C4;
	Thu, 19 Nov 2026 00:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048913;
	bh=H+WhkM11Lwt25z7kwcmvDX94OdMkXFIWVygPTsr772E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ND0ezNz1kDc6DxudabdtH7CSieoUZ4FmbWYSxWYCCN12x6IViyim72RWr1g/WM4+u
	 duwOGYNX41/cVU3D3AS+VlnLgf6g4d3ACxY7m7ogEJhvszyFU6YQ3pzzttgKe8R7ky
	 37s5NabQ9hdQV7/jLDWDL4kcDj/9g1dPsKtUy4yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2124/2857] swim3: Fix FDEJECT ioctl for exclusive open
Date: Wed, 18 Nov 2026 15:52:38 +0100
Message-ID: <20261118150317.878600071@linuxfoundation.org>
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
index da811a7da03f3..3fe5dcbca83d6 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -887,7 +887,6 @@ static int floppy_locked_ioctl(struct block_device *bdev, fmode_t mode,
 			unsigned int cmd, unsigned long param)
 {
 	struct floppy_state *fs = bdev->bd_disk->private_data;
-	int err;
 		
 	if ((cmd & 0x80) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -898,10 +897,9 @@ static int floppy_locked_ioctl(struct block_device *bdev, fmode_t mode,
 
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



