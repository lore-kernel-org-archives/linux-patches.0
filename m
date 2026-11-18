Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024808;
	b=CfB/NLczPtXbhpPPemEuJY9+1SAinuRXno7mjD5PL6k7rduj+QiAYCs5EepzSMgPN8kQ
	 Vf6P0zIybnXKeriQSSlamoZbcyi+7rnq4Sek0mlNnk4/403ENHdINZELPK/ahWdHt2q9p
	 5j8db3WwC2hplmhvigCLBSu/wNnCLAW6MnICU9mz08wIPAccpK/6SpN+Xy1DqFoioSHgQ
	 Jq1WVkrhUZvJZhbgh0QGT5BrB50DdRL2ZZ57Q8M7LksKkiShCswdQnBQgYUkZi5uuFZwv
	 zgkSVQinAp2d21sphPa1MlWdo4R6e1B0k3P/x54+ePQZgBXFG5q5+cc77ECIIxvzYfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oa21hlXdrSk+9AYiOxPNUmaapTa3sOZBX4G06M71oKg=;
	b=aSzPCTBwsk4sMbbqQ966Taun888WdBqKMEHotv73HF9i0mmZAbeoTUN7j7SQQ7rIqZGS
	 7CiI7/ebc2vM8vRHarJrzLzFhmuhLol8djugycdTNM8Wu/4mhz0Y9stp2DmRl7NuaYItr
	 pCEq4wnXCLcfGEbCpKk5RC5deBAQehl+6YeW+0iWKYxpsOe3lMu66aOgLLEYWQl9VWtq6
	 zVRSr8/o6XFRcXbz/JPdX+33JvdULQP6MkbvMz9HNdR66lSXHtrJHCusSkRskOg+dlEWI
	 FmrrONHAWO33r/f++orgptbsrRFMX00x4lX/nP5iJ2JyyCLISS+1qTyh4brqojteL6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jTJ/0ewO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D3A606A320;
	Wed, 18 Nov 2026 18:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jTJ/0ewO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F6C1F000C4;
	Wed, 18 Nov 2026 18:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024808;
	bh=oa21hlXdrSk+9AYiOxPNUmaapTa3sOZBX4G06M71oKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jTJ/0ewO1Qbp5cBo0XEUX/hXSk0JpshRmjrEQhL/a2NlOqAfztWeqzdjQSdI47DFu
	 lWxjmxyIjABIzE8wZZaEUnXj/UZtopszOg+WmVXdJzyuSc1cB9lcoUlwvgqKH8xGku
	 4qAmMlQ31lz73gizvfKgRQRWUWQ+hPXl+87WWqJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0855/2151] swim: Fix FDEJECT ioctl for exclusive open
Date: Wed, 18 Nov 2026 15:43:10 +0100
Message-ID: <20261118150153.390293950@linuxfoundation.org>
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
index 9057dca830c5f..9c63e67c556c7 100644
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



