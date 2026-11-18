Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048536;
	b=nzlzo8qHjgfRxvtF9B0BiUSTlmmsqfEj8IRg9BYPbWhwcTdWkZejks8q+JeH2PeuqMhH
	 OFNvIIOqDmoLCF3aLSEg59uLkJQzaFLLefA4sUsDPTaX7pdRLpGd+lxj9YxOrtGi4mO6+
	 s8Ue8GNI5OGcwEkFN9NGIrtRX7qnWAlRoKzhpf85XXl7uY3KuAFZWdogy4qsoMcNiyheL
	 pD/xE0g0YaKvtsLwZFCQDVNTE4/Ea9XVOSrBgGV1yUQN4V8WwU/3muvmD1pR5dKYN2bCS
	 BORC/Yf1Irc5o9CA+o0umNCmxBw9LSdOUGsC5EreB07XggPi7ZHhRZow4Wg/h0aYENg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g9a8qSOUXTBL3zHGbvZ/HWl6kpwwu5+s/XrRx5nBpSU=;
	b=ZHIty7X7Fohk+Eefl0ObHPmES0f+fSMuZnjeW04T+iyV3xulSwp7dPg+0wQ/VvnZ6KB4
	 bw+eKkrSzlzK0go52fP+lBM4hidK64DIc/+G7u/6dFQZ+I1G/X6D+JggPQL4jnsQL24Rw
	 GEZWBcvT7T3YMzOkbNCtaRhpF0cb/C5fRQ4gt44YYwiyE0fjrk092hAeWZF7BAKwiLFJ3
	 0k1aLv+SqfIe/R2cKWS9iOP7k2NdABFpGRFZ2g2w26g/lHzaxsvvzBnV1Kea/bGVmgsvW
	 oSWsUp44pbEHwkS/4fRk/FbeMdG6qTBmGVsW2i4cB2byCpOdEBgvyJdWouzGT43WA1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=biA0Dg+5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4570A606A31C;
	Thu, 19 Nov 2026 00:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=biA0Dg+5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9709E1F000C4;
	Thu, 19 Nov 2026 00:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048536;
	bh=g9a8qSOUXTBL3zHGbvZ/HWl6kpwwu5+s/XrRx5nBpSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=biA0Dg+5mKT3U7NUJ5T/XrUhZLTkHrdEmFSU0CNJssy3dsAPu/9YrDv6gLRdb1Ma7
	 GUmtVwjhURuMTcsP2pScS7HYO0HBFt+n5v1AnW0ApE8VnHCFrVrnSllYdfC7vemBlU
	 6oSLoXGV75/zI0va6lmebDM2yq2NBI2lLS3CMz8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2027/2857] swim: Check drive ready bit
Date: Wed, 18 Nov 2026 15:51:01 +0100
Message-ID: <20261118150314.388426889@linuxfoundation.org>
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

[ Upstream commit abae04f5bed924590e98fe1519566a6e0144e6b5 ]

The drive provides a readiness signal that has to be tested before
certain commands are issued to the drive. Rename the SEEK_COMPLETE flag
as READY because that's how it's known in the documentation as well as
the mkLinux source code.

Poll for that signal after stepping the heads and also after switching
to MFM mode, as that's what mkLinux does. Check for readiness when
stepping because testing shows that some drives require this.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/8d6fc833c719de2248b64ee521418b1032b1e509.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 09829960ebd63..d75897d473c6f 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -117,7 +117,7 @@ struct iwm {
 #define TACHO		0x103
 #define READ_DATA_1	0x104
 #define GCR_MODE	0x105
-#define SEEK_COMPLETE	0x106
+#define READY		0x106
 #define TWOMEG_MEDIA	0x107
 
 /* Bits in handshake register */
@@ -314,6 +314,14 @@ static inline bool swim_readbit(struct swim __iomem *base, int bit)
 #define swim_readbit_timeout(base, bit, val, timeout_us) \
 	poll_timeout_us(, swim_readbit(base, bit) == val, 1000, timeout_us, false)
 
+#define swim_READY_timeout(base) \
+({ \
+	int ret = swim_readbit_timeout(base, READY, true, 1000 * 1000); \
+	if (ret) \
+		printk(KERN_DEBUG "%s: drive not ready\n", __func__); \
+	ret; \
+})
+
 static inline void swim_drive(struct swim __iomem *base,
 			      enum drive_location location)
 {
@@ -352,8 +360,6 @@ static inline void swim_eject(struct swim __iomem *base)
 
 static inline void swim_head(struct swim __iomem *base, enum head head)
 {
-	/* wait drive is ready */
-
 	if (head == UPPER_HEAD)
 		swim_select(base, READ_DATA_1);
 	else if (head == LOWER_HEAD)
@@ -388,20 +394,25 @@ static inline int swim_track00(struct swim __iomem *base)
 
 static inline int swim_seek(struct swim __iomem *base, int step)
 {
-	if (step == 0)
-		return 0;
-
 	if (step < 0) {
 		swim_action(base, SEEK_NEGATIVE);
 		step = -step;
-	} else
+	} else if (step > 0)
 		swim_action(base, SEEK_POSITIVE);
 
+	swim_READY_timeout(base);
+
+	if (step == 0)
+		return 0;
+
 	for ( ; step > 0; step--) {
 		if (swim_step(base))
 			return -1;
 	}
 
+	msleep(30);
+	swim_READY_timeout(base);
+
 	return 0;
 }
 
@@ -483,6 +494,8 @@ static blk_status_t floppy_read_sectors(struct floppy_state *fs,
 
 
 	swim_drive(base, fs->location);
+	swim_READY_timeout(base);
+
 	for (i = req_sector; i < req_sector + sectors_nb; i++) {
 		int x;
 		track = i / fs->secpercyl;
@@ -608,6 +621,8 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 
 	swim_motor(base, ON);
 	swim_action(base, SETMFM);
+	msleep(30);
+	swim_READY_timeout(base);
 
 	set_capacity(fs->disk, fs->total_secs);
 
-- 
2.53.0



