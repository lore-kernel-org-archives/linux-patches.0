Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4CC340A5A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301058; cv=none; b=iGC1B6pYGprIOFlBSJUOjyBCqknEqW5HRqMHZFXMBuO33PT86EFDZwu4pP6l3l15ObHjGysRbozhxVAZ+fTaW+yG4yL/9/s/+Ep2v/vgyRRVJ/+MC/qpntby8FWXssibNrM3N4gOxUAzqGyxt0V69d8LJJid3OjtCwC3KBShxLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301058; c=relaxed/simple;
	bh=YXhinGD2EShjI+Ju96y5fdmzoeygDql3kCvvn3JTisw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEQkhH0zqSdXmgjM60fVARjBad7/XuG1BKhRowOLCRCND3uddrS5CN6bQIKIRklxdxUhwp72U+zhC9v9BQhg3lJdwbw1rfkQEI0jNpghMCy4O9QZ7I8uEV8xKbol//1UGLrKeWy46s0fsq5LOFQH9sn4ogCUaUVkxMBPPhJdus0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MO1ma90C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MO1ma90C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70487C116D0;
	Sat, 28 Feb 2026 17:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301057;
	bh=YXhinGD2EShjI+Ju96y5fdmzoeygDql3kCvvn3JTisw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MO1ma90CeIDMNurwvwH5z27Yh9CXiVWWCq3KP+yK6W5NuDFiTpH8LteEjeNlpcjxT
	 nNb1rFWVfbY+eGAzkCocggBzueCmb2FseLcJer+cOvA4vmDjIfVb22hoM4Bnht2drA
	 T+A8+9R7vpEGgM7ySio5xz21GHm4yWCSa8rd4UDlO6AhAP21R1kO5UiNmRSu2I+Dla
	 z8D9/1oI5BZxHDC1Sv/3rMbrzHdaPsi6pyw5NrU8jk52WhW0/6g8/C9s0zDbmVaqaW
	 6Bn8vXiVrtdhZH4Q2Lz4LwfoqjrbM6z1ldyBHiqeD+BLoPyW4kVWw/TLajNd6W4sp/
	 EA3qxXplkVcOQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 199/752] hwmon: (f71882fg) Add F81968 support
Date: Sat, 28 Feb 2026 12:38:30 -0500
Message-ID: <20260228174750.1542406-199-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>

[ Upstream commit e4a3d6f79c9933fece64368168c46d6cf5fc2e52 ]

Add hardware monitoring support for the Fintek F81968 Super I/O chip.
It is fully compatible with F81866.

Several products share compatibility with the F81866. To better distinguish
between them, ensure that the Product ID is displayed when the device is
probed.

Signed-off-by: Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
Link: https://lore.kernel.org/r/20251223051040.10227-1-peter_hong@fintek.com.tw
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/f71882fg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index df83f9866fbcf..204059d2de6cd 100644
--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -51,6 +51,7 @@
 #define SIO_F81866_ID		0x1010	/* Chipset ID */
 #define SIO_F71858AD_ID		0x0903	/* Chipset ID */
 #define SIO_F81966_ID		0x1502	/* Chipset ID */
+#define SIO_F81968_ID		0x1806	/* Chipset ID */
 
 #define REGION_LENGTH		8
 #define ADDR_REG_OFFSET		5
@@ -2570,6 +2571,7 @@ static int __init f71882fg_find(int sioaddr, struct f71882fg_sio_data *sio_data)
 		break;
 	case SIO_F81866_ID:
 	case SIO_F81966_ID:
+	case SIO_F81968_ID:
 		sio_data->type = f81866a;
 		break;
 	default:
@@ -2599,9 +2601,9 @@ static int __init f71882fg_find(int sioaddr, struct f71882fg_sio_data *sio_data)
 	address &= ~(REGION_LENGTH - 1);	/* Ignore 3 LSB */
 
 	err = address;
-	pr_info("Found %s chip at %#x, revision %d\n",
+	pr_info("Found %s chip at %#x, revision %d, devid: %04x\n",
 		f71882fg_names[sio_data->type],	(unsigned int)address,
-		(int)superio_inb(sioaddr, SIO_REG_DEVREV));
+		(int)superio_inb(sioaddr, SIO_REG_DEVREV), devid);
 exit:
 	superio_exit(sioaddr);
 	return err;
-- 
2.51.0

