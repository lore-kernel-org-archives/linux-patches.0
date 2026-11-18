Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033448;
	b=vUHZX/qtl89C2Oam4FQQea1TnDPTglpP6Adv8wT/o323EoJ8D/T8a+OpSgeVdgGIMkIw
	 qVd5Dayto25bv65b3tfH/cr/DdBI7piiI/kFfmFNpMF3FC/woIiElGMcXl2z+55+QEJZF
	 63DtxBBP/QplutAUpgXH0wtFfYEuBh0TmgU/FR55sGylvTdpvTQNDne9Eg4oiZmledP8v
	 /G5GXatwwklozrko0VelIN5tQaQVxPU3D8KRoncciwB7pkSYbDYO/O2WrlQTA3aP2E2Dq
	 niK4SPkmLIntuJBPraRF2x/PNAZ4KmSTONcbMoRKd8G99Ao5+EaNKyUH+X8u+ExWG4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MOlcP1lNgEjfB0SrVif/YCtw1Yv/JzHLEvpsOv+gLmU=;
	b=pyGHpHZckgt6WkhuZM700G2lPBd4NeJldu7glR70cajUdbAVRgIFq93dhsVxsFwJG88h
	 7haKqpdp2evwvzpswT4bWcuMI5raTNr7TewAkuQ8+FXdfQtQUby0qmPM4eWQ0SE2Lpcw5
	 w2dTlfNmP1izNe4yuaZ+ZA0lF1z2eLbFxV5TN0aZR8Q5VSxA6GBcYRWAWK74TGncFlWXW
	 esytDx4TQLDPs3IYBeWkBmZLqK9A5kW9X8zRBUT18l9Gu1yiKUqNtE5ZjaCYhR6jZxk+a
	 brDsh9b6ZoafhDoZHkDXPdbYnaWyIRjaxrL3U8KWptijX0Wog3EGH7jaB4Cz9MbD42Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ggLEJZ/K";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8E0606A31C;
	Wed, 18 Nov 2026 20:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ggLEJZ/K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641C61F000C4;
	Wed, 18 Nov 2026 20:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033448;
	bh=MOlcP1lNgEjfB0SrVif/YCtw1Yv/JzHLEvpsOv+gLmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ggLEJZ/KvbILWbSlxKkp4p2olj7ypTQMzt5Az6B7CbDsCVIJZTlttzIXSXuvaIX7c
	 EjykbufL76KqYq9TK6ifdcZJm4IjwbU7xp6yc5JDNucBaSIV4y4RufmdSEx9Arrbnq
	 ou8K/tMIDt2yvwhMTVczGjQQZKW9t3Y45dcMLOpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0019/3318] drm/rockchip: dw_hdmi: Use resume_early pm ops for system suspend
Date: Wed, 18 Nov 2026 15:10:41 +0100
Message-ID: <20261118150314.286966130@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit af3a9eadc11896f6677bcb7102bfb7c84be48d2d ]

rockchip_drm_sys_resume()/drm_mode_config_helper_resume() is called
before the resume pm ops of dw-hdmi. This result in an atomic_enable()
before dw_hdmi_rockchip_resume()/dw_hdmi_resume() is called.

Resume (without changes):
- rockchip_drm_sys_resume()
  - drm_mode_config_helper_resume()
    - atomic_enable()
- dw_hdmi_rockchip_resume()
  - dw_hdmi_resume()
    - dw_hdmi_init_hw()

Change to use resume_early pm ops for system suspend to ensure pm ops
for dw-hdmi is run before rockchip-drm pm ops. Also fix a possible NULL
pointer dereference timing issue while at it.

Resume (with changes):
- dw_hdmi_rockchip_resume_early()
  - dw_hdmi_resume()
    - dw_hdmi_init_hw()
- rockchip_drm_sys_resume()
  - drm_mode_config_helper_resume()
    - atomic_enable()

Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Tested-by: Heiko Stuebner <heiko@sntech.de> #rk3328
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260518193748.2482823-12-jonas@kwiboo.se
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
index aae48e906af11..b8e2f2b87a0d2 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
@@ -690,17 +690,18 @@ static void dw_hdmi_rockchip_remove(struct platform_device *pdev)
 	component_del(&pdev->dev, &dw_hdmi_rockchip_ops);
 }
 
-static int __maybe_unused dw_hdmi_rockchip_resume(struct device *dev)
+static int __maybe_unused dw_hdmi_rockchip_resume_early(struct device *dev)
 {
 	struct rockchip_hdmi *hdmi = dev_get_drvdata(dev);
 
-	dw_hdmi_resume(hdmi->hdmi);
+	if (hdmi)
+		dw_hdmi_resume(hdmi->hdmi);
 
 	return 0;
 }
 
 static const struct dev_pm_ops dw_hdmi_rockchip_pm = {
-	SET_SYSTEM_SLEEP_PM_OPS(NULL, dw_hdmi_rockchip_resume)
+	SET_LATE_SYSTEM_SLEEP_PM_OPS(NULL, dw_hdmi_rockchip_resume_early)
 };
 
 struct platform_driver dw_hdmi_rockchip_pltfm_driver = {
-- 
2.53.0



