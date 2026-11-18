Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060567;
	b=hHiXe3y2RNA6EbXvABv2yD4/iBFmINGkS6v/wK/BdqduGGq2lWDyDHbbPed8rx8GbzLV
	 mzgZM/04OHlFTtCVCkCG98/X+6Mo5sg/I+4tRHP5OxVKGi3iDiNt/lVbiRstALD/9Zc4O
	 fBkal9Lxg3X7zkQ9gW6EB2uRrl6G+vYeLTmDEPvvvJossKP7QHPgEafUzjqbULmetH0pb
	 0J3V6BBFFoU6iSy/Cx3/1F+XmczYTFdjOYgoWm5yNeZCK9/gmDEohTL/Xgub4qeqKVL+8
	 az2yNfjYfDISvSrZ9PFRKZLMzm35gyWD/5v50wMV/VOs+wSdWGH59zpFR2mRa2fcIVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mtWmMSqCEs7r1VGbFHJX68yhz4Y58D49lRXlDbHldmw=;
	b=E2bDB3D9srw0/QjHfYcfmKoCywANIXvb75MuV5I/EwdCgnEMgcUpS0jVvtHsSPXzvQ23
	 trA4gCOelgbhntlqVHmLvLlJRThlMTLidX8inrL31I5ZK5IXoUJtrTy2hGByay9D0Muvv
	 kkBT6Rh587hYOmlC8X3udyZ3pXXNhXnZYx/ohUiBVgww3/jn5FFdOwtP6wLkWG6XJZrSG
	 ljSFfUAXXleLDClKlKKWmNNTTgr/+eHw1NKhl+H1Bgvmhx4VCN3+FT/f89nXJ19Y0Pd7Z
	 aM5cCBCSJ2hpjP2FIV60NpqrncGg857XylB01jr18h8+uT1E0Am0l8KgKfPuq92b0AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IBdHbmX1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63549606A333;
	Thu, 19 Nov 2026 03:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IBdHbmX1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1FE1F000C5;
	Thu, 19 Nov 2026 03:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060567;
	bh=mtWmMSqCEs7r1VGbFHJX68yhz4Y58D49lRXlDbHldmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IBdHbmX105N8e7Cr59Vu7F5/W3wewEBMZaKTw7nJc+EXLdsI2iWXcgdAq8L5eRXb1
	 OEbpavLvu9I4jz5lzpmO0BG1W3E0EBZiKOlXDymxvEgMlcVmKE8fzpP6k7YZVGPedM
	 yEET1ppL0b+b6u+WaCS1UZnVrAalmoPWBZVq7Z0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1203/1848] power: supply: bq2515x: Propagate charge-enable read errors
Date: Wed, 18 Nov 2026 15:54:01 +0100
Message-ID: <20261118150010.358370464@linuxfoundation.org>
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
index 374b112f712ae..56e9bbd48b790 100644
--- a/drivers/power/supply/bq2515x_charger.c
+++ b/drivers/power/supply/bq2515x_charger.c
@@ -415,7 +415,7 @@ static int bq2515x_get_battery_current_now(struct bq2515x_device *bq2515x)
 							BQ2515X_ICHG_DIVISOR);
 }
 
-static bool bq2515x_get_charge_disable(struct bq2515x_device *bq2515x)
+static int bq2515x_get_charge_disable(struct bq2515x_device *bq2515x)
 {
 	int ret;
 	int ce_pin;
@@ -423,6 +423,8 @@ static bool bq2515x_get_charge_disable(struct bq2515x_device *bq2515x)
 	int charger_disable;
 
 	ce_pin = gpiod_get_value_cansleep(bq2515x->ce_gpio);
+	if (ce_pin < 0)
+		return ce_pin;
 
 	ret = regmap_read(bq2515x->regmap, BQ2515X_ICCTRL2, &icctrl2);
 	if (ret)
@@ -430,10 +432,7 @@ static bool bq2515x_get_charge_disable(struct bq2515x_device *bq2515x)
 
 	charger_disable = icctrl2 & BQ2515X_CHARGER_DISABLE;
 
-	if (charger_disable || ce_pin)
-		return true;
-
-	return false;
+	return charger_disable || ce_pin;
 }
 
 static int bq2515x_set_charge_disable(struct bq2515x_device *bq2515x, int val)
@@ -610,7 +609,11 @@ static int bq2515x_charging_status(struct bq2515x_device *bq2515x,
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



