Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015878;
	b=ufTXPjA6LuZ4WfBHLTi2sJ23L5ueklvYLosuVemTOiLbiVcDIdgQkprAojicWVa5cpnA
	 5RYZq+ndVBqJmP/h9tw77vb6bW1gsAvIcJK37sP5ehf2mcTCRpnS0E+h5wx0RSIIwjU0e
	 eWHDww6sznswv0ZG6lMCL4Py10HwCbdMBxZwrgLDduKMTwkZhWeCDxppPMvbsLtUqpMCU
	 /HVopvpQvhbC4/TpWNBcYcpaeeY9t/eN4YmKFWLb9QfY1jFxU22hxja1rw/xbS0dk0lWN
	 d5YMEkdthPX1bJA/+1cD8umqZAgXrkpzBTeblWsQySpYsue07nwDqnFalwkaoaUTkKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bMQZTc1qmBWUKebNo4/VeQ9fywjWvD8qNJrGJCBgXso=;
	b=b10j9xtKH/CA3OJ5VVGZKA77vxh4TKkDEgdq95d4o+aoMjUHLrMwWKPsFKNh/QdEMzvc
	 GZwcomqpCDiX1gMLG2oeFXPiTrwrM4yWdcbFDFG09LrZ/vpXiOVOLb8dsCg/cLSmknrNw
	 TKZihWHfj8O0cRanOTluDFCWvRDDwIpYvJEtY0CHVzZMdRZ9MZz+JDAJus54cuhvuYJ0Z
	 oPBRwd6IdqsKpBgfZuGAOtejFAGGUG5dlP8ybOMj2M7pmMH+c0wqvde5vn8XgOaGaehr/
	 bCypWBRkDNtjQn0vhTFGGYDeup6OuL+p4lBQZEsIiS/ou4uAdmKU9f9+6m2xRbi0Ugg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d8Td16Iq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DF2606A31C;
	Wed, 18 Nov 2026 15:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d8Td16Iq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC191F000C4;
	Wed, 18 Nov 2026 15:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015878;
	bh=bMQZTc1qmBWUKebNo4/VeQ9fywjWvD8qNJrGJCBgXso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8Td16IqFsgaxXDD2+iXcGZB5T4Q/yckJSjPaeCePItTBzfFR9Wu4Lwm2rTKYihCL
	 QN2GmSQBlKq/MqxI4GdIMAYLL3al83raerXbo6YYFYv9gawPOPF3vFxa6zM20fRUyI
	 UzHHcVZL3xdb8v0kkpmUkFc/fpHtSp16A08mPi1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0329/2651] power: supply: bq2515x: Propagate charge-enable read errors
Date: Wed, 18 Nov 2026 15:26:09 +0100
Message-ID: <20261118150259.704113283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 4a35810a847411c466a15d1737d11e8e818dc197 ]

bq2515x_get_charge_disable() returns bool even though reading the
charger-disable state can fail. A negative error is therefore converted to
true, so POWER_SUPPLY_PROP_STATUS reports NOT_CHARGING with success instead
of propagating the failure. The GPIO read is not checked for errors either.

Return an int from the helper, check both reads, and only convert a valid
charger-disable state to the charging-status boolean.

Fixes: 44908459275e ("power: supply: bq25150 introduce the bq25150")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Link: https://patch.msgid.link/20260824084217.670213-1-lilinmao@kylinos.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq2515x_charger.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/power/supply/bq2515x_charger.c b/drivers/power/supply/bq2515x_charger.c
index 0208358ebbe4c..c2b17562cf8bb 100644
--- a/drivers/power/supply/bq2515x_charger.c
+++ b/drivers/power/supply/bq2515x_charger.c
@@ -420,7 +420,7 @@ static int bq2515x_get_battery_current_now(struct bq2515x_device *bq2515x)
 							BQ2515X_ICHG_DIVISOR);
 }
 
-static bool bq2515x_get_charge_disable(struct bq2515x_device *bq2515x)
+static int bq2515x_get_charge_disable(struct bq2515x_device *bq2515x)
 {
 	int ret;
 	int ce_pin;
@@ -428,6 +428,8 @@ static bool bq2515x_get_charge_disable(struct bq2515x_device *bq2515x)
 	int charger_disable;
 
 	ce_pin = gpiod_get_value_cansleep(bq2515x->ce_gpio);
+	if (ce_pin < 0)
+		return ce_pin;
 
 	ret = regmap_read(bq2515x->regmap, BQ2515X_ICCTRL2, &icctrl2);
 	if (ret)
@@ -435,10 +437,7 @@ static bool bq2515x_get_charge_disable(struct bq2515x_device *bq2515x)
 
 	charger_disable = icctrl2 & BQ2515X_CHARGER_DISABLE;
 
-	if (charger_disable || ce_pin)
-		return true;
-
-	return false;
+	return charger_disable || ce_pin;
 }
 
 static int bq2515x_set_charge_disable(struct bq2515x_device *bq2515x, int val)
@@ -615,7 +614,11 @@ static int bq2515x_charging_status(struct bq2515x_device *bq2515x,
 	else
 		status1_no_fault = false;
 
-	ce_status = (!bq2515x_get_charge_disable(bq2515x));
+	ret = bq2515x_get_charge_disable(bq2515x);
+	if (ret < 0)
+		return ret;
+
+	ce_status = !ret;
 
 	/*
 	 * If there are no faults and charging is enabled, then status is
-- 
2.53.0



