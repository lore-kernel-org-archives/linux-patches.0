Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7C315956D;
	Mon, 29 Jan 2024 17:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548395; cv=none; b=FqwoTQ9MicS7r9LSYJsKkcPiETUHGuBp5INjTTe5XLVuxUZsOfDiepDZpLTXTChQemJGExqUSKgnUdKf4zybFWvNbirdZPUtWR9aj+RAlzm4i0siMHbIwTFnjxRJBEceuw9w5ST/PUIN9wy5VP9KTNS+qypksA+WGoF0Uo2c+tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548395; c=relaxed/simple;
	bh=WCZwO2FzMUzou7r8ExXYMkdQpdKAutY9sJ5HCK+qgZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tT65VBI6Hk33ps1Ik1pZjXlgBKNssNX7mSRwph05rBSOZ+lK1yuB6C+jHMNDlB3CrBkiaagf/dk2PzjP7wgRr5V4sMN1GsRiiOnb2qfZBlyA507hCO9mrr0Ndr5I4wKVF7pbB12aAhp7oDFa+I21ejKjUcv6y+n566cC1Z0vOyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOWGP3rD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOWGP3rD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F00C433F1;
	Mon, 29 Jan 2024 17:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548395;
	bh=WCZwO2FzMUzou7r8ExXYMkdQpdKAutY9sJ5HCK+qgZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOWGP3rDTY9QOnWyLjMwmDPtttc4l3xVy24HWvi7JNpf1kxxK+tHZpdW1RRK5R6VC
	 iBN08UYsm0rY5S1BxPK0RtUQembMSLyeHlNuXnECG/dAfq0dEai7cvgtWVpdQagC5m
	 UeCr+U1gIzMXcfnB4SBXTsFvz1rCfiiCpAhWay2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 164/185] drm/panel-edp: drm/panel-edp: Fix AUO B116XAK01 name and timing
Date: Mon, 29 Jan 2024 09:06:04 -0800
Message-ID: <20240129170003.863702634@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit fc6e7679296530106ee0954e8ddef1aa58b2e0b5 ]

Rename AUO 0x405c B116XAK01 to B116XAK01.0 and adjust the timing of
auo_b116xak01: T3=200, T12=500, T7_max = 50 according to decoding edid
and datasheet.

Fixes: da458286a5e2 ("drm/panel: Add support for AUO B116XAK01 panel")
Cc: stable@vger.kernel.org
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231107204611.3082200-2-hsinyi@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index a163585a2a52..ecd6238749f7 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -975,6 +975,8 @@ static const struct panel_desc auo_b116xak01 = {
 	},
 	.delay = {
 		.hpd_absent = 200,
+		.unprepare = 500,
+		.enable = 50,
 	},
 };
 
@@ -1870,7 +1872,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x1062, &delay_200_500_e50, "B120XAN01.0"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x1e9b, &delay_200_500_e50, "B133UAN02.1"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x1ea5, &delay_200_500_e50, "B116XAK01.6"),
-	EDP_PANEL_ENTRY('A', 'U', 'O', 0x405c, &auo_b116xak01.delay, "B116XAK01"),
+	EDP_PANEL_ENTRY('A', 'U', 'O', 0x405c, &auo_b116xak01.delay, "B116XAK01.0"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x615c, &delay_200_500_e50, "B116XAN06.1"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x8594, &delay_200_500_e50, "B133UAN01.0"),
 
-- 
2.43.0



