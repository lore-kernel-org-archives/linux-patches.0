Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F6722A4D5;
	Mon, 13 Oct 2025 15:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369345; cv=none; b=bng4g85mXMB7AZO0sYS5YtPvpt2Crt3z7Zcu/9JmOqReLD/qdYHNyk9GwysUKLhVbrZuebW6+nu94EXfRtYhXkx90wx39PF4pwS+qhZlXuaX8sWrI2QGxrUZMxZFJtaaaRIOz0MDWxwtv8NUNfij/c9ms/YJTn/k3ptyMnLnHgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369345; c=relaxed/simple;
	bh=2LyOO3nrxliLJOd/1iPk87XMQNbumUJY/hmcVTwV0Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBTBFYV6kY8RLlKNxOWZNYxOPHl1juiMLjN+YJcdjVRUg4SeAOBbBEwQhLp/Hm7B3hIAWpjR6fZeKtFUYZq6L7Uvca5JChtE1Pcc6s+W4AAV5MGBzzGrn90trFyWK/TYHbVsSHkDaYOJ+sXwvPJyB5yNtdda141934ccKPSiNwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGOZnRHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGOZnRHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A50C4CEE7;
	Mon, 13 Oct 2025 15:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369344;
	bh=2LyOO3nrxliLJOd/1iPk87XMQNbumUJY/hmcVTwV0Jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RGOZnRHLbx9v2jw1GEiyhdZPhNR7+jFiE5myUPQR2fwY5A/ofDjBf4d5W5GmpTBhx
	 IoETKm6p/rPRvuL0KwtTKVzAu8XMATMQlo0mMjLkzYYEPgLL8dz4TyMcxFPBNfaHE2
	 nNRReYgZiSHnhuz61pZLEaYCLwXQqs/jHeT9XpPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Langyan Ye <yelangyan@huaqin.corp-partner.google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 214/563] drm/panel-edp: Add 50ms disable delay for four panels
Date: Mon, 13 Oct 2025 16:41:15 +0200
Message-ID: <20251013144419.037309948@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Langyan Ye <yelangyan@huaqin.corp-partner.google.com>

[ Upstream commit 1511d3c4d2bb30f784924a877f3cef518bb73077 ]

Add 50ms disable delay for NV116WHM-N49, NV122WUM-N41, and MNC207QS1-1
to satisfy T9+T10 timing. Add 50ms disable delay for MNE007JA1-2
as well, since MNE007JA1-2 copies the timing of MNC207QS1-1.

Specifically, it should be noted that the MNE007JA1-2 panel was added
by someone who did not have the panel documentation, so they simply
copied the timing from the MNC207QS1-1 panel. Adding an extra 50 ms
of delay should be safe.

Fixes: 0547692ac146 ("drm/panel-edp: Add several generic edp panels")
Fixes: 50625eab3972 ("drm/edp-panel: Add panel used by T14s Gen6 Snapdragon")
Signed-off-by: Langyan Ye <yelangyan@huaqin.corp-partner.google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20250723072513.2880369-1-yelangyan@huaqin.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index 09170470b3ef1..d0aa602ecc9de 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1736,10 +1736,11 @@ static const struct panel_delay delay_200_500_e50 = {
 	.enable = 50,
 };
 
-static const struct panel_delay delay_200_500_e50_p2e200 = {
+static const struct panel_delay delay_200_500_e50_d50_p2e200 = {
 	.hpd_absent = 200,
 	.unprepare = 500,
 	.enable = 50,
+	.disable = 50,
 	.prepare_to_enable = 200,
 };
 
@@ -1941,13 +1942,13 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x09dd, &delay_200_500_e50, "NT116WHM-N21"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0a1b, &delay_200_500_e50, "NV133WUM-N63"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0a36, &delay_200_500_e200, "Unknown"),
-	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0a3e, &delay_200_500_e80, "NV116WHM-N49"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0a3e, &delay_200_500_e80_d50, "NV116WHM-N49"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0a5d, &delay_200_500_e50, "NV116WHM-N45"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0ac5, &delay_200_500_e50, "NV116WHM-N4C"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0ae8, &delay_200_500_e50_p2e80, "NV140WUM-N41"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b09, &delay_200_500_e50_po2e200, "NV140FHM-NZ"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b1e, &delay_200_500_e80, "NE140QDM-N6A"),
-	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b34, &delay_200_500_e80, "NV122WUM-N41"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b34, &delay_200_500_e80_d50, "NV122WUM-N41"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b43, &delay_200_500_e200, "NV140FHM-T09"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b56, &delay_200_500_e80, "NT140FHM-N47"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b66, &delay_200_500_e80, "NE140WUM-N6G"),
@@ -1986,8 +1987,8 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('C', 'M', 'N', 0x14e5, &delay_200_500_e80_d50, "N140HGA-EA1"),
 	EDP_PANEL_ENTRY('C', 'M', 'N', 0x162b, &delay_200_500_e80_d50, "N160JCE-ELL"),
 
-	EDP_PANEL_ENTRY('C', 'S', 'O', 0x1200, &delay_200_500_e50_p2e200, "MNC207QS1-1"),
-	EDP_PANEL_ENTRY('C', 'S', 'O', 0x1413, &delay_200_500_e50_p2e200, "MNE007JA1-2"),
+	EDP_PANEL_ENTRY('C', 'S', 'O', 0x1200, &delay_200_500_e50_d50_p2e200, "MNC207QS1-1"),
+	EDP_PANEL_ENTRY('C', 'S', 'O', 0x1413, &delay_200_500_e50_d50_p2e200, "MNE007JA1-2"),
 
 	EDP_PANEL_ENTRY('C', 'S', 'W', 0x1100, &delay_200_500_e80_d50, "MNB601LS1-1"),
 	EDP_PANEL_ENTRY('C', 'S', 'W', 0x1103, &delay_200_500_e80_d50, "MNB601LS1-3"),
-- 
2.51.0



