Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2526634A763;
	Tue,  6 Jan 2026 17:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719930; cv=none; b=OzW97avgnhX7cRpmBhS3QHPZhpflTjPDKUgwmudqVWAWV/RH3BJCEpMrj89+SmVYlvTt+W3E9V6rPP+sFAGbMMSRWKVGCz5evzEiEnD8nftp1oOwBVqKhcDrSNNGieK387o7X9+nTwABWexJSKyvQO16ZYkam2Q8TJ6kLO9J+pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719930; c=relaxed/simple;
	bh=330Ms+fxQ84cMXfBiUOGegbryFFsCPwPxRYc7ABAIEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8thXIuxd3lK2dvIGBTn1g6//UHOh6D8olJuylI/pm7IpKcNkYz7UsgxWseYzi/IDp+uL5gcsVMuvnkiAXNqgOibq9u/Xa7dFjOLNBuJmtaKeorIo9fy+9KaQrE2xSI7AuoNogjYlA4WjHA+rbn3mK7QBH0XyOc1KYC1zcI1WYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmdY5CZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmdY5CZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558A8C16AAE;
	Tue,  6 Jan 2026 17:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719929;
	bh=330Ms+fxQ84cMXfBiUOGegbryFFsCPwPxRYc7ABAIEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hmdY5CZoDOQvuakAZ8iiXvzAjNQliErF9SxbIE4lupkbKMfvLgD+2bVR0vZluGXP5
	 5/c+l7EVq/clwHyLCvMFde0gsZXoSRhzqaRI+6CxV0YXWoOxhxk48LfQbDaiVFUknY
	 hMZevutCR73piBdY293HO35+WjlI2tbjN/lxvr9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Douglas Anderson <dianders@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Martin Botka <martin.botka@somainline.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/567] drm/panel: sony-td4353-jdi: Enable prepare_prev_first
Date: Tue,  6 Jan 2026 17:57:46 +0100
Message-ID: <20260106170454.438106983@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 2b973ca48ff3ef1952091c8f988d7796781836c8 ]

The DSI host must be enabled before our prepare function can run, which
has to send its init sequence over DSI.  Without enabling the host first
the panel will not probe.

Fixes: 9e15123eca79 ("drm/msm/dsi: Stop unconditionally powering up DSI hosts at modeset")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Martin Botka <martin.botka@somainline.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20251130-sony-akari-fix-panel-v1-1-1d27c60a55f5@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-sony-td4353-jdi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-sony-td4353-jdi.c b/drivers/gpu/drm/panel/panel-sony-td4353-jdi.c
index 472195d4bbbe..9ac3e0759efc 100644
--- a/drivers/gpu/drm/panel/panel-sony-td4353-jdi.c
+++ b/drivers/gpu/drm/panel/panel-sony-td4353-jdi.c
@@ -274,6 +274,8 @@ static int sony_td4353_jdi_probe(struct mipi_dsi_device *dsi)
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to get backlight\n");
 
+	ctx->panel.prepare_prev_first = true;
+
 	drm_panel_add(&ctx->panel);
 
 	ret = mipi_dsi_attach(dsi);
-- 
2.51.0



