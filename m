Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829689;
	b=jKFO1ShyZnbshrcf0gDghWXRa8pb3mfYOAUxGsGimJgSJVU4tERn1qmd64m7b+jtWYKW
	 1078Iyzy/6Tbde1cMWbZz9iWP4WljWSlzP0StCN+FRpuhHZsUsLzWNB59UhdO6tiRLdB2
	 Ab0X6YITiUBBSdLcATtwYHCnau1GAD3b7d/xNYVAsR2oQ64JaI9QNsdxeAVo8XiNy2RIU
	 spqFVqV8dz7/xCASgReS8Pci5DhP68i+Y7WukkXx7eKqpBMMh7lHIP1hbWoN3FewH3gw7
	 G2pEG4YavY2gmyIssapa3uHX0EYHnTmGUxrnW3E3WF3OiBC4rt5e+AjEw5lEWaGIz2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829689;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9jcT9YrZ8f/VIVgrYbbF0Ti4u7hdQn423iEjjyH5r+s=;
	b=aqu9j8r/ODrYW5XHUFlAbIOeVbWxenS/u0fHOdWVcPB1srLEYw5fkyB50xtkAZWv/Vux
	 lTEwtkQr7zxBtM433Sp9UOVCeaiKLVtnjf7ata+YJGE3Koi0SP4SibSkeNkeReYQyxCBa
	 eV9H7ApQeaL5szavNkW6Ye8Hi9/b3pfbCw3jsowEqoYzeKzhziGxvw4oiEVYmiENtyJCl
	 PRP59grmTxBl5EJpc8rgjlSJnBqjaPjF9rKwH0KJdOu5T2Wqtfc58PwgilMcEDmMHJ9Ki
	 7SW0Ta7MqYwOjbidGApkroiVvmDLrt4Sa6r6xgg9QceQx9pV79Ii6qzp14jFWr2NFMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CS/tSx7X";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6BC606EE91;
	Wed,  4 Nov 2026 22:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CS/tSx7X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F4E1F000C1;
	Wed,  4 Nov 2026 22:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829689;
	bh=9jcT9YrZ8f/VIVgrYbbF0Ti4u7hdQn423iEjjyH5r+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CS/tSx7X3k9q1Krc/wI7niHbFYwKlntZt0WrozwBEdEqxyFz2mj5RL2QC1eL8PHHX
	 WYlKox6DUv6+31uWZkKZdqh7+EARwIC1AM0BAtviwjitNQAUUlRyySbfBox3IawS55
	 IbEU8EwGoKbzFVtxkws1X/ySN/8AJYdWIGpsQcso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiji Wang <nebclllo0444@gmail.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0281/1005] drm/panel-edp: Add BOE NE140QDM-NX2
Date: Wed,  4 Nov 2026 16:00:14 -0500
Message-ID: <20261104211051.765070870@linuxfoundation.org>
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

From: Weiji Wang <nebclllo0444@gmail.com>

[ Upstream commit 354b9c43d36ce9b41e48b2d67c5d9b953a0e9d64 ]

Add timing from datasheet for BOE NE140QDM-NX2.

edid-decode (hex):

00 ff ff ff ff ff ff 00 09 e5 f2 0a 00 00 00 00
20 1f 01 04 a5 1e 13 78 03 ee 96 a3 54 4c 99 26
0f 4e 51 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 60 d2 00 a0 a0 40 32 60 30 20
35 00 2e bd 10 00 00 18 c8 9d 00 a0 a0 40 32 60
30 20 35 00 2e bd 10 00 00 18 00 00 00 fd 00 30
78 c6 c6 36 01 0a 20 20 20 20 20 20 00 00 00 fe
00 4e 45 31 34 30 51 44 4d 2d 4e 58 32 20 01 f8

70 13 79 00 00 03 01 14 30 69 00 05 ff 09 9f 00
2f 00 1f 00 3f 06 31 00 02 00 04 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 4d 90

Signed-off-by: Weiji Wang <nebclllo0444@gmail.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/82fc6395-3425-4f71-ba58-813856cee61d@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index 614c63e95c357..65e2f68b919ef 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1989,6 +1989,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0a6a, &delay_200_500_e80, "NV140WUM-N44"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0ac5, &delay_200_500_e50, "NV116WHM-N4C"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0ae8, &delay_200_500_e50_p2e80, "NV140WUM-N41"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0af2, &delay_200_500_e50_p2e80, "NE140QDM-NX2"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b09, &delay_200_500_e50_po2e200, "NV140FHM-NZ"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b1e, &delay_200_500_e80, "NE140QDM-N6A"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b34, &delay_200_500_e80_d50, "NV122WUM-N41"),
-- 
2.53.0



