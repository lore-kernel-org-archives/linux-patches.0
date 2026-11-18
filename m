Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016932;
	b=q+kf/VYJgJjTd6SYy/JZLHxYu1GD39yy94IdSL+q42u5zNwqT1VSuePT3WpP1p+x15Wa
	 NO5kFlM9IfoAH8HvglwylIwFTmR077ReHX5TZ/dIchZkImnne7rMjtMc44sIXAbGBI+/O
	 /27rQh6azpTwTaTdyuqtxsoEV4efwRheDCyXyomWuzL/0eBbGUixzTBltWdjKPeW77ehC
	 Cw7dUwvUnQr0GcNskska7XaqcSa423pvM5VCXcAvRc75qrdcH9TRQaRN4Le3E0BEOGmlt
	 hNF6bk3XwxGG2fSyk4Y4ayZd9VqgE4UPnG0TIpyWHNvrkFlm1zpsyNDlqatooRnIf9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2/+AWNBTw+l4nG6HgWcLE7GISSyGEO4SGKVy/wQAO2I=;
	b=x8VGPoQHwxmUwaEGQnPOqzqzg55DnFcC0+fOQMQxkXe8pQbD995hq3v+KFmp814Bq6p7
	 nX7/kzNgFmwcuVABIODRDyfGZg0o1+UR0vGi2hkE7zQegvc9ZzZjsAXErITr08d8h+v8/
	 fN2a8gxEoj4tE0ivGrZXlgf1EFBx1rknoTDrg5x/Aa+NeXku3upLr1kVIB0gd6F23jBRw
	 CPxQsOmYh6d5sdhDxjDB88/vLZYDfS1DJR/+iNQRnQpR1176SZI4swsBsDgxG/73AA/xW
	 jKpTa3N3F057ppWUbAzc4ySn9BbAz+9qa7me48Jdq/eWARLQBduJBn45WiocJ5MdzEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mfNtixbZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54423606A31C;
	Wed, 18 Nov 2026 15:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mfNtixbZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50E41F000C4;
	Wed, 18 Nov 2026 15:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016932;
	bh=2/+AWNBTw+l4nG6HgWcLE7GISSyGEO4SGKVy/wQAO2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mfNtixbZF0RphTJ/MlJxbAatEFrcL2CfZctazEQQNeDqFD1ZnhYVaI+iyyzf6YYGB
	 Jg72AjshpkBPjAzJX6baUBZozp2ZLw1VKwSaSRdDz+mgT7i90y1LEyL+dyoE9GdXmw
	 Dsr/H0saesu0VKRblmcfqOx5XF0VbbV+rFwkDKKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0705/2651] swim: Configure parameter memory
Date: Wed, 18 Nov 2026 15:32:25 +0100
Message-ID: <20261118150313.208873395@linuxfoundation.org>
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

[ Upstream commit 994a778d966592d0e211deaf6e436fcb21413935 ]

The original SWIM chip has a 16 byte memory to store parameters which
control read/write timing. The SWIM 2 chip retains the last 4 parameters
which control write pre-compensation, but omits the first 12. Hence
SWIM 2 can perform reads without any parameter memory setup but SWIM 1
cannot.

Configure the SWIM parameter memory with the appropriate values so that
SWIM 1 can read too. The parameters used here were observed in SWIM chip
memory, using Macsbug, while MacOS was reading from an MFM floppy disk.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/eccb76911fd255330b05eb3174ac15c29bb41a23.1788513996.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 190b2e1b5b0e1..c2d7ad3f065cf 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -796,6 +796,17 @@ static void swim_cleanup_floppy_disk(struct floppy_state *fs)
 	blk_mq_free_tag_set(&fs->tag_set);
 }
 
+static void swim_set_parameters(struct swim __iomem *base)
+{
+	unsigned int i;
+	static const u8 mem[] = { 0x18, 0x41, 0x2e, 0x2e, 0x18, 0x18, 0x1b, 0x1b,
+				  0x2f, 0x2f, 0x19, 0x19, 0x97, 0x1b, 0x57, 0x3b, };
+
+	swim_write(base, mode0, 0); /* reset parameter memory index */
+	for (i = 0; i < 16; ++i)
+		swim_write(base, parameter, mem[i]);
+}
+
 static int swim_floppy_init(struct swim_priv *swd)
 {
 	struct queue_limits lim = {
@@ -805,6 +816,8 @@ static int swim_floppy_init(struct swim_priv *swd)
 	int drive;
 	struct swim __iomem *base = swd->base;
 
+	swim_set_parameters(base);
+
 	/* scan floppy drives */
 
 	swim_drive(base, INTERNAL_DRIVE);
-- 
2.53.0



