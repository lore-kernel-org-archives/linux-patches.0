Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048146;
	b=bIkPINLztHcmRNYMe4Xb3WVWKvSCwFdpB8YqzUbV/kS3auDHKqFiV+ZXrGbBLwFG/qdy
	 dLCsfUoWGckAqHkH4S5jAL1J5F7tq3wq0o7Xk+9ks+4hhcfgcMrVGZezF5gcvbSYqzzJK
	 ozLGXJ8S7Mc+ax4jdwlJenhDOMQ7batGHQ1Trf/pbEYj76CZiZ65B2kT1ygS1NaAMtIBK
	 ySJDYfkYaARxQZK774ScKGhXSefKu6HabtEidM/nMoujGGJa6QYlAli0x754TMTNe4E0S
	 sliMQ13m19nZk9fkzh7JIQsGGd0+jMevRoVQT947t/VBoZRDoLXO6HXZ7dXqNQ1ZiTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QOsFS7XOZhJKJaZHB0090mtDhB11N7C1g4Dr6kV3Y1E=;
	b=vJUpKLtASi22S1Ly9OyoF/0NCqlaRav3eIqZ979A5sPDCrMjHjkX3iS8U3nkAf6YZf1n
	 ZYo8ET6U3mqA+oqi/pNGKKY19Dptt/hScHnawmiys2N34p/N/f1uTahR9vTSLmZ2sIEaf
	 9ME1mvF0Gj5XIKVC0G0Vynph1IPvlxY87rd1eEB4CY8tUbkQPPc5184yDLFxnH/+Xf/vA
	 lAeV/SJAsNTDeCjrGC+17dqwemMiIu5pef5YXB0nQ9Kuwopof1OtmuIYm9Xn78DyCEm1G
	 w62vF+d95Sb85gDplezrGT350byMATqpPJ7la4j7nu7UIRy4PO6crLUZlp5wPcGA8/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WU337yfW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F190606A335;
	Thu, 19 Nov 2026 00:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WU337yfW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95C61F000C4;
	Thu, 19 Nov 2026 00:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048146;
	bh=QOsFS7XOZhJKJaZHB0090mtDhB11N7C1g4Dr6kV3Y1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WU337yfWmdkc1CeY+wG0BSHuUPTR93OwKAv4WyOJgnA3L5LWoOgA7MEKJDPnBlNLp
	 EAoHIuvNnPPX+VdUXxqoaKQYP/aihL/ync96BuRkdgXLjDef1/UxBqyWzxOqQ6PiET
	 otWlitVR+DTeAVEyAgLoQINYIYF63m7r7xfDK4sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1890/2857] regulator: ab8500: Test dedicated enable bits only
Date: Wed, 18 Nov 2026 15:48:44 +0100
Message-ID: <20261118150309.284300530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit a5ee78846015512b4d3d32f8aa463024a23234ce ]

Some regulator control registers have independent enable and low-power
bits. is_enabled() currently tests their combined update mask, so an
off regulator with its low-power bit set is incorrectly reported as
enabled.

Add an optional enable mask and use it for VINTCORE, AB8500 TVOUT,
AB8505 ADC, and AB8505 VAUX5/6. Regulators whose two-bit field encodes
the complete operating state continue to test the full update mask.

References: AB8500 User Manual, UM0836 Rev 3, p. 214;
AB8505 User Manual, DM00046744 Rev 3, pp. 171-172 and 223

Fixes: 65e03ed2d0cd ("regulators: Fixed errors in ab8500 register mapping")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260901-ux500-dts-snowball-regulator-v2-5-fe88b01829bf@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/ab8500.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 110c660e899d7..c00bd8bf1e058 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -162,6 +162,7 @@ struct ab8500_shared_mode {
  * @update_bank: bank to control on/off
  * @update_reg: register to control on/off
  * @update_mask: mask to enable/disable and set mode of regulator
+ * @enable_mask: optional mask for an enable bit separate from the mode bit
  * @update_val: bits holding the regulator current mode
  * @update_val_idle: bits to enable the regulator in idle (low power) mode
  * @update_val_normal: bits to enable the regulator in normal (high power) mode
@@ -183,6 +184,7 @@ struct ab8500_regulator_info {
 	u8 update_bank;
 	u8 update_reg;
 	u8 update_mask;
+	u8 enable_mask;
 	u8 update_val;
 	u8 update_val_idle;
 	u8 update_val_normal;
@@ -377,6 +379,7 @@ static int ab8500_regulator_is_enabled(struct regulator_dev *rdev)
 {
 	int ret;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+	u8 enable_mask;
 	u8 regval;
 
 	if (info == NULL) {
@@ -392,13 +395,15 @@ static int ab8500_regulator_is_enabled(struct regulator_dev *rdev)
 		return ret;
 	}
 
+	enable_mask = info->enable_mask ? info->enable_mask : info->update_mask;
+
 	dev_vdbg(rdev_get_dev(rdev),
 		"%s-is_enabled (bank, reg, mask, value): 0x%x, 0x%x, 0x%x,"
 		" 0x%x\n",
 		info->desc.name, info->update_bank, info->update_reg,
-		info->update_mask, regval);
+		enable_mask, regval);
 
-	if (regval & info->update_mask)
+	if (regval & enable_mask)
 		return 1;
 	else
 		return 0;
@@ -833,6 +838,7 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
 		.update_mask		= 0x44,
+		.enable_mask		= 0x04,
 		.update_val		= 0x44,
 		.update_val_idle	= 0x44,
 		.update_val_normal	= 0x04,
@@ -861,6 +867,7 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
 		.update_mask		= 0x82,
+		.enable_mask		= 0x02,
 		.update_val		= 0x02,
 		.update_val_idle	= 0x82,
 		.update_val_normal	= 0x02,
@@ -1070,6 +1077,7 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x01,
 		.update_reg		= 0x55,
 		.update_mask		= 0x18,
+		.enable_mask		= 0x10,
 		.update_val		= 0x10,
 		.update_val_idle	= 0x18,
 		.update_val_normal	= 0x10,
@@ -1092,6 +1100,7 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x01,
 		.update_reg		= 0x56,
 		.update_mask		= 0x18,
+		.enable_mask		= 0x10,
 		.update_val		= 0x10,
 		.update_val_idle	= 0x18,
 		.update_val_normal	= 0x10,
@@ -1113,6 +1122,7 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
 		.update_mask		= 0x44,
+		.enable_mask		= 0x04,
 		.update_val		= 0x04,
 		.update_val_idle	= 0x44,
 		.update_val_normal	= 0x04,
@@ -1141,6 +1151,7 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
 		.update_mask		= 0x82,
+		.enable_mask		= 0x02,
 		.update_val		= 0x02,
 		.update_val_idle	= 0x82,
 		.update_val_normal	= 0x02,
-- 
2.53.0



