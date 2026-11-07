Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064016;
	b=IJjkNCs8RN7ormYBz/+mXYG8grTPEce25PJ2qzKYDZTwfdlZrJgdts81qVGvFerAXFbH
	 oFdnLFSLGYf/nq3lSik0Hy9qUkV1An7yNVlPrjhCS24tvKq13DOOUzEoqav58mBnU6FXi
	 NkZG6awxe1naWHq4wWlFiuhZj1lunkOyXGy7filMdul+GZ7qb43FORuvEQTwCHqh01Lfq
	 6NkOFyFouwfnVmh9y0xuUbHtztOmTeoKHUuk1C7WGZKaGEAUU1enpB9Efqfeh/IvCkU1B
	 I4imtPD93gp28rKa5JRbki+9ZQ3rbvbCyZzu3HzaZwAXdcWOCQ/YpDPdHcVBzZOEHVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kRWvgL3KJyxoccb3yjH81JfwpQF9Kjp1Tr8au3K884I=;
	b=GA5Om09ysyc+LzCxfv6TA9w/leAVNxJ8aLplX7WIfgs1jUniOqsPoTYTKzd/M6sUfY7A
	 XAjQqnutLeFgyTua29TdXkJRgZz8NJi8pqdDHubvbeeXDBsBwF9w7Tj8vGSZveHAIjPDD
	 K2PIlgxVak9MsjsSxIKR2MZKrtQDuKuI/NoOf5WOWw3O/nFwpiywf+DbqkAyiMgx2QPII
	 r1XrMGhwBJ6ZyqWfClkdy8VKGSjv46YbVu4KBVgiU9F8QkT6dkM7TlO5l11QOnYrD7VyL
	 xSszd0SG/abNBr2WfruTpnTW5tpGuSu8aAyKJwxGBQjfpUfeGuslmROp9+V1hTgj5pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sUs6Vrqr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DE9606A334;
	Sat,  7 Nov 2026 15:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sUs6Vrqr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3325F1F008A6;
	Sat,  7 Nov 2026 15:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064016;
	bh=kRWvgL3KJyxoccb3yjH81JfwpQF9Kjp1Tr8au3K884I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUs6Vrqr8pE3rDop+soDjeKJZyjrzFZLdaL8t7fzHt3S6SaqbgDNWrJEa6Nevlr44
	 WyHagMLpMrMbtQxcFN9y+oCDNZmgPUwq0+jSNyXymS19UN+rUOsbPREqnQcf/CKssw
	 cqSn/beqxCx8tQsQCQkw2cnZimudow5xayDrekxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0194/1257] media: imx219: The horizontal blanking step is 8
Date: Sat,  7 Nov 2026 08:41:30 -0500
Message-ID: <20261107134944.813281346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index b1f29037af742..05717b1e32244 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -78,6 +78,7 @@
 #define IMX219_LLP_MIN			0x0d78
 #define IMX219_BINNED_LLP_MIN		0x0de8
 #define IMX219_LLP_MAX			0x7ff0
+#define IMX219_LLP_STEP			8
 
 #define IMX219_REG_X_ADD_STA_A		CCI_REG16(0x0164)
 #define IMX219_REG_X_ADD_END_A		CCI_REG16(0x0166)
@@ -593,7 +594,8 @@ static int imx219_init_controls(struct imx219 *imx219)
 	imx219->hblank = v4l2_ctrl_new_std(ctrl_hdlr, &imx219_ctrl_ops,
 					   V4L2_CID_HBLANK,
 					   IMX219_LLP_MIN - mode->width,
-					   IMX219_LLP_MAX - mode->width, 1,
+					   IMX219_LLP_MAX - mode->width,
+					   IMX219_LLP_STEP,
 					   IMX219_LLP_MIN - mode->width);
 	exposure_max = mode->fll_def - IMX219_EXPOSURE_OFFSET;
 	exposure_def = (exposure_max < IMX219_EXPOSURE_DEFAULT) ?
@@ -935,7 +937,8 @@ static int imx219_set_pad_format(struct v4l2_subdev *sd,
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



