Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018073;
	b=NK9mIx6426LMb1tabrXvuaijWcAaGtGHTNiFW94Krr15sxTPOInC36l6iRSube4+9Da7
	 F2wVYOJAqwK53TOw5T9/uE8dGkTUcjqEo0dN3UOerS+98pOWN8prYupVV2MuJjcuBjHJM
	 HG5ofLTK63jL812ZqTTmkS4p2Ye8rI4BxcyQA8fE/MQYXa5LhLxgwfNGgJ9n6aUsu3iiI
	 rs4awndAErJI5TocpYyfviDRJ8KowX/D5XUs61q1R0MlvrQhV1TYWL8KVnau0jj92VYBG
	 +mwori+5JccnH45QDjSvyuJio1zLsEgCaSBCk1WJJXMbAz2DwP5XLEaIKE2Nx5llJ3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HCiEKj+YtIAhFPeFTfjVHbJgrHNM7AlYzpoXNsnXxOc=;
	b=KdTGYIzwSVuqIvcEvRBq9X4I92Dm9U+9vueQt+unrqqWytm8RjrerGBNutrYIQoiW+aC
	 SsyuiBoQsT+x5RHESDyOhtO0tXjcH0Sgp5KNhp5lJ0ndSRNcPAcFZ/V/nI/I2s5tyZfuV
	 cbdORXcIJiARUOzZ11CjlhAmYaM78egQ3xharbOpDq7z1qAyswXQ8W3Y/0vNvz5qmOQzp
	 9o/LhW7E/lZ7dfy+B0H2LuaqXzsOTEH/UdHx43M1AQjQxWdqoB85kSVV/8q4RTMtMb7tN
	 HvQSddstA/d9y1ajs9cYLO3dpn+bQ0QLb0DlooG6eC4v0h9iPWaG+q6MCX90gQ4no/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xJCOE1ch;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411A660A6F4F;
	Wed, 18 Nov 2026 16:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xJCOE1ch
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3FA1F000C7;
	Wed, 18 Nov 2026 16:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018072;
	bh=HCiEKj+YtIAhFPeFTfjVHbJgrHNM7AlYzpoXNsnXxOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xJCOE1chklJxIxkYmcryroeGjM3CxSOUpBpj5o80J+yLUhDiB4Ep50XPxmgpPtZQv
	 XQy6ezdmenqRoNfaTCnE6IBo4+wFzZ1b2wWohbb18fI3lLjmLK3My54ipKEHOvcPni
	 6DGEx1OZwS5ZCrj2JV4DL7g4BHlIe9tUg4b9xuKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <barnabas.pocze+renesas@ideasonboard.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1110/2651] media: rcar-isp: ispcore: Fix inconsistent step sizes
Date: Wed, 18 Nov 2026 15:39:10 +0100
Message-ID: <20261118150327.959005629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Pőcze <barnabas.pocze+renesas@ideasonboard.com>

[ Upstream commit a5b7cf994f6361e2c7be43979c82f16f897afa63 ]

`risp_io_{input,capture}_enum_framesizes()` sets the horizonal and vertical
step size to 2. However, `risp_io_{input,capture}_try_format()` passes 2
to `v4l_bound_align_image()`, which corresponds to a step size of 2^2 = 4.

So move these constants into macros to avoid the repetition, and with that,
use 4 as the step size everywhere.

Fixes: 2151350f60d1 ("media: rcar-isp: Add support for ISPCORE")
Signed-off-by: Barnabás Pőcze <barnabas.pocze+renesas@ideasonboard.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/renesas/rcar-isp/core-io.c | 40 +++++++++++--------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/renesas/rcar-isp/core-io.c b/drivers/media/platform/renesas/rcar-isp/core-io.c
index 820af506f896c..b60b91f43d42d 100644
--- a/drivers/media/platform/renesas/rcar-isp/core-io.c
+++ b/drivers/media/platform/renesas/rcar-isp/core-io.c
@@ -15,6 +15,12 @@
 
 #include "risp-core.h"
 
+#define RISP_MIN_WIDTH 128
+#define RISP_MAX_WIDTH 5120
+#define RISP_MIN_HEIGHT 128
+#define RISP_MAX_HEIGHT 4096
+#define RISP_SIZE_ALIGNMENT 2 /* 2^2 = 4 */
+
 #define risp_io_err(d, fmt, arg...)         dev_err((d)->core->dev, fmt, ##arg)
 
 static struct risp_buffer *risp_io_vb2buf(struct vb2_v4l2_buffer *vb)
@@ -330,8 +336,9 @@ static void risp_io_input_try_format(struct rcar_isp_core_io *io,
 {
 	unsigned int bpp = 0;
 
-	v4l_bound_align_image(&pix->width, 128, 5120, 2,
-			      &pix->height, 128, 4096, 2, 0);
+	v4l_bound_align_image(&pix->width, RISP_MIN_WIDTH, RISP_MAX_WIDTH, RISP_SIZE_ALIGNMENT,
+			      &pix->height, RISP_MIN_HEIGHT, RISP_MAX_HEIGHT, RISP_SIZE_ALIGNMENT,
+			      0);
 
 	for (unsigned int i = 0; i < ARRAY_SIZE(risp_io_input_formats); i++) {
 		if (risp_io_input_formats[i].fourcc == pix->pixelformat) {
@@ -423,13 +430,13 @@ static int risp_io_input_enum_framesizes(struct file *file, void *fh,
 
 	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
 
-	fsize->stepwise.min_width = 128;
-	fsize->stepwise.max_width = 5120;
-	fsize->stepwise.step_width = 2;
+	fsize->stepwise.min_width = RISP_MIN_WIDTH;
+	fsize->stepwise.max_width = RISP_MAX_WIDTH;
+	fsize->stepwise.step_width = 1u << RISP_SIZE_ALIGNMENT;
 
-	fsize->stepwise.min_height = 128;
-	fsize->stepwise.max_height = 4096;
-	fsize->stepwise.step_height = 2;
+	fsize->stepwise.min_height = RISP_MIN_HEIGHT;
+	fsize->stepwise.max_height = RISP_MAX_HEIGHT;
+	fsize->stepwise.step_height = 1u << RISP_SIZE_ALIGNMENT;
 
 	return 0;
 }
@@ -720,8 +727,9 @@ static const struct v4l2_pix_format_mplane risp_io_capture_default_format = {
 static void risp_io_capture_try_format(struct rcar_isp_core_io *io,
 				       struct v4l2_pix_format_mplane *pix)
 {
-	v4l_bound_align_image(&pix->width, 128, 5120, 2,
-			      &pix->height, 128, 4096, 2, 0);
+	v4l_bound_align_image(&pix->width, RISP_MIN_WIDTH, RISP_MAX_WIDTH, RISP_SIZE_ALIGNMENT,
+			      &pix->height, RISP_MIN_HEIGHT, RISP_MAX_HEIGHT, RISP_SIZE_ALIGNMENT,
+			      0);
 
 	pix->field = V4L2_FIELD_NONE;
 	pix->colorspace = V4L2_COLORSPACE_SRGB;
@@ -824,13 +832,13 @@ static int risp_io_capture_enum_framesizes(struct file *file, void *fh,
 
 	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
 
-	fsize->stepwise.min_width = 128;
-	fsize->stepwise.max_width = 5120;
-	fsize->stepwise.step_width = 2;
+	fsize->stepwise.min_width = RISP_MIN_WIDTH;
+	fsize->stepwise.max_width = RISP_MAX_WIDTH;
+	fsize->stepwise.step_width = 1u << RISP_SIZE_ALIGNMENT;
 
-	fsize->stepwise.min_height = 128;
-	fsize->stepwise.max_height = 4096;
-	fsize->stepwise.step_height = 2;
+	fsize->stepwise.min_height = RISP_MIN_HEIGHT;
+	fsize->stepwise.max_height = RISP_MAX_HEIGHT;
+	fsize->stepwise.step_height = 1u << RISP_SIZE_ALIGNMENT;
 
 	return 0;
 }
-- 
2.53.0



