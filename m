Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CE1148843;
	Tue, 23 Apr 2024 21:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908784; cv=none; b=UBA0+7ynuyy/d4pEEYrRVlY00b29s1jZySJGVi4wfGSCn6mPz7NYRf7dGXsTxLlrqSM+I3TwoUDiMZTjyQYaxGG7gGHdLOb+KB+910l19JRKd8mh0U4Td64gu+Dt3A2BrgdC/be8mmjG2SSrCwDwH6Iv/GNkuv+TWjvv//7s4+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908784; c=relaxed/simple;
	bh=Ro2iV7xC4KDR1sQr2TSAHVCMiP1BmKFtG7JfHKF7v5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sY5GzYTomSh4sCl0WRD7Y4RH/CPgiB80QNvITyFLJTfRS7H6YqnrIctgDmbePpO6LclQQxCPrKgd25VhXw5IOu2oiLL6kG3ZSR2Pyk08eHWSDrhIXpapuG4dznQYqmDwdixDvqhnL8jaFX8iamudsEMboclm0os2ZsTg7pcmjA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gbid60Gf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gbid60Gf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC034C32783;
	Tue, 23 Apr 2024 21:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908783;
	bh=Ro2iV7xC4KDR1sQr2TSAHVCMiP1BmKFtG7JfHKF7v5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gbid60GfYsT+23LNikiw3BuwuSV2JnkYbXX7QHS0ifcg0BUjEIrZ4mLf0Ed8zNfCr
	 CPlc6LQwF/5k46assjkezUrdnC+M16/Ie2XWUtPPoea0s2/oSRHJHjQA+cxXI4L8gH
	 XO+wIi/wFCSKz5unsX991ePePiEIehD/J6nfv54c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 33/71] drm/panel: visionox-rm69299: dont unregister DSI device
Date: Tue, 23 Apr 2024 14:39:46 -0700
Message-ID: <20240423213845.291699144@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



