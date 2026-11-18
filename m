Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024811;
	b=4ykvBEsP4qyTVgZtjWHak2tSCyp2tN8ET8b9FbU/qmRt0WXnVcpa73UvijIiaxTQCGsw
	 TmL+4FpZU6mL/SaSTAWhsPU8dQwMUkbU9pKbQSeS/nJvjaMkawoCvAkYnTyVWDl95Ye0L
	 n4REHdk9GiHmtS1KE8A9+J2RIJHAa5Qk51Tmn2ZVrAm/bkw4W6Z4qCLpAyoUhjyFEL0uX
	 FYRDAtrurgd6o/ZfFiMQtu1tZzjGOpD7zaIqM2zdwlLXm38jH6JXPBMXpOjBdwPWcd2Xn
	 Oz/uk4490ayImoal30iKPsr0Zvkvn/ArvWuag+tUItUq0E8UM5OoBdaHTy1H/BBhVYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9ApHPEnklTbySCs5KnFLYpger8577qxNE5U2xsYPuFQ=;
	b=Kls9pVHsw4jgTaVD4+1iFN9AVJcsknhiBofPxZfxOapytwH9frnDIlDkj38i5DjFGZtg
	 d59L/NSKQhHTsAIIKscTUCmVabPR404LHcVNztuESipbw0hBYf/ljzjXb/ihS6K3EP95+
	 W0HP2lqrZrhcXUaxAiv83z6UcqPGh8QS0FdgSB4hus3w+8t5oC55Q2cO0Bx6JubxCaHgi
	 wXUhWfoxGp67bmgCSL4HWp6hnCk/tmdhYW0jCHO6SobPtJBdkUtoz96Hge07DLUnoOdJe
	 LZR4no+v8jRu8Q9jJQzlOwiBq3MLgxVCIDarPlGHVrSpACcBBDtebHb/ZFh/O7i7e8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uaBJEC9Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F0D606A31C;
	Wed, 18 Nov 2026 18:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uaBJEC9Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA5F1F000C4;
	Wed, 18 Nov 2026 18:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024811;
	bh=9ApHPEnklTbySCs5KnFLYpger8577qxNE5U2xsYPuFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uaBJEC9QVzV1z+r8hDk82rg2xns2Qzk7cV4VZqpgYs8uhovkJ0c4Svqel3Nph0YYa
	 QK6uO0lQx+HAzOjUYT5uZgOFYcXBMgVqeknV40Sn0ZMv/YPMoXs82pzNVjthS6hgFZ
	 mvlm2IWaL2ovIV+KF1UkuzyU8K/pRh7TH1jfmvMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0856/2151] swim3: Fix FDEJECT ioctl for exclusive open
Date: Wed, 18 Nov 2026 15:43:11 +0100
Message-ID: <20261118150153.420409227@linuxfoundation.org>
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
index 01f7aef3fcfbc..b55cfe485bebd 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -887,7 +887,6 @@ static int floppy_locked_ioctl(struct block_device *bdev, blk_mode_t mode,
 			unsigned int cmd, unsigned long param)
 {
 	struct floppy_state *fs = bdev->bd_disk->private_data;
-	int err;
 		
 	if ((cmd & 0x80) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -898,10 +897,9 @@ static int floppy_locked_ioctl(struct block_device *bdev, blk_mode_t mode,
 
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



