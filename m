Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019555;
	b=cXfJ8NJo1E1j7zbnxEYQB2OF14ENATCJosuWTkLeL+RXLxJeBww67D63+5A5tofzna9B
	 oyKQaF0ETJU9Yps6kKNEo0tN1rAOX+Wfn5fZWL5kVgOLRJSXUBQ6ebI54y9nKpkapr1Zn
	 GO0ZB8F+9yMybvMDuHqfBF5xjyfTlJSZYpXmawsSNJJ7bZTOPWiL3ZfBHbIwjRoZATb4d
	 CyMEfdiENPcdLB1KD4pWDerQAUONJk1zYqMJMDNkZb8/PPHaH3lCJyPvszpVjE8IttvJZ
	 5TdEamX1HeheTe/DZVc1IVVrElbdkSyZY96Z1m0rs4OcfztM0GcdbTPejuQRy/cI09A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=yFxA37EmQJa3vrcswfS9SO05cQ14zggMADXojoMMSQQ=;
	b=wQFg1lIXXIMlNd3GqLyZsoWpC9H3CJ96+GPVHwmuwuMj4KGWFsn4ISzjPMiD5XPWpy8t
	 jQelpQDzrI0tu8FamJxTEnbXvmppFqXDbFJM6TEXIgra2Qx7xV2qkkp03h6i4zApJ7Et2
	 ET7oMIWNargG3GqP4XY9orACfeFehHF7GkvNdPsgcKCgciPU+HtplQlR5dDrUB5putRtT
	 9hGrHH1Iinw+iPI2liL/W+BwCe2Yj7tiX5GRawZsKaYxD7hnNp7cMUMuIdXMDN3nqetsS
	 +st33qSUPi5sPKvr/DjO+K7koLQWcbJdM+RmGmV37xZFfIkuyLFdh8gLGLCPKCwdQkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nSrS+4cM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95118606A31C;
	Wed, 18 Nov 2026 16:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nSrS+4cM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7FF1F000CB;
	Wed, 18 Nov 2026 16:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019555;
	bh=yFxA37EmQJa3vrcswfS9SO05cQ14zggMADXojoMMSQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nSrS+4cM1hQgTpxNzh6B+VPRAIDVSEirasDgvlzY9RB658b3Nd12FaaWNCwvOj/DW
	 poFJpB7UT8dHSWwxh9NM1FbS9fb5N8kMu30CZ8CodLJQ1X7OaN3DSrst2WmyGpPbot
	 dwNuqeRCqAOcwpvyoCf5Jl8D8Pb7QOpJpNXiQZvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Robin=20R=C3=A4ber?= <robin.raebi@gmail.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 7.3 1638/2651] drm/rockchip: dw_hdmi_qp: Cancel pending HPD work on suspend
Date: Wed, 18 Nov 2026 15:47:58 +0100
Message-ID: <20261118150346.798265061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 5d0aa771a5308f6a6c83eeaa89351a472ae580c3 ]

The HPD threaded handler debounces hotplug events by delaying
hdmi->hpd_work for 150 ms.  Nothing discards that work when the system
goes to sleep: drm_kms_helper_poll_disable() only disables the HPD IRQ
line via the bridge .hpd_disable() op, and disable_irq() merely waits
for the threaded handler, which has already returned after arming the
timer.

If the debounce expires during suspend, its non-freezable work may probe
the connector and read the EDID over DDC.  Since genpd powers off the
HDMI controller's power domain in ->suspend_noirq(), this access may
hit unpowered hardware and hang the system.

Cancel the work in the suspend callback.  The DRM device is registered
as a consumer of the HDMI device, so it always suspends first and the
HPD IRQ is already disabled by that point, meaning nothing can re-arm
the work behind our back.  No counterpart is needed on resume, as the
work gets scheduled again on the next hotplug interrupt.

Fixes: 128a9bf8ace2 ("drm/rockchip: Add basic RK3588 HDMI output support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260723015909.7F79A1F000E9@smtp.kernel.org/
Tested-by: Robin Räber <robin.raebi@gmail.com>
Tested-by: Igor Paunovic <royalnet026@gmail.com> # RK3588 Orange Pi 5 Plus, dual HDMI
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20261005-dw-hdmi-qp-scramb-v12-7-195157ba0b40@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c b/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
index 646a4cb968309..42f2627e1a052 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
@@ -728,8 +728,12 @@ static int __maybe_unused dw_hdmi_qp_rockchip_suspend(struct device *dev)
 {
 	struct rockchip_hdmi_qp *hdmi = dev_get_drvdata(dev);
 
-	if (hdmi)
-		dw_hdmi_qp_suspend(dev, hdmi->hdmi);
+	if (!hdmi)
+		return 0;
+
+	cancel_delayed_work_sync(&hdmi->hpd_work);
+
+	dw_hdmi_qp_suspend(dev, hdmi->hdmi);
 
 	return 0;
 }
-- 
2.53.0



