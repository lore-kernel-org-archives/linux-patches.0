Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E2A15E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZFnGfQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B59BC433CC;
	Mon, 23 Oct 2023 11:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060892;
	bh=eM1aiEc1djzbuuy+wDteP8RBUqjqmvto4occTdBKMdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZFnGfQKl1T+zDZ1c2XJKSG4LcgFYTp01Y6vz1xl6z8yNZk2CsGpZy2myz/8O+eeb
	 1V6RIjYIdKm2QZE+vV2lrmy83965eRPl78Wh0qubt3GOHqTqVz2pDYajDVSmkZn8Xw
	 50qUxLMcRUmWA7PDjHcD+oX2nVWn6WQ1d4ClmFs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kurbanov <mmkurbanov@sberdevices.ru>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 103/123] mtd: spinand: micron: correct bitmask for ecc status
Date: Mon, 23 Oct 2023 12:57:41 +0200
Message-ID: <20231023104821.165673772@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>
References: <20231023104817.691299567@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kurbanov <mmkurbanov@sberdevices.ru>

commit 9836a987860e33943945d4b257729a4f94eae576 upstream.

Valid bitmask is 0x70 in the status register.

Fixes: a508e8875e13 ("mtd: spinand: Add initial support for Micron MT29F2G01ABAGD")
Signed-off-by: Martin Kurbanov <mmkurbanov@sberdevices.ru>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230905145637.139068-1-mmkurbanov@sberdevices.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/micron.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/spi/micron.c
+++ b/drivers/mtd/nand/spi/micron.c
@@ -12,7 +12,7 @@
 
 #define SPINAND_MFR_MICRON		0x2c
 
-#define MICRON_STATUS_ECC_MASK		GENMASK(7, 4)
+#define MICRON_STATUS_ECC_MASK		GENMASK(6, 4)
 #define MICRON_STATUS_ECC_NO_BITFLIPS	(0 << 4)
 #define MICRON_STATUS_ECC_1TO3_BITFLIPS	(1 << 4)
 #define MICRON_STATUS_ECC_4TO6_BITFLIPS	(3 << 4)


