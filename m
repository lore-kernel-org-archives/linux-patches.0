Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D06189B94;
	Mon, 23 Dec 2024 16:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969930; cv=none; b=j/zXTu2zCOqEki4GPy5i2CWPHLXckHMKt3klDT36sXevBYqtuziElsQ75dfvxK/hdF0rQIm7cNuURA6UdUq0qiqYiPQ5ciwJwUv86Nxiaz4F7L7evAYSzYnp74au4SLRygM7ZgSdo4dRhnwgNn71sM8kiEYji3MYS6GGLRD5ozI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969930; c=relaxed/simple;
	bh=rKVny4zwZIMlQ5Z+zI+7xIePG2O6RM3hTRVtAHuUGh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqk0wGHcnvtoJOFEbHvhgRTLyX59bv8Z9/P6LGEPi3ZIA36nirAZIMs+1quAuq1ilULoPF/0f/peHZ5e21VQyzkQxwoCKmy0avY0b+AmquFGhhSP8N/OtTA2QbKMPB3A5xiw5MHf1u3nOP/VLEo13qMCSpSlRKkdgWySvyoGCak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IGFIPKtw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IGFIPKtw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B6BC4CED3;
	Mon, 23 Dec 2024 16:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969930;
	bh=rKVny4zwZIMlQ5Z+zI+7xIePG2O6RM3hTRVtAHuUGh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IGFIPKtw7gP5MK4blNkltSbhkIMUKWbzWI2HUuJbK2cZJh8fKCgp4iKD9BuJba0w3
	 23q7pnC4o0sDP1DhnFa13lAJOq04OFrH5LvaghXRCCMUsON6VorO4xIRBAq1yfhEyM
	 5zmSTYQiOso2uNZzSNzgkIeVzaz1LdiUnqzSAB64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/160] drm/panel: st7701: Add prepare_prev_first flag to drm_panel
Date: Mon, 23 Dec 2024 16:58:26 +0100
Message-ID: <20241223155412.358478601@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 406dd4c7984a457567ca652455d5efad81983f02 ]

The DSI host must be enabled for the panel to be initialized in
prepare(). Set the prepare_prev_first flag to guarantee this.
This fixes the panel operation on NXP i.MX8MP SoC / Samsung DSIM
DSI host.

Fixes: 849b2e3ff969 ("drm/panel: Add Sitronix ST7701 panel driver")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Link: https://lore.kernel.org/r/20241124224812.150263-1-marex@denx.de
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241124224812.150263-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-sitronix-st7701.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-sitronix-st7701.c b/drivers/gpu/drm/panel/panel-sitronix-st7701.c
index eef03d04e0cd..1f72ef7ca74c 100644
--- a/drivers/gpu/drm/panel/panel-sitronix-st7701.c
+++ b/drivers/gpu/drm/panel/panel-sitronix-st7701.c
@@ -1177,6 +1177,7 @@ static int st7701_probe(struct device *dev, int connector_type)
 		return dev_err_probe(dev, ret, "Failed to get orientation\n");
 
 	drm_panel_init(&st7701->panel, dev, &st7701_funcs, connector_type);
+	st7701->panel.prepare_prev_first = true;
 
 	/**
 	 * Once sleep out has been issued, ST7701 IC required to wait 120ms
-- 
2.39.5



