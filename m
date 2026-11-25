Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618013;
	b=SUgEIpL4dCO+adE9anU3jgKLiuDpx8VPT9hCfh8Rt8DmIc52Gp+s3hHSqxNd3lQNVEOr
	 EKHaHpsUhav2muf5dsO7lvHiGLbeVJDGnZjljVYLt58U6OizpYcgQ0na7Ol7/DFwJoM5e
	 xta9hKVI20wJ6kOezYbEoEywpV3pHynsIs9sWrv8Mo/BP6Vtk2EfoGQlWibooMP5l6rV2
	 zw+X5UQD1AWIF1xwqS+pylw685c5jeNaimlSK3cm0lmEsE5Jo8Wc+bAvE6t+6InXf/3Iv
	 MVz/fF8W2DzwwjFe7JaKnKCN5CxDIJAV9LXbvQzg4B71XiZcfjXKRqs0zy9nl5vEPvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VM0Eom/OhCnJ8IY/zi+GBt/3elbcUJ2VAregtRJPjZs=;
	b=XYRjQLV0KCiNoJ7AFgtva8pCPd0nq22UrvqluboF+mL8fTpYjSE/DB9KNMU0ImEAxVE0
	 hu+uk5DWD0fcfG6+K1DbGxl6MBWsUFqDGlkYhNCS0wZhXDZogZjY1Mz3xltzEg5BUmopJ
	 C77iCxedBAJ0+XEA4YWjWYqAWqv8DoY8L+JR6qSHUhB+l6WaR7d1yhcsm+Q2ciJwuQ2wp
	 gAqQyRcphs1HQR6pV3bZ2JmIrOTkCYs4O031KWS6SXkN9pRccrOHqdtSYEU7/Ons9o2q/
	 M/6JUpoot3yzSlXWPf1yNiNX1rvwl+SGP1yFKgzW2JsGkvzSTqMMl+cidH6MAyRk0FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wsYcptrD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE18606A326;
	Wed, 25 Nov 2026 14:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wsYcptrD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4091F000C4;
	Wed, 25 Nov 2026 14:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618012;
	bh=VM0Eom/OhCnJ8IY/zi+GBt/3elbcUJ2VAregtRJPjZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wsYcptrDOdGjwcuMVaO3u5vmO2+O9lLVFm7ZZMeta6Bv1ami8gKliZlHRENUsUrW7
	 Ip6X2WZ4u50pEgAJovd9koUELG0OYxe678DqGDxw/N9+PBe39yK9ii5XZ78xWKhKJp
	 tUblWqj6k3FtYYD+MNrlZ9ZiF8ITuq3qLX0sPWN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0145/1005] drm/panel: visionox-r66451: Send the brightness value MSB first
Date: Wed, 25 Nov 2026 15:24:43 +0100
Message-ID: <20261125143825.134230927@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vz@kernel.org>

[ Upstream commit 00fe6be187ffde738fdb71ea7deb671fc939e583 ]

The panel expects to get two bytes of the DCS Set Display Brightness
command with the most significant byte first, and it uses the lower
12 bits of the value, use mipi_dsi_dcs_set_display_brightness_large()
to correct the programmed brightness values.

Tested on the SM8350-HDK display card, the display brightness increases
gradually with:

  for v in $(seq 16 16 4095); do sleep 0.1; \
    echo $v > /sys/class/backlight/ae94000.dsi.0/brightness; \
  done

while without the change the display is dark during all writes.

Fixes: a6dfab2738fc ("drm/panel: Add driver for Visionox r66451 panel")
Signed-off-by: Vladimir Zapolskiy <vz@kernel.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20261101212458.2431191-2-vz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-visionox-r66451.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-visionox-r66451.c b/drivers/gpu/drm/panel/panel-visionox-r66451.c
index 690cccedd438f..0ce5c670dbb9b 100644
--- a/drivers/gpu/drm/panel/panel-visionox-r66451.c
+++ b/drivers/gpu/drm/panel/panel-visionox-r66451.c
@@ -227,7 +227,7 @@ static int visionox_r66451_bl_update_status(struct backlight_device *bl)
 	struct mipi_dsi_device *dsi = bl_get_data(bl);
 	u16 brightness = backlight_get_brightness(bl);
 
-	return mipi_dsi_dcs_set_display_brightness(dsi, brightness);
+	return mipi_dsi_dcs_set_display_brightness_large(dsi, brightness);
 }
 
 static const struct backlight_ops visionox_r66451_bl_ops = {
-- 
2.53.0



