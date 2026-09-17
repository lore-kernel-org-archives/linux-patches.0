Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5956497384;
	Thu, 17 Sep 2026 16:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660960; cv=none; b=emM9QNJPW50ZSiWfq6P1tx7vsK+sRYAF5nWPmTYQWKurxVA0A6tIUMYG5bOnKkn3tMvZIYkoHHB3nKsYBVr63w0uijjo3oR+fdivrM54BUUovuEwK9HXVZ7nhOFEGBowTfQ1R0am1Vjy9LeB1WKvNxT4ucofJR1sBbD7x8euUBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660960; c=relaxed/simple;
	bh=hG3Xgbcq/XktMYDSY7qZRIYKHfyWUAN3gudJ5UxddPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egMgkQOv8OG/5uXnhgKVe4thpdq8GAzcmQ6gqBPysHiGkhgNa/bhf9KKvNONJjdog1IhmY0djEVsv0CxidrHGEg78ONF0SRjxqZVKyQpsI8+CMasOHAfute+jYCieJh7PYLF9JjbaxfBxxE5p+op56M6GxRwPk/V8aW69/NPWSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVR02M82; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVR02M82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15F11F00893;
	Thu, 17 Sep 2026 16:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660959;
	bh=xOjgKFzzOlsplNg7cz5x/jEBLNl0Xiid2Hpnt/GrtgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dVR02M82DZ9DCg8X9RIHN51h1Xj1ZwtVkvincxOpVe/Dy5wJvaSkxl+Sa4N94BKET
	 8YtLAzanb41FfqMAjd9YcveQaSv0oU14f/D2s5orOR543g3mLZRM9DtUOYGZTKsqOo
	 xYIUf1VokrPVe0lf3dLbx671galw5+30jkCFmBRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Riccardo Mereu <r.mereu@arduino.cc>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0010/1250] drm/panel: jadard-jd9365da-h3: set prepare_prev_first
Date: Thu, 17 Sep 2026 15:56:45 +0100
Message-ID: <20260917151552.203133968@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit b55a4b5d4769a650f52ea3f1ae680610169d125e ]

Sending DSI commands from the prepare() callback requires DSI link to be
up at that point. For DSI hosts is guaranteed only if the panel driver
sets the .prepare_prev_first flag. Set it to let these panels work with
the DSI hosts which don't power on the link in their .mode_set callback.

Reviewed-by: Linus Walleij <linusw@kernel.org>
Tested-by: Riccardo Mereu <r.mereu@arduino.cc>
Link: https://patch.msgid.link/20260413-waveshare-dsi-touch-v3-13-3aeb53022c32@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c b/drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c
index 5c2530598ddb9..9e5287829b952 100644
--- a/drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c
+++ b/drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c
@@ -1157,6 +1157,8 @@ static int jadard_dsi_probe(struct mipi_dsi_device *dsi)
 	if (ret)
 		return ret;
 
+	jadard->panel.prepare_prev_first = true;
+
 	drm_panel_add(&jadard->panel);
 
 	mipi_dsi_set_drvdata(dsi, jadard);
-- 
2.53.0



