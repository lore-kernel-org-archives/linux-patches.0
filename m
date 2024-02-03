Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729951642F;
	Sat,  3 Feb 2024 04:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933850; cv=none; b=gN0SoRTAZ0c/vXCMUGl49Oj+EzNDBgqKTvTRwM63FP5bdGkYx3GeWkRmrE/dpeAihhiHOE8YffJQ/24VeNwt4Shc9Di71apBfobCK8z/u/kI5k9yzFPKc1ZvjhrYPQAwkh0u+4v4DCc6/20rH/adYw9oXP8y/G9JlOFIqoRZdAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933850; c=relaxed/simple;
	bh=Lh+VD8lYtu28hUF6d7xkETtGj9LEl3OPmu/mezfDivg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xf0KzVR0ZRrZiWXFJzmNP7Po/BpB+UIJLZRT54/Cs20O8/Rv+IXj7YPKGNkb3eoozG05mjnLGOLMvcG40u8VzOsmgdkSpWwZLO41V9yIDVs/6e6TTyCi1ROi7GMLnRRbpyRCgWv65U3PyUrHVmrrrfzsVMSUFTvweO9+UDBtLs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4XghrDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4XghrDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC8AC433C7;
	Sat,  3 Feb 2024 04:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933850;
	bh=Lh+VD8lYtu28hUF6d7xkETtGj9LEl3OPmu/mezfDivg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4XghrDnFoS8ZG8AXV21+SIwE4JCOPryiNm+WOZq46hdYpLVX9+WWcEK4CXjrWRdi
	 jgoEbbf8dX4UCB+bK+mngg8rZRtB33hqcuU/UahtNXR2nLGa0fDLZLmzun+ZTgxnmg
	 ueUvPBwYe9XMtelBqGM9yc09mvvr9aCiYhTU+Ctg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 180/353] drm/framebuffer: Fix use of uninitialized variable
Date: Fri,  2 Feb 2024 20:04:58 -0800
Message-ID: <20240203035409.348719400@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index d3ba0698b84b..36c5629af7d8 100644
--- a/drivers/gpu/drm/drm_framebuffer.c
+++ b/drivers/gpu/drm/drm_framebuffer.c
@@ -552,7 +552,7 @@ int drm_mode_getfb2_ioctl(struct drm_device *dev,
 	struct drm_mode_fb_cmd2 *r = data;
 	struct drm_framebuffer *fb;
 	unsigned int i;
-	int ret;
+	int ret = 0;
 
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EINVAL;
-- 
2.43.0



