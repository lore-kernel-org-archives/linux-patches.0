Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA41633
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49253C433D6;
	Wed,  2 Nov 2022 03:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667360397;
	bh=k2l9qUbaWkKHd2+qYsKY467rd2E2pAKYXv1prQ8CcmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcoff4KG09+C82MKNXQo0A59SOmK+e0Nz/Xi0l0yebOAltJpX0eh01m0XvAs0SVJy
	 gmPWhXlH90aIHQRvw7KrpuR9JkzTGhF6qmfrCvpQxGLlxiMwiUvXviVLWS7RDIwuHe
	 LewcStI12hBbyBPNHW5YxcYe8loPCknpY3hXsqSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Fabio Estevam <festevam@gmail.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 4.14 04/60] ata: ahci-imx: Fix MODULE_ALIAS
Date: Wed,  2 Nov 2022 03:34:25 +0100
Message-Id: <20221102022051.212805450@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.081761052@linuxfoundation.org>
References: <20221102022051.081761052@linuxfoundation.org>
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
@@ -887,4 +887,4 @@ module_platform_driver(imx_ahci_driver);
 MODULE_DESCRIPTION("Freescale i.MX AHCI SATA platform driver");
 MODULE_AUTHOR("Richard Zhu <Hong-Xing.Zhu@freescale.com>");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("ahci:imx");
+MODULE_ALIAS("platform:" DRV_NAME);


