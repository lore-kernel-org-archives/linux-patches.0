Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040037;
	b=zhpV6sU2dX2x2gctThCrHX6m/srZ8bBCvG1C4iyofO1rfAGayZcuICGqIviszVIlasa1
	 ZtcgzsnAIaBTJbXYZAYAT/ciNDLEHfl1TIO8F9/r9yFZaz15tWFjafVcpktl4gJ/7doU8
	 dOnGILYxoayk0+O4Vn+Y+/5Z1eWsBdn1qsQgbP2ADV/2nDKCnY/R/SQNlaGdYtM4vNxvv
	 HMogoOXGO1Ni1CmZCYVmnVGIQHgagVyqKQbUCt7P1mnUFXiUw0+H6woZ35WqMQwgvj55y
	 Oz1+EC1/YJR3Sdl1U8tza5zTPlDmo/28CdiwQy7UnHMpbynkPy2J4/6d1Ug5RnOhSdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bMrmj9EGo3RyRqER71IdjY+X1i0Z7B8gpWP6kn7ySdM=;
	b=xMr8puKQX1Tm+X0rtPOB3C93p3/g+/Ng4dzDalXbY/cE/xH1s7Uu0ynBMmlxyD8oxYcw
	 hgHVaf1AyvPu6VWDshDIC0tvf2WC9W44mHT0L0L1TjStX197uvUHobJOi1GVu6H+xzr7g
	 4hEXOucaOTcS2JyUD8pdzFYoYr0rjg2d2Y/c8bCtpXBzKRORGegXvF1BeDKcvPsgmqZ3r
	 15pcM8OgFy9ZtDtl60kGQyAK+33pW8zDfn4eQUEl8sRgxd0RyPq+IfouXLwoPbq8fPky8
	 8IeS/UNz4niqB9vJqBdqW4ejxTypna2MAM8IMH9583ztQEqjc3F9Nb5NtZMGKcNmQaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jmPIWAuz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B81B606A31C;
	Wed, 18 Nov 2026 22:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jmPIWAuz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F101F000C4;
	Wed, 18 Nov 2026 22:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040037;
	bh=bMrmj9EGo3RyRqER71IdjY+X1i0Z7B8gpWP6kn7ySdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jmPIWAuzjEQ0MSFkxb5xAJMAWL+ovCzsXrwnidbEd/IWBlNduXz442Al6A4lbuOHQ
	 9AdNhpXxBOr9siRjjV7xn50lfGWPFjyqnHWooYD2/guT5Xos1n7d3ChlLPmvdqIJJk
	 f1rmQajjLBK4PlI1T/FxMn4BinIMAL9ySnm79aOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2312/3318] swim: Configure parameter memory
Date: Wed, 18 Nov 2026 15:48:54 +0100
Message-ID: <20261118150431.051210707@linuxfoundation.org>
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
index cdfe8fbb16913..1b7726e3041e7 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -796,12 +796,25 @@ static void swim_cleanup_floppy_disk(struct floppy_state *fs)
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
 	int err;
 	int drive;
 	struct swim __iomem *base = swd->base;
 
+	swim_set_parameters(base);
+
 	/* scan floppy drives */
 
 	swim_drive(base, INTERNAL_DRIVE);
-- 
2.53.0



