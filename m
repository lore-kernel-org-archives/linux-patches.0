Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035877;
	b=CW8uzAhLKyVNbYuSRK3rlR6unnBkSaLZcalXPSIJX8vY58IaSN/NElru8HUUpei9hS2j
	 fyIyMBh2Cfg2KMWsvs/4+BaHbVJlKtQSX6YgomvPxJXvj+ZiVI3nJahhr5Qw10p9dmSWa
	 svSOZ5DjE5XMTsNMSlcllRdkgnBnVdEzYxV5GJnFfydDVgkrjyQsNR9K0v2tfSRKFEF1H
	 EgsMi7+3uUVXke0gwJlyApA2loa8lQUK1d9gyqpOu2LFFOpzU8y6c2hJnyRFBipUnWQf0
	 V7gwH12P9Jaall+3zmFqKXFNR26ZFJXTxoxF/B0UscVEXRsA/3ljZaLGQidH5SRQc+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WqJM4Dgnnys/csPg0m9Kw6dzSN64yUeWjXDjjUa4yzY=;
	b=ggx1wjW/Ugu2X/LNHTAWIcgK/zr3Rq+qRUbn1ur9LxtlCa4BlCVSUkop5v0zhBaeZ6TY
	 u4kZH8d1d1Q1vOEld8N9DCBPNLVWrXAcj2MXmDWZPraQa5y6GWqvlitLhwbhe79PPcpM/
	 izyuLCNTQGgGLeOQIiVSTXFJyM44yz9AZKDpY+zW/zP6dCOT+LqFwhTAbikeWZgUU1Md1
	 MvJ5dMt/bD+h0E6InhG8GiAOspK5Og0g2mUc3j5asd8Zbfu9EEbA4OIqxtjIekGXjQzLp
	 BjM8jQOm8iCjpJBNW6CuNUOvWrkxxidO5aB9PHDhX1OlJz5kOtE8zc8wzj1+fST7v/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xCbQqENv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17971606A325;
	Wed, 18 Nov 2026 21:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xCbQqENv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F1E1F000CA;
	Wed, 18 Nov 2026 21:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035876;
	bh=WqJM4Dgnnys/csPg0m9Kw6dzSN64yUeWjXDjjUa4yzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xCbQqENv0L3e8J/GNjBdgtf2EpnTPXp9d6rGsu5Gw9gWOhNP8wnQMtH9oc+GqgEUv
	 i2jQ9U2EB/ddnHoLTbr0w21rZg9H9V8ObyhwlbJZeUV9a75sDxOHqx/MybrGKRWqzA
	 MRRBbTLuX3Umw5YNPF+nA5ZrM4PcbBXGrdl+RvW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Snyders <robin@snyders.xyz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0859/3318] power: supply: qcom_smbx: fix float voltage selector
Date: Wed, 18 Nov 2026 15:24:41 +0100
Message-ID: <20261118150345.042378272@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Snyders <robin@snyders.xyz>

[ Upstream commit 2a26d260e72a95e9f13b9e475f63aa404600fcb2 ]

FLOAT_VOLTAGE_CFG encodes 3,487,500 uV as selector zero and advances in
7,500 uV steps. The current calculation adds one to that selector, so it
programs the requested float voltage one step too high.

Remove the extra offset and name the hardware encoding constants.

Fixes: 8648aeb5d7b7 ("power: supply: add Qualcomm PMI8998 SMB2 Charger driver")
Cc: stable@vger.kernel.org
Signed-off-by: Robin Snyders <robin@snyders.xyz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260812-qcom-smbx-fixes-v1-3-eb48246be599@snyders.xyz
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_pmi8998_charger.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/qcom_pmi8998_charger.c b/drivers/power/supply/qcom_pmi8998_charger.c
index 8f953d1550b6c..24e1897f53556 100644
--- a/drivers/power/supply/qcom_pmi8998_charger.c
+++ b/drivers/power/supply/qcom_pmi8998_charger.c
@@ -349,6 +349,8 @@
 
 /* pmi8998 registers represent current in increments of 1/40th of an amp */
 #define CURRENT_SCALE_FACTOR				25000
+#define SMB2_FLOAT_VOLTAGE_MIN_UV			3487500
+#define SMB2_FLOAT_VOLTAGE_STEP_UV			7500
 /* clang-format on */
 
 enum charger_status {
@@ -993,7 +995,8 @@ static int smb2_probe(struct platform_device *pdev)
 		return dev_err_probe(chip->dev, rc,
 				     "Failed to init status change work\n");
 
-	rc = (chip->batt_info->voltage_max_design_uv - 3487500) / 7500 + 1;
+	rc = (chip->batt_info->voltage_max_design_uv -
+	      SMB2_FLOAT_VOLTAGE_MIN_UV) / SMB2_FLOAT_VOLTAGE_STEP_UV;
 	rc = regmap_update_bits(chip->regmap, chip->base + FLOAT_VOLTAGE_CFG,
 				FLOAT_VOLTAGE_SETTING_MASK, rc);
 	if (rc < 0)
-- 
2.53.0



