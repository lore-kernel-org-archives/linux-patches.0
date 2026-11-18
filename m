Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040040;
	b=gPe3UBkcr/hsmLouQj6M7bH+GN9RNsQXUzpMIJF5AiWl6HNmpMbZNkQrpeY6ZH2zWibz
	 GpS/JFND060NsNQx6CE5Qo04ITm10UFAZotuOPIeZruEB9Jw64cViUd7oogEVrSKbDCrA
	 QC8h/XIGfw6NO2lBNjAIRKrUWGUHMFTZIO9dPpqAAliCWwTiToz6rUfrVIyjtomC2SukS
	 Q2XK4niNmDPIWHxGxu5IVghC307oRE1Tbtw34BqDnDYB2zteaBVtEDr7unqWbhzw57oA9
	 hD4deVKeg3k7eBze2nAd5t/4q2sdG9L2bELrGEa8BWb8CV6ZsemZeUz83oHXaPUXXzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gxt3zn2k6h9fTOpz3yfL8HpuWePmPkjI963cRLiUSCo=;
	b=Mft/fqi2GfFeSDE6qWGcF2sbq+xMTusFpp9GtjU+Obr6wF3eJEPIeKYfZjnRtlCCcuQj
	 3SDbP9LSMnDWBVJGV4MBePky5r7TAOXABrv0zTvNk43otFXLqs33sPdReIgS+8CwItZ7+
	 vTNzsClE2TeoTR8Bc+oYReD+IsFkZuYIYmZIfmtE+oV01O1aaR5WE+tg2wy21f1x+Mebr
	 fBvc7H0nOuJSphQdSuXZtaCyJ7uBdfPF6sJfiYV0nqbnL0i9xJlYEa9mqnw3Sy5Hh/1KC
	 v/ogHdKvXyX00FYD+KwKGoYaKex42nX/Rm2mS8PHIsmQYnldANnFU6wrNs1DGeLZwiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gWTEMifG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507EB606A31C;
	Wed, 18 Nov 2026 22:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gWTEMifG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87071F000C4;
	Wed, 18 Nov 2026 22:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040040;
	bh=gxt3zn2k6h9fTOpz3yfL8HpuWePmPkjI963cRLiUSCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gWTEMifGUQ5hRFcbP0kRnGIh2mBHKVRo6uCYuadEKfbCJY7j+XQ+nxGQhxwzvG6We
	 xf1Bk4mu/t798+FRwpSrppa+L9KrCzJyjS4BKtputyGMR+Z+qhQkG50UepkVyGZM4W
	 s0eW5LwzkDkkYi+lvRMO1GOSQ27gBIqiwMlYhL00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2313/3318] swim: Dont start motor until medium is present
Date: Wed, 18 Nov 2026 15:48:55 +0100
Message-ID: <20261118150431.077736681@linuxfoundation.org>
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

[ Upstream commit dbbaaae83cb277d76e70426c0f0ce289e867ed77 ]

The spindle motor should not be running when a disk is to be inserted.
Don't start the motor while the drive is empty.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/7ea60e0bf6135b9bcd4be0991a257d4c5de22bb3.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 1b7726e3041e7..bc30382731cb8 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -631,8 +631,7 @@ static int floppy_open(struct gendisk *disk, blk_mode_t mode)
 	swim_write(base, setup, S_IBM_DRIVE  | S_FCLK_DIV2);
 	udelay(10);
 	swim_drive(base, fs->location);
-	swim_motor(base, ON);
-	swim_action(base, SETMFM);
+
 	if (fs->ejected)
 		setup_medium(fs);
 	if (!fs->disk_in) {
@@ -640,6 +639,9 @@ static int floppy_open(struct gendisk *disk, blk_mode_t mode)
 		goto out;
 	}
 
+	swim_motor(base, ON);
+	swim_action(base, SETMFM);
+
 	set_capacity(fs->disk, fs->total_secs);
 
 	if (mode & BLK_OPEN_NDELAY)
-- 
2.53.0



