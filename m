Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EE03A8F2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ss6GeHu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9867EC433C8;
	Wed, 15 Nov 2023 19:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077791;
	bh=EcBvJGDgMBjdZw/90G3eCxtdm9wN5yKO8/JViuiPo60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ss6GeHu+1alaa2erWvT4/9CUPtDuccqhOI+SGiof7RJTc20+lViwNRoeecaC7On3M
	 vEFo25vvBm6RZMOsSB1kt85gHVm9LRTDMvjizIoDaV+wPRa1ewGqrWDCGUCysPcCP4
	 5gROf/xZjZRMvApqYQvXn6GqliErH5Z583++7Dks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 523/603] media: i2c: imx219: Drop IMX219_REG_CSI_LANE_MODE from common regs array
Date: Wed, 15 Nov 2023 14:17:48 -0500
Message-ID: <20231115191648.177523556@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit ec80c606cca5f7a676febde10d63f5532f57e8e7 ]

The IMX219_REG_CSI_LANE_MODE is configured twice, once with a hardcoded
value in the imx219_common_regs registers array, and once with the value
appropriate for the system in imx219_configure_lanes(). The latter is
enough, drop the former.

Fixes: ceddfd4493b3 ("media: i2c: imx219: Support four-lane operation")
Suggested-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx219.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index f8d164e69b05f..3afa3f79c8a26 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -224,7 +224,6 @@ static const struct cci_reg_sequence imx219_common_regs[] = {
 	{ IMX219_REG_Y_ODD_INC_A, 1 },
 
 	/* Output setup registers */
-	{ IMX219_REG_CSI_LANE_MODE, IMX219_CSI_2_LANE_MODE },
 	{ IMX219_REG_DPHY_CTRL, IMX219_DPHY_CTRL_TIMING_AUTO },
 	{ IMX219_REG_EXCK_FREQ, IMX219_EXCK_FREQ(IMX219_XCLK_FREQ / 1000000) },
 };
-- 
2.42.0



