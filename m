Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055526;
	b=sdAMPqUbWU5E6R+RXKpplGQhlh77aNhwNluyzuAflhgKiwnpvQ3lEJ6BmdbGHo6scJzy
	 p9EFTRPFjWGw+E83APS4qorb0iCnbN9pWPioarhlzc+5U7fDEuG9+7leRpjif4BknEDKG
	 atjyungtKgo0+Wy9oYSwgyrBgilqoy9JPFRVfjHP0aksBIWLc8RcvimIsa4UNUkVLe75+
	 MeF1RScIu4fXMov3twU0rP52J0cAT/8lDNNmb5X0OARHF2zx0vn99c8U8oCJwl76452Eo
	 TnGS3k/wtWVVmG5nw/E2MyfKHm97vzorg+iiXqUNKMasrzeqzJz0pEemMMmg8/y2JzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055526;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WOU2Sk/k3fClc9hdQKrlQLdeRztc98C3K6FNUJaapl0=;
	b=oEJuWJ5RQq4kHeCvMDKhHN/Act84kpb4casFiVtcp4HOGJbkeArvj0kQ9qegDh4gulZL
	 cuSqWnaCYC8T9Br6uKB94LUaO103teZbMZO8nOs7yKxaMEwl6xjdQpdg9vy5EovTotNE3
	 nQgN7v+MQ1fvqarvzHzJQ5jr84Bdvm6d1XBHIwVZR6gfyDXHFf3htYJmzZj4D9ofr7RaI
	 xxI7ccWnI/WiVBZJ0qSa9DXbWGuolPZGtv074vV1XJYop6w4WElTkR7ia0YGe2ykNUYrD
	 Hhqt/Pn1FxZsKSGcCRvkGyTsrXE+h1XMX6IYNr3hh+aCDVMkw6kDsjQEk/HjkQsqSMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nCMZ4a1l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DF2606A320;
	Thu, 19 Nov 2026 02:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nCMZ4a1l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349E41F000C4;
	Thu, 19 Nov 2026 02:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055526;
	bh=WOU2Sk/k3fClc9hdQKrlQLdeRztc98C3K6FNUJaapl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nCMZ4a1lfPgtGCt1KHdwV49TOvedJK/41BsLZL/B6XAXdoPn/oygxkUlLbTgtP5dv
	 Y46UWe+Cjlgrl+79dkN7ukNXTJsCEzVX2rkCaJ1AIiCqRmfMvL2ivAi8eqpKmsodlW
	 75w3UJ1fRf2uFlEaW1mAEK+a7PQWnQvS8E48KzFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1663/2214] swim3: Fix FDEJECT ioctl for exclusive open
Date: Wed, 18 Nov 2026 15:55:39 +0100
Message-ID: <20261118150118.388776917@linuxfoundation.org>
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
index 965af0a3e95b1..10f72835045bc 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -886,7 +886,6 @@ static int floppy_locked_ioctl(struct block_device *bdev, fmode_t mode,
 			unsigned int cmd, unsigned long param)
 {
 	struct floppy_state *fs = bdev->bd_disk->private_data;
-	int err;
 		
 	if ((cmd & 0x80) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -897,10 +896,9 @@ static int floppy_locked_ioctl(struct block_device *bdev, fmode_t mode,
 
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



