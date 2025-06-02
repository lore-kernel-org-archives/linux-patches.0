Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5801DED64;
	Mon,  2 Jun 2025 14:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873734; cv=none; b=fXpVmxpMAltjGxliC8ILWeZWpcpLzjnr9FSCMQYzyjC5/q2xRQETWEvl/GIMF/thLJ0LeU4W5jp/aEhspokYeENUdPEA2Lhy1zz7JM5kKiUiN/1dmIkrciKiRLzpddb5VGs93EhkCeE3MW8a/wMyBy4/77inmBCESBa/+IA7+u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873734; c=relaxed/simple;
	bh=XnqdrkyseXbfu4yDQSMNvhtO1GcMOrfjEjbWcRVEIko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFA0Ztb1a4965yeyZv5GbhCWk60jeiGDUONp+3te0+2vSayjB6ZmSHrfOTvjDrnBywUMN4Pwh4hiX38zbfoxcOexHBbgA2vLppSTJ9FwW5o/+cFnX+9N2LCVqW3TrxXOBQZh0Por0gCiSuDS/KCiIbnay8c4BnxlqVPZ2WjXv1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KU5WWRtU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KU5WWRtU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F876C4CEEB;
	Mon,  2 Jun 2025 14:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873734;
	bh=XnqdrkyseXbfu4yDQSMNvhtO1GcMOrfjEjbWcRVEIko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KU5WWRtUzl1xSNwsEE54SKNtVzQsxBwXmch6iSLSd5Hp6qc05OQpqdiGTiEiPadav
	 ihacF7gc8AAHxkgjs4kjyfbQGlajFuCEmIDgngRbcrU1DZ/4LuROlv/+TX4e5kP73e
	 xp6dhELrLHukwChiXIAUukcQTk3beF8u2/J7a1Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Plowman <david.plowman@raspberrypi.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 233/444] media: i2c: imx219: Correct the minimum vblanking value
Date: Mon,  2 Jun 2025 15:44:57 +0200
Message-ID: <20250602134350.367012799@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Plowman <david.plowman@raspberrypi.com>

[ Upstream commit e3b82d49bf676f3c873e642038765eac32ab6d39 ]

The datasheet for this sensor documents the minimum vblanking as being
32 lines. It does fix some problems with occasional black lines at the
bottom of images (tested on Raspberry Pi).

Signed-off-by: David Plowman <david.plowman@raspberrypi.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx219.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index a14e571dc62bc..a3d5a8a7c660b 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -77,7 +77,7 @@
 #define IMX219_VTS_30FPS_640x480	0x06e3
 #define IMX219_VTS_MAX			0xffff
 
-#define IMX219_VBLANK_MIN		4
+#define IMX219_VBLANK_MIN		32
 
 /*Frame Length Line*/
 #define IMX219_FLL_MIN			0x08a6
-- 
2.39.5



