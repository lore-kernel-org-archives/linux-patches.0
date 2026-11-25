Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621178;
	b=X1eNembPWv0zsJmGWzit2xa/C3X2txlmTUBZooIPJRXxciYxaKlBQhDZlYbO3DA4pa6x
	 2zOWIfAytW+QEDJAaFIShIcZQ8W/7zlFjVnHJEk8URR6uF1gLZYaxCuuvTNX2qpq8jjYk
	 +2sI0Vr+ngEKmvL6JoC45zxVWvkVBX/h0fihts97d9hf3/dBA8ljvaz9N1Xuu0z8FNaCm
	 oiSt5tStB7sHgz4uUY1PtafCSlkodJFuN03t9F3fOEQvOHkm1moFF3zP6Nl40gzzaq1EO
	 K1qF7avLhFz1e+7a2i/oMM16UDnVUMv43iT5z3b8BPhbj1+W3EKqjYvU9tE7keYMGWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0bdfrqApUwZKebq2PSdw7pAZU3q0+qSDAS6xWmnLKpg=;
	b=GFbhAGkgMcwXTiSRbAxoZTEG8myp8zMZjx40tzxx9p2M1eB/EImEm2Y4/S7Qr/8o7s7k
	 tVl8onmD4Vpxt3/kCd5Gil5D0sb9uHvs2bFdW5vjXo6vpIsPshK98UDC6W+BipQZ799Qi
	 2NhjDZYrXHIlEX07E6zZshnW1FFLk911vrpA0NS849OA+/7YKT3sgU98BVRAt0cjXlOw6
	 E1vMCk191tcgPZ33uZhMOdpIE8EP3BQ/pnnyZaOEAJGu0KBmuwyjAGnsXutD3MfB6rVcs
	 Pnjx38heb3Ph9gPzaVg4scIbAmRk0A6p5FxduvanMVyJAF2kSaicOmML2kDB+fkfB6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FhG2zFsF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005C8606A6AD;
	Wed, 25 Nov 2026 15:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FhG2zFsF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71381F000D3;
	Wed, 25 Nov 2026 15:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621177;
	bh=0bdfrqApUwZKebq2PSdw7pAZU3q0+qSDAS6xWmnLKpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FhG2zFsFCkml+Uo+rrWoM+XgtIsbeI3A90r6AK4SNtzRpSLy5X20oZ9vBZWU+Anux
	 EyfOxQItJbdZ+WibYjaTlAPRxTYY3foerJpn9YRW41gQzgkfxV97gQDUIuIJqCXOXX
	 KpvLUjibf9qk1b693LrbNkBsS0UX8f/In+zWdMWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 145/990] drm/panel: visionox-r66451: Send the brightness value MSB first
Date: Wed, 25 Nov 2026 15:25:12 +0100
Message-ID: <20261125143825.481012670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



