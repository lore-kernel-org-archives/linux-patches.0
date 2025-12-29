Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE9433120C;
	Mon, 29 Dec 2025 16:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025194; cv=none; b=EKXg5u8xOlDSLIJiag4vD1fmrCiBSNoT5zuPV4qjf1TKbjOcyC0YL1ReoqnPJl9Dh3/rxDSXkZdmqGFyqsQ/L2iJub31BmvQJgci4Iunlb3JX5YPFQskVhP/4uMlpUaqaU39g/U9ZL7QjDTStzyXP8Jst0wcKIHIpLueCgmL5Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025194; c=relaxed/simple;
	bh=OGoXzyorf4JPP8sT5JANLP3gdP1E7OoxM+QXKp+3bv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKwfXhhmeG5LZtW3PdhNdQQh4tV7FYZTMalA6H4qFo4ZiWj+L4vfg1bToQW/kvXACatdHD+q2sWRrMuc3+XWaaP/Re1FlUQCTw33/JIg0RNlTTv40X8NqBKNRNEa7EuwlW3E4P9MkTe+CLR1NRYHOrf1VQ/9FHVXns/jOnui6No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxdGScMZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxdGScMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0557FC4CEF7;
	Mon, 29 Dec 2025 16:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025194;
	bh=OGoXzyorf4JPP8sT5JANLP3gdP1E7OoxM+QXKp+3bv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxdGScMZhrX5hrhlihbndhVAa9Ucu7xD1RY4YvULdAw6CqUGVc9OkrAyEIVwi7Azk
	 SEjTUN0+ry6OAhZAuETLZa/mWl9ZV4tlXJ57nLZPBDjbkEpei4tD0zFQLMQSGjhui3
	 JPRcPSkMP3BjHbQQKIitsvE9Mhd7GiwII6OvTv9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Douglas Anderson <dianders@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Martin Botka <martin.botka@somainline.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 126/430] drm/panel: sony-td4353-jdi: Enable prepare_prev_first
Date: Mon, 29 Dec 2025 17:08:48 +0100
Message-ID: <20251229160729.003501836@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
index 7c989b70ab51..a14c86c60d19 100644
--- a/drivers/gpu/drm/panel/panel-sony-td4353-jdi.c
+++ b/drivers/gpu/drm/panel/panel-sony-td4353-jdi.c
@@ -212,6 +212,8 @@ static int sony_td4353_jdi_probe(struct mipi_dsi_device *dsi)
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to get backlight\n");
 
+	ctx->panel.prepare_prev_first = true;
+
 	drm_panel_add(&ctx->panel);
 
 	ret = mipi_dsi_attach(dsi);
-- 
2.51.0



