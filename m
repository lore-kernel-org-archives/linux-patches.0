Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FEF2566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579B6C433EF;
	Tue, 18 Apr 2023 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821008;
	bh=Ifse3UVLu92gxU1NG64i/qIdIpm7X8ynfTNycx84lSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZuasacCedhZcuEdLmOjsVoOcK8mRW5pO6ojYK7eFMKnyLZV0g2jFdnNVG7TLX3bto
	 JzqiggmEs2xBUIcmxCsIXsXb7/wqrInJNkvyl4Tf4StHDl0FAiKJfJa0fMMqxMMaio
	 xfLCf1tHI3D6CzjkMwjtNseim9AHaK6trb9oLiQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Kerello <christophe.kerello@foss.st.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 56/92] mtd: rawnand: stm32_fmc2: remove unsupported EDO mode
Date: Tue, 18 Apr 2023 14:21:31 +0200
Message-Id: <20230418120306.809260487@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
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

commit f71e0e329c152c7f11ddfd97ffc62aba152fad3f upstream.

Remove the EDO mode support from as the FMC2 controller does not
support the feature.

Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
Fixes: 2cd457f328c1 ("mtd: rawnand: stm32_fmc2: add STM32 FMC2 NAND flash controller driver")
Cc: stable@vger.kernel.org #v5.4+
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230328155819.225521-2-christophe.kerello@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/stm32_fmc2_nand.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mtd/nand/raw/stm32_fmc2_nand.c
+++ b/drivers/mtd/nand/raw/stm32_fmc2_nand.c
@@ -1592,6 +1592,9 @@ static int stm32_fmc2_setup_interface(st
 	if (IS_ERR(sdrt))
 		return PTR_ERR(sdrt);
 
+	if (sdrt->tRC_min < 30000)
+		return -EOPNOTSUPP;
+
 	if (chipnr == NAND_DATA_IFACE_CHECK_ONLY)
 		return 0;
 


