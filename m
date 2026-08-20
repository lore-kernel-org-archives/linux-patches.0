Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4B047D47F;
	Thu, 20 Aug 2026 16:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243703; cv=none; b=q5W4ApohS1XfUJ3/cN4OrS8E8T2eJ0UwOz1uGs0SHI8YFrLtRtUEU6ILyrRkaumZOJu0EcAnGrmNrreP5V9Y0XqPzZ9v24SLggsLVrvvxceH19Bm60xqTdNB3EY7+F5Eiku+BVbqiOcesX3xCeYUjrrhQhqonWLVGPnmwg6Jedk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243703; c=relaxed/simple;
	bh=LPf75bTn6yWdptQyKntrXP6bazK2xGQW4WDCcLi/it8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cp2Hf/jv5markIZjFKno6ExI988uBgMXoT7zGVxeqnrZF1OVRAi8qLld45azZixu/r+Gs1biH6jEjx2F1Qzcso4/pMkdyUd1n2mAyDyHaz5BoqtCVxke7tVtkt+HV+VWVgMRNiDS2PAJkIEN30rkZoXgqjxIxaG7MpFUUOkH/oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YnKnNCsq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YnKnNCsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93771F000E9;
	Thu, 20 Aug 2026 16:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243701;
	bh=a0b47UEhCIR6zwKtZI90oqogBMcGuqVrLQ+/g3Us3tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YnKnNCsq0PHoSyRsjMDSjDjjBuT5LJBZwtSXhXA3Pzwhy76pJwiZvyUv7wJBeohcs
	 F/56J4VJG0bSfSlnZVj4MIAuT/3lWnCiiKS8NaqcFkz90RM8eoDnkacZ4Rwifz5yEM
	 pZyQOCNaRTfMHCg3nDNJQoTEllXQesmcZAgFu0WA=
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
Subject: [PATCH 5.15 185/272] media: i2c: imx219: Correct the minimum vblanking value
Date: Thu, 20 Aug 2026 16:56:09 +0200
Message-ID: <20260820145237.018514702@linuxfoundation.org>
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
Stable-dep-of: 2c4f1ba73543 ("media: imx219: Fix maximum frame length in lines")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx219.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -51,7 +51,7 @@
 #define IMX219_REG_VTS			0x0160
 #define IMX219_FLL_MAX			0xffff
 
-#define IMX219_VBLANK_MIN		4
+#define IMX219_VBLANK_MIN		32
 
 /* HBLANK control - read only */
 #define IMX219_PPL_DEFAULT		3448


