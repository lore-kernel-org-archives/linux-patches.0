Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859031974F2;
	Thu,  6 Jun 2024 14:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683091; cv=none; b=UgpVrNCc2IKs+B3zNtzrcDvl6VTU6KKWIEguDNOHJSSq8vBwB9WihQn8fgqSWnWKHmjzjHghykZiMG5u+j/Sl7/e9hzfHGWepBBzFsEji6wFlTJG2QAhrXhMoUXHoETRhHkZJlJCz0sfV6Uz9spVDcvjemkfedgscanYb/hSsgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683091; c=relaxed/simple;
	bh=3stbjyUfOoQAGrE3xtrvbHNUEDzv1EOKzLdr0b4Qjlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9wr/LkZstYuPVQhtl2HdOupN7gyoiT4X8aR+7sZW3rICuTVy17RGPCeNq9chIokefQQA1SIUS4Z0gqu2Kz8dn5t1+BNWU/pCVgQoYlPA+kiOF3NJ4McNSUV/V7HlaXk6CttQsp4Ah3zf/dru8qt0VbOjCH8QCkT3bK004sNxxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9QFS0Ar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9QFS0Ar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F6AC32782;
	Thu,  6 Jun 2024 14:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683091;
	bh=3stbjyUfOoQAGrE3xtrvbHNUEDzv1EOKzLdr0b4Qjlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9QFS0Ar2JzdhXCgexSJdD7c3m/cZkcQeCXly01YtTFmiyS8K1hbVy1VOTfq1GqfA
	 IDxL638fDSp6JKPnP7fmv61m+ICiIB2nLNtwu6nWXz2EPTjPjEnTCrnLa9US/fdsas
	 Ng0EiVl5nOZ6bkix+hzs9a8ZyFYosChh1GgACF5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Loacker <gerald.loacker@wolfvision.net>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 360/374] drm/panel: sitronix-st7789v: fix display size for jt240mhqs_hwt_ek_e3 panel
Date: Thu,  6 Jun 2024 16:05:39 +0200
Message-ID: <20240606131703.943104045@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerald Loacker <gerald.loacker@wolfvision.net>

[ Upstream commit b62c150c3bae72ac1910dcc588f360159eb0744a ]

This is a portrait mode display. Change the dimensions accordingly.

Fixes: 0fbbe96bfa08 ("drm/panel: sitronix-st7789v: add jasonic jt240mhqs-hwt-ek-e3 support")
Signed-off-by: Gerald Loacker <gerald.loacker@wolfvision.net>
Acked-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Link: https://lore.kernel.org/r/20240409-bugfix-jt240mhqs_hwt_ek_e3-timing-v2-3-e4821802443d@wolfvision.net
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240409-bugfix-jt240mhqs_hwt_ek_e3-timing-v2-3-e4821802443d@wolfvision.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-sitronix-st7789v.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-sitronix-st7789v.c b/drivers/gpu/drm/panel/panel-sitronix-st7789v.c
index c7e3f1280404d..e8f385b9c6182 100644
--- a/drivers/gpu/drm/panel/panel-sitronix-st7789v.c
+++ b/drivers/gpu/drm/panel/panel-sitronix-st7789v.c
@@ -289,8 +289,8 @@ static const struct drm_display_mode jt240mhqs_hwt_ek_e3_mode = {
 	.vsync_start = 280 + 48,
 	.vsync_end = 280 + 48 + 4,
 	.vtotal = 280 + 48 + 4 + 4,
-	.width_mm = 43,
-	.height_mm = 37,
+	.width_mm = 37,
+	.height_mm = 43,
 	.flags = DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC,
 };
 
-- 
2.43.0



