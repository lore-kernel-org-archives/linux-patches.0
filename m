Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061967;
	b=wEf7ELeoAc5QCojjONqG8vofzzDINFclcWA0U4c+6Crp/yTJ1h1iF1gwZI1i+t3OFARE
	 JRt0hIWyjCqsbn1nFs8LZLeKDOL8QsNj/06HrA+aPA0qXwPXb5bVheOlf6g1cXxfol8YL
	 yIceW62KCanIXQWGCkdD4le+SsgwP/V1pr/AEqA00nJZRJk6tBcum/cYmHM3aIkpjQWlb
	 THSgwCezZ6pg73orRpcE5U8pFHkTUnB7kNFDNUfGtySvKt5gBL7+L0EFvIoVZXFBsSX6B
	 kJOyNZuCRajQjR6AiP7zyHnRVjtPVMf8g689DBx8QdUVwrRdm53yOKTHPF1BujxgK5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=30Qv8q+aIZJpXVACCa23aS7v4Q2yBhubhCWB7Bm6ClA=;
	b=EV/YV0Cdj3j2KcDm/XFRU3AFcnq/NGkxZj3rnpkBmAHaBocoEUaap7vRaIwihhcUd3WY
	 sqk+xGl+vBJ21zF1RTHWUtNbb084WfAV0MLQjUgqmx30ueZZxuMmBJFMgT+9lMTphWU+B
	 RvOqvfimWxRYBIa+tkRRPkVE9fDJiGBZ0gEuKtub0BleS7c5JXdyALe0tY6dnPBTXWfmM
	 sUXULgHv//QoGybyzMlrwDEMVh3abZw0yHDACB4wrW5+47duw1G1kBXNXCSJBnXSG/F7S
	 xFktb4IAhhIZOy/EpiF0EvBWslBXpFs/kdMj17gSrZ8ubYwYe87Laow9Tsz3mwp4pYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OgA3SLee;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E340606A32E;
	Sat,  7 Nov 2026 14:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OgA3SLee
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01071F008A2;
	Sat,  7 Nov 2026 14:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061967;
	bh=30Qv8q+aIZJpXVACCa23aS7v4Q2yBhubhCWB7Bm6ClA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OgA3SLee+UEirhWta1WdkwF6NYQ/wWoM/Wf0zag1Yxw7sd9tGDJJA3vRhuEpZhdnX
	 PzxyH6q9+l+ImTsgevm3XqAsz7vWYeEmxSvgxC74mildZmp4BSj3B4m8MEIx2WVC5A
	 HZyOZa/Iok53EwEIG0QFf1AiJrPA05txDco8ybDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Snyders <robin@snyders.xyz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0964/1536] power: supply: qcom_smbx: fix float voltage selector
Date: Sat,  7 Nov 2026 08:49:40 -0500
Message-ID: <20261107135024.726420364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7d13da8e8cb93..a9dbe050ef248 100644
--- a/drivers/power/supply/qcom_pmi8998_charger.c
+++ b/drivers/power/supply/qcom_pmi8998_charger.c
@@ -349,6 +349,8 @@
 
 /* pmi8998 registers represent current in increments of 1/40th of an amp */
 #define CURRENT_SCALE_FACTOR				25000
+#define SMB2_FLOAT_VOLTAGE_MIN_UV			3487500
+#define SMB2_FLOAT_VOLTAGE_STEP_UV			7500
 /* clang-format on */
 
 enum charger_status {
@@ -987,7 +989,8 @@ static int smb2_probe(struct platform_device *pdev)
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



