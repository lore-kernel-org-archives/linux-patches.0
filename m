Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829363;
	b=0DVbieUipjbXCcX8Q0OL3Nm8h6oZU16MapBNQ3K47qlXJEu0c4RPvIZWXtFnx3a1XM2y
	 o5zTpf9G5ZW9WtrZxlkXMpCBr6tUkTjzimz18lZYim+1BnKus4FQOJXyexXuCGVAxX/7/
	 e8E185Zp+qpJjQdKWQyEpzuusDBatZhuREsxgz2KsEIg+TZz80/eXIkHEBFXwHlQD9ARn
	 Hz4IYiWXVY/uizLiP+X7tEjjMmvaK+2BxpCZLiWLrw17wd2t48ig6o8Tgk+kU93m43vvx
	 Mpz8BK63oaCkgOEu0RaGtYMUnEZT2lKPVttsZtSBEsurWfkYzqvbg9LT437FcU44cVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4JdWKAdvI4Uy29ET+t1NSOoAjNIZ4TSpvlcwW4G8QiA=;
	b=wYsdnTPrAoP5LlPZY8YNrDs6m7WxqRd1F8bi3VYVd8OkwfCq+KlDm9bFcQw8YeZUQucS
	 qAo/5/4P1UgAQVm23Tdlv9uejXZsQ+4QhzCCHN+XnvIAL69X8AjhSKU+3or0uZu/0Ui5I
	 qMkJ4tocsWgx550xD6QP080iPvBMH8zvV7BHU5hVqOEfyPUwJyYjvTNduQ0xyiNmUeqWe
	 3SIwwmUi9wGkqF6iXoBHCTrz3kTBAAs/KH7ojN/GAst4pV4PdS+/O6HnyR6vIUW6HZ20E
	 EIBrbFxhxUsK2h/3ChRVvJD0waNC6Hn7DUqfg4s3nTZfPZ+5Cb3WmEPqdL0iBjXMjZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A4s0YRjn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E0A60BF2DC;
	Wed,  4 Nov 2026 21:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A4s0YRjn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DB51F00919;
	Wed,  4 Nov 2026 21:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829363;
	bh=4JdWKAdvI4Uy29ET+t1NSOoAjNIZ4TSpvlcwW4G8QiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A4s0YRjnqEAiwofqR/vJscJI3DFRS56vWxHRMOG4GVRyuuScViP8iYrA6GXvUXO43
	 gWrpwmErqv8igmbAJI4r6i6r4LFKx9kpkajFxiHNNpoaypJkjInEjlSBVd1YdwgGQ1
	 iR0YXn8B/zGlmr29K0HnTlFVvoR+rtkT0VQwJl6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damon Ding <damon.ding@rock-chips.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0052/1005] drm/panel-edp: Add BOE NE160QDM-NY1 panel
Date: Wed,  4 Nov 2026 15:56:25 -0500
Message-ID: <20261104211045.048629779@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Damon Ding <damon.ding@rock-chips.com>

[ Upstream commit be4f10d44757211fd656fa57f37034657f26c883 ]

Add an entry for the BOE NE160QDM-NY1 eDP panel. The panel's AUX
backlight functionality is verified and working on the RK3576 EVB1
board.

edid-decode (hex):

00 ff ff ff ff ff ff 00 09 e5 85 09 00 00 00 00
1c 1e 01 04 b5 22 15 78 03 7c e5 a4 55 4c 9f 26
0f 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 6b 6e 00 a0 a0 40 84 60 30 20
36 00 58 d7 10 00 00 1a 00 00 00 fd 0c 3c a5 1f
1f 4e 01 0a 20 20 20 20 20 20 00 00 00 fe 00 42
4f 45 20 43 51 0a 20 20 20 20 20 20 00 00 00 fe
00 4e 45 31 36 30 51 44 4d 2d 4e 59 31 0a 01 ed

02 03 1d 00 e3 05 80 00 e6 06 05 01 6a 6a 24 6d
1a 00 00 02 03 3c a5 00 04 6a 24 6a 24 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff

Signed-off-by: Damon Ding <damon.ding@rock-chips.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260625071916.744686-1-damon.ding@rock-chips.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index 792923b1d7878..f2ae333a32d8c 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1975,6 +1975,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0964, &delay_200_500_e50, "NV133WUM-N61"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x096e, &delay_200_500_e50_po2e200, "NV116WHM-T07 V8.0"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0979, &delay_200_500_e50, "NV116WHM-N49 V8.0"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0985, &delay_200_500_e50, "NE160QDM-NY1"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x098d, &boe_nv110wtm_n61.delay, "NV110WTM-N61"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0993, &delay_200_500_e80, "NV116WHM-T14 V8.0"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x09ad, &delay_200_500_e80, "NV116WHM-N47"),
-- 
2.53.0



