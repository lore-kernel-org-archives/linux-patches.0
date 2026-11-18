Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060515;
	b=XeatWUT5bcGeInGSwjAdMvu60ERj571g55IVy2zPtJAUhH+2Mbk9UkGm1c2qFKPAl4nA
	 vykqo1mdlksuwa5Tq0CCEu4Oc3m8uHM4/6bHQUGcGIH1xmsnNaL1RarpQrAQcX5oTgTp6
	 zraf5xWvwl/1FVazgNWpLjE6ZUxq0ALzVGlfanpL+GgWIxcs6DWaAAMl7CzsCzfysZAft
	 Ld50x5m/j7Mv2x4davQx1z4bZhVLjvLRDYMRpk0NqfUMFwV+8WyzuT7jMkatMg5wyHauT
	 L+JicxVigljscX96mDprKN++S2VT/PU3eVnHq8CLFScIIKUkJuI6GMTJjtbi/Q12sLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9VaelKKBsnt1iy9aUAWXtSDKOSWbee63gqAVnwjb1eo=;
	b=WDbN9HmLUUvhG0R/mlbHUtq6c0+cZsmLegvTtUk2Mt0MqL8lre3oEN6sH/+YIXMK6Zgd
	 AxR8O/fm3v7QIh5yLOCd95054U4ysqyQR16efZfmZeWkl7KqCBXVdfkraGneWEaGoO5Hj
	 Tpg3ewcLW++rj/38kPAm5q4myGKihITvkv9MqohkEN+JAPg35/Fn09kf+FxDE4JjoJY9o
	 4sw1buyZwUtmasEWCLCQYaofFrtNbcaa/9KklcPz9C0RnOPCRflVd1tZ36/l3Qn4GHUUg
	 HaRW0YHMeU1h3GGf2Tx9Z9YmU1uf5aH3cD/vayO02H7bQgnNFcVf9+PXvWFMmxNb52w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lQ29vRj2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586E2606A325;
	Thu, 19 Nov 2026 03:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lQ29vRj2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02B31F000C4;
	Thu, 19 Nov 2026 03:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060515;
	bh=9VaelKKBsnt1iy9aUAWXtSDKOSWbee63gqAVnwjb1eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lQ29vRj27k9OOghZmLtJDmtGLCJ3W4AyhSvdY4FWcqYvLXnrORVtfG+Udkb+8hUen
	 NWjaJgW0Q4KfIJJkXXEnQ+N+Tg/63+yjF2R283fwh1chFaS+WWcJZJXvzJqA04Oh3B
	 I8Abh1SoHNkSeWJTcDfXl0Ee+cRVGCJeVAkzkZ3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1225/1848] regulator: ab8500: Propagate mode enable read errors
Date: Wed, 18 Nov 2026 15:54:23 +0100
Message-ID: <20261118150011.208647113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 71ac8878573058e2b85210760ccaeaac90796c35 ]

For regulators whose enable and mode share a state field, set_mode()
first reads that field so changing the requested mode does not enable a
disabled rail. A register read error is currently treated as true and
the driver proceeds to write the new mode, potentially enabling a rail
whose state is unknown.

Return the read error without changing the register or cached mode.

References: AB8500 User Manual, UM0836 Rev 3, p. 227;
AB8505 User Manual, DM00046744 Rev 3, p. 237

Fixes: 438e695b87e0 ("regulator: ab8500: Get rid of is_enabled from struct ab8500_regulator_info")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260901-ux500-dts-snowball-regulator-v2-6-fe88b01829bf@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/ab8500.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 43720f51e3076..ecf1a85833e42 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -319,7 +319,7 @@ static unsigned int ab8500_regulator_get_optimum_mode(
 static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 				     unsigned int mode)
 {
-	int ret = 0;
+	int enabled, ret = 0;
 	u8 bank, reg, mask, val;
 	bool lp_mode_req = false;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
@@ -376,7 +376,17 @@ static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 		goto out_unlock;
 	}
 
-	if (info->mode_mask || ab8500_regulator_is_enabled(rdev)) {
+	if (info->mode_mask) {
+		enabled = 1;
+	} else {
+		enabled = ab8500_regulator_is_enabled(rdev);
+		if (enabled < 0) {
+			ret = enabled;
+			goto out_unlock;
+		}
+	}
+
+	if (enabled) {
 		ret = abx500_mask_and_set_register_interruptible(info->dev,
 			bank, reg, mask, val);
 		if (ret < 0) {
-- 
2.53.0



