Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043016;
	b=Rjpw+5nrNZSwqvoc4UPl7TlQDi3I8dqD6zL9Ep15ZUX90ZMQVdTr3CqFQjEoBTTphx0z
	 +4y7T1cosPLib24mWrz6wyUN7g4p6pyGSjoREyizmq1Z9zF1FNgIDwOaKFWwob9fFuO0m
	 2HN1pJHgNeoLouA10uNHMJqQGu7j61Bvov3ZwyWHZPB7lhbrdqDqI4v6Eae/MXkTbVbkQ
	 BF8eXlSntYY5fMz+GYnMB0JILv230vMFosZyiwl1bMjD22jPCWqbQP+AB4IARzTUZKmBN
	 msOprXyycJY4WDaD169CpCVvxMHpCS2WE3DrTW/Gu5rV34geKJq8TQ8qBxV9bPQnuUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j+8gDYb3JCVj8xxe1Wj6R2Sdcvtb+1B55b0jDupfLZU=;
	b=E3s2UTf9Gg247T/Jurdxmuh8xq/hZ8vVmhagY5wDEvA2vmfrVEAZIszxB+yVKizjyjlB
	 zv/h1KtK+INJsWuwck+nQ7KDOZqt7/Z+seFcK/kH2d0rMhwUPZRj1Y/M9o7VVCEIQK7bx
	 i39Z9xbNR5H9ZHbaxZY2fvJhgMU5SkDvVXYly9Mxauc7I0CLxO8/51wJhJDrdaXp5smmk
	 bpt6uzwFTZ4/yNoESAdxqw9srQqE0MVY6xT2jFeUWyA3Fa+EppEJiuszbdx6UEUTvEM9o
	 NWm+PmF1GqdmdV2GUSA8nJj1k4WM3jGhMhKPPc3653IAK0gb3rB6NoR2ooGsfcf3IMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="U6Z/ye1l";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28AC606A325;
	Wed, 18 Nov 2026 23:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U6Z/ye1l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46EF1F000C4;
	Wed, 18 Nov 2026 23:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043016;
	bh=j+8gDYb3JCVj8xxe1Wj6R2Sdcvtb+1B55b0jDupfLZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U6Z/ye1lzqAPcJZ75UU5Lhx/jr6hToDn6pibO+26RSw46li4bHf11c1VxPdP28VE9
	 tvTtTMGiNDTTPXIdNm40yNi3D7OVFFkKhhcUyzwb2ktMwSkNLhcF8vm3JK4sNasGud
	 6+iNu/RDGoQay29KbjtTp7PwLiguNWg0p/HsvR0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0018/2857] drm/rockchip: dw_hdmi: Use resume_early pm ops for system suspend
Date: Wed, 18 Nov 2026 15:17:32 +0100
Message-ID: <20261118150202.012851328@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 566f2942f24ae..386ca898812de 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
@@ -666,17 +666,18 @@ static int dw_hdmi_rockchip_remove(struct platform_device *pdev)
 	return 0;
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



