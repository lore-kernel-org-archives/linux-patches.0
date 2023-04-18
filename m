Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D812572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24C7C433D2;
	Tue, 18 Apr 2023 12:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821738;
	bh=fzAd6xMVxPqoigDacFBZ1ZFRV4kxd6oevsFExFdBmOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=doMvaKrOxOAVKfCTHHWvkPxxeqC+s77/Ja4rjmFaMbvuzr6Us20Jk8l4OEB/389rW
	 fNuDi9oIUiW3wr8uuX1EPJ8HrtsMaUNYWT/2bnl8c5DxIF2B8s9zBgmqSeHBxSR23c
	 ab0Zoz6gg/hPc9jawPB2T0UK/lKmqiOwNveVqmoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Kerello <christophe.kerello@foss.st.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 023/134] mtd: rawnand: stm32_fmc2: use timings.mode instead of checking tRC_min
Date: Tue, 18 Apr 2023 14:21:19 +0200
Message-Id: <20230418120313.801710567@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe Kerello <christophe.kerello@foss.st.com>

commit ddbb664b6ab8de7dffa388ae0c88cd18616494e5 upstream.

Use timings.mode value instead of checking tRC_min timing
for EDO mode support.

Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
Fixes: 2cd457f328c1 ("mtd: rawnand: stm32_fmc2: add STM32 FMC2 NAND flash controller driver")
Cc: stable@vger.kernel.org #v5.10+
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230328155819.225521-3-christophe.kerello@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/stm32_fmc2_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/stm32_fmc2_nand.c
+++ b/drivers/mtd/nand/raw/stm32_fmc2_nand.c
@@ -1531,7 +1531,7 @@ static int stm32_fmc2_nfc_setup_interfac
 	if (IS_ERR(sdrt))
 		return PTR_ERR(sdrt);
 
-	if (sdrt->tRC_min < 30000)
+	if (conf->timings.mode > 3)
 		return -EOPNOTSUPP;
 
 	if (chipnr == NAND_DATA_IFACE_CHECK_ONLY)


