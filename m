Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017780;
	b=lDLPpNfaMt4rkcZIoBAPcIPOMqCt9xG1wDli2v0TRLW2ZUK5BRAmb/tIKpLLfPezkTpi
	 DhGAb1qS79rbkxWnRuB0mHwL8Jl4xqXrFbsfxC4CI1+r7vMW1m1cmzr1dtdeX4MqXhVzK
	 Mp/9SF1HNrvJ3G0KClCc71/wZNudxNjIVX6ukAhzQJ82jH+74JYz0bvexae175lNO0s8D
	 HCQ8fXhfZjOV7Drm+EN3T/tMHu7nyjHjLMZKW+xGsiso2AC6QzoZx/Jd4PbzYbWWhzEpd
	 x/5nB+mQaGEF3bLoFso34Gfe4CSc/PjwO+qNFlfwuSL5C403Zuj6Hacv7HLpdlUKL+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yw682wHrb8K4CfA8N6UXm8j9lseS1A2yN0n9iPW+GDA=;
	b=j6OJ7MrLb0oGSRwdObfslQGHY/4iGPHbERgo5y7NAobPKNIAtMBu80WJn46RV9iF2HaX
	 hIq5CK2tGM29GpVZ2FlkjuZfGesnBSx7ZQWApI+NFAangSwyVd9OfT8sgg4W4VPQ8IxWx
	 FqD74o84HSiGduqAffEaMr29F4SKJzXHBcYse5PedOrIdI87WI53xvPsyPhlhiR91Fwy2
	 9HXXiE6gK4v6ia+pi/JjLBjsawbrrLfbcrpyLnmnrJ162wa+mEu6UZwjJ7Ca2oIkYS24M
	 0PcrbhVnSfQW3SJE76ha+FYs5FZ6UF9Uh+sOXBzxLY6lAG2LFhxk/qanOl8LvSx5zGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FtQ0Wyc0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E504606A31C;
	Wed, 18 Nov 2026 16:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FtQ0Wyc0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB24F1F000C5;
	Wed, 18 Nov 2026 16:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017780;
	bh=Yw682wHrb8K4CfA8N6UXm8j9lseS1A2yN0n9iPW+GDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FtQ0Wyc0v7BAPIwm6klj6lgOQFbNYXbPDp89ORb3/WLlcn4GGOF+5QEDtKg99jsLJ
	 YeYxNHVDcSx3/UnD8g/oNKv3Xtvdjn16WIUIt519PPamafSBmP8EFOdlb+5zdljTQT
	 /8vPeDs4XRO2EpthM1rf34j9XciZ1J4VvxK1KC28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1007/2651] swim3: Fix FDEJECT ioctl for exclusive open
Date: Wed, 18 Nov 2026 15:37:27 +0100
Message-ID: <20261118150324.172405882@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index d4f0d43e0a723..a03de4c4d35f0 100644
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



