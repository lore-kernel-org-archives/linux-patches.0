Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A385B35A296;
	Mon, 18 Aug 2025 14:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526450; cv=none; b=R7Sz3ocLPb6nWrpoD8Ta4SOPEE/iAMsabKCizNQfiCdwk/egMqtqIcTsW80dJuOC25HNJ0Qha49valxH9RD250CXn0iVELNj8eXelJTpOsIUyki0eLLQsXliD44Dt+ms+1058w+9ES+BXkUqM2cRZ1JIdUk2pmQxRoQJ7O+CviY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526450; c=relaxed/simple;
	bh=Ynr7B52KmX2YLPyygpvbH6+2gzcpai0qnAAEvHtf43I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxqFX+ngVVm3pUrasngLBvEElFRaFtncLUNaldTpd0uR5cEUAgXgl6OHyeUjPAtcCgCcfGOf6izOgcPhUauJJlrZjLQkolQQQcjhriFkttgwmyQYQYV1XOHb3hwbi7NYi3GC49AzZw+w9N5GjkRSg8WTM9rKAMG6Ls7tt6xv8TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjD+cSo8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjD+cSo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EAAC4CEEB;
	Mon, 18 Aug 2025 14:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526450;
	bh=Ynr7B52KmX2YLPyygpvbH6+2gzcpai0qnAAEvHtf43I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjD+cSo83Mx24NsG9EEfp1iI8WUjEyHYXeEQ1Ixj3kDyCvOB8JXNd2DwY8dOLy67v
	 2eQ9K+KS7RgNM8JXIELfDrI6kOzJTqT0A3my844t9FyfALvRIafd76ICh6le4GsBB/
	 tF2q6DrC0pyjd7dHIgT7L0I8KroE+EAlVERMVpiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.16 551/570] media: v4l2: Add support for NV12M tiled variants to v4l2_format_info()
Date: Mon, 18 Aug 2025 14:48:58 +0200
Message-ID: <20250818124527.092480449@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -323,6 +323,12 @@ const struct v4l2_format_info *v4l2_form
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


