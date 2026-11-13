Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590548;
	b=qHCyhUaVWoRVcZrRvJs4I91FbEEw6YzzQKQz7GmFL8sLzZ6NmhfwAZQpNsLUrSLwqq1r
	 EU2PyR1tIjHXw+oa3g3Vo4rE+IqCNLSm/uDhd9ttMZmaYPLVX8cNY02RAGZCdkUFrmQYE
	 9hkPnU3l8IDIvUnAk+x2GpqehZtUh2PnJCaG4QAfbk9+XAZGWmKGq35q40PCnoUdZnpY4
	 eKv01Le7UtxwBjTkiS3l4VVMlzjeToiV78yFztUECjHZnfRH3GToqvGw+LTiRbmN4PbeL
	 ho8rOzy634MCns0nmh6GphzOwLh1qe6Be+3b1x9lGmsOP0aK/+QC2Oalds1CdsRLSSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3RgpBfOhsWw3DpWBjmI7e1YsdcvNVBn8xTANMQFCBB4=;
	b=uovCwmCq5EU+cjGDMir4Yc/s8RkYwpsG9IxFxkNGEmSp4Z+s50b3xjf8HzxR0FDQ4jaw
	 pUzFQWsOASj8OTFxdo8+cV4lnCMXqBjS0S9IRUrJtOn+g1z27ROpt0esT5BkwZ06QlDBh
	 fNoPhOQ1tSymKbakVD6kH+AeyrQPbuEbqkEAF7F3sRl9xKLRPjzFyATTB20yQlCCT8C4w
	 LUhR8/mZ4Zl5+WQwPLiOpEBKdgbJiuDA5tIABUDgAgOaOtBJF120Gh7z5jDifReGy1ZGj
	 647hTcUjTgrAtUpOQM7Gr/pd6xNOloovzQ3uWEnZuTg5yvDPxQlcQut3zXQmG6Ov+NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bPT/DDkZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BFF606B361;
	Fri, 13 Nov 2026 17:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bPT/DDkZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445F21F000C8;
	Fri, 13 Nov 2026 17:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590548;
	bh=3RgpBfOhsWw3DpWBjmI7e1YsdcvNVBn8xTANMQFCBB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bPT/DDkZwGq0TI/JuEVUoR73QBFXQBBva6jh5u8aykAawYUkIh0fDtJzwobnxQw5J
	 zuySqvApD9opOd+833ULrkYzfueX1arF7WDOQusS3W50xlh55SWen7M8Z9uApf40pF
	 bfHgIIYWh1kdEOukdgwCbFYE8N5R39jVX40eQjEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 486/686] media: imx219: The horizontal blanking step is 8
Date: Fri, 13 Nov 2026 10:50:19 -0500
Message-ID: <20261113153837.422020712@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 47576c541e9b473841742bd0686d4940f5c93564 ]

The step for the LINE_LENGTH_A register on imx219 is 8. Take this into
account in creating and modifying the horizontal blanking control. The
minimum line length in pixels as well as the horizontal blanking values
are already divisible by 8.

Fixes: cd5e2fd89923 ("media: i2c: imx219: make HBLANK r/w to allow longer exposures")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx219.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index ffb04a56419ad..76e65cedbb32f 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -77,6 +77,7 @@
 #define IMX219_LLP_MIN			0x0d78
 #define IMX219_BINNED_LLP_MIN		0x0de8
 #define IMX219_LLP_MAX			0x7ff0
+#define IMX219_LLP_STEP			8
 
 #define IMX219_REG_X_ADD_STA_A		CCI_REG16(0x0164)
 #define IMX219_REG_X_ADD_END_A		CCI_REG16(0x0166)
@@ -587,7 +588,8 @@ static int imx219_init_controls(struct imx219 *imx219)
 	imx219->hblank = v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops,
 					   V4L2_CID_HBLANK,
 					   IMX219_LLP_MIN - mode->width,
-					   IMX219_LLP_MAX - mode->width, 1,
+					   IMX219_LLP_MAX - mode->width,
+					   IMX219_LLP_STEP,
 					   IMX219_LLP_MIN - mode->width);
 	exposure_max = mode->fll_def - 4;
 	exposure_def = (exposure_max < IMX219_EXPOSURE_DEFAULT) ?
@@ -932,7 +934,8 @@ static int imx219_set_pad_format(struct v4l2_subdev *sd,
 				  IMX219_BINNED_LLP_MIN : IMX219_LLP_MIN;
 		ret = __v4l2_ctrl_modify_range(imx219->hblank,
 					       llp_min - mode->width,
-					       IMX219_LLP_MAX - mode->width, 1,
+					       IMX219_LLP_MAX - mode->width,
+					       IMX219_LLP_STEP,
 					       llp_min - mode->width);
 		if (ret)
 			return ret;
-- 
2.53.0



