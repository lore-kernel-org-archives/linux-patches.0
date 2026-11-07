Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063990;
	b=oIAFZMxKCmkRN/xxce07RkFsJylG3Y+1tTlyBm5t//RkEtGxwamGAbXnXDoeyMju60Hn
	 caDqAbROFWq2o79WHczm1AcAN+3F5npEU8gskWFYU6Y984J66A/Y8tPjRyJu8BFBmcjUR
	 Hd0Y+HkLeZLvNawXj/S2z9XjpW1uEgDAZTZnxiZ8WDavQcNuH5zdWHMDJi/0+Mjjd7xdU
	 uhz3lhlP+syF+BFP7ab2svsJu7c+Y7YnzHPXX56r7nJcMw8wJTuREG9UlVy4RisGyQstT
	 imYYAiAZBmimUdI48Q/Vd+tjaEZxkF9JMZRtNHG9D3k8UT163IJQiuWvz8SpSLYVQ0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063990;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I/lei3gDO5xxwLM3PvuUzokyy5xjyy3cuuW/Um9OoME=;
	b=UHMcAdtBO2qJcH6J6iNK63IJfwqVoTZ86csgNfzHYvxpg3Ajv3QZL3yJJbvgcJmIrdQH
	 8J5uC3z1zcZSuInQ7ADKdCVb5qvbjdZpe2NQYOEXhN2dHr56kSJDb5vG8crNQKQDuwb8k
	 toW4HmApEKjmxAcgDNkvZpnDuJg4CPJw467ItAUAADcrUnFaUQuehyqFgjvzFMSWXC0Ws
	 MnI+zG/twPiK4kVVXJtv9FmIiJWwtbarhnWIAoVLeWfHILpunCqHIg//KF7yloOPRUQed
	 TfevVcJtKNaWQwOq4u/ySJOolWDKmGFbltbyAOQqczIil15Pj3wkGF3N1kjfzCo7shw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WsPws2l8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04685606D83C;
	Sat,  7 Nov 2026 15:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WsPws2l8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A694B1F008A1;
	Sat,  7 Nov 2026 15:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063989;
	bh=I/lei3gDO5xxwLM3PvuUzokyy5xjyy3cuuW/Um9OoME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WsPws2l8+mdbJ+GRRdQvPwBu4FyUci5FR97iL3FuRc8q9F41GvcE4/tfohz24yZQ2
	 HqfGSiRNIK1ipGES4y4z3je1CnOuKfLBXZO+QWGSFnF5i6IzW3v11wuTyYKb69cUr8
	 OHtnYb2F8zTEtq/eRYLb3MS5VRJTqZ5w97+nQtGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Snyders <robin@snyders.xyz>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0134/1257] power: supply: qcom_smbx: notify battery overvoltage recovery
Date: Sat,  7 Nov 2026 08:40:30 -0500
Message-ID: <20261107134943.016190221@linuxfoundation.org>
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
 drivers/power/supply/qcom_smbx.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/qcom_smbx.c b/drivers/power/supply/qcom_smbx.c
index 55ffe9857e494..f5557b8cc92ae 100644
--- a/drivers/power/supply/qcom_smbx.c
+++ b/drivers/power/supply/qcom_smbx.c
@@ -722,16 +722,22 @@ static irqreturn_t smb_handle_batt_overvoltage(int irq, void *data)
 {
 	struct smb_chip *chip = data;
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



