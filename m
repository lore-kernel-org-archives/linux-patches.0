Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B82C17C76;
	Sat,  3 Feb 2024 04:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933601; cv=none; b=W+KXFFxUByLo2ynzqhrKGqRcjT8sOVNmYhzZ/Adjhz8kbDmMn8VvYwHo63ihCJzYD9L4AW2UEAV4chDC3TIho/oaosT5ZBtB5XQRDoPzHtGRvWin4TGSZEG+0HJdLiECaAyKNPotufs06I0xdDLG4/ne7gPfQDX08+2Fls5JGnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933601; c=relaxed/simple;
	bh=QqW/C/BQ2Q/1MriXDQie6BtyTupRIvOqaduhmj/hO2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYIz5xb+vcxfo6jHg2gBUI1xA3c2C74ntHs/HtWFT4cRh91jA4Vq37hE/vpDOw5w/BXRmxNZCeN3P1eVOEbbUnadH7jTjOLcxhvKZt+MXbE698euOc0HEgQHt5dP2PtoRlUxhZU2BmKquqrnyRm7ppS8hXHhXQKkUQ3D3N3C77A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KL/24gs9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KL/24gs9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659E0C433F1;
	Sat,  3 Feb 2024 04:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933601;
	bh=QqW/C/BQ2Q/1MriXDQie6BtyTupRIvOqaduhmj/hO2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KL/24gs9QDC1eD3f/B/agO9evo7+ijqF8UkMscjoN5JmNbNZR2ppRcowyNO+TZL8T
	 vGifTTC8eI5vPkNm0vMNRW0JGKmcwk0hGo4V641l8nPgzsdM39Fn9Xil0E4GFSJ7gw
	 fj8a1I5210ceOJvaNWXLvEBmwd87yRUldb4GjIpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/322] drm/framebuffer: Fix use of uninitialized variable
Date: Fri,  2 Feb 2024 20:04:27 -0800
Message-ID: <20240203035404.727010564@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index aff3746dedfb..1955eaeba0ab 100644
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



