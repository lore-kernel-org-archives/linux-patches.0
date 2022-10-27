Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF05E8487
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D60C433D6;
	Thu, 27 Oct 2022 17:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890090;
	bh=auDV5quGmlCB5NPtSqIbcR7zagW5xynXmehfOY2SGUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1NbwGf4xOJZIDCZ5XHgNGmE36cKGj3Ros31N/33dclNSSiwyZgx4fcTeiO4jW9p1m
	 QZp5NGqaQDUJH2n9iXX3/sKcH3oWOzrTiSz2ulNnZ+528I2m2on7VD/Im0fmBVmWbZ
	 u9kCOmznUBDzcj01P0XpH60rn1lDYioIUh1TVPnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Fabio Estevam <festevam@gmail.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 5.15 19/79] ata: ahci-imx: Fix MODULE_ALIAS
Date: Thu, 27 Oct 2022 18:55:17 +0200
Message-Id: <20221027165055.596662461@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit 979556f1521a835a059de3b117b9c6c6642c7d58 upstream.

'ahci:' is an invalid prefix, preventing the module from autoloading.
Fix this by using the 'platform:' prefix and DRV_NAME.

Fixes: 9e54eae23bc9 ("ahci_imx: add ahci sata support on imx platforms")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/ahci_imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/ahci_imx.c
+++ b/drivers/ata/ahci_imx.c
@@ -1230,4 +1230,4 @@ module_platform_driver(imx_ahci_driver);
 MODULE_DESCRIPTION("Freescale i.MX AHCI SATA platform driver");
 MODULE_AUTHOR("Richard Zhu <Hong-Xing.Zhu@freescale.com>");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("ahci:imx");
+MODULE_ALIAS("platform:" DRV_NAME);


