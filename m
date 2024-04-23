Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEC4143C49;
	Tue, 23 Apr 2024 21:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908720; cv=none; b=JPQ0M/2MtFq1HoowT6kokcnTjzsHIsFC/n+dTzMiq3bqQHb9KjcRBQggje7bhMV8SqsuPEv5oMrp2zio/Xsix0aKkn7MatzaAzukv74N+aPxtNS96bS/5BrwJMzumTk2slPLNhVcQzvDJJytSp7mZ82GnwBa6R1L7rILxsAIeDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908720; c=relaxed/simple;
	bh=BQDPeFMV9DbQ57Izr8Z7JFOGvvV4bv9KtHfm3/HfKbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJZ5nUabmiKtMtI3oAWhsVuPnLt1PhYaY3qqRLH+xUlUn9g3oapsJC/eRpjPf3B4G1hBvExSai+xC1BPEZW4SviP+n+T9jdUxoIjHLNCAvLKaM9/2TbezviYHSbRtIOX61hReWUnYQL1IcF+Z8OSUVjKM8rGEtwtwXb5pD56IKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hv0FfiP3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hv0FfiP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D93C3277B;
	Tue, 23 Apr 2024 21:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908720;
	bh=BQDPeFMV9DbQ57Izr8Z7JFOGvvV4bv9KtHfm3/HfKbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hv0FfiP3dFCbKw8OfOLQMZQqU4xEApzdJJ83xnUJF6tlCk2yYjI1bNAs+Q7GAkpYS
	 9N1iVUGWFYlvPcYiS0V1VSdXtzWB3+ZxMHNn93IxI2EykUrIWkWAo+Kul9T6WVHRKy
	 9TEkiovzZd959NtWWYYQta5/Vqlenevsq8sFYWzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/141] drm/panel: visionox-rm69299: dont unregister DSI device
Date: Tue, 23 Apr 2024 14:38:42 -0700
Message-ID: <20240423213855.003378625@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 9e4d3f4f34455abbaa9930bf6b7575a5cd081496 ]

The DSI device for the panel was registered by the DSI host, so it is an
error to unregister it from the panel driver. Drop the call to
mipi_dsi_device_unregister().

Fixes: c7f66d32dd43 ("drm/panel: add support for rm69299 visionox panel")
Reviewed-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240404-drop-panel-unregister-v1-1-9f56953c5fb9@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-visionox-rm69299.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-visionox-rm69299.c b/drivers/gpu/drm/panel/panel-visionox-rm69299.c
index ec228c269146f..b380bbb0e0d0a 100644
--- a/drivers/gpu/drm/panel/panel-visionox-rm69299.c
+++ b/drivers/gpu/drm/panel/panel-visionox-rm69299.c
@@ -261,8 +261,6 @@ static void visionox_rm69299_remove(struct mipi_dsi_device *dsi)
 	struct visionox_rm69299 *ctx = mipi_dsi_get_drvdata(dsi);
 
 	mipi_dsi_detach(ctx->dsi);
-	mipi_dsi_device_unregister(ctx->dsi);
-
 	drm_panel_remove(&ctx->panel);
 }
 
-- 
2.43.0



