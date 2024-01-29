Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3289D15A4A6;
	Mon, 29 Jan 2024 17:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548305; cv=none; b=GKRUf53y85/Nb9DA+8kK0LIx27kx/LzWjoid2A+d32xDQnahKtON/ou4ZFBQ3SgkVWbIThS2Iqz7ALmoJsMbby+2kdqHVaVHAHHr94fxb9yfNnic3WGXZz1I8fjwEXz+Ss/wxNm3FVwxnBhLF6BfhwqppJFrvswHdPuesgAuR0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548305; c=relaxed/simple;
	bh=GnbqD4GGma+o4RjPJ+KE6L9LSQbKOBxAE2KzkZvwE68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KmGf7IARkoLMfSL/WbqWMl95RsmfEeV9KS6iYEbTgSGgtBIA0z42lY2NWMLpJRj0mwCu49PgE8sGoHBxnMnCpAry4uiYdrf+jqhZK6OJBQEoynINnIVE/0jQVqT3GP6xaaduSKnpt9qnQ8g2f5I7SdT0lyBUApQ5IwLPnv5/dkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPBmItoM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPBmItoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88F3C433C7;
	Mon, 29 Jan 2024 17:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548304;
	bh=GnbqD4GGma+o4RjPJ+KE6L9LSQbKOBxAE2KzkZvwE68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPBmItoM1gd2zl6lvINoqSVedWtbLarHqXnBqwIWezzgqN3Tf+Tr2Uk+CZzr5OXrX
	 VB5pMgISL6k15aDduutJ3qoz91b2+KhGxABfIBmaN1r2hYMuk0MtP6fSYXga5lm6xP
	 pGxpnWLYBYO5R2HV0PujmRJefd8Ornm2eFD9GH10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 309/346] drm/panel/raydium-rm692e5: select CONFIG_DRM_DISPLAY_DP_HELPER
Date: Mon, 29 Jan 2024 09:05:40 -0800
Message-ID: <20240129170025.561201194@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 589830b13ac21bddf99b9bc5a4ec17813d0869ef ]

As with several other panel drivers, this fails to link without the DP
helper library:

ld: drivers/gpu/drm/panel/panel-raydium-rm692e5.o: in function `rm692e5_prepare':
panel-raydium-rm692e5.c:(.text+0x11f4): undefined reference to `drm_dsc_pps_payload_pack'

Select the same symbols that the others already use.

Fixes: 988d0ff29ecf7 ("drm/panel: Add driver for BOE RM692E5 AMOLED panel")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20231023115619.3551348-1-arnd@kernel.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231023115619.3551348-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
index 99e14dc212ec..a4ac4b47777f 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -530,6 +530,8 @@ config DRM_PANEL_RAYDIUM_RM692E5
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
+	select DRM_DISPLAY_DP_HELPER
+	select DRM_DISPLAY_HELPER
 	help
 	  Say Y here if you want to enable support for Raydium RM692E5-based
 	  display panels, such as the one found in the Fairphone 5 smartphone.
-- 
2.43.0



