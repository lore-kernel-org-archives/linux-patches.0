Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BD646D2D2;
	Tue, 21 Jul 2026 19:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661650; cv=none; b=kpWQcOJZwO14rQ/S2TDxH+p7S6qLB3LG1Qf5lqynpn13+Ez/bXLVvtb+x8+hgkBJJkFuQgU+KJwKkR0+DlGtdA4t1mR47mBjUxjdBWJsrIKnik0KzLJgEOpRWKNVz752abcRRw9Hhu53rb5UOAXSSo3tI0k5FqMMBmCteHGXqts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661650; c=relaxed/simple;
	bh=dSoNZxAIo/UexJPwpl4bVp0+AxrMpYirrimvJQRgypQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoW7ShZRdW+GN4EFMuphTy9WhcQSC31q4mWeBaKnCSw+b+LuOp+KzOg1TZYPHdSuEo+iP+0pUgE8Ii8+XBNRN8s1tN6ycAyYSzZNXafXDMtVTutLRxvazziMfU+/7L4QfauTTKDy0XEKXSh5h/SA4gBbn5uddcNiAYvwkq7vWX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAR9qCgT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAR9qCgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEF31F000E9;
	Tue, 21 Jul 2026 19:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661648;
	bh=hs+G12BCbLpBbee5bXcJyA3j7aSYHiKe6t3+vfn47AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NAR9qCgT/aaSGhPm4YbVpk/m1mbYucv/WVWFPC35AuZQ0001zIC8ukH84h73VJfGT
	 QQ1PToJyLXeP2VEe3adcLAhAMp9nttADgYC83Bdgt+KPjz4BC5jMXSVqsv/KKaB+Rp
	 JwnlOr1EzwIu4GK/WmWnP2u7+Y0Iy4dhVlDLA9NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Saravana Kannan <saravanak@google.com>,
	Mark Brown <broonie@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 6.12 0147/1276] Revert "treewide: Fix probing of devices in DT overlays"
Date: Tue, 21 Jul 2026 17:09:50 +0200
Message-ID: <20260721152449.392139920@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit aaf08c52df9a19148731d4a3cfd85d98455db901 ]

This reverts commit 1a50d9403fb90cbe4dea0ec9fd0351d2ecbd8924.

While the commit fixed fw_devlink overlay handling for one case, it
broke it for another case. So revert it and redo the fix in a separate
patch.

Fixes: 1a50d9403fb9 ("treewide: Fix probing of devices in DT overlays")
Reported-by: Herve Codina <herve.codina@bootlin.com>
Closes: https://lore.kernel.org/lkml/CAMuHMdXEnSD4rRJ-o90x4OprUacN_rJgyo8x6=9F9rZ+-KzjOg@mail.gmail.com/
Closes: https://lore.kernel.org/all/20240221095137.616d2aaa@bootlin.com/
Closes: https://lore.kernel.org/lkml/20240312151835.29ef62a0@bootlin.com/
Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/lkml/20240411235623.1260061-2-saravanak@google.com/

[Herve: Fix conflicts due to f72e77c33e4b ("device property: Make
modifications of fwnode "flags" thread safe")]

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Acked-by: Mark Brown <broonie@kernel.org>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Acked-by: Wolfram Sang <wsa+renesas@sang-engineering.com> # for I2C
Link: https://patch.msgid.link/20260511155755.34428-2-herve.codina@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/imx-weim.c    | 6 ------
 drivers/i2c/i2c-core-of.c | 5 -----
 drivers/of/dynamic.c      | 1 -
 drivers/of/platform.c     | 5 -----
 drivers/spi/spi.c         | 5 -----
 5 files changed, 22 deletions(-)

diff --git a/drivers/bus/imx-weim.c b/drivers/bus/imx-weim.c
index f735e0462c55ee..87070155b05724 100644
--- a/drivers/bus/imx-weim.c
+++ b/drivers/bus/imx-weim.c
@@ -327,12 +327,6 @@ static int of_weim_notify(struct notifier_block *nb, unsigned long action,
 				 "Failed to setup timing for '%pOF'\n", rd->dn);
 
 		if (!of_node_check_flag(rd->dn, OF_POPULATED)) {
-			/*
-			 * Clear the flag before adding the device so that
-			 * fw_devlink doesn't skip adding consumers to this
-			 * device.
-			 */
-			fwnode_clear_flag(&rd->dn->fwnode, FWNODE_FLAG_NOT_DEVICE);
 			if (!of_platform_device_create(rd->dn, NULL, &pdev->dev)) {
 				dev_err(&pdev->dev,
 					"Failed to create child device '%pOF'\n",
diff --git a/drivers/i2c/i2c-core-of.c b/drivers/i2c/i2c-core-of.c
index 50e97e2ed2cff4..a250921bbce094 100644
--- a/drivers/i2c/i2c-core-of.c
+++ b/drivers/i2c/i2c-core-of.c
@@ -178,11 +178,6 @@ static int of_i2c_notify(struct notifier_block *nb, unsigned long action,
 			return NOTIFY_OK;
 		}
 
-		/*
-		 * Clear the flag before adding the device so that fw_devlink
-		 * doesn't skip adding consumers to this device.
-		 */
-		fwnode_clear_flag(&rd->dn->fwnode, FWNODE_FLAG_NOT_DEVICE);
 		client = of_i2c_register_device(adap, rd->dn);
 		if (IS_ERR(client)) {
 			dev_err(&adap->dev, "failed to create client for '%pOF'\n",
diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
index f5f624fc327fa3..77818436fd60a5 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -225,7 +225,6 @@ static void __of_attach_node(struct device_node *np)
 	np->sibling = np->parent->child;
 	np->parent->child = np;
 	of_node_clear_flag(np, OF_DETACHED);
-	fwnode_set_flag(&np->fwnode, FWNODE_FLAG_NOT_DEVICE);
 
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 7fe456dddce396..052d7aceec97d1 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -740,11 +740,6 @@ static int of_platform_notify(struct notifier_block *nb,
 		if (of_node_check_flag(rd->dn, OF_POPULATED))
 			return NOTIFY_OK;
 
-		/*
-		 * Clear the flag before adding the device so that fw_devlink
-		 * doesn't skip adding consumers to this device.
-		 */
-		fwnode_clear_flag(&rd->dn->fwnode, FWNODE_FLAG_NOT_DEVICE);
 		/* pdev_parent may be NULL when no bus platform device */
 		pdev_parent = of_find_device_by_node(parent);
 		pdev = of_platform_device_create(rd->dn, NULL,
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 5a6c2f5672ae96..319d3834476e04 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -4820,11 +4820,6 @@ static int of_spi_notify(struct notifier_block *nb, unsigned long action,
 			return NOTIFY_OK;
 		}
 
-		/*
-		 * Clear the flag before adding the device so that fw_devlink
-		 * doesn't skip adding consumers to this device.
-		 */
-		fwnode_clear_flag(&rd->dn->fwnode, FWNODE_FLAG_NOT_DEVICE);
 		spi = of_register_spi_device(ctlr, rd->dn);
 		put_device(&ctlr->dev);
 
-- 
2.53.0



