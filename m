Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060591;
	b=wFu0BQZ7Din7Rpqn8sw/7isf/8dUx9wqw64T7a2fRTrqkKcHUhxCthY13EJVDsbuPP3I
	 AcrMLd1EVMRDzp9GdxLef3SLV0MT573fBiDnv4usbmZo02NfslaoTThi0vzYfuFfwlxTy
	 2AnhRvZjc1jmTUBsQROuiEPDEO8OsjofRCbSCSSbkvQcOqFO77j1C9XCKf80aycVWbS29
	 /2zX0Iu82Zyq8rzUDSQ/W54GtyZ/eF4eErfkZNxhFqwnbrIManeRQUWf0Y8+zPqqv+4/s
	 BtKkSWfDXIIGlY4MUB0kwG3AmSnoHwOLrnfvgousrUcJgCYZrTb8ynY1mhNmZQqwnBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l3qb44Ssyp3oXO2GQRGqbxUt8gsYIlvixKDgOl1ubXo=;
	b=EWZBLxaopueWZZdK0IbGUM4UUDmQXSG1tQnXYP9O5MldvEWXBI45Jky+i7sqIt7kWhJG
	 OSWtSnj3acg23h4BJPxiOp2T0OnmKla6hTS6fzyou1q48FM9J6rWkeqNQ+QaANQrYFH3p
	 OM6SNGfWp3E2kV0MVi+NWntZNpXna1uct4oI1xYcnux/Ve7PFPRO6PEJi/EmXnsNvxgDp
	 Tizo4snd5njZvL7TSisPmJnT84x0AI0clZ42/mEwEgKpXP7a517hQOolna2S2YN3I0DZE
	 W0Jj/Kq4dGeelQ+eJtMfcUqnjtWoVzfepRf6a6amdsUA7H0j7N/C39oKGlZ7pXFa+Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MGpECoFi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD5E606A326;
	Sat,  7 Nov 2026 14:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MGpECoFi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B151F008A1;
	Sat,  7 Nov 2026 14:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060591;
	bh=l3qb44Ssyp3oXO2GQRGqbxUt8gsYIlvixKDgOl1ubXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MGpECoFih6Cegw4Mc7gcXEZl3t99MfzNQprMnbykTMJLo6O1E0WfZjLIICoTDcjbB
	 nybviNe9Rv/xiHfRTlhUi4QLSCDJgF6ziqKZEd6ZgPXGtrxNNecZX/HRFwc7FFSzfS
	 ld1m7BCehVv6qbOtvo5PbVwTTq9Xhmxc8XJROUOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damon Ding <damon.ding@rock-chips.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0048/1536] drm/panel-edp: Add BOE NE160QDM-NY1 panel
Date: Sat,  7 Nov 2026 08:34:24 -0500
Message-ID: <20261107134959.009165101@linuxfoundation.org>
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
index 98537e1ac8105..a67386a1ac89c 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1905,6 +1905,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x095f, &delay_200_500_e50, "NE135FBM-N41 v8.1"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x096e, &delay_200_500_e50_po2e200, "NV116WHM-T07 V8.0"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0979, &delay_200_500_e50, "NV116WHM-N49 V8.0"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0985, &delay_200_500_e50, "NE160QDM-NY1"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x098d, &boe_nv110wtm_n61.delay, "NV110WTM-N61"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0993, &delay_200_500_e80, "NV116WHM-T14 V8.0"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x09ad, &delay_200_500_e80, "NV116WHM-N47"),
-- 
2.53.0



