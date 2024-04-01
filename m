Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC5C40876;
	Mon,  1 Apr 2024 16:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989696; cv=none; b=GH+LBy9B1QQHBwS4SMS7VlEMO/4zQY1kPECaWfgWHLAaZtvh78yzb/9frr/LdJyiE/B91BqGwhbPdp3fKZxTNXo54hWWPBcnI+19v3Bw8gNp43lfgNjblWnz49D7maquwF9Skxqy0lPV7G+vp1Ryl9dNv75KJVw+937k6VWTQ2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989696; c=relaxed/simple;
	bh=ipAEloZ2M3Bkoqd90FT7+ReqBpjGclYRVtPJwDm4/4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sP2XcV7lECdKi/ZVu7WfiOYilLpqYuuuRg1X2dg+zv26gwjoUrpj9MYRvd0TjFRky6JcC+6mfT+lHhf7VPa1zXoKztm6llCz/jUa9E9rn+J1pQ03C3P35YGbyoYxLFeQuAS66lhm4eB/PqVY8/WnFqZ3M3E0wcNeJjjlDwhTD/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9cr6CK6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9cr6CK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1869C433F1;
	Mon,  1 Apr 2024 16:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989696;
	bh=ipAEloZ2M3Bkoqd90FT7+ReqBpjGclYRVtPJwDm4/4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I9cr6CK6OQbmiFvm0xuRCtXsxKzvkdoFRbrG0QkVXoghC8D6au9MS+PTEraSW5kPC
	 hQaSUsg/aLPmDcyixY8x0jaK1N/fp1q2IQJDoNurWAFBuJ9wib0lpnJFvYO1KvzLv3
	 6K0wZaf+fypVrPOB5ReX2FIO4JAdWMuPEkwvriGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wunderlich <frank-w@public-files.de>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Daniel Golle <daniel@makrotopia.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/396] thermal/drivers/mediatek: Fix control buffer enablement on MT7896
Date: Mon,  1 Apr 2024 17:42:55 +0200
Message-ID: <20240401152551.675135851@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Wunderlich <frank-w@public-files.de>

[ Upstream commit 371ed6263e2403068b359f0c07188548c2d70827 ]

Reading thermal sensor on mt7986 devices returns invalid temperature:

bpi-r3 ~ # cat /sys/class/thermal/thermal_zone0/temp
 -274000

Fix this by adding missing members in mtk_thermal_data struct which were
used in mtk_thermal_turn_on_buffer after commit 33140e668b10.

Cc: stable@vger.kernel.org
Fixes: 33140e668b10 ("thermal/drivers/mediatek: Control buffer enablement tweaks")
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Reviewed-by: Markus Schneider-Pargmann <msp@baylibre.com>
Reviewed-by: Daniel Golle <daniel@makrotopia.org>
Tested-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20230907112018.52811-1-linux@fw-web.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/mediatek/auxadc_thermal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thermal/mediatek/auxadc_thermal.c b/drivers/thermal/mediatek/auxadc_thermal.c
index 8b0edb2048443..9ee2e7283435a 100644
--- a/drivers/thermal/mediatek/auxadc_thermal.c
+++ b/drivers/thermal/mediatek/auxadc_thermal.c
@@ -690,6 +690,9 @@ static const struct mtk_thermal_data mt7986_thermal_data = {
 	.adcpnp = mt7986_adcpnp,
 	.sensor_mux_values = mt7986_mux_values,
 	.version = MTK_THERMAL_V3,
+	.apmixed_buffer_ctl_reg = APMIXED_SYS_TS_CON1,
+	.apmixed_buffer_ctl_mask = GENMASK(31, 6) | BIT(3),
+	.apmixed_buffer_ctl_set = BIT(0),
 };
 
 static bool mtk_thermal_temp_is_valid(int temp)
-- 
2.43.0



