Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3C12609FD;
	Tue, 11 Nov 2025 01:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823385; cv=none; b=CzHRUMrE6jGXgBUbCG7RJpogXxAwyzFr8+5EAaybCgymRh8CphPAEOns6fTz8laQMnYgMc5Y3esNkQDhaA6kbWsHbBS7GXUL7A0MrTz/RcJaX4HGDJOfZzt1b8wKEr+63o+8wDzq9Ji9ENQey4RNnk1CF1NWzGYFYyW11Ps8K1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823385; c=relaxed/simple;
	bh=YYLJp6aKvRL5kjnBwkZrEZlqGQYisi8RtC1kfPTq9Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJ/jzyFObZB1RBfznkmBDIX8xDRsygQRzsHecRPX1ta1tJki6+Y8HvWvf0CrtYmGEG/UGVXpxaKesi+iZWqBd+XLz83USGkMxMqjns1JwHkdf7Ris9u2xIEUGkZRDYbVxpfB0mevJSrGQ1+2gQquYsufTNaiyuq7MPnAh1xsIMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njPk/Zeg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njPk/Zeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD72C4AF0B;
	Tue, 11 Nov 2025 01:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823385;
	bh=YYLJp6aKvRL5kjnBwkZrEZlqGQYisi8RtC1kfPTq9Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=njPk/ZegeSbi041XHsdg2zpTPMNoEOo2fFTbqGli9NNbsDxI8ARcRp0tkV4WfMOSE
	 svahc0hcPzlxLdkjdoSG+ggdZdEm57a3PNwc+EPCHAgGsx8xaYUbAQsXgobi5RBByP
	 JOO3db5CbigTNtOrr97KMZvPqqZ++E02FyUD2lJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 290/849] media: i2c: Kconfig: Ensure a dependency on HAVE_CLK for VIDEO_CAMERA_SENSOR
Date: Tue, 11 Nov 2025 09:37:40 +0900
Message-ID: <20251111004543.420589928@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mehdi Djait <mehdi.djait@linux.intel.com>

[ Upstream commit 2d240b124cc9df62ccccee6054bc3d1d19018758 ]

Both ACPI and DT-based systems are required to obtain the external
camera sensor clock using the new devm_v4l2_sensor_clk_get() helper
function.

Ensure a dependency on HAVE_CLK when config VIDEO_CAMERA_SENSOR is
enabled.

Signed-off-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 6237fe804a5c8..1f5a3082ead9c 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -27,7 +27,7 @@ config VIDEO_IR_I2C
 
 menuconfig VIDEO_CAMERA_SENSOR
 	bool "Camera sensor devices"
-	depends on MEDIA_CAMERA_SUPPORT && I2C
+	depends on MEDIA_CAMERA_SUPPORT && I2C && HAVE_CLK
 	select MEDIA_CONTROLLER
 	select V4L2_FWNODE
 	select VIDEO_V4L2_SUBDEV_API
-- 
2.51.0



