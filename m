Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B872C2D0;
	Mon, 11 Dec 2023 18:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zC19sEOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2E5C433C9;
	Mon, 11 Dec 2023 18:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319536;
	bh=+tkd4F87sCHhsb5xyFvvlV+yS1/e7WEXKrgsSxCROUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zC19sEOmgvIjRwt+A1XgiD/ltwdYWq77Fq1BFystJnZcxGoGxXV0dSxvelVUpl1ND
	 OPmNjDTvx48J56oAQH35qkkDk6WTXwSdMMzfuH/OCtWcstj1KM8qQUclgwckDLVKbO
	 Nrj3p7ZMNoJyi8EcV6ka6GZ87v49pdFI43M7Cpyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/244] drm/bridge: tc358768: select CONFIG_VIDEOMODE_HELPERS
Date: Mon, 11 Dec 2023 19:20:05 +0100
Message-ID: <20231211182050.820443290@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 26513300978f7285c3e776c144f27ef71be61f57 ]

A dependency on this feature was recently introduced:

x86_64-linux-ld: vmlinux.o: in function `tc358768_bridge_pre_enable':
tc358768.c:(.text+0xbe3dae): undefined reference to `drm_display_mode_to_videomode'

Make sure this is always enabled.

Fixes: e5fb21678136 ("drm/bridge: tc358768: Use struct videomode")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20231204072814.968816-1-arnd@kernel.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231204072814.968816-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index ba82a1142adf7..3e6a4e2044c0e 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -313,6 +313,7 @@ config DRM_TOSHIBA_TC358768
 	select REGMAP_I2C
 	select DRM_PANEL
 	select DRM_MIPI_DSI
+	select VIDEOMODE_HELPERS
 	help
 	  Toshiba TC358768AXBG/TC358778XBG DSI bridge chip driver.
 
-- 
2.42.0



