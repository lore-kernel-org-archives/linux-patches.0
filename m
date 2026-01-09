Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E881946C8;
	Fri,  9 Jan 2026 12:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960323; cv=none; b=CAxx9AzmJLVeFdA9IGJnPpxQltr+S73ciX12tare1IfkBh8EP/3VtYjkDC+a6MGOTK1PhmGSEZXZJIlkQwXnMLXT++/d3JuQDIyD1jtDZiULr6G58/hhdTOK1n1vl/YXhSHvp+J4fqYcEQKcqkgDa0wK3U4Rkq29+I4mkpALlTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960323; c=relaxed/simple;
	bh=bF08xcUAreejH1gEgMm+bTsy5d90siujNZeIQBU4RCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrCArwktsiCNJneb8/2XLpYf1bm4qQWeWDFRxfpQbu88vZK9NOk3I+Masp603PLwAv9ePT/nD92E5Q2aXuGMsZH8wpM01owd9OGb/Jt3STi3rEavavbCNSSRb3fpW+5NZuM2XWgsRY6XRZNsETpdpDYrxMoS0SMq+owmbX+Ujkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACmLDeZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACmLDeZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE17C4CEF1;
	Fri,  9 Jan 2026 12:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960323;
	bh=bF08xcUAreejH1gEgMm+bTsy5d90siujNZeIQBU4RCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACmLDeZS5CtNIoz6bRvUZRwgN/+ZHUTtnPUH+nETeFEjZohCGQbyi5Pm419w9aUS1
	 TmzBb1XRx2VRFdSxZIVfSd4b5nidcEJb2Rbv6vRiAHRk+bgVQa4jUmblt1xweQDIDM
	 7UJXPY3r8mNnLWbJJ3J1rjLt96LGx2yoxTTuDKKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Douglas Anderson <dianders@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Martin Botka <martin.botka@somainline.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 364/737] drm/panel: sony-td4353-jdi: Enable prepare_prev_first
Date: Fri,  9 Jan 2026 12:38:23 +0100
Message-ID: <20260109112147.689570949@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1bde2f01786b..e7383a0e3d36 100644
--- a/drivers/gpu/drm/panel/panel-sony-td4353-jdi.c
+++ b/drivers/gpu/drm/panel/panel-sony-td4353-jdi.c
@@ -283,6 +283,8 @@ static int sony_td4353_jdi_probe(struct mipi_dsi_device *dsi)
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to get backlight\n");
 
+	ctx->panel.prepare_prev_first = true;
+
 	drm_panel_add(&ctx->panel);
 
 	ret = mipi_dsi_attach(dsi);
-- 
2.51.0



