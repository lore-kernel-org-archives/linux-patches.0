Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59773335BCB;
	Mon, 18 Aug 2025 13:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524607; cv=none; b=hU1u3uC+87f1/3z0GTkYjZqtlVeEM6JC4tp41uuiNOyhyxYk9jjvG9Boy20fxLIHfX7Gp0qIApQTHzvBSAA5wEOuaWHCVAbRUXXFewf9HvMqlmWDXF1PjZgP781qLYiSr//ehJbVJnd+lf+LGp9DfqsEX3kkzpkGRO3AmQd+CsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524607; c=relaxed/simple;
	bh=U/DbNkKJuRZnnDQEuMmX1Si5bFrCrFRUa+nGuOG2o9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKAF7Fa6Bf8Qcj3U3le68CLTVMAJGmT41eBarBbiOYghETKST9fL32fDcnNfuB573UBSWxh+x2CN229hpizy4aEG97iFD4+RZOIBkGGSIm10XrFiNrY2X1XYAqBC1MaKLYYeF6lh3Gx+pvX8vFFJFskeDYZn9m1sYXxZosMZKH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOGtQBpZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOGtQBpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAFEC4CEEB;
	Mon, 18 Aug 2025 13:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524607;
	bh=U/DbNkKJuRZnnDQEuMmX1Si5bFrCrFRUa+nGuOG2o9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOGtQBpZam0rxSioNTFNX0naPbuOAij31K3wCBsRjoIQNDL36ynAN44ppk96lbHqL
	 hVx4WQumqOx6wMzyjqxo/m/uVvtCI/y3cdLuspAgs3jH3Tv82pxS7m/tJ2KI0AzUZ6
	 WyRFKw3w646GXeXuqwTrY44Ix1+v+SbNvF4AYEgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 499/515] media: v4l2: Add support for NV12M tiled variants to v4l2_format_info()
Date: Mon, 18 Aug 2025 14:48:05 +0200
Message-ID: <20250818124517.660207795@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit f7546da1d6eb8928efb89b7faacbd6c2f8f0de5c upstream.

Commit 6f1466123d73 ("media: s5p-mfc: Add YV12 and I420 multiplanar
format support") added support for the new formats to s5p-mfc driver,
what in turn required some internal calls to the v4l2_format_info()
function while setting up formats. This in turn broke support for the
"old" tiled NV12MT* formats, which are not recognized by this function.
Fix this by adding those variants of NV12M pixel format to
v4l2_format_info() function database.

Fixes: 6f1466123d73 ("media: s5p-mfc: Add YV12 and I420 multiplanar format support")
Cc: stable@vger.kernel.org
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-common.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -312,6 +312,12 @@ const struct v4l2_format_info *v4l2_form
 		{ .format = V4L2_PIX_FMT_NV61M,   .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 2, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 2, .vdiv = 1 },
 		{ .format = V4L2_PIX_FMT_P012M,   .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 2, .comp_planes = 2, .bpp = { 2, 4, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 2, .vdiv = 2 },
 
+		/* Tiled YUV formats, non contiguous variant */
+		{ .format = V4L2_PIX_FMT_NV12MT,        .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 2, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 2, .vdiv = 2,
+		  .block_w = { 64, 32, 0, 0 },	.block_h = { 32, 16, 0, 0 }},
+		{ .format = V4L2_PIX_FMT_NV12MT_16X16,  .pixel_enc = V4L2_PIXEL_ENC_YUV, .mem_planes = 2, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 2, .vdiv = 2,
+		  .block_w = { 16,  8, 0, 0 },	.block_h = { 16,  8, 0, 0 }},
+
 		/* Bayer RGB formats */
 		{ .format = V4L2_PIX_FMT_SBGGR8,	.pixel_enc = V4L2_PIXEL_ENC_BAYER, .mem_planes = 1, .comp_planes = 1, .bpp = { 1, 0, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 1, .vdiv = 1 },
 		{ .format = V4L2_PIX_FMT_SGBRG8,	.pixel_enc = V4L2_PIXEL_ENC_BAYER, .mem_planes = 1, .comp_planes = 1, .bpp = { 1, 0, 0, 0 }, .bpp_div = { 1, 1, 1, 1 }, .hdiv = 1, .vdiv = 1 },


