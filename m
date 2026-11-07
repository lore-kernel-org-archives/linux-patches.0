Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062820;
	b=Mquh/suVsv22R5WnWFb9A5YLFH8ilX9JVmunseZxho8zf43OT7vGAlLRiFSBJ166J3Ds
	 UUnsuXe/XPPPRfTqwizN49rewiIAT64UYJZ631qA3JCb5+pamqWqbCzAly/G1keEyUkug
	 mi4t3VATbCq0pOOm9Cl6TlS09KDwGQpzgLR1Lngs2dlXd0qGfcU8nU0xRUDo7jmyTixc8
	 dqNkQAVSzh76OyXmRTmc6lrqAcKg5M3Jfs4zP3gZI6DA7+KFQEgdXHYe7SloDHCOnZUn+
	 I9uqSjyQVAN38TbWVIkte9le2SbccDczSlvwJ1SpbzYj2fryASQZ9BmkYWDKivqFVDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cXfGVZCNaEb77aK2j8aQNpjtIB1bBipofWuh70YcgKo=;
	b=WE8sEe/VdTafpt4V2ADm7KUW/BDQpGIJ+URizuLy72/PNwmKnKzVUFzGfY88o62fepS3
	 TWFawlshOcXvg3Sa6FAhMymY/sKjLjUaMi6Z6HmuEFNA0LLR+XvmJqag/3g5KEf5tXilS
	 tFLzr7CUPiqrOZmSmjsEokDcf7D4cGjz0egDkN6pwWdalL8DwtHAdLkttWAgMfuMLWyu0
	 RTUeSX6mMFXbxGRGgo1uKB/sa1dmdpdzwZNrksuVl3frWRXVgfN5SxETkMR9fFEY+PhVe
	 9SBiAGrQc/fl9zs0CMQ71pQPUsitM3pfzp3xh+bFsio6t8nFngS/7f/bp9sSE8iy9/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NkHpIU0J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B2A606A336;
	Sat,  7 Nov 2026 14:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NkHpIU0J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F6D1F0089F;
	Sat,  7 Nov 2026 14:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062819;
	bh=cXfGVZCNaEb77aK2j8aQNpjtIB1bBipofWuh70YcgKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NkHpIU0JmVvQQBPFYy/qpKu4uBXRBzq7xucapr7ULGX1eOgSRjMosbN8gWfonWc5D
	 fb6nz5ppT7PFjD7eMGXvFjxUYB0guLK9YavaOcUWuzJ/1Q6NNBMvHhtxlz3gDaElc/
	 eZYpbnBL8C7TuwVl4+BZ1aIAFhAOCxLtwccsdwlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Snyders <robin@snyders.xyz>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 117/869] power: supply: qcom_smbx: notify battery overvoltage recovery
Date: Sat,  7 Nov 2026 08:46:39 -0500
Message-ID: <20261107134856.511885554@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index dddc8f3e1073a..55fe31aa3df3d 100644
--- a/drivers/power/supply/qcom_smbx.c
+++ b/drivers/power/supply/qcom_smbx.c
@@ -715,16 +715,22 @@ static irqreturn_t smb_handle_batt_overvoltage(int irq, void *data)
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



