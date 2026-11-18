Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030376;
	b=Cn2/czcvXhxuYYfcqxK7b3v2tF0SJzLLGwvoTXhmMY+C3kAxGXysLPNEPuhLZWTWGTcW
	 cJydqiPbwywGltFL4xKo4FD2DkzeRMaiTtzwiCvbO6MuqpVUTt0d2nkSOSCs3JrltNJ9u
	 KUOLSIYt024te/+cCCUhG7p6HN9JYEwEE202eHLEGX9xrFktueuLQ7svFrkA+zbon4ySv
	 LtKeZkjP8cuHHuXrr7+iU2EkZaaOgMA4ZkfewMKhyNaxmH3M1O/sVzZ/SeIJQr191c74w
	 fDfHB9BsHpjrZl101hwy8BnOdn4u2h5PbdT2XikSG2ZjBs6n6XN/OBdeLYZvX+kCWEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030376;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zHLwNQ3H6OcJ7xP0OI7tEj30CHDKrViVXVZmdKUDOY8=;
	b=4PggBkpJ9RPkVExQRbbLGrxrCnwPqCXXjRcdj7nvbyDtumXgNaneRgEtJPv+SFxy2Ahx
	 8FiaqPG/UaWXvYPHXfSv5MeTyydHU86IM1v4jC9Xqt+p+k8u0Xrnm4rwMH17uIC4kD6KZ
	 hPgxWBCXWCvVoYZc/p0ccZ/W/eS/vxWJLlhnuuIW3wGi8luupUe5kxgonpM7f8T+EbDHI
	 ng+t8LLokYADcH6iz2ZIN6xxEtzvEUJbAtmRRjd1ZijAYz8AAG/M1pA16pSr9eMhGL3ag
	 V0yjnsQdTwhwoD+rdgNHOzmXgS3sAaemIVIGRAmHrc6r6LkzBDReI8aqU/u1RQVZfcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fovSViHD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4174D606B120;
	Wed, 18 Nov 2026 19:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fovSViHD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4DE1F000C4;
	Wed, 18 Nov 2026 19:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030375;
	bh=zHLwNQ3H6OcJ7xP0OI7tEj30CHDKrViVXVZmdKUDOY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fovSViHDRCXh1fRNlYxHTw2ve5hAzm289zmozish4fj/T1XDarbLetUBIgDy1q1Rz
	 PGfzOCqyIOxC9+6bMGB3mW/bPWgaSlI3JiKbfoCGyatWu22/4JmVRWVy9PIn3L33IM
	 w+Yvyl5JbVe48PWfG+21okz8Sh0XLKmSkN2pyq4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0681/1756] swim: Fix FDEJECT ioctl for exclusive open
Date: Wed, 18 Nov 2026 15:46:48 +0100
Message-ID: <20261118150036.361450132@linuxfoundation.org>
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
index 0271e59f25ad7..968bb296bfe04 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -691,10 +691,11 @@ static int floppy_ioctl(struct block_device *bdev, blk_mode_t mode,
 
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



