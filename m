Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6C52566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E3DC433D2;
	Tue, 18 Apr 2023 12:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821471;
	bh=RsPzg7tOgj8ne2UAPtj5+A2OTjmu+aQkqUdItbmNXeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0pXxXuutr6B5B/eKh3Rj+P9CnwKgIAGuc67h6KDkz0eqUpex1TkqnQvT9kFw+Y2d
	 SY8g8dtIq4aOPXpGAxZrGf2mcSYt1n6uJRILVb0sJWRkcPopLjg6jPdxfTs0385ycn
	 nhQGNs5aoUVkjgwiyF1oxMzwOA1z3KlWOA0KtN4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Kerello <christophe.kerello@foss.st.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 15/91] mtd: rawnand: stm32_fmc2: remove unsupported EDO mode
Date: Tue, 18 Apr 2023 14:21:19 +0200
Message-Id: <20230418120306.089243416@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
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
@@ -1527,6 +1527,9 @@ static int stm32_fmc2_nfc_setup_interfac
 	if (IS_ERR(sdrt))
 		return PTR_ERR(sdrt);
 
+	if (sdrt->tRC_min < 30000)
+		return -EOPNOTSUPP;
+
 	if (chipnr == NAND_DATA_IFACE_CHECK_ONLY)
 		return 0;
 


