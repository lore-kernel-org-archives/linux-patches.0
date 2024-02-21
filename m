Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A637D411;
	Wed, 21 Feb 2024 14:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524228; cv=none; b=NtYm/lhOvuesc2/D0Eus8wWABoJbcdzkugcQJPZnjc4e0b3v7uioqG9QA76pQFrg5gZ3RTretP1WUdlRIcPQ78+KkVTnWdQzwxYNcrZWNT1qryGXPSc8AwWRDmfDiKELzBvHyKB/zY6XGGn8xYGpeQIkodzrltd+pfQbz6K3/HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524228; c=relaxed/simple;
	bh=Ty63bmVZ3YGtzjHWBUbI3/0VqeMKbTupBEL2yCFZk6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXyO1Wi5wOQMy1OzVrcGyjTWSW8knuBlMb88b29hs9EA0hxcMM05a2hZH3MsZqFOgq4beZ3JMk2Uy860cPaySNYbbGnn6oIB+WtQ2g5+kGsYvTBiZOXKS3EVpX3sjvSx7E9H+HfreQ5xBNemsjw2lsqQzmqhCt3Er/VSF1irceE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxaeeG3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxaeeG3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CACC433C7;
	Wed, 21 Feb 2024 14:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524228;
	bh=Ty63bmVZ3YGtzjHWBUbI3/0VqeMKbTupBEL2yCFZk6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxaeeG3InKjvFi8MU8xycMNPhvJGHVDwIm0dS3JWbH/ewv3oR/MGeMoc/RaI+fVMA
	 LPbeI8gTjYlu7nZJFkpfdwfrD37CraLprpjQOirys7woG0rcMG+rssH1o7fW1v9fpN
	 0zst0anZVBu0LJyFV6UcNvjDF09xV+IHQGT1FqSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 183/379] drm/framebuffer: Fix use of uninitialized variable
Date: Wed, 21 Feb 2024 14:06:02 +0100
Message-ID: <20240221130000.321764978@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2f5b0c2bb0fe..e490ef42441f 100644
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



