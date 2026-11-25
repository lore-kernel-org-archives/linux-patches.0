Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624236;
	b=zLanu8a6vaXR2SXF7B9cK+FxnietJftQ+PYRyZLrB1tLTmHHcQA98JmpbbIrcvf1D6cR
	 sDEeB8YP5K+ZPzOBSJ7R06u/B0eOPdGIltKxY59H+/pWLQIkoW7zUKvIBEWo8s1fec8tF
	 eAjmfnQ+v9F+6Jkw4KEJnvTYHWWpZbcuAs5d6XuFbzsANOMsHHbFd8E5AjirfFZ9JKqyj
	 Op60LLHD4TiYe9cKkYyI3K/0jJA6rcVeV7ZkU6TM5d2L+0OEW99W0gd+hZBxH1KwJH0xN
	 oUPreEi+ItM83+PqM16nmpCHRo07XxXDq8jjF8t3iKW/f9h9yFucA7T08yl+CmENCLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+Bw45AWEH61ij5oFJWg+eJGURVFynrdEmV6xD/ho/Ic=;
	b=GeLmzGQC7lWaXZ7hxwJOVTN0tiG3ElRbtj7YbZrNt36gg39EkiVsZrLS2i42gVp8FD4A
	 /pgmFUswWsqyf9YQ+XZP0lOn6Bbc560C+4eQk4ITvQHaK6A3EyC8WzEi5tDgNYKv0qCYw
	 3fFDpha5SGPvpyjTlOokHr7GhsWoVdcr8KpMjs1Jo/hQNTOleF+UP6Qu0cXKZsOQb4ASp
	 hmGhjlLIq4nVq/gi6MWJ8Db8C7axkVL7JTu7e2F842NVZZfjOB0rkPiT6JhU+T/KZGnOv
	 Cw8EhWPUZ7UJ8NHMsUNE2yw4wo5U0YYMqqG+F5uw4dmBxEfetrkTxDtgG8fj0UWAbzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pDZMlJ3u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEFF606A68C;
	Wed, 25 Nov 2026 16:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pDZMlJ3u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CAAE1F000CA;
	Wed, 25 Nov 2026 16:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624236;
	bh=+Bw45AWEH61ij5oFJWg+eJGURVFynrdEmV6xD/ho/Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pDZMlJ3uECEH0xJxux4P2KrScEAKt2o8qNw7gywJCVsDxkW8C/+O82GE8QH/qLn1n
	 9iCK+Kwx70z2YZl67BaGtO/Os03jL51SQA5xYyfVriSXBE7ED0UOTZa8E22HOb4hR0
	 IQ+XCLWIUD8GTo5TrRFgTYuKn5ztZ9MXgSqwpc8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 126/816] drm/panel: visionox-r66451: Send the brightness value MSB first
Date: Wed, 25 Nov 2026 15:27:54 +0100
Message-ID: <20261125143852.123144448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index 493f2a6076f8d..c2b53458a9698 100644
--- a/drivers/gpu/drm/panel/panel-visionox-r66451.c
+++ b/drivers/gpu/drm/panel/panel-visionox-r66451.c
@@ -254,7 +254,7 @@ static int visionox_r66451_bl_update_status(struct backlight_device *bl)
 	struct mipi_dsi_device *dsi = bl_get_data(bl);
 	u16 brightness = backlight_get_brightness(bl);
 
-	return mipi_dsi_dcs_set_display_brightness(dsi, brightness);
+	return mipi_dsi_dcs_set_display_brightness_large(dsi, brightness);
 }
 
 static const struct backlight_ops visionox_r66451_bl_ops = {
-- 
2.53.0



