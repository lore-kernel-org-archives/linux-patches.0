Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64CC47ECFB;
	Thu, 20 Aug 2026 17:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248350; cv=none; b=PXaJ6RMPDbfiMOkti84MK1XY748gaIhLooLVoSCCy04aGiMeOQk/4/cGMDItgf6qCCtAckK7C5uzHAtaVl/MKAc8iDYhEY1RUyQXkk0ubZwnvf0wHcdHlLI4iVlH/MuWrbOAfKPMjy2H4zh8vfQg6SEcahy8t2Qh/cVIHncPlPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248350; c=relaxed/simple;
	bh=SPCBOmHkFoqOHIaQuY8FJ0/ha4VvYuErkpL5Omt7XPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsGkxEoRVzvEdu8i21wl4OoUdOzTrofDwggUMlafCROchlgVV3wAgw7ONzkMaveJ/LuVTtlZsHcEgRGaP9txe84EcfCrUMsCmmlqZFQ+NWPx8LrCA9tsJCv3w2J4wNdCcZKDGuM/seIeVo01MsxhNUm6I9Ooh6XrrAf6LcT2fZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2V9bpwTJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2V9bpwTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1F91F000E9;
	Thu, 20 Aug 2026 17:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248349;
	bh=Q7HJtowJgTHDxlCDj1tJK+xyGsYo00uE19/h35RaagY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2V9bpwTJ48g2fbsMVKg7RBsvLvC9uwJYjYq/6wC+ZB7YT/1lYKxkLONVvNpsLCVuW
	 T+js3s0gdXzgwYMvuTFUttWBzcRPV/ohethK5eUYl0bDnf88jFBiQEhzN5zLFT1iRZ
	 sDJmPqOnK8viUYqltGF5+YG611r0RoXzlIkbxrtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 198/303] media: imx219: Fix maximum frame length in lines
Date: Thu, 20 Aug 2026 16:55:34 +0200
Message-ID: <20260820145259.336348254@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


