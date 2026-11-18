Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054865;
	b=QU+tjSgDbvXV6g46z8z2aYDR1cTkgrc+Bnf3PS9djJlVG3DLB4uXQJ7o0zrsTdGyDdJd
	 U+B1pHcg0dRwn3TlHlRaIdjJbDgSnsnTIJfqs5lpBDS0+VNIarKE1uwxbgie031CzgJWZ
	 edmGaw8KyI/5rVh9QyV9Q/2FtpR7ST0AXJQ67u3Z4wFh9dkvOmEnSHylPdFj7AI7mV44D
	 Qe0uoi6dzkOnY/RrnJe621stWkr9hRG/zK8I234APxZZz7pNNitMJX61s8rUwnd1rehIo
	 0vUGJKB65gsej/Cn+ptOo8UT7YCjV8GXEZCsMhHd4yWcqnRpOzlrPzFrsnwQf6zuhtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3A3BhoWzJfmU84qWOSyUmRluXvK91nevybRdPwOgNOM=;
	b=ydoGvVGR/Vuq5a10RRuQ3FF07WEayBzmSnITD6gACcoMqIpHOzV3vgdOHOQct6AIubMV
	 WYm8O8ZiAxTuZudpGlAbaSNmCjTeakVLZ5nWTU+6FIFLZ/meoqt6PTMHmpC6QlXBLeeJQ
	 QEzPo9yMeT4Qp6NXTCOo1c/e+bpGDm7Rb21avHlD1sNkRMYDNtik+wpZqsjXRvH45dtPE
	 gygUm9dqBt88LQZ3WWQhm9lcqJts9TY9TSNrnGVQea690opel3/fY9uP20UhDKT0zKL1F
	 DWclrk5S6fJJS6mycbGdMLfEQhJKTi589yaX7pjq5hpLIKBzlS2/N4FJvFWRPa8VMnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DII8LeH2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763C2606A31C;
	Thu, 19 Nov 2026 02:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DII8LeH2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50351F000C4;
	Thu, 19 Nov 2026 02:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054865;
	bh=3A3BhoWzJfmU84qWOSyUmRluXvK91nevybRdPwOgNOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DII8LeH23egSPJszvEMI/IaQOZMs/B9Ju8XA9Yy2mTuuiHv+umEi7+4zkKPlBdQ08
	 wDhX6TWfRI4yEtkwe7DtqoCSdecHklgwyk+k/w7fWfHeMLRvUs89UCf6uy8QHp/XM1
	 NCpD+EVpG5/C1sjfz5TFSTFDMnAY13+av/d7jLdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1428/2214] power: supply: bq2515x: Propagate charge-enable read errors
Date: Wed, 18 Nov 2026 15:51:44 +0100
Message-ID: <20261118150108.312276006@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



