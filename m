Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0979D171C4;
	Sat,  3 Feb 2024 04:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933399; cv=none; b=OP0Q8/F3t6tHRi+xCAR4x6c6B51jH52tTV8RIt8arwCdRRqjoc1mVM7yK/SbBs1O/OghlTkhevzMrhtzKYpBk3mtSE6DonZd+0gVFtpC7WUQMgjK1UBrHLbgVo0vMRtSSCNvQ4OSVV3pmpsd15VPZxq5OcJgw9B2RK6RzMCbzoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933399; c=relaxed/simple;
	bh=OX8inmMx4Dv8YdVFl51+RxTAJx+P8DK12OvOROuNXrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tt7aq0LnjghpBp7YiLv5IL0DcnQRR7WBminHzkujJ0OSUjJQFRuMK5jt2OgGjUuYxQDGzByEvniS5P5URktOHeDdAV9e7xLD/nwLg0ocG/t9HdXtly/pGKubuoy2y6XJT2cu4ssHFqBrVx+YzKstFfPMOPPj3KasSvVGEjzvw90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhPtJIYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhPtJIYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B52C433C7;
	Sat,  3 Feb 2024 04:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933398;
	bh=OX8inmMx4Dv8YdVFl51+RxTAJx+P8DK12OvOROuNXrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhPtJIYdUBK5A/NRoIX3X8egwR8XHW9V5klLjcrzEuaIoHJvaywPWRpuceCnDYPSx
	 5JgbpwMPl9ir6zehW1Re0fTUNQKvc5uEOGp1Et2Of/FyuUcuyz/C2hxsDKGH8edByj
	 Nn0Y5XbmjcBrTUQe89q12XeiKI3ji2eNMAWlA6Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 115/219] drm/framebuffer: Fix use of uninitialized variable
Date: Fri,  2 Feb 2024 20:04:48 -0800
Message-ID: <20240203035333.577822988@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit f9af8f0c1dc567a5a6a6318ff324c45d80d4a60f ]

smatch reports:

drivers/gpu/drm/drm_framebuffer.c:654 drm_mode_getfb2_ioctl() error: uninitialized symbol 'ret'.

'ret' is possibly not set when there are no errors, causing the error
above. I can't say if that ever happens in real-life, but in any case I
think it is good to initialize 'ret' to 0.

Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231103-uninit-fixes-v2-2-c22b2444f5f5@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_framebuffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_framebuffer.c b/drivers/gpu/drm/drm_framebuffer.c
index 2dd97473ca10..72ad1715f8e7 100644
--- a/drivers/gpu/drm/drm_framebuffer.c
+++ b/drivers/gpu/drm/drm_framebuffer.c
@@ -570,7 +570,7 @@ int drm_mode_getfb2_ioctl(struct drm_device *dev,
 	struct drm_mode_fb_cmd2 *r = data;
 	struct drm_framebuffer *fb;
 	unsigned int i;
-	int ret;
+	int ret = 0;
 
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EINVAL;
-- 
2.43.0



