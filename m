Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B751AB52B;
	Mon, 14 Oct 2024 14:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916593; cv=none; b=k/8PeYzy0IwPCVU/baaNThmDy+0ZXLEtR/rbugusQtEucV5IncY/CHsCB7y/xlSCgyANL1C9xCv3ApJmWvjxJzpsar1sYl7RmPBaeSk4cjLG6f5dbcxdV0PzFHIzYp5iUIopeAms2nBX3beIq11RHRDEjQgjrn5N6s86bemQIGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916593; c=relaxed/simple;
	bh=DGZ6CdCDNj14yfX/+pwjIRATyVdRf8MnN0KMSDtGfSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSklDFnkf0mH7tVhI5HIER55Yhd2pOhsLhw25NX8fratNj5O0Y1dNzUCyXxQs1oEcoKAzImMsY+qS65BDCCelaqJiDMfSbJvl82FgmkeboOMxsetym5FfKM3nPwEoh5cE1qXHAfiHLS6VuUX6Ebung11l8q1Rgcqp2h/pgLiDUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7S4PKdh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7S4PKdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB85AC4CEC7;
	Mon, 14 Oct 2024 14:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916593;
	bh=DGZ6CdCDNj14yfX/+pwjIRATyVdRf8MnN0KMSDtGfSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S7S4PKdhvsRikwnC24ejcAWOnuf+SoRZz8K1ES6gALpUgv6BmEQM067Wpwzb55DG3
	 wChiWVXhHYTyL4qS3HL+8iKoK6m2xn1jiEqls084ooHKJOcPunRUE4yLU3jEXqdDwz
	 pGyEMnmrRp2bO6ogZCVAj3vjIpXACkHQg4/vVnC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Yang <yangcong5@huaqin.corp-partner.google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/213] drm/panel: boe-tv101wum-nl6: Fine tune Himax83102-j02 panel HFP and HBP (again)
Date: Mon, 14 Oct 2024 16:18:38 +0200
Message-ID: <20241014141043.460800985@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: Cong Yang <yangcong5@huaqin.corp-partner.google.com>

[ Upstream commit 9dfc46c87cdc8f5a42a71de247a744a6b8188980 ]

The current measured frame rate is 59.95Hz, which does not meet the
requirements of touch-stylus and stylus cannot work normally. After
adjustment, the actual measurement is 60.001Hz. Now this panel looks
like it's only used by me on the MTK platform, so let's change this
set of parameters.

[ dianders: Added "(again") to subject and fixed the "Fixes" line ]

Fixes: cea7008190ad ("drm/panel: boe-tv101wum-nl6: Fine tune Himax83102-j02 panel HFP and HBP")
Signed-off-by: Cong Yang <yangcong5@huaqin.corp-partner.google.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240301061128.3145982-1-yangcong5@huaqin.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
index cfa5b54ed6fe7..e6328991c87e9 100644
--- a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
+++ b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
@@ -2112,11 +2112,11 @@ static const struct panel_desc starry_qfh032011_53g_desc = {
 };
 
 static const struct drm_display_mode starry_himax83102_j02_default_mode = {
-	.clock = 162850,
+	.clock = 162680,
 	.hdisplay = 1200,
-	.hsync_start = 1200 + 50,
-	.hsync_end = 1200 + 50 + 20,
-	.htotal = 1200 + 50 + 20 + 50,
+	.hsync_start = 1200 + 60,
+	.hsync_end = 1200 + 60 + 20,
+	.htotal = 1200 + 60 + 20 + 40,
 	.vdisplay = 1920,
 	.vsync_start = 1920 + 116,
 	.vsync_end = 1920 + 116 + 8,
-- 
2.43.0



