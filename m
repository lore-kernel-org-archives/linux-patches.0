Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055524;
	b=ElJ4/SiI/IH0rRym6S21PZgCR/8rVI5Tt+m/KL4VTFhu6WZbKuZavjdCw8UyaOdL42Mk
	 15Zs9VS6q4yxROAwf4uvXnVtyicdF28BNB0PN1N/1Oh6CHhPKidbGHH9Wg/sCTNJ5pVgp
	 zIzM4CEpR8rgXV1mF8oAptp/fmDWmr5egijZKHgHXRZLbyHBy+P6Jbc2+n/LAorz+x2v/
	 0Ggekgiy4TE0PMg1q//+8i6AB0yoB75p6ACYxloDMmJf1SZ15nu9rp98ANvmU5+RTXVsm
	 ZFu5FRprflK22QfXG53SN6uxjaHEMM9E7V9RX0cEaZuO4ab9s7ska9WaT2b3W6MqOjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=meORVWfUvjZvzo4aHvv+GB3kWvPELpicCHWDj+0yFpw=;
	b=j7q4OzxRozimcX3JhcDqx4bTcXRj/ZCdeF+HO9X1wCpYN4sbVU/SSHNH6kLZz2ykjq6v
	 HcFZrvDGP/G3F3P4VeZQ4zbBbAMuZd4N4Q6XldGGuXfbSjBHmhEbFrK5VofIleIHgs012
	 t/EoGJF3dCrpxy1O3wIP11a6vZu2lkfipX3WP5mmXSateaBzojh9QY5k9pjItR0g83zSk
	 UC9yB9mZamxX6T2Qf3kIhfLPz+1BIboe5itkC9hJLoD8g61EW1/JwOv6/Z7SWEYLt1F5n
	 3vQKESuRCqMG+zkhMdn2XuywPQ33gXGBkIMro7SYdxYy0xG2LPMQEZkU35MvtOrYZhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u+HyKE99;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D472606A325;
	Thu, 19 Nov 2026 02:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u+HyKE99
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6BB1F000C4;
	Thu, 19 Nov 2026 02:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055523;
	bh=meORVWfUvjZvzo4aHvv+GB3kWvPELpicCHWDj+0yFpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u+HyKE991bOqhtaLh5GiLXrTj6CMZ0kBc9apHJ1oAGyCOHjSsdSj/RK6LGeoPekTi
	 K5i5dDO04aGJ7OzxVgIPrhyH4XOLsi5OvqRM8pnTHc1n3rMdjjYE4fs8DydDBatryt
	 TDYvUXoVhaqBin5vSq1g0hGB0td6/LTKMxx5Rzv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1662/2214] swim: Fix FDEJECT ioctl for exclusive open
Date: Wed, 18 Nov 2026 15:55:38 +0100
Message-ID: <20261118150118.349671284@linuxfoundation.org>
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
index 155ff90599b61..133b49f5ff4a3 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -695,10 +695,11 @@ static int floppy_ioctl(struct block_device *bdev, fmode_t mode,
 
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



