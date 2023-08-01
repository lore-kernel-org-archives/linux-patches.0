Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FB01F95A
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C07DC433C9;
	Tue,  1 Aug 2023 09:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881762;
	bh=Ui4NihlIv0+S1U4E7ZfEE2TQSCpeites75t3ZEOu6Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y12MdBVaJIfNEaXcM/K290y0IwpXS4peXOZ0xZuJMm+dfjdYDkV1rfLcUqQp0LUoA
	 MHujylywj5qGrVrbDj+FznRfoJwrbAoc7xdxQS8sQdlc8jbAsPjVIdlG42fTW5yiqv
	 GZMPssh9NT3E0ZAULHZpr3gAHMur6CNmUZ5idBRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/155] i2c: Delete error messages for failed memory allocations
Date: Tue,  1 Aug 2023 11:18:40 +0200
Message-ID: <20230801091910.488340673@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit 6b3b21a8542fd2fb6ffc61bc13b9419f0c58ebad ]

These issues were detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 05f933d5f731 ("i2c: nomadik: Remove a useless call in the remove function")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-ibm_iic.c  | 4 +---
 drivers/i2c/busses/i2c-nomadik.c  | 1 -
 drivers/i2c/busses/i2c-sh7760.c   | 1 -
 drivers/i2c/busses/i2c-tiny-usb.c | 4 +---
 4 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/i2c/busses/i2c-ibm_iic.c b/drivers/i2c/busses/i2c-ibm_iic.c
index 9f71daf6db64b..c073f5b8833a2 100644
--- a/drivers/i2c/busses/i2c-ibm_iic.c
+++ b/drivers/i2c/busses/i2c-ibm_iic.c
@@ -694,10 +694,8 @@ static int iic_probe(struct platform_device *ofdev)
 	int ret;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev) {
-		dev_err(&ofdev->dev, "failed to allocate device data\n");
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	platform_set_drvdata(ofdev, dev);
 
diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index a2d12a5b1c34c..05eaae5aeb180 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -972,7 +972,6 @@ static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 
 	dev = devm_kzalloc(&adev->dev, sizeof(struct nmk_i2c_dev), GFP_KERNEL);
 	if (!dev) {
-		dev_err(&adev->dev, "cannot allocate memory\n");
 		ret = -ENOMEM;
 		goto err_no_mem;
 	}
diff --git a/drivers/i2c/busses/i2c-sh7760.c b/drivers/i2c/busses/i2c-sh7760.c
index 319d1fa617c88..a0ccc5d009874 100644
--- a/drivers/i2c/busses/i2c-sh7760.c
+++ b/drivers/i2c/busses/i2c-sh7760.c
@@ -445,7 +445,6 @@ static int sh7760_i2c_probe(struct platform_device *pdev)
 
 	id = kzalloc(sizeof(struct cami2c), GFP_KERNEL);
 	if (!id) {
-		dev_err(&pdev->dev, "no mem for private data\n");
 		ret = -ENOMEM;
 		goto out0;
 	}
diff --git a/drivers/i2c/busses/i2c-tiny-usb.c b/drivers/i2c/busses/i2c-tiny-usb.c
index 7279ca0eaa2d0..d1fa9ff5aeab4 100644
--- a/drivers/i2c/busses/i2c-tiny-usb.c
+++ b/drivers/i2c/busses/i2c-tiny-usb.c
@@ -226,10 +226,8 @@ static int i2c_tiny_usb_probe(struct usb_interface *interface,
 
 	/* allocate memory for our device state and initialize it */
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (dev == NULL) {
-		dev_err(&interface->dev, "Out of memory\n");
+	if (!dev)
 		goto error;
-	}
 
 	dev->usb_dev = usb_get_dev(interface_to_usbdev(interface));
 	dev->interface = interface;
-- 
2.39.2



