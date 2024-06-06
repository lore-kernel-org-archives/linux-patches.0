Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE981A256C;
	Thu,  6 Jun 2024 14:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683757; cv=none; b=kIXXL5z2mTyX4Sj28Hai5DBuZpe7LhhSAPKVs3urMppmsekSdF3FUG70eOT4OBP972J6xrXpPWuZ0+qbSImQU5yUu+x96Y+zyOiRsLumx3HuY4xppAC0F9J36LVIE2RT1tWYSS5lC8TOPIXYK7RJ4/2XgRl+OszOmZLkFrLP7FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683757; c=relaxed/simple;
	bh=JBhFqxmx68kuPoNadAenZ6tIQNnAqYB4QcZLn4Lb+YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWZOG8TK8ePNIdP/cypDVRQFnza0ilHnM3Qwd64qbXPgXJ/WL91pKfqWmgfiTM8iUGJobf6W5s3KcGe20lBLGx2nBoPH6PANEh8c21QpqVuifuLjSzuv3CYUyiQx38GwANQlCdJV0q38Tm6VaddOMRxo9v8JnMyFkGrItxrhJXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2O7HwDmV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2O7HwDmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7D9C2BD10;
	Thu,  6 Jun 2024 14:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683756;
	bh=JBhFqxmx68kuPoNadAenZ6tIQNnAqYB4QcZLn4Lb+YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2O7HwDmVAI6o1lqNnH1m73PU3nTgKPxNYbQYj2h6FsOi9XugZHD2g4fXd+rcySSqr
	 7J6JRbgp5fX4WAZVl6DkmTg8uD5oz3InIB65hYoJ9t0Irv+/XEETYubh8Biqezf54+
	 Oa4yn3kWWsAWLUaEBP03nJzBZSN5yrSSN8gFfU6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Gerald Loacker <gerald.loacker@wolfvision.net>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 730/744] drm/panel: sitronix-st7789v: fix timing for jt240mhqs_hwt_ek_e3 panel
Date: Thu,  6 Jun 2024 16:06:42 +0200
Message-ID: <20240606131755.877139352@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Gerald Loacker <gerald.loacker@wolfvision.net>

[ Upstream commit 0e5895ff7fab0fc05ec17daf9a568368828fa6ea ]

Flickering was observed when using partial mode. Moving the vsync to the
same position as used by the default sitronix-st7789v timing resolves this
issue.

Fixes: 0fbbe96bfa08 ("drm/panel: sitronix-st7789v: add jasonic jt240mhqs-hwt-ek-e3 support")
Acked-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Signed-off-by: Gerald Loacker <gerald.loacker@wolfvision.net>
Link: https://lore.kernel.org/r/20240409-bugfix-jt240mhqs_hwt_ek_e3-timing-v2-1-e4821802443d@wolfvision.net
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240409-bugfix-jt240mhqs_hwt_ek_e3-timing-v2-1-e4821802443d@wolfvision.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-sitronix-st7789v.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-sitronix-st7789v.c b/drivers/gpu/drm/panel/panel-sitronix-st7789v.c
index 88e80fe98112d..32e5c03480381 100644
--- a/drivers/gpu/drm/panel/panel-sitronix-st7789v.c
+++ b/drivers/gpu/drm/panel/panel-sitronix-st7789v.c
@@ -286,9 +286,9 @@ static const struct drm_display_mode jt240mhqs_hwt_ek_e3_mode = {
 	.hsync_end = 240 + 28 + 10,
 	.htotal = 240 + 28 + 10 + 10,
 	.vdisplay = 280,
-	.vsync_start = 280 + 8,
-	.vsync_end = 280 + 8 + 4,
-	.vtotal = 280 + 8 + 4 + 4,
+	.vsync_start = 280 + 48,
+	.vsync_end = 280 + 48 + 4,
+	.vtotal = 280 + 48 + 4 + 4,
 	.width_mm = 43,
 	.height_mm = 37,
 	.flags = DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC,
-- 
2.43.0



