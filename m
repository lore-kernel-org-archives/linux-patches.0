Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5C946EF8D;
	Sat, 12 Sep 2026 11:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213784; cv=none; b=X5R8AidsBraBFLYC/mIMKyuHgpi3FjOC7YAIqXMNxMo54PPSN64H5GYw4p8dCqfx0cVDWxhWbZpmiclj8507P640TWioTzdJbVzmKbuUZ39oGx6+I/NWIo+3xuvsCieAUYQ2BZ7WXAovO2pnLxBXjH1Z8ppBBiZDMs4WiBshW0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213784; c=relaxed/simple;
	bh=oLg0B0C53rNvFD1sE75hmPtf+6xaFdf9LArrp8crUKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OC0g4vZNe9RpGnEZbWGCFLECdGu5hLm6mh71U37w5TR8CEOG6JTsHAMnrKuSlYX1HOfpnjUeoZz0sk418kP0b3cwUwMSNfWqQoN4e5UXwRgs5krZmsovCn4WP8RmHsiTmW+J6SiwkILuO+D+8kLuiw4D/4DrDNy4yiS1EypTsDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTcD0464; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTcD0464"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C951F000FF;
	Sat, 12 Sep 2026 11:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213782;
	bh=9vLXok4tNMgv2Lh/hdO9gsAUMhpHTtp6qEKwD89brfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iTcD0464j+JSTpGgHS7gebqHIB7/F82FSOBmuG1Rr6DBvbKkQ2P/ioM8fwNwLFoGG
	 bxFEaj/Z6tSFN81V3NkOPRPF1GMUseUDbJsDMQxZjvEoOTr6o5WXKJ31wDqnaJIMmI
	 c7cytafDTIclbtLOkiKxA7Wcei9xXX88lu8kFups=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hecht <mhecht73@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.12 0193/1376] media: i2c: alvium: Fix: Correct name of register in alvium_set_ctrl_auto_exposure
Date: Sat, 12 Sep 2026 08:43:39 +0200
Message-ID: <20260912065611.852603873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Martin Hecht <mhecht73@gmail.com>

commit 58ca8a0bff9e78841a39863474b96e59ef60da19 upstream.

Write value for auto-exposure into correct register REG_BCRM_EXPOSURE_AUTO_RW
instead of wrong register REG_BCRM_WHITE_BALANCE_AUTO_RW.

Fixes: 0a7af872915e ("media: i2c: Add support for alvium camera")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Hecht <mhecht73@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/alvium-csi2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/alvium-csi2.c
+++ b/drivers/media/i2c/alvium-csi2.c
@@ -1291,7 +1291,7 @@ static int alvium_set_ctrl_auto_exposure
 	struct device *dev = &alvium->i2c_client->dev;
 	int ret;
 
-	ret = alvium_write_hshake(alvium, REG_BCRM_WHITE_BALANCE_AUTO_RW,
+	ret = alvium_write_hshake(alvium, REG_BCRM_EXPOSURE_AUTO_RW,
 				  on ? 0x02 : 0x00);
 	if (ret) {
 		dev_err(dev, "Fail to set autoexposure reg\n");


