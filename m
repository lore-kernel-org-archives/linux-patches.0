Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2D52798F0;
	Mon, 13 Oct 2025 15:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369339; cv=none; b=SX204HI1t5V7/DjoEOgZuBG8300qUsIk5TGidD9peC0ww1/wPi/1Fs+ClxOSr0++SMQpJO4bvOw5j+oyKwmBoc0Mlr79oYJOM8e4jJG1FZA3FIyF0PnkD3QOJFZZaFK2/QJPvykhIu66sm4jsdnzWXApe8LqxSbmOV46MuK0YPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369339; c=relaxed/simple;
	bh=WuNwjdbIBfpidWElLktmJqDpP80PZe2qfr6xNkQz5dQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGUOP4yshjmlJcxFRgDQnNQr5hu28SqFVLzFoNNzXuV0aRKtN+U+ceu7fI8bb9q8LjDqxWHE6drYLa8fexr6tt2GE6CR2LALmM9S96KUhzkdcwmn5opNNGgVxlp7rrzZ8ujj0VpGXF899zqtTksEO7Jq7naNt3qg8n4WL7vSmaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wC6zWBvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wC6zWBvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B62C116B1;
	Mon, 13 Oct 2025 15:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369339;
	bh=WuNwjdbIBfpidWElLktmJqDpP80PZe2qfr6xNkQz5dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wC6zWBvqfHkPGwL9lJHbsoIWI1cV34EYj5Q2RWQyZ02JcwbYYbBgzPHFzCA3Hs/XT
	 dw5QxdnM4gmmlylnSDT1yUVvAFMEq7zrPCoyuugMTh7B3k3waXcB8sQQh0s7Y3ml+6
	 p8Qp8LjW21E24PFx96Bac6+cEYDhE+U0rltz6AAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Langyan Ye <yelangyan@huaqin.corp-partner.google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 212/563] drm/panel-edp: Add disable to 100ms for MNB601LS1-4
Date: Mon, 13 Oct 2025 16:41:13 +0200
Message-ID: <20251013144418.965070478@linuxfoundation.org>
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

[ Upstream commit 9b3700b15cb581d748c3d46e7eb30ffced1642e8 ]

For the MNB601LS1-4 panel, the T9+T10 timing does not meet the
requirements of the specification, so disable is set to 100ms.

Fixes: 9d8e91439fc3 ("drm/panel-edp: Add CSW MNB601LS1-4")
Signed-off-by: Langyan Ye <yelangyan@huaqin.corp-partner.google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20250721061627.3816612-1-yelangyan@huaqin.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index 9a56e208cbddb..09170470b3ef1 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1828,6 +1828,13 @@ static const struct panel_delay delay_50_500_e200_d200_po2e335 = {
 	.powered_on_to_enable = 335,
 };
 
+static const struct panel_delay delay_200_500_e50_d100 = {
+	.hpd_absent = 200,
+	.unprepare = 500,
+	.enable = 50,
+	.disable = 100,
+};
+
 #define EDP_PANEL_ENTRY(vend_chr_0, vend_chr_1, vend_chr_2, product_id, _delay, _name) \
 { \
 	.ident = { \
@@ -1984,7 +1991,7 @@ static const struct edp_panel_entry edp_panels[] = {
 
 	EDP_PANEL_ENTRY('C', 'S', 'W', 0x1100, &delay_200_500_e80_d50, "MNB601LS1-1"),
 	EDP_PANEL_ENTRY('C', 'S', 'W', 0x1103, &delay_200_500_e80_d50, "MNB601LS1-3"),
-	EDP_PANEL_ENTRY('C', 'S', 'W', 0x1104, &delay_200_500_e50, "MNB601LS1-4"),
+	EDP_PANEL_ENTRY('C', 'S', 'W', 0x1104, &delay_200_500_e50_d100, "MNB601LS1-4"),
 	EDP_PANEL_ENTRY('C', 'S', 'W', 0x1448, &delay_200_500_e50, "MNE007QS3-7"),
 	EDP_PANEL_ENTRY('C', 'S', 'W', 0x1457, &delay_80_500_e80_p2e200, "MNE007QS3-8"),
 
-- 
2.51.0



