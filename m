Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D791170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA79C433C7;
	Mon, 11 Sep 2023 14:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441550;
	bh=NH1whBAMTK5y5EGK1vEMIwRTjN7FrC6jRiM+4shsIOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1j/sr4yCCjVx2KorOE89XTHCKme/fOOX6eJjthQ2RYSoCH7+4Vs0Cl3w4WAFiWz4
	 t2G2RCTd4leRGzM81QRv7WaaNthSbEO+TlnsbTa1nYmBMhYQha+nvgJtb9ThSeYCjL
	 TqyuoWBhE8ouluj7wPWlfnQH3QFXv/IP1pIL7SqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommaso Merciai <tomm.merciai@gmail.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 452/739] media: i2c: imx290: drop format param from imx290_ctrl_update
Date: Mon, 11 Sep 2023 15:44:11 +0200
Message-ID: <20230911134703.784905151@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tommaso Merciai <tomm.merciai@gmail.com>

[ Upstream commit 9b4e0e7a570d222be5f5e0f914d3c4528eadeeb4 ]

The format param actually is not used in imx290_ctrl_update
function, let's drop this

Fixes: bc35f9a21a55 ("media: i2c: imx290: Fix the pixel rate at 148.5Mpix/s")
Signed-off-by: Tommaso Merciai <tomm.merciai@gmail.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx290.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/imx290.c b/drivers/media/i2c/imx290.c
index b3f832e9d7e16..0622a9fcd2e07 100644
--- a/drivers/media/i2c/imx290.c
+++ b/drivers/media/i2c/imx290.c
@@ -902,7 +902,6 @@ static const char * const imx290_test_pattern_menu[] = {
 };
 
 static void imx290_ctrl_update(struct imx290 *imx290,
-			       const struct v4l2_mbus_framefmt *format,
 			       const struct imx290_mode *mode)
 {
 	unsigned int hblank_min = mode->hmax_min - mode->width;
@@ -1195,7 +1194,7 @@ static int imx290_set_fmt(struct v4l2_subdev *sd,
 	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
 		imx290->current_mode = mode;
 
-		imx290_ctrl_update(imx290, &fmt->format, mode);
+		imx290_ctrl_update(imx290, mode);
 		imx290_exposure_update(imx290, mode);
 	}
 
@@ -1300,7 +1299,6 @@ static const struct media_entity_operations imx290_subdev_entity_ops = {
 static int imx290_subdev_init(struct imx290 *imx290)
 {
 	struct i2c_client *client = to_i2c_client(imx290->dev);
-	const struct v4l2_mbus_framefmt *format;
 	struct v4l2_subdev_state *state;
 	int ret;
 
@@ -1335,8 +1333,7 @@ static int imx290_subdev_init(struct imx290 *imx290)
 	}
 
 	state = v4l2_subdev_lock_and_get_active_state(&imx290->sd);
-	format = v4l2_subdev_get_pad_format(&imx290->sd, state, 0);
-	imx290_ctrl_update(imx290, format, imx290->current_mode);
+	imx290_ctrl_update(imx290, imx290->current_mode);
 	v4l2_subdev_unlock_state(state);
 
 	return 0;
-- 
2.40.1



