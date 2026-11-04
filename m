Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829280;
	b=TPpiq5XGaHQw0dNTwet3gpOg/Mb6Rz/DjgSaZgIL/7u4JGYtwzIfr7q82mKvSubv4vcT
	 TPWGU4Cizb7deaQKYFYjAZFfA/yaswKw/dsbMRbjCTymMOyjVPJSk5nErLLxk0FCYloP5
	 pfw0T1+YXppR4/APG8XCpdSAYlU7RNfDmQOeDFlm7vvvFmejVy6NkhZOM05X/L2hGH+Vh
	 CBM84V5eFRFUmQ+CLJm3ZD227vOAI0FpwarzhzCxfFIo7vDS3aveSBmZMv+f+9z6ZBcOf
	 7Ybr0Nx8t+eizY/XNefExiy5Tc9oNNxFQVVBwYzxUAzPKLPRD5xpfucPqyCrjVslvmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n9GE8oTuugPPygWBgDj5V5WWuVJ2f2Pyy0olaE1IcUI=;
	b=1zdr6OTpJayoLL0HvCNy4PIXAflXA1YFQ3ZXbf9JV8xyDwB9Rxb2GzRS+GkZKZlSG5Fc
	 hx8ZffzShZ34ALyHd0+Rz8ky2Geqzj5edl2kG86MlmRCmqgr+bcYvZcJb9WiBwg6It2oV
	 Z5jb8LKzmp7yaJ7qpQSAntC3qT+5rvyrL4Qg7jYhKpZt3WkSV76QgrAY8VYDMRu7o3ARf
	 o5aRKOF6MOMoJBRXuUEuzErajeoavPjOWFXVbBzUR+0KShH5Bl7w9rG/1BWIp7ic7mzmo
	 QmrSpny+JfTT1ur7A2T4UX09rdEDppmzdqz+3cjGtAO/vn3yQdezJBF/bLcjUghHcbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BpBncEvx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D205360745AE;
	Wed,  4 Nov 2026 21:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BpBncEvx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9DA1F000C1;
	Wed,  4 Nov 2026 21:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829279;
	bh=n9GE8oTuugPPygWBgDj5V5WWuVJ2f2Pyy0olaE1IcUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BpBncEvxecnjacCN7W/E10LExMLnTtJfUMu3+0Btc6RjETpG+i0a2Vx9zijNhrnO9
	 YDQDTBgVVC20n3BRpjZrUy+EBVed5Hk+osRxyVVtN9lqJZ9/Lx8qR8uqsUV7o2EC4v
	 3R2rG+iuNrWCTBUUjM7IoSCPX+qmx6i/a6KFcr/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0017/1005] drm/panel-edp: Add BOE NV116WH2-M30, BOE NT116WHM-N21, BOE NV116FH1-M31, BOE NV116FH1-M30
Date: Wed,  4 Nov 2026 15:55:50 -0500
Message-ID: <20261104211044.027846649@linuxfoundation.org>
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

From: Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>

[ Upstream commit d4ae726fc08024b359e9cacf2507f1c256b9d71c ]

The raw EDIDs for each panel:

BOE NV116WH2-M30
00 ff ff ff ff ff ff 00 09 e5 6e 38 00 00 00 00
0a 24 01 04 95 1a 0e 78 03 0b 55 9a 5f 58 95 28
1e 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 96 1d 56 c8 50 00 26 30 30 20
36 00 00 90 10 00 00 1a b9 13 56 c8 50 00 26 30
30 20 36 00 00 90 10 00 00 1a 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 0d 40 ff 0a 3c 7d 0f 0c 17 7d 00 00 00 00 80

BOE NT116WHM-N21
00 ff ff ff ff ff ff 00 09 e5 79 38 00 00 00 00
08 24 01 04 95 1a 0e 78 03 3a d5 95 5c 58 94 29
24 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 38 1d 56 c8 50 00 1c 30 30 20
36 00 00 90 10 00 00 1a 7b 13 56 c8 50 00 1c 30
30 20 36 00 00 90 10 00 00 1a 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 0d 40 ff 0a 3c 7d 0f 0c 17 7d 00 00 00 00 7a

BOE NV116FH1-M31
00 ff ff ff ff ff ff 00 09 e5 8b 38 01 ff 00 00
0c 24 01 04 a5 1a 0e 78 03 50 d5 9c 55 52 8f 27
15 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 9a 36 80 a0 70 38 28 40 30 20
35 00 00 90 10 00 00 1a 67 24 80 a0 70 38 28 40
30 20 35 00 00 90 10 00 00 1a 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 0d 36 ff 0a 3c 96 0f 0b 1a 96 00 00 00 01 cd

70 20 79 02 00 20 00 0c 9a 0e 00 8b 38 00 00 00
00 0c 1a 00 21 01 1d 03 0a a2 05 80 07 38 04 88
c2 39 55 1e 15 8f 7a 32 15 02 35 54 b0 5c b0 5c
00 36 12 78 22 00 14 ff 21 02 85 7f 07 9f 00 2f
00 1f 00 37 04 27 00 02 00 04 00 81 00 15 74 1a
00 00 03 00 28 3c 00 00 53 5a 53 5a 3c 00 00 00
00 00 00 2b 00 06 27 00 28 3b 00 00 2e 00 06 80
4b b0 5c b0 5c 00 00 00 00 00 00 00 00 00 89 90

BOE NV116FH1-M30
00 ff ff ff ff ff ff 00 09 e5 8c 38 01 ff 00 00
0c 24 01 04 a5 1a 0e 78 03 50 d5 9c 55 52 8f 27
15 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 9a 36 80 a0 70 38 28 40 30 20
35 00 00 90 10 00 00 1a 67 24 80 a0 70 38 28 40
30 20 35 00 00 90 10 00 00 1a 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 0d 36 ff 0a 3c 96 0f 0b 1a 96 00 00 00 01 cc

70 20 79 02 00 20 00 0c 9a 0e 00 8c 38 00 00 00
00 0c 1a 00 21 01 1d 03 0a a2 05 80 07 38 04 88
c2 39 55 1e 15 8f 7a 32 15 02 35 54 b0 5c b0 5c
00 36 12 78 22 00 14 ff 21 02 85 7f 07 9f 00 2f
00 1f 00 37 04 27 00 02 00 04 00 81 00 15 74 1a
00 00 03 00 28 3c 00 00 53 5a 53 5a 3c 00 00 00
00 00 00 2b 00 06 27 00 28 3b 00 00 2e 00 06 80
4b b0 5c b0 5c 00 00 00 00 00 00 00 00 00 88 90

Signed-off-by: Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260608080310.15126-3-terry_hsiao@compal.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index 9ad1769885b3c..792923b1d7878 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -2005,6 +2005,10 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0d45, &delay_200_500_e80, "NV116WHM-N4B"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0d73, &delay_200_500_e80, "NE140WUM-N6S"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0ddf, &delay_200_500_e80, "NV116WHM-T01"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x386e, &delay_200_500_e80, "NV116WH2-M30"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x3879, &delay_200_500_e80, "NT116WHM-N21"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x388b, &delay_200_500_e80, "NV116FH1-M31"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x388c, &delay_200_500_e80, "NV116FH1-M30"),
 
 	EDP_PANEL_ENTRY('C', 'M', 'N', 0x1130, &delay_200_500_e50, "N116BGE-EB2"),
 	EDP_PANEL_ENTRY('C', 'M', 'N', 0x1132, &delay_200_500_e80_d50, "N116BGE-EA2"),
-- 
2.53.0



