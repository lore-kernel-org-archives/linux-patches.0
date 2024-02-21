Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BD83CF42;
	Wed, 21 Feb 2024 14:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525341; cv=none; b=gzvDDZTq33tsMXmUsYLLZmccM5dMbVHOPW5wxn298rrXnA4KrtHXZ3oojZnKM3SwvlCy8JAvQ2cP+PFeABrBH6Yen+t5QdSuZtCOKYP+sL+dg9ar2zAEh4qjUCxQwfB9dtueqYNfCEOhd9BW1Kljxkhijw53wAs+xj9LlT5mo3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525341; c=relaxed/simple;
	bh=l9iirCmRHWGl49yCOx2DojbyWJaLnF0S1sDxwUoLCgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzOlxtT2ngy594ybnFNOhUYk8mV8cQvuzq77ftpC/4SSgbvE45rJlsBvwRqLFhF2vFJhCmIk4Dwb97vB2Tjq5Xpqi2CWeuteDqIZrgFwPgF/6TaPn6WdxncD3PJJkbCaQvAWRJRi/0pteg10/TErHn7sFY/swUSnXIa1Yqvsd18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ft6eunYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ft6eunYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C0DC433F1;
	Wed, 21 Feb 2024 14:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525340;
	bh=l9iirCmRHWGl49yCOx2DojbyWJaLnF0S1sDxwUoLCgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ft6eunYGTdihUmHCWWXbpRmAUwfHc3SU3SVTr0vZ/Lp7NJL1HTpPAH1Uv4edZA8/o
	 Mhl35fD0t+vrKk2axK40qb/hPM+VY8TGzgFWgAaCrC2H42nllLcoz6U5v4o0OI0eeN
	 0wOqvxmyZxCG+ev21t6vz7Nn5JU5uqdjfK3SqS9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 125/267] drm/framebuffer: Fix use of uninitialized variable
Date: Wed, 21 Feb 2024 14:07:46 +0100
Message-ID: <20240221125943.951805121@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 57564318ceea..e85fbbbc07f8 100644
--- a/drivers/gpu/drm/drm_framebuffer.c
+++ b/drivers/gpu/drm/drm_framebuffer.c
@@ -580,7 +580,7 @@ int drm_mode_dirtyfb_ioctl(struct drm_device *dev,
 	struct drm_framebuffer *fb;
 	unsigned flags;
 	int num_clips;
-	int ret;
+	int ret = 0;
 
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EOPNOTSUPP;
-- 
2.43.0



