Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1D94A99C;
	Mon,  1 Apr 2024 15:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986974; cv=none; b=icVY9d3UbuAWeerS8MQifIi17lli5YH8FmJtud6uJKC2qzb/KyFlIJ2DSwPMQOH0iwGl53rhdATIPw6iqOtUD32O2DvP75OT/LeTjZI188bRE5cLJPNTaUywveRspma1VkalDF1bchzgo4/CAATtwjs3tt6izytuRpuftNZz+KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986974; c=relaxed/simple;
	bh=MxUfxpo1oGlQonQuSpZsoB9TgoPYSkafCSlYubvqZbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJ3phBzh+SF5Yen6oGjVGvEQWtAwvk2C/bPCCNJjIWUw/fcQJE4WBdvNXryN7LC4ODjBA7RkzAD9hxFnZ3VDWM4kqZdyOv8E09mb7fl+ej7R+UmkxuNC1hPoj3OnOSxiI7u6C4NFcraH0rvWH1oYmiPsR2JA02Cqaek3wGaxDfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQtJHDTN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQtJHDTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9C0C433F1;
	Mon,  1 Apr 2024 15:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986973;
	bh=MxUfxpo1oGlQonQuSpZsoB9TgoPYSkafCSlYubvqZbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQtJHDTN8xrN37hGDlurBtbVrol3mk8dxhgy4opbUMF3YPmnxNHvWbsDZXTM2SJQY
	 mjIH3Tt6HOsosj4s2hkZ3GNXcEK0d3Ys/cZMYLsm/gu321hw55HKhvRDo4OElvb6ky
	 /RexysQjzrjHfxG7I4Cr1BL4U1/LGlM1rsUu63WM=
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
Subject: [PATCH 6.8 145/399] thermal/drivers/mediatek: Fix control buffer enablement on MT7896
Date: Mon,  1 Apr 2024 17:41:51 +0200
Message-ID: <20240401152553.518974688@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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



