Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0191A256C;
	Thu,  6 Jun 2024 14:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683757; cv=none; b=uKXPNkOTmRpu68WSlZXmai338Hz5fK7/pQDKdXAn+6SrxRZMmjmJ/nzdGFPnE4pvcaCU7buyV0B936oONiDqrlpelVrbSW02HehMHfkJ0HjU/SVBgJ7xIqsEK685JNup4wd+Gv/VJBTbpay4k1sZRCOsZbztT84V81K8WvAaceI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683757; c=relaxed/simple;
	bh=4KZebLwrBX057hUG0N17Z6Gr48PF4T/GiphZIqkBTWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tchIi8YVALJbltiIlxBC+smTIdBmP2Wr6ZnkRWbNRHYnJG46jGOlXL+UsG2OUkpkx1KtYlfNxt8HaTmNVb+lAY+9OdogwS8EnqvtPW33R0znkDdSfLeZachreclfgp5IyHGeH1ts+jIBSdT02pn1EhtPzthVbrpt0pim2j37KII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEIQZtcp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEIQZtcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFC4C32782;
	Thu,  6 Jun 2024 14:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683757;
	bh=4KZebLwrBX057hUG0N17Z6Gr48PF4T/GiphZIqkBTWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEIQZtcpl7wvJ3y6TzqqROBd8Zi9KCfmYWeAYZUednYg42X2e4rBTGxhFPIAeSFX+
	 28SRrEj24X+HBhDGiQFWOVIWS8ath8IGtzBl7FCx0G0rJhJ4BuRPOikVo3os5betXb
	 yih2l1S6DEP5Ey/UGwHk9Swr5k9U2qHjIhr2gy2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Loacker <gerald.loacker@wolfvision.net>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 731/744] drm/panel: sitronix-st7789v: tweak timing for jt240mhqs_hwt_ek_e3 panel
Date: Thu,  6 Jun 2024 16:06:43 +0200
Message-ID: <20240606131755.909263035@linuxfoundation.org>
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

[ Upstream commit 2ba50582634d0bfe3a333ab7575a7f0122a7cde8 ]

Use the default timing parameters to get a refresh rate of about 60 Hz for
a clock of 6 MHz.

Fixes: 0fbbe96bfa08 ("drm/panel: sitronix-st7789v: add jasonic jt240mhqs-hwt-ek-e3 support")
Signed-off-by: Gerald Loacker <gerald.loacker@wolfvision.net>
Acked-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Link: https://lore.kernel.org/r/20240409-bugfix-jt240mhqs_hwt_ek_e3-timing-v2-2-e4821802443d@wolfvision.net
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240409-bugfix-jt240mhqs_hwt_ek_e3-timing-v2-2-e4821802443d@wolfvision.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-sitronix-st7789v.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-sitronix-st7789v.c b/drivers/gpu/drm/panel/panel-sitronix-st7789v.c
index 32e5c03480381..c7e3f1280404d 100644
--- a/drivers/gpu/drm/panel/panel-sitronix-st7789v.c
+++ b/drivers/gpu/drm/panel/panel-sitronix-st7789v.c
@@ -282,9 +282,9 @@ static const struct drm_display_mode et028013dma_mode = {
 static const struct drm_display_mode jt240mhqs_hwt_ek_e3_mode = {
 	.clock = 6000,
 	.hdisplay = 240,
-	.hsync_start = 240 + 28,
-	.hsync_end = 240 + 28 + 10,
-	.htotal = 240 + 28 + 10 + 10,
+	.hsync_start = 240 + 38,
+	.hsync_end = 240 + 38 + 10,
+	.htotal = 240 + 38 + 10 + 10,
 	.vdisplay = 280,
 	.vsync_start = 280 + 48,
 	.vsync_end = 280 + 48 + 4,
-- 
2.43.0



