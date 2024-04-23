Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971A0147C70;
	Tue, 23 Apr 2024 21:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908602; cv=none; b=TjipRMy98hTuHnP/Zg24KuKjdvlKT5bjvkc0u3w3V4OmPPnWr+PfDk4apGX8V3n+94PJOrILDGVaSlHrzKCIt4mv3wJR69pHVMA9ykiaPI6s6SgGqru/Tt6N9vukmhD8PTRlMhgTSDjv/svr5nLLUePKo7TLv8BEmK5QbU1PmK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908602; c=relaxed/simple;
	bh=H7lTcsiOMJF2dLc3UEwse4pIgvQF3L5j6qKObDFb6o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4ROuyiQib+CB6VP9OgIGta+sNyl8Cqkr92L1XfIoFH8nlDkdzQOei7laFcVfHaUgSDc0OV9BloLVycYyOMxJDtzOWRfuq3lySEfhfrUbwwYU76z1S7pKAdixAvRcCmQI/Kl8TrGfRwP3tkGVwPxs/ad/FbpDyTMVgEzvOuZcn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZ9rjeuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZ9rjeuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6F1C116B1;
	Tue, 23 Apr 2024 21:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908602;
	bh=H7lTcsiOMJF2dLc3UEwse4pIgvQF3L5j6qKObDFb6o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZ9rjeuJq2wdeMYKIgNnOR6C0nHzryuWYqyNZGhBHXPErAGfGGuiQZv+6f/YFGNZF
	 HpPMSkjiJG3bllwwxtZ5ksRLk9XhedAgbf6m+vVtsWmwHt8+8fIO2EDbkp0us6msM+
	 vmEdlnpSdNZzFx2m3yOybv0LUP4IOiFD7LQ17Zxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/158] drm/panel: visionox-rm69299: dont unregister DSI device
Date: Tue, 23 Apr 2024 14:38:24 -0700
Message-ID: <20240423213857.945570079@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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
index c2806e4fd553b..6e946e5a036ee 100644
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



