Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827CE47D47F;
	Thu, 20 Aug 2026 16:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243708; cv=none; b=VK4xpNp05UOBH/j3/Icn0HW107A29gICfPmLOsG+GlCAgW5Vi6r9f9Dj14LSRBGaXrN7P153froOj8fquNEyNztKlQ0gU6Ra2+HyqcqOWEvpihl34LshJUHy24v4Ije0DQbtRBD01xkmnMhFz23riLbQ9v8YOd7ekm+Mx6rlLKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243708; c=relaxed/simple;
	bh=wnRBZEtPA1nussEFUzoj1xqXNXLU7w9Z4rpbFbSzFD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoQRCmbPwit9tlYk6KjvgJZrtM7om0B0yAefIIcBESyZwOPANwgNgFnb9k188Hcw2Yv2M72XB7kJlzTLmXedet3JMLAWDhNffRkogw2s7jD1fcjtVLROFhysYYDL3NZtfyIIF6yg5bYQv1KdK01u1woyc38I+y0TC8W8/qJPRBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grBfTddC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grBfTddC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2B61F000E9;
	Thu, 20 Aug 2026 16:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243707;
	bh=Wk/WIBXNLogLt5ReDtHISLjoeiCJ486F/xlKjNGTb7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=grBfTddCrt8V/m3yljcwbke3zhBkQrLWkxzIpU+yJxjKuFz3J43XYyyGfVv/5ZrIQ
	 AN8vYgLpZJP1VaJR8hyeSstIunVvBuM9Gk67Ns2c15h3OyM8VmCIjluDaaKea1pfyt
	 4Dzf0SlibYdZ4rHA2PlHiXrUACtYgWXQaL6R0uyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 187/272] media: imx219: Fix maximum frame length in lines
Date: Thu, 20 Aug 2026 16:56:11 +0200
Message-ID: <20260820145237.088388904@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 2c4f1ba7354312ad2d6e34e70a518a51a9344715 ]

The driver used the maximum frame length in lines value of 0xffff, but the
maximum appears to be 0xfffe instead. Fix it.

Fixes: 1283b3b8f82b ("media: i2c: Add driver for Sony IMX219 sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx219.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -73,7 +73,7 @@
 
 /* V_TIMING internal */
 #define IMX219_REG_FRM_LENGTH_A		0x0160
-#define IMX219_FLL_MAX			0xffff
+#define IMX219_FLL_MAX			0xfffe
 #define IMX219_VBLANK_MIN		32
 
 #define IMX219_REG_ORIENTATION		0x0172


