Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035879;
	b=5lJNtuCAbQkewSwUKbv6VkZT+rG139/6mlO5zUukhChb2M/7raL6cwFZyjQJDTWQkdLx
	 6+B+9NtUaRrAk7VBBLNjv/SeG89TJKZOpnsdQbfl7vUjBFHjbOSijizMDZ2lXM8CK8Qv9
	 zgAwDcinZ7mN9jQqzko9kaIq9Ib857Gc/ce0UdpNE19RJLf63QDzWU2ztxDXAaw8rEOpY
	 Cm0lMNlzORw/cZwV3+5rxfiW4bGDeVNGUS/3tMRfxOBhtNJq4bV+OpKUO40J/W5FZYACA
	 KEeVrczZgjp6PSjSMd1XvHsbTtd44yWzR2aTn7O+Fl0dl6QkL4k8xEpUtDBAzEB/3hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AeSkjypx0NOpEcTwEdiaMo8pyxxQPOwuMokVH4mpK4k=;
	b=YYswfFqlKayBjjRgz9xK/yWwZcdzmN15ODxpMUXuBSN1y6NtuVvgJmkZbFqmsB/IV8kb
	 CTjdYV9VuxLU3chNz0yBBsjVNaY+krDFzg83h9wV40varIwIQyFCTqyIQegxTc9dwNxvb
	 aKhCQnHDv8+C5yB9Yyt5j1LF2606PcMhL02+NhqOBN+agnPBPWMqDUzPa8q2bkQ3LAxyI
	 A+0uh5gvZZC1d7XQDNkGR/aZG32Tj9nojWtG3aUdUVEI4dS/m/FDwFXRDQC83HqbJvLnb
	 bIaw8s9x8nhkAoocc68w//wT0Jj4LB3ocrzsLU/tT9ovfD/lVn7OcIFw2xH+bZfaM5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0bZ9vfO/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3B660A260E;
	Wed, 18 Nov 2026 21:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0bZ9vfO/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37821F000C5;
	Wed, 18 Nov 2026 21:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035879;
	bh=AeSkjypx0NOpEcTwEdiaMo8pyxxQPOwuMokVH4mpK4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0bZ9vfO/oxaC6Oi4VQ97yhwItn+mbYlj/ceZ3PCKXKpkG/x8MNFzxsxfmH0ar9k1N
	 39u5oxvdX8DoQMS+RoQm3dTxtKFBBlulmj28nfbYpJn8/doyW42mNWM3J97bcb0hBz
	 jAJbxjRAogihf1K/3U979gw92AAYEX8cmK9LAZgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Snyders <robin@snyders.xyz>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0860/3318] power: supply: qcom_smbx: notify battery overvoltage recovery
Date: Wed, 18 Nov 2026 15:24:42 +0100
Message-ID: <20261118150345.076254961@linuxfoundation.org>
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
index 24e1897f53556..2ad6b87eba762 100644
--- a/drivers/power/supply/qcom_pmi8998_charger.c
+++ b/drivers/power/supply/qcom_pmi8998_charger.c
@@ -719,16 +719,22 @@ static irqreturn_t smb2_handle_batt_overvoltage(int irq, void *data)
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



