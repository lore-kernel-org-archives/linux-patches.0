Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F3B58FD2A;
	Thu, 17 Sep 2026 16:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661219; cv=none; b=oXNAKFgPJJg11atjo2Ld4FYlbLeP9aTQN+uvsS+dwTLbqD1FokP/L9vgVawThtqrXDyvUe7cgMZ//0phKeK0LI492yFXBHCreRJphX+KPBCnscji1Fxv0ygXgN36nPJ2Ovdwg5i01r4uLrL/kUS66rjU5cpox4W+Bl7HNHmkROw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661219; c=relaxed/simple;
	bh=Nc7QGwV9F07a/dehCxhaJaKhNGKmNaPbE3HwxqaxlEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDXKk9IgzEaRUnIlg6W6bbbjWIDtHkYswzrLHl+4FmTYT/fcIFXPxF74YWcVUnF/v9pZXu/Ni/rwUwNfHEtTGzTZNbi59OUPm+LhNFQFy1wJ4aPt7lv/OpnI91I1fLRJeagkgHk6WhHikhh4OeZViSW2rOGPsVNQTP2JEW0MKKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUE1yhu1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUE1yhu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD521F00893;
	Thu, 17 Sep 2026 16:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661217;
	bh=YwLuXSfp2AdxygOpsQKVt3+WNrsHxchzn6WMq7sVrJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QUE1yhu1lS+VLSykjDl0EbBaDtvP1z7AIOitXP6pisOI20xLns/algJixbUYIZDPW
	 yntk6N2yOIbTas2JlU4hEcuX6GUpNwICNbshDO03sZOJfTRfFrQz0u1rQABDFI1jiw
	 Fcax/uX0MBSvc4csEJgpTi1z5LQjlIZPSby58uJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0083/1250] drm/panel-edp: Add BOE NT140WHM-N4T, BOE NT140WHM-T05, BOE NV140FHM-N40
Date: Thu, 17 Sep 2026 15:57:58 +0100
Message-ID: <20260917151554.225526960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>

[ Upstream commit a58ff7da4835e76a5ffc078ecfd2773de90e5d8c ]

The raw EDIDs for each panel:

BOE NT140WHM-N4T
00 ff ff ff ff ff ff 00 09 e5 0d 09 00 00 00 00
01 1e 01 04 95 1f 11 78 03 f8 45 96 57 54 92 28
23 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 a9 1d 56 d0 50 00 24 30 30 20
36 00 35 ae 10 00 00 1a c6 13 56 d0 50 00 24 30
30 20 36 00 35 ae 10 00 00 1a 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 0d 40 ff 0a 3c 7d 11 11 21 7d 00 00 00 00 65

BOE NT140WHM-T05
00 ff ff ff ff ff ff 00 09 e5 85 0b 00 00 00 00
01 21 01 04 95 1f 11 78 03 ea a5 93 5c 58 8f 29
1d 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 c7 1d 56 e2 50 00 1e 30 30 20
36 00 35 ae 10 00 00 1a da 13 56 e2 50 00 1e 30
30 20 36 00 35 ae 10 00 00 1a 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 0d 40 ff 0a 3c 7d 11 11 21 7d 00 00 00 00 4e

BOE NV140FHM-N40
00 ff ff ff ff ff ff 00 09 e5 6f 0c 00 00 00 00
19 21 01 04 a5 1f 11 78 03 21 35 97 59 57 8f 29
23 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 c2 37 80 cc 70 38 28 40 6c 30
aa 00 35 ae 10 00 00 1a 2c 25 80 cc 70 38 28 40
6c 30 aa 00 35 ae 10 00 00 1a 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 0d 36 ff 0a 3c 96 09 0a 19 96 00 00 00 01 57

70 20 79 02 00 25 01 09 8c 2d 02 8c 2d 02 28 3c
80 81 00 10 6f 1a 00 00 03 01 28 3c 00 00 53 4a
53 4a 3c 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 e4 90

Signed-off-by: Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260506170607.10813-3-terry_hsiao@compal.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index ad4fd509692d7..cd738fa199288 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1966,6 +1966,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x08b2, &delay_200_500_e200, "NT140WHM-N49"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0848, &delay_200_500_e200, "Unknown"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0849, &delay_200_500_e200, "Unknown"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x090d, &delay_200_500_e50, "NT140WHM-N4T"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x09c3, &delay_200_500_e50, "NT116WHM-N21,836X2"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x094b, &delay_200_500_e50, "NT116WHM-N21"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0951, &delay_200_500_e80, "NV116WHM-N47"),
@@ -1991,8 +1992,10 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b43, &delay_200_500_e200, "NV140FHM-T09"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b56, &delay_200_500_e80, "NT140FHM-N47"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b66, &delay_200_500_e80, "NE140WUM-N6G"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b85, &delay_200_500_e50, "NT140WHM-T05"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0c20, &delay_200_500_e80, "NT140FHM-N47"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0c26, &delay_200_500_p2e200, "NV140WUM-T08"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0c6f, &delay_200_500_e50, "NV140FHM-N40"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0c93, &delay_200_500_e200, "Unknown"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0cb6, &delay_200_500_e200, "NT116WHM-N44"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0cf6, &delay_200_500_e200, "NV140WUM-N64"),
-- 
2.53.0



