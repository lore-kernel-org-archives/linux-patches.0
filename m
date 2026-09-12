Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF6837F729;
	Sat, 12 Sep 2026 07:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197072; cv=none; b=OJhaoEU57sEwIjhS8AZbvlr6Qg42j5PICsmrNQ/EM9irfEnVPZ3tbw5+4ceQFUKDOk71nUSu5tH/2DzqftP5D+/oUik3URtjtS8oQzBtjtXuoS5/qsUZZwX1u2ELhTiIJPOtFJ7nVNDR1z03CxIAgLk8p5Fju9zFvkNxlReVyAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197072; c=relaxed/simple;
	bh=2/qqM3XDKqIha61cRlkCWoVga0XoWbPGmxkzecT9khw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmXESUVqoyGdVCEen7WO5I8bw380wBD032zOGS1cU25t8VsosXee7445P1NrH7lilgE0/7VDaKE+blxlO7QEs8JSm+30u8RipKd+8SKv1G09rzFzwtKuS+rumptWqzr4A3bO+7ZKsD1oq639+rcrFcL9k0ni+VrjlfyVhTQ0+D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6k14Ik8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6k14Ik8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF95E1F000FF;
	Sat, 12 Sep 2026 07:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197071;
	bh=rE7jyGe6cxUH1lTHdra65glSZfKjrOEv+VnO5vb370E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6k14Ik83Td1c9+EeYt4+Y0iQ1LarfwyyPOAkmHnViwQ6FGoemH+UI4s8xLfSy1fW
	 vBYRwRKLVJIbIdq3M/HHEruOmOji3gorEjjgAHf/aq8vZLiMf7pUoU7aT9fOvuBMk6
	 QGp4ZK53UTv8PraavuoPhv8JR+eUt5bP/+8cRd/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Daniel Stone <daniel@fooishbar.org>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Daniel Stone <daniels@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0052/1815] drm/rockchip: vop2: Recognise 10-bit YUV422 as YUV format
Date: Sat, 12 Sep 2026 08:30:02 +0200
Message-ID: <20260912065650.239591895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index be7830c9001c9..a268bd2fbaaab 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -352,6 +352,8 @@ static bool is_yuv_output(u32 bus_format)
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



