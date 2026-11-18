Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037238;
	b=lOIS5rfcPcNYP4H3yclmBiWHeM4gAa/VOpX50sCNinrVP6b8698P8Kbmw3Wqt6vbODVo
	 Jofm1i1BSU5WQQWVTNJ2g/lYv2nwZzjiwts3M7ENUW5/OokZh+yFVQU0fg/3E67ObLZ7W
	 NHCwB42dvCnvOyCF536EaO0Dpko5YEySRWQHQNthotmIQa/YM0Hqdj5VCap0kRcNsL15W
	 tl9OtkHChKRzadPyScT4sURwl70L92vMNj+aaeqqm7IRYf64WgQxmWby+BtVkXIVtzYrT
	 7l9xSbc/PmNMIc9CEqw5QyNgFnwS+Kndk3vaIdZFr6Nyfo/XzLfJkalE9ma00dc6A6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AMHh9THdRbcBIOalqqSqfBn5JWC0XnY1cw5woWGxpg4=;
	b=oOSoXxm6/Viod4ojGZhNnCRsEQhNRiZ16zL3P9+QeRNbdjXnHPPYqtrhT4L1d1koEBqM
	 6/MJTm5CSuahXUNfjnMQ5Kv2i2Rwfw6sym9Z975nOmiUX3RY3Qt14fJkgnFPb095rvk5J
	 7ssWbdBbKykDwy/Sjv/i1S9hPA+uoWTUlt1QqxaKUhCIcTvqb0EZOdMzvyIBVOKUZxyt9
	 /UcQD65ZikUQxd2XOfK9pZMQCdD59gDnvAV4JNxhabFMS/c8+pxoTbCTYA0PaX4ftMs+4
	 p1QEnDdr1r5B7JTSX8zq5wLt2HlmKVAyjtqwL8IX7IGhLoqv3gLH9PdTYJXjw32GVug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OHz7Zvd7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138FF606A325;
	Wed, 18 Nov 2026 21:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OHz7Zvd7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC551F000C4;
	Wed, 18 Nov 2026 21:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037237;
	bh=AMHh9THdRbcBIOalqqSqfBn5JWC0XnY1cw5woWGxpg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OHz7Zvd7DZIP1gKpJ2jaH2IhD4inKIaTNQzTjEKVT1QOMLPWjQrR2vb4WFx9ObEla
	 as70v7w5Ov499DsQ52ITMeHq8hAWwpSE/H1FtczWy/0VvvPk1dn28PQJmOgOWFsTfH
	 I9MHiUDSAlIK4usEoXtWtDp+NlXqqHsakyXQVFQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Miquel Raynal (DAVE)" <miquel.raynal@bootlin.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1296/3318] mtd: rawnand: pl353: Fix debug prints
Date: Wed, 18 Nov 2026 15:31:58 +0100
Message-ID: <20261118150359.147053833@linuxfoundation.org>
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

From: Miquel Raynal (DAVE) <miquel.raynal@bootlin.com>

[ Upstream commit 2b7baaddf1bc3e39206a0354449fdc349945b86b ]

They are partially incorrect since "software" engine does not mean
hamming, the "none" cae is also falling into this print, and on-die
means there is some kind of hardware support; we prefer to use the
wording on-host vs. on-die.

Fix all those prints.

Fixes: 1e06dbfdfb85 ("mtd: rawnand: pl353: Add message about ECC mode")
Signed-off-by: Miquel Raynal (DAVE) <miquel.raynal@bootlin.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/pl35x-nand-controller.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/raw/pl35x-nand-controller.c b/drivers/mtd/nand/raw/pl35x-nand-controller.c
index 771bda7612864..140428fff8f1a 100644
--- a/drivers/mtd/nand/raw/pl35x-nand-controller.c
+++ b/drivers/mtd/nand/raw/pl35x-nand-controller.c
@@ -972,17 +972,19 @@ static int pl35x_nand_attach_chip(struct nand_chip *chip)
 
 	switch (chip->ecc.engine_type) {
 	case NAND_ECC_ENGINE_TYPE_ON_DIE:
-		dev_dbg(nfc->dev, "Using on-die ECC\n");
+		dev_dbg(nfc->dev, "Using on-die hardware ECC\n");
 		/* Keep these legacy BBT descriptors for ON_DIE situations */
 		chip->bbt_td = &bbt_main_descr;
 		chip->bbt_md = &bbt_mirror_descr;
 		fallthrough;
 	case NAND_ECC_ENGINE_TYPE_NONE:
+		dev_dbg(nfc->dev, "Using no ECC engine\n");
+		break;
 	case NAND_ECC_ENGINE_TYPE_SOFT:
-		dev_dbg(nfc->dev, "Using software ECC (Hamming 1-bit/512B)\n");
+		dev_dbg(nfc->dev, "Using software ECC\n");
 		break;
 	case NAND_ECC_ENGINE_TYPE_ON_HOST:
-		dev_dbg(nfc->dev, "Using hardware ECC\n");
+		dev_dbg(nfc->dev, "Using on-host hardware ECC\n");
 		ret = pl35x_nand_init_hw_ecc_controller(nfc, chip);
 		if (ret)
 			return ret;
-- 
2.53.0



