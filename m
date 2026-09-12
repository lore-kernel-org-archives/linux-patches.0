Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1820D3BFAF7;
	Sat, 12 Sep 2026 11:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214369; cv=none; b=r0xeDvinfjKjwSKDHuju5q1zXwBzdfbRitqUtnCgcOftxlRnB8/xZ9O7Eb3ttkl+CeBUP9kXq3bO6TdFop43BcIqZE7P3PkJIGAA3oIM+vIWaSoLUXSQOYjkPKKec3cyMcWYf1foAdy9/URogIP0d32G7sDN+Wapi5bYtnXXCcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214369; c=relaxed/simple;
	bh=CDNaVFMtodJGNWgB+n19xSeGLxh7dA1hIE4qZ5cUCDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMln5AnIbI8/D3BjD0ywjWLNA/efUgNMCkBUAvczl7T60isNNfHV11zszYe4vbz9Tzcnlp+EC2NcDOh3vA1KrYHSGGnj+UiiQtja8SwTRXGaMtZMCza5eHqJcuRB9Y6V0W5PYDEuNYNwpa5Iu1hrEGmKLGvT8O49Lpvy1XFoFmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ai/1KR/x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ai/1KR/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19311F000FF;
	Sat, 12 Sep 2026 11:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214367;
	bh=KyBLiQ0oUpQhbv2S+vK/U+iAiPeskRsOxo3TmPGREgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ai/1KR/xztgkTT7aUVIK9vvgcLeMHlbsSgHANtUyxEPFKv6PUTvzN8RRnFNymPlBJ
	 gFWg4oJTlx+EnULv7eXTsi1Nm9uewVYFKzPggHQ7V8HyiFnOD1s5LliRtVobgrB9on
	 8UZNgy0eHMZwS+LuXdlRD7InYWjhwY/F47GZa5Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Daniel Stone <daniel@fooishbar.org>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Daniel Stone <daniels@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0312/1376] drm/rockchip: vop2: Recognise 10-bit YUV422 as YUV format
Date: Sat, 12 Sep 2026 08:45:38 +0200
Message-ID: <20260912065614.503346331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a551458ad4340..42521bd2ac16f 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -514,6 +514,8 @@ static bool is_yuv_output(u32 bus_format)
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



