Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063988;
	b=VtWQg9vVd7q/DiIicFJxGLtsYr3z0VeMMPvI3YaQ3u8vGnJpqcXjw1nbHhsARgDcc/RY
	 Mzop/7wkBZBfgbkw3kQhYgD695wAdUpuj4lkjWydrxTxI4ElrTugvVUkpDgOpNyQr7slw
	 iOUMdOM1yQ3kbdh33ePtXY6gmeIKDIedhD9Fv+1enYGAzcvs7KxkRUmQ5bSw04AQ6XQuB
	 bVF1B6SsZv8LV01LhW6A2iiT4fDwakwoDiwmH5B4xRft+hAWPVwdc5x3Nn/2s5/bTJPDi
	 wYdtO8Aq1UnmkKFFYTvfrmY8fQRpW7HiVaLyEk7Wa+AuXswb/k5ahqyL300iSdaR9yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zwFuOQ2PSZ7OaxOVw7l60Nvjf4ZS6sL0Vk1cFibjCr4=;
	b=W/klHwM/GLer5v4yrq5gWUGKREed5QEhy2opV+x6X2e0lNNSxRB0UE+ee+3y781FWjnv
	 DVUjPtXzAyHfOyZdiSL2KizqWIe3F3YZM5Gv8H5WUnQaXPV9ibSu+Dv3D/5xvwadWFbWG
	 7dVPur1/pyJWGzS8PUGK+zp+TCk3V0Q6aF3/jfWk5AX0TbU5AZuiY6IRAM8H3FGCdi2Y/
	 YDz8x2S2GwThaVhdx4FUnOzIkVdFsN9f+pmlFVMZisv/T+JUsDnn9xMmMkKKlYrda83zf
	 VY8tOC9O9p4NkLBLFDTpWW/uqsYAChBaNq0i7hHB2NeIzJbVpDTPIe01V6mVBVrpblw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g3veqNLO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDC2606D83C;
	Sat,  7 Nov 2026 15:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g3veqNLO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF5C1F0089F;
	Sat,  7 Nov 2026 15:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063987;
	bh=zwFuOQ2PSZ7OaxOVw7l60Nvjf4ZS6sL0Vk1cFibjCr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g3veqNLOeNGi/zwwAUPTFY+k/F98JbUCw/CD6FrLHwAJ9OoAl7CVscsJQaqJQ2MMS
	 xbS2Lc6hKrGvL/r4GDlravFPfnrQG5fCvVJDAp9ekdYY1nH3CHkWcJ0ZQvIc4bokp6
	 IrQuHaoazJufTH8cWx05O8cqnoqJKnwwa2fPg410=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Snyders <robin@snyders.xyz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0132/1257] power: supply: qcom_smbx: fix float voltage selector
Date: Sat,  7 Nov 2026 08:40:28 -0500
Message-ID: <20261107134942.962280975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/power/supply/qcom_smbx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/qcom_smbx.c b/drivers/power/supply/qcom_smbx.c
index 0e50d81aefc2a..e236b95c0ebf3 100644
--- a/drivers/power/supply/qcom_smbx.c
+++ b/drivers/power/supply/qcom_smbx.c
@@ -352,6 +352,8 @@
 
 /* pmi8998 registers represent current in increments of 1/40th of an amp */
 #define CURRENT_SCALE_FACTOR				25000
+#define SMB2_FLOAT_VOLTAGE_MIN_UV			3487500
+#define SMB2_FLOAT_VOLTAGE_STEP_UV			7500
 /* clang-format on */
 
 enum charger_status {
@@ -993,7 +995,8 @@ static int smb_probe(struct platform_device *pdev)
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



