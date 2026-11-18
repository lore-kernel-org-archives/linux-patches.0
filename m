Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048910;
	b=imBIiCQd1J6Ch5P2IqGEwlSNfb8MaBB+0vB7jcVcBhixGucAHhAWt9fKA9z2Le9yvPVY
	 zRALCkUGL0UcAzi5VQ9+oO8A5LLr8KUFWpWm6oFXpOBh/cZgy1h3foTQzeDpenHsJlzxe
	 SHb6DonAXun7YRU80p2OhqafFYMN+PKt1kyAdH/vNvXRQfdwq/ds1N0EPAytQfGh5uDXO
	 JL2L6azC4SVX5JL7j1NQ0RQZtmPRVuxBY3Sa1A2R2IeFFgQwAYih6zwys7jIHCS40B8tK
	 S4NJlrxDiCvKpp7jDKlZpD3t+kMpu8zcqI5o+LJZ23lRfYmw7tDBCZn67e7j0IPMKgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mSeWQ9h41pulX7hJGZluHBPeaItqEAw+0AJlbbFt7mM=;
	b=FEUL8hYwKrW1Z7iKT16l4yNroUsI6CQ3NqvRsV+bO+VOKfD0gXRhV/Qd05uOv2LG3K+Z
	 2l6Xa5/2BgkAgRx4SY6StfHLEAg/xzGJdtF/7XUwIasL/0kx1jd1u9qjMSue5VYzvLxUl
	 ZEH4DJp+oRb1nY3TRB72hyBBd3V8pckDP1+GDXV2+Om+ODe+SS07BRDUu/1SISiA7agro
	 Ia0Q0JPF9jddyOVh7N0iHH4MQTRHzmWZ9CmU9gLI/Hxy7IFeocQfiJVr1a7v6h31aLZ2H
	 teVER3cfu0DQ9B/aX69sMqDtLdFLu11AKdEpdl8ZJB7l/3DC8c1Uxsiyoxh68Ips5iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EtxByl+u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3AD606A31C;
	Thu, 19 Nov 2026 00:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EtxByl+u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B601F000C4;
	Thu, 19 Nov 2026 00:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048910;
	bh=mSeWQ9h41pulX7hJGZluHBPeaItqEAw+0AJlbbFt7mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EtxByl+uCJcDzitwJuLuysMdNOXJnyZmzcnBPKF4LdQ3aKtTb7NLVffJWwdvlllKT
	 EDI3UCuAvvuo6y/GtUVajOM69OgPej1vtPZ8VrIsq84r/hthfX9O8HW2NICaxMJ5OY
	 QYhPctUmZ+2ckixhF7YE+yYVNN7Sfz4z2NEx9HPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2123/2857] swim: Fix FDEJECT ioctl for exclusive open
Date: Wed, 18 Nov 2026 15:52:37 +0100
Message-ID: <20261118150317.841177314@linuxfoundation.org>
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

[ Upstream commit c76b93df9ae61d8ddebf6aa3bc218252f85e80c6 ]

The eject command from the util-linux package does not work with the swim
driver: the drive doesn't eject anything and the command fails.
Apparently, ioctl(fd, FDEJECT) returns -EBUSY when fd is opened O_EXCL.
Fix this by checking ref_count for either 1 or -1. Either value means that
the caller is the sole user of the disk.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Link: https://patch.msgid.link/ae3ee8e86833a2739d7857460cbe2addf4146088.1790641175.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 6b9a07d0f7c5a..7a5186d1700b5 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -696,10 +696,11 @@ static int floppy_ioctl(struct block_device *bdev, fmode_t mode,
 
 	switch (cmd) {
 	case FDEJECT:
-		if (fs->ref_count != 1)
-			return -EBUSY;
 		mutex_lock(&swim_mutex);
-		err = floppy_eject(fs);
+		if (fs->ref_count == -1 || fs->ref_count == 1)
+			err = floppy_eject(fs);
+		else
+			err = -EBUSY;
 		mutex_unlock(&swim_mutex);
 		return err;
 
-- 
2.53.0



