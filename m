Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C9512C534;
	Tue, 30 Apr 2024 11:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474933; cv=none; b=Tgrhr3q4KpXc/hwjd7+dSa/L8So2bUBgO7pHasz6zjX/Grm/kpSzLceYg7HlSf6UFOmPBBiihki3iz65q8WQLYdhZGax+craFnWpTxL4elkE73XWTRL3Hht03F8jDBMbNemKF/cUkkwG0mUKKnVzZ/Tw8PRSXdQNn+JNfgtORB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474933; c=relaxed/simple;
	bh=7jcUqfUq+Jh9F09L1xjgESM+c+A3wos48ud8IUxl6rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipynl/9zcSn6e9foT2al5QVkRqqdiFzfmDVHcDhQ6jwsMGCi226rUQ3Nc9j53u09KfriNkYRhEaDe6NLsUaB6ee9MXOgU/CL47xIfDw5Op0wO4NhAG9pPVcT+tnXn6Z+Z/JDjNZ+uC/6vFnEijyerskQkoL4WE7gUDJzq4XoOtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wR5AaFp9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wR5AaFp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5D3C2BBFC;
	Tue, 30 Apr 2024 11:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474933;
	bh=7jcUqfUq+Jh9F09L1xjgESM+c+A3wos48ud8IUxl6rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wR5AaFp9VljgqfFWwf3zIXlpPVdKO/z7PAhkLzkcVDIZh9/WSTYzFTkgfJQQ1+OEZ
	 rq/FP205q2YP9deVgWQtZ2J9/Ulsq4QPr3GToiflmbSyL6DVdkvBgIMzym+2JvTMmt
	 iTWUJAmakrm4f940PppPQec9mhOkyCkf1tAvCnMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/138] drm/panel: visionox-rm69299: dont unregister DSI device
Date: Tue, 30 Apr 2024 12:38:48 +0200
Message-ID: <20240430103050.699306184@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index eb43503ec97b3..6134432e4918d 100644
--- a/drivers/gpu/drm/panel/panel-visionox-rm69299.c
+++ b/drivers/gpu/drm/panel/panel-visionox-rm69299.c
@@ -261,8 +261,6 @@ static int visionox_rm69299_remove(struct mipi_dsi_device *dsi)
 	struct visionox_rm69299 *ctx = mipi_dsi_get_drvdata(dsi);
 
 	mipi_dsi_detach(ctx->dsi);
-	mipi_dsi_device_unregister(ctx->dsi);
-
 	drm_panel_remove(&ctx->panel);
 	return 0;
 }
-- 
2.43.0



