Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5D8350D79;
	Fri, 21 Nov 2025 13:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732570; cv=none; b=qiBwW6QvjyJRrWYuJ37/smcM1h78u9wzaO/fZ1aCqnCYOXBIJ5Sd+FhY50qVXBZf+K964a2Y13ocf0O9fTF8RJRObjqXi3KzRu7LjYdzhNeRV9+xyTbLclkV4Grhhcjl6zkUkaop/hJbqXhLKIQFQ/1zhkxtqS8X8iziPfVkkfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732570; c=relaxed/simple;
	bh=p9sZMVuv2Z6ec8Nr5+dkhJDFwiCkByN0OCsLWm+c6pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IA497WKvKKGs3Rb7xjGfyarwQRU0VLG142ZMFI+Xy51IsiWDm5Oh0Ff+XdlCzC769z7b9n9/x25PZIcqds/WXnJS2sZTNm3yJdt7f0p6J+jPtTrBajKIo7XxZPvfD2/hgiATbt5g2E9XmN/N3S0nR8paStml7ht3kZHLeXAkudo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hg7LkIqN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hg7LkIqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E6BC4CEF1;
	Fri, 21 Nov 2025 13:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732570;
	bh=p9sZMVuv2Z6ec8Nr5+dkhJDFwiCkByN0OCsLWm+c6pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hg7LkIqNUtws1poxc5M7vbzpd5cD/DWgzidwX+weG7pT44uqTElW8mPM4zjFfAvBQ
	 /EqLXayVPzxUm//EObsvo+HHMIK1eoQmf8ejl8owpn/GuKjWHOd2Hoh/6VFuI9bcFY
	 VJDsnfgITCnQLiiJkyCOPXzajYOodTxB3DPq2PX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/529] media: i2c: Kconfig: Ensure a dependency on HAVE_CLK for VIDEO_CAMERA_SENSOR
Date: Fri, 21 Nov 2025 14:07:13 +0100
Message-ID: <20251121130235.786915830@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 53b443be5a59e..d4082a86fcedb 100644
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



