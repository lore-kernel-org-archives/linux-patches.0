Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2FD168C4;
	Mon, 27 May 2024 19:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837996; cv=none; b=Jd8QcPfpyHXVL1qNvZVU37PYs/guSk4nURhLs4X2/QxojFCen6JW/xjBJiFpjWb/M4lkcHN67yT/xU+ZwJOhkRkMwoWsJ8GzJTDNMFVWFQH+eguDg0n4VF5F0B65GNrxjDVegnhbEkhng4ZprOXUpxObOXdX1WM/GjqrNa8ggkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837996; c=relaxed/simple;
	bh=pmF5/S0HKmhP9dm4UyB+CxSunaf0/2+cjKSeFn0FIRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJumVZSWmPaxNnjUMf16KvOjgxdsZ9wc5dXaD2bJDaM7JmzDiZBDsJU1q2Lq8y/jtywd8xTxSxDg2IRZbJLk99MzZDpTSA+HCy28zk85rmDyjZQCEW5NoKstLGTTJz3NC9JmAJl8PhLqnOuICrXDSwRvtw1nhbx3ZDQ0VTe789Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZB+Qm8te; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZB+Qm8te"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B1CC32781;
	Mon, 27 May 2024 19:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837995;
	bh=pmF5/S0HKmhP9dm4UyB+CxSunaf0/2+cjKSeFn0FIRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZB+Qm8tekT+koXxmd9Ymf7y5OCuWI6BUzibFcPkwdj70cFyOtU5fZtb9+9FQP+L0R
	 UKlnVHTG0xwlp+eGjC2ykBHU74vgSqLBWF6ZnLc7su8tZqnTWDwQmqRDGiTT5HItCV
	 DwcNpcxE4hASpthcbXBpJgsrXTieCFfUjjFYX4+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 227/493] thermal/drivers/mediatek/lvts_thermal: Add coeff for mt8192
Date: Mon, 27 May 2024 20:53:49 +0200
Message-ID: <20240527185637.731926660@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Te Yuan <yuanhsinte@chromium.org>

[ Upstream commit 7954c92ede882b0dfd52a5db90291a4151b44c1a ]

In order for lvts_raw_to_temp to function properly on mt8192,
temperature coefficients for mt8192 need to be added.

Fixes: 288732242db4 ("thermal/drivers/mediatek/lvts_thermal: Add mt8192 support")
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20240416-lvts_thermal-v2-1-f8a36882cc53@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/mediatek/lvts_thermal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/thermal/mediatek/lvts_thermal.c b/drivers/thermal/mediatek/lvts_thermal.c
index fd4bd650c77a6..4e5c213a89225 100644
--- a/drivers/thermal/mediatek/lvts_thermal.c
+++ b/drivers/thermal/mediatek/lvts_thermal.c
@@ -1530,11 +1530,15 @@ static const struct lvts_data mt7988_lvts_ap_data = {
 static const struct lvts_data mt8192_lvts_mcu_data = {
 	.lvts_ctrl	= mt8192_lvts_mcu_data_ctrl,
 	.num_lvts_ctrl	= ARRAY_SIZE(mt8192_lvts_mcu_data_ctrl),
+	.temp_factor	= LVTS_COEFF_A_MT8195,
+	.temp_offset	= LVTS_COEFF_B_MT8195,
 };
 
 static const struct lvts_data mt8192_lvts_ap_data = {
 	.lvts_ctrl	= mt8192_lvts_ap_data_ctrl,
 	.num_lvts_ctrl	= ARRAY_SIZE(mt8192_lvts_ap_data_ctrl),
+	.temp_factor	= LVTS_COEFF_A_MT8195,
+	.temp_offset	= LVTS_COEFF_B_MT8195,
 };
 
 static const struct lvts_data mt8195_lvts_mcu_data = {
-- 
2.43.0



