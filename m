Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDFD34252D;
	Sat, 12 Sep 2026 09:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205956; cv=none; b=UeHbFSakEOrS1dG2/JUeBjF6Eo/BW3lNCg/JBqBr+9K6TBe9JjsThBQwitgw+6rpF+2uxY+yJFN9Vw7zKS/zbxXEVew9opHJNVddDcEQ4SIIzLwI9wl/TUBgD7LfiOeZEotRTi4+T3/e/iYxy6oOw1mSIt9t8SeM4MftGDlvEQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205956; c=relaxed/simple;
	bh=gPz5Bzlm4sWkO+fMvdXVaN5FjO/+6GEQ3l+crC+F7Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWdOOYNVsmcQXxWME4YpuJoN5VrOw+DgjAp0E3lKat2l3mwnVsYdUT/eskfcg2ImxrV+U6ViSD84ZSBWSK7gMrKLY/pYzpsCVvEia8SYVajus7PMTvoE+sSvGkl0YhsAiUgHa5Jy+ybmNPIzQ6m4eyoERoN2VY4Em7sjk2w3Amw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WyB+Jgb+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WyB+Jgb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B903A1F000FF;
	Sat, 12 Sep 2026 09:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205954;
	bh=Sy0kqIm0uhli6Vl3EhxmJfdks+2Aa3wSabp00CCc5aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WyB+Jgb+zprkGN2BnUIlU/VLrQ6eJ+UjV/ZDpRbiDRd/P3EGA5jYLRSpgDJKu+l6s
	 zzmjRRH6f3r5q/12kqRhOfHAwKdwQlIjV/8aN09gxABcrf9ll4/ArB8HU4izGcfqCe
	 J6bkvIfJ/pDDa/8pDDvWgF6UTDtkeYP4c6tQ+s3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Daniel Stone <daniel@fooishbar.org>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Daniel Stone <daniels@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0108/1518] drm/rockchip: vop2: Recognise 10-bit YUV422 as YUV format
Date: Sat, 12 Sep 2026 08:37:57 +0200
Message-ID: <20260912065625.920015927@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

[ Upstream commit c1bfe8dac0a79d47eed313b9bcaa2658898684ec ]

The Rockchip VOP2 video output driver has a "is_yuv_output" function,
which returns true when a given bus format is a YUV format, and false
otherwise.

This switch statement is lacking the bus format used for YUV422 10-bit.

Add the two component orderings of the YUV422 10-bit bus formats to the
switch statement.

Fixes: 604be85547ce ("drm/rockchip: Add VOP2 driver")
Reviewed-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Reviewed-by: Daniel Stone <daniel@fooishbar.org>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Link: https://patch.msgid.link/20260609-color-format-v17-13-35739b5782cc@collabora.com
Signed-off-by: Daniel Stone <daniels@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index a9ae9e472f56b..3c48984d62448 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -351,6 +351,8 @@ static bool is_yuv_output(u32 bus_format)
 	switch (bus_format) {
 	case MEDIA_BUS_FMT_YUV8_1X24:
 	case MEDIA_BUS_FMT_YUV10_1X30:
+	case MEDIA_BUS_FMT_YUYV10_1X20:
+	case MEDIA_BUS_FMT_UYVY10_1X20:
 	case MEDIA_BUS_FMT_UYYVYY8_0_5X24:
 	case MEDIA_BUS_FMT_UYYVYY10_0_5X30:
 	case MEDIA_BUS_FMT_YUYV8_2X8:
-- 
2.53.0



