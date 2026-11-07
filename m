Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060560;
	b=ZoMfsVrPFhyAip6kKrcq5ggHvui/mu4PMI2Dt/UW8TTk3EduGPwGr7/6Kq0XP4Z4zgDp
	 7GxddTakw947XeKQVCy9Ga0G7gfx0LhuopGBF7g8xhfhcGp9m1ap5bLTD53Jc5cE6ybSZ
	 9ZPSd7t60bg513fvguVC7C6JaZoxOtC9BLaLLL/kdRRkqjg3IMzLqF7Z2iNv4QiO2Gas7
	 3bouurHnrKndyh9kgkzqOLnp6ZIazX3ELTw18ULYIjrcNOt2J4SbucH4EYXGla9lDr5Fn
	 dfs26Zzpj00txeHtbxdVlWujb18xo/UchgJcwlkZbT8ZsyUd1BCq7rroX7Ck86U9bgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/x4jMEQpB+5N8Xb444HLkML8lx3M+sDsZHvgPfG4FsU=;
	b=uQdHlhiUPstAtMSaj0dr35hTWjQ57Jy49OXLg/BtwTP+bLDnhvx+hLViRJRBQesTAEhu
	 UpuU2UYHkabyeUq2y2UKYCSdMu0CWXBb6MUnYTZoKrA8sV6wTm/BCWTBiJAW4d4QtaMhU
	 HDSl9Og+2LmEdeUvjiPIy+4OJsyI/t4T1ujHL1o7QRHqAzg9DRNGreOn1+vtsrdDKqbm1
	 xmsp1oD3DVO4tJOyQ4weHR3QeUNW5yMM6rTzosg4mFlHMxCzTYqZv8EMjrAZ+quCrTppM
	 IK+sbfRy8HT4Ph14dTW2/DuUWuKS7LfDUzZbofcZLkOJ4Tg8KZ2Npq5Z1GmLg/Qv6Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I63jDqat;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4DB606A326;
	Sat,  7 Nov 2026 14:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I63jDqat
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19C91F0089F;
	Sat,  7 Nov 2026 14:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060560;
	bh=/x4jMEQpB+5N8Xb444HLkML8lx3M+sDsZHvgPfG4FsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I63jDqat87uHaiLpwY30yR+PLP3joVwv3PwCrYWE+z1H++711wBo1oRiA7ZHuxcjF
	 4Q+qGTWfwzPBfKt30WQzozgyCLj2weGbzOL3jNR8os05E/jfn2cEERVnesRaZ5iQER
	 UORycIVilDv7AGbGXFiXl/nksnsaJFCjbRV7IkSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0024/1536] drm/rockchip: dw_hdmi: Use resume_early pm ops for system suspend
Date: Sat,  7 Nov 2026 08:34:00 -0500
Message-ID: <20261107134958.358283577@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 240552eb517f7..6d61c912dde47 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
@@ -663,17 +663,18 @@ static void dw_hdmi_rockchip_remove(struct platform_device *pdev)
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



