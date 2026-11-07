Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061968;
	b=QjAX9mYFIpIFsqQ6C/YED6B/bcFKlueIhhVgS1FCDS1eRk78Er2my7j20mRpwvEnMrj2
	 bP5Dg/lZ7jVRR3VK+krf4mE4WsMoNFffcJsE+RgROHyGBLjv6HF5vvRBrazcJYQcn6OiK
	 Idd8cZdx1siOCGPTjRuf2m05r/ACTnpLmcFtsbFBXjJplQRoXxmHZmjC8SFhBtDoZu0HO
	 /L8nvEOP+3jCfuE9E9zZQkVGGJ2J81mfhIxrQyOKu2dcTc6iObPuODa+vTJYpOiRxY7IR
	 ZpKMEp6DcXjkGegN69SpAs8dSSXTFwPGqHB/svfdu8gjYEr2Pop4EO2mvmp0HKqdQog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f6zxvSRbcf04potQCLOG7WEwFZNu2hft8BVSHMkkM74=;
	b=LYgxq8E21nRHj5cqeTov89m/P2sPW2c90ew6gM20FZC5P0i7Sppt+xMfObYUCagFxHVX
	 VIQYhnVrDyspGT/d02dJXqX0yCy/5jsfgqRSgF+nef4svU4RQYcusEIEtPb3YPqzhqvgI
	 UJP7YoZx82SpPB86SnfljT0odM7bm6Ne1xWynrreYSDQgzKbmuelo36ExXHWIpRcSA5DU
	 Ics2HGnDRTAIznoJyH8JgkeAd3p0P4RYahiR4iy72LaplNz8lnWeKBWWblgbnQ/5hCMxs
	 kTmQIfSyZmsteK50gH2L+aFrg6VlT2bCocWuDppSps0NWmNctM1H+Fd7ojsyDSnvGmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UcpOA2kW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849FE606A332;
	Sat,  7 Nov 2026 14:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UcpOA2kW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331A61F008A1;
	Sat,  7 Nov 2026 14:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061968;
	bh=f6zxvSRbcf04potQCLOG7WEwFZNu2hft8BVSHMkkM74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UcpOA2kWo+QcmCH0jTIGAJMRhxpoNHntGpYCtGV8oNEPf5SfxSNfakHXSVCT2oBEY
	 05xzNNkC1nYEbbQRPW1JWdn1Mu++w0Z4kPXvRdpm/f0zX2qpltGVO5LUMmINTCLdI2
	 1iImyvC5O9s3rgIB8i9nyx3VoHzmd0ITOcT+t/38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Snyders <robin@snyders.xyz>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0965/1536] power: supply: qcom_smbx: notify battery overvoltage recovery
Date: Sat,  7 Nov 2026 08:49:41 -0500
Message-ID: <20261107135024.753462128@linuxfoundation.org>
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

[ Upstream commit 2548e4fa576a87a3b0d1b15a9c3f909bc54887b5 ]

The battery-overvoltage IRQ is configured for both edges, but its handler
only notifies the power-supply core while the fault bit is asserted. The
falling edge therefore does not publish the recovered health and status.
The handler also ignores register-read failures before testing status.

Handle read errors, log only an asserted fault, and notify the
power-supply core after every successful edge read.

Fixes: 8648aeb5d7b7 ("power: supply: add Qualcomm PMI8998 SMB2 Charger driver")
Cc: stable@vger.kernel.org
Signed-off-by: Robin Snyders <robin@snyders.xyz>
Link: https://patch.msgid.link/20260812-qcom-smbx-fixes-v1-5-eb48246be599@snyders.xyz
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_pmi8998_charger.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/qcom_pmi8998_charger.c b/drivers/power/supply/qcom_pmi8998_charger.c
index a9dbe050ef248..d4c9f85654da3 100644
--- a/drivers/power/supply/qcom_pmi8998_charger.c
+++ b/drivers/power/supply/qcom_pmi8998_charger.c
@@ -712,16 +712,22 @@ static irqreturn_t smb2_handle_batt_overvoltage(int irq, void *data)
 {
 	struct smb2_chip *chip = data;
 	unsigned int status;
+	int rc;
 
-	regmap_read(chip->regmap, chip->base + BATTERY_CHARGER_STATUS_2,
-		    &status);
+	rc = regmap_read(chip->regmap,
+			 chip->base + BATTERY_CHARGER_STATUS_2, &status);
+	if (rc < 0) {
+		dev_err(chip->dev, "Couldn't read charger status: %d\n", rc);
+		return IRQ_HANDLED;
+	}
 
 	if (status & CHARGER_ERROR_STATUS_BAT_OV_BIT) {
 		/* The hardware stops charging automatically */
 		dev_err(chip->dev, "battery overvoltage detected\n");
-		power_supply_changed(chip->chg_psy);
 	}
 
+	power_supply_changed(chip->chg_psy);
+
 	return IRQ_HANDLED;
 }
 
-- 
2.53.0



