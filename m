Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70BF46AA82;
	Tue, 21 Jul 2026 15:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648285; cv=none; b=Tb7R0ScujBLioig6g7F1XDu0K8snXxhlka6I5AGNrzut48OEwT4OO5w0iibcXwLbfS5WqIc2kv0rvAws8+j1XThj9cP8PCzQI1kmSiBYaYC18MvWIU003uJOc4HLWlAF6hTLjJvRBvLrZBn7CkHQKisS53mbSjU8GOFoOXfFZPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648285; c=relaxed/simple;
	bh=VRzmJMzlXDyPMuO3FiWy0MBG885PyOxwKazAn1noleY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXfh2As+h4wT2ML16YysLU4ZU0LRh2+5zL/g1qnxm1wtezv/zgkOPrXluquZ2kuW0X0k1fDXJzgjWLfwDTE+4NiNWhkUJ7mJMpAtpqNqSbnMedGz+KwMIo0R83VSnA14c5aUT8kBPYfmEc9pfxrN+WOOM0Us4dkxDDKMSd5Y3t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HE0Z3ZEO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HE0Z3ZEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC031F000E9;
	Tue, 21 Jul 2026 15:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648283;
	bh=4k8fRzBFqnVp/6beCLt5Jy1pP5Vdut8x+tOKPwYBwC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HE0Z3ZEOB2sAlMQfMINdJ/AxoPYEqgtU+svvcXMEPqqKKX9sjO8b3PlJQAPP9+kC/
	 /MZlKa+rpShoMBtrh17EhdSa4jyeIGU5tbH4nT8QGY/XEu9Og3nejAZMazGoogoqMv
	 D4tqji3ZsKgl68sK8tLV9D7a14nqzwjDTNGTBqw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Casey Connolly <casey.connolly@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0142/2077] drm/panel: Clean up SOFEF00 config dependencies
Date: Tue, 21 Jul 2026 16:56:55 +0200
Message-ID: <20260721152556.035522824@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit e87e2357292f80d10e1a43cb910454313a5cb448 ]

As per the config name this Display IC features a DSI command-mode
interface (or the command to switch to video mode is not
known/documented) and does not use any of the video-mode helper
utilities, hence should not select VIDEOMODE_HELPERS.  In addition it
uses devm_gpiod_get() and related functions from GPIOLIB.

Fixes: 5933baa36e26 ("drm/panel/samsung-sofef00: Add panel for OnePlus 6/T devices")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Casey Connolly <casey.connolly@linaro.org>
Reviewed-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260505-panel-clean-up-kconfig-dep-v2-1-9cc31d6e6919@ixit.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
index d592f4f4b939a9..28802f86a538fe 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -982,10 +982,10 @@ config DRM_PANEL_SAMSUNG_S6E8FC0
 
 config DRM_PANEL_SAMSUNG_SOFEF00
 	tristate "Samsung SOFEF00 DSI panel controller"
+	depends on GPIOLIB
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
-	select VIDEOMODE_HELPERS
 	help
 	  Say Y or M here if you want to enable support for the Samsung AMOLED
 	  panel SOFEF00 DDIC and connected panel.
-- 
2.53.0



