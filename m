Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055301;
	b=Bu7jRCu3SGrM0ACtL3VjUt05URpSdOCtUij1C6ZBjaYl85ukI5vA1aMRy1GGRpvvEvRa
	 Owa+zV3OlQuvTM0izAMW56Vy3cuCPc39+4d4TkeaeStbcmWLwTcf8nbRtoJr/DEY3QNwd
	 r1nRLbz/dsqLdBfUKzaZgyOHW0lJzrwpCr8JSxB1srPq8IWORcJ+gsrYyxv1wmpeAAq3s
	 52ZahjoByRULFFvPT5sjK+xzbXf6qEkueGrxT3BMdTPmUAFgqxMk1bCzxDcCcU3itq2/x
	 ncHYrNLXCi6pKCVi9yuP00efVkyY68t+QWXpvUqMYzQEjQMWcKcu7dJf4l+PCMpF/XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gldVaalqx92ViDw0m+7tn7r9Nml9G9nx8tqkoFA9K2E=;
	b=ih9yQMU3jBZ8hQxc/dLOPHBKJA8/tBeUAOBZp6CmqlMXBNLIFJfkGkVnM2Rg+BmT5yQD
	 MNPpHxrn7lEDXHdsPzL/avE87j3+vUvWK/PaLtMFa7OrZXP/nnIourFkdPWKEOR4PH4qM
	 Z/h9vAscQNpPgYJ5hPHKXvUAYB6gcdZ5nHFgieyZBOZ/PPajWDMa5e7IfSQsAWn0cdrdP
	 uL9Q9c95qb3T8Hjo0Ajg/4KO07HMNRgVShQvsGHNVOYBz9ruxhm6Qx8pNLB1ypfhFDfqa
	 lb55c2SIL0pibqhAhQKwHayJOO6R2ajte7vqgUQg9PDce53mfuWdQyUHgLdh006fdDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AtGo2bHK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15B8606A320;
	Thu, 19 Nov 2026 02:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AtGo2bHK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101D91F000C4;
	Thu, 19 Nov 2026 02:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055301;
	bh=gldVaalqx92ViDw0m+7tn7r9Nml9G9nx8tqkoFA9K2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AtGo2bHKJ1aaskkfek6af8tp+wvN5d+0+P2PcUP4Scx+Sm8s+lR0zCsrUoJrBMZEl
	 MD20FiqQ23RlpKA6RnAQrI+dcLw292BIq0cT8L8qxVo9ihc2mhmsw0sb8vF8V/H2dJ
	 8CbPpx2ch2hg5g1e4QH5H/uCuNNxlqKoX9MxO8uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1581/2214] swim: Check drive ready bit
Date: Wed, 18 Nov 2026 15:54:17 +0100
Message-ID: <20261118150115.262982101@linuxfoundation.org>
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
index 795058cdf4343..6e9fe07a8440e 100644
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
@@ -313,6 +313,14 @@ static inline bool swim_readbit(struct swim __iomem *base, int bit)
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
@@ -351,8 +359,6 @@ static inline void swim_eject(struct swim __iomem *base)
 
 static inline void swim_head(struct swim __iomem *base, enum head head)
 {
-	/* wait drive is ready */
-
 	if (head == UPPER_HEAD)
 		swim_select(base, READ_DATA_1);
 	else if (head == LOWER_HEAD)
@@ -387,20 +393,25 @@ static inline int swim_track00(struct swim __iomem *base)
 
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
 
@@ -482,6 +493,8 @@ static blk_status_t floppy_read_sectors(struct floppy_state *fs,
 
 
 	swim_drive(base, fs->location);
+	swim_READY_timeout(base);
+
 	for (i = req_sector; i < req_sector + sectors_nb; i++) {
 		int x;
 		track = i / fs->secpercyl;
@@ -607,6 +620,8 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 
 	swim_motor(base, ON);
 	swim_action(base, SETMFM);
+	msleep(30);
+	swim_READY_timeout(base);
 
 	set_capacity(fs->disk, fs->total_secs);
 
-- 
2.53.0



