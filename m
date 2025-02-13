Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87CE26B080;
	Thu, 13 Feb 2025 15:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459197; cv=none; b=pD/EQNRLnx6DwRwHoLGfnWZjzHrQmHrtKujklvCd3UyfrVcPvY1AhSFfi6mDZL+VEODQF0FBT053MJisgrc/2IAzdQ/+7Ox1y9nXCzb8iipnC+laz73iALS3ccEFLiDD2LSRT5TaOYD2JRlDs/i1NVeM9RkX8OGOY6Os92e/0s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459197; c=relaxed/simple;
	bh=smiSAxC2riAMQgKeicFYei+L3TsCWWAWRwtZneHlgG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFIMqxXkQpGfK27BuKTTsGT23udMZw+QYc6TYfZosRqrMmorJVr79QOvv2appL8LAAM5upbfwLzF3uaH4SGKU8sUgGNM9b98lUoellef2c0FLcwppHWN1GdaCwSgfY4OsF+ntlmHjEsjRxW7EUzRZyQC3ElohV3ymtao2RTrZQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7aBfgwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7aBfgwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7047BC4CED1;
	Thu, 13 Feb 2025 15:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459196;
	bh=smiSAxC2riAMQgKeicFYei+L3TsCWWAWRwtZneHlgG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7aBfgwFDQIZsXkBum4HOfEXvHPdHTHeHD7AdjTaMHkmFPEfHTM1GO5c8gNngqXlw
	 9ddgdBwAYJSQjoihG2dZXtnpn1d1HOPsa7Kc89utGDorVkF272g2xlIFHZLRe8ElMe
	 GVNrK3Tklm40JtCEpJyJBBPePVrI26hC37k8u4Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.13 195/443] media: i2c: ds90ub960: Fix UB9702 refclk register access
Date: Thu, 13 Feb 2025 15:26:00 +0100
Message-ID: <20250213142448.136558571@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

commit ba3bdb93947c90f098061de1fb2458e2ca040093 upstream.

UB9702 has the refclk freq register at a different offset than UB960,
but the code uses the UB960's offset for both chips. Fix this.

The refclk freq is only used for a debug print, so there's no functional
change here.

Cc: stable@vger.kernel.org
Fixes: afe267f2d368 ("media: i2c: add DS90UB960 driver")
Reviewed-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ds90ub960.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/media/i2c/ds90ub960.c
+++ b/drivers/media/i2c/ds90ub960.c
@@ -351,6 +351,8 @@
 
 #define UB960_SR_I2C_RX_ID(n)			(0xf8 + (n)) /* < UB960_FPD_RX_NPORTS */
 
+#define UB9702_SR_REFCLK_FREQ			0x3d
+
 /* Indirect register blocks */
 #define UB960_IND_TARGET_PAT_GEN		0x00
 #define UB960_IND_TARGET_RX_ANA(n)		(0x01 + (n))
@@ -3834,7 +3836,10 @@ static int ub960_enable_core_hw(struct u
 	if (ret)
 		goto err_pd_gpio;
 
-	ret = ub960_read(priv, UB960_XR_REFCLK_FREQ, &refclk_freq);
+	if (priv->hw_data->is_ub9702)
+		ret = ub960_read(priv, UB9702_SR_REFCLK_FREQ, &refclk_freq);
+	else
+		ret = ub960_read(priv, UB960_XR_REFCLK_FREQ, &refclk_freq);
 	if (ret)
 		goto err_pd_gpio;
 


