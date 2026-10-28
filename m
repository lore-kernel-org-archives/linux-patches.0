Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215936;
	b=vI9Dmc8o41VOtCL/jotSbMmbwMRZ8cqIrxFmiGf+vv/pUdQNJj+1emSX5umiKcSOP3KG
	 XLNx1NMJLJIXFciSrMnWpMyRxWVQJ/2GuDoELZSS5VS0+i22zyhaO2IuQfnkNOsMcZB8L
	 aC+KTwKqX6zp/R26MsbcSxn/ibuD4vgUmzqUaTSkFGG8EKbKtP0ibg22weFXwF1vjg4AI
	 DwY4tW3hkD8wDjbIuHn3X3Yy/T6VU97iX0BR8inK8s8xooPU098UEOUJkExjBFKeNmYO8
	 +ofAU6NsLaRK5nI/er2hhxpStA7/IjxzcEzNmnduT8109XVl2FoCnpTJ6XmD38atIpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215936;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=spSpYfP7NMvoIZwEk3WoAHPTfadaC3hiX23JHHQCZcw=;
	b=kkd3d594ZAYpkafde8+0L9EHulJaNhC8M0SA6qKei8RzDkw4k4aWaeM23XazVSZQdH4c
	 u71k9AnSGDiqMie6UPcZvMIU+DHqiErRSACDBm13XlIfCpUqwW2w7p+LBStXGYqSNYSgs
	 3C6vzA1HdIfVAG+iBXR69NyGDEcWdst8nYqORfRoyuwqcZJXyhokaXWMJEKr44EVCRfSi
	 7vgSBlhBprNJGWoFzgmyaJgIGv8sIE4cGpTdp1znEQOUae9CxYH7HC5MqyfcuSbS7von4
	 tmeN/sutWn0YwpMQMrueAXM80SMnpnMwWBUbQFDHyHfDO14e52tsiFh9QPzDZos0fdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jp4Jrhhk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635B5606A31A;
	Wed, 28 Oct 2026 19:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jp4Jrhhk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D541F01825;
	Wed, 28 Oct 2026 19:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215936;
	bh=spSpYfP7NMvoIZwEk3WoAHPTfadaC3hiX23JHHQCZcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jp4JrhhkfY90z+95DcbBUx5Ghl5pZNV3ZHysFu9sGAEqg0i30IpxIJ28TMSK8x6Sb
	 R5N+DT/jBaK6FFWkOuwQ63eoBdpuTAZxjEFTrciuXMcrHAQupdvRS+Xox7MwjJ/Kcq
	 jfsneSGdhNdHTCcW5/ozUmqXeO/nTSWmNhqYnsfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianing Li <m13940358460@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1384/1887] power: supply: max17040: propagate register read errors
Date: Wed, 28 Oct 2026 17:58:00 +0100
Message-ID: <20261028170530.939426466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Jianing Li <m13940358460@163.com>

[ Upstream commit 659cc3d8d5ef246263873fce72c8cadeeed073cc ]

max17040_get_vcell() and max17040_get_soc() ignore errors returned by
regmap_read().  When an I2C transfer fails, the uninitialized register
value is converted and reported to userspace as a valid voltage or state
of charge.  The polling worker can also replace the cached state of charge
with the bogus value and emit a spurious change event.

Propagate read errors through the power supply get_property callback and
keep the last valid cached state of charge when polling fails.

Fixes: c6f4a42de60b ("Add MAX17040 Fuel Gauge driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jianing Li <m13940358460@163.com>
Link: https://patch.msgid.link/20260727064825.948-1-m13940358460@163.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max17040_battery.c | 27 ++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/power/supply/max17040_battery.c b/drivers/power/supply/max17040_battery.c
index 2017acf67a32c..509b18d359343 100644
--- a/drivers/power/supply/max17040_battery.c
+++ b/drivers/power/supply/max17040_battery.c
@@ -190,8 +190,11 @@ static int max17040_raw_vcell_to_uvolts(struct max17040_chip *chip, u16 vcell)
 static int max17040_get_vcell(struct max17040_chip *chip)
 {
 	u32 vcell;
+	int ret;
 
-	regmap_read(chip->regmap, MAX17040_VCELL, &vcell);
+	ret = regmap_read(chip->regmap, MAX17040_VCELL, &vcell);
+	if (ret)
+		return ret;
 
 	return max17040_raw_vcell_to_uvolts(chip, vcell);
 }
@@ -199,8 +202,11 @@ static int max17040_get_vcell(struct max17040_chip *chip)
 static int max17040_get_soc(struct max17040_chip *chip)
 {
 	u32 soc;
+	int ret;
 
-	regmap_read(chip->regmap, MAX17040_SOC, &soc);
+	ret = regmap_read(chip->regmap, MAX17040_SOC, &soc);
+	if (ret)
+		return ret;
 
 	return soc >> (chip->quirk_double_soc ? 9 : 8);
 }
@@ -259,7 +265,11 @@ static int max17040_get_of_data(struct max17040_chip *chip)
 
 static void max17040_check_changes(struct max17040_chip *chip)
 {
-	chip->soc = max17040_get_soc(chip);
+	int soc;
+
+	soc = max17040_get_soc(chip);
+	if (soc >= 0)
+		chip->soc = soc;
 }
 
 static void max17040_queue_work(struct max17040_chip *chip)
@@ -386,16 +396,23 @@ static int max17040_get_property(struct power_supply *psy,
 			    union power_supply_propval *val)
 {
 	struct max17040_chip *chip = power_supply_get_drvdata(psy);
+	int ret;
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
 		val->intval = max17040_get_online(chip);
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		val->intval = max17040_get_vcell(chip);
+		ret = max17040_get_vcell(chip);
+		if (ret < 0)
+			return ret;
+		val->intval = ret;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
-		val->intval = max17040_get_soc(chip);
+		ret = max17040_get_soc(chip);
+		if (ret < 0)
+			return ret;
+		val->intval = ret;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY_ALERT_MIN:
 		val->intval = chip->low_soc_alert;
-- 
2.53.0



