Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048020;
	b=0BpVAB/lGaYCEfW/MbAhJd2bHRgMyF60dO4ryioX8HchOh/b4uuAkrbqPKryFMUWkxnX
	 RyQOhmH80WioVG1Ylemctb+AIsg0oRRTSI9IxL6GMO10gzDe6M3rB3zLtNCJ7tzhEBHHt
	 gFramjuUuTLZEXvDrdoL2kFWj2I5mbywyhbvUR1/cspF78sg1rETsIbzEq1Z6A9CkXp1C
	 wJSuJhxilqqQO1sDjpGJjEm7xw9SQXPK+9bXIeBGnO0Z+5cytWLpNPNR+oHgIqUUkD4fH
	 6j6bz1J6G69B9D/PvJ1KQiPXa0BNxLMzNX/Aw6b6JwYTniWqEl5pxfAlH3qRLhclMoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J54cHfpX1q4NKev6Z4r4bhyaXXDMRZjuBXUeno4bSiU=;
	b=Jf+qH22MH9Q+QlLBblBpjgdN6OOWi/ldw5V76ETqbm1H+b9I3LSkfPma0ECCPME83S2s
	 9e+zAlrPcmf8CRN0Y9D7xI9+u1yQjCxPes8ZtQmMvYHx0Bq9Lzkni/bL/k5I6S9bBuZkd
	 vqx1UFovpM801PGFbPv2+ZSJzwyrAj5qzEHKQA3v7T/S3qhMXHm5bb16SvJLE4Xk1WUNM
	 H0McMGMrmChwmMktPva/bmTi/vxHmufT9QprDunxbFK9mFtrfPf7Hjnm6C5wkl59FiXRb
	 0eyeW7fbn8tXyWvMpjoDLVn3e0G9KTXbQ9bFggW5ACaLLN78g9JIr3MIoIf1o1hl9Ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ot71gs7a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72642606A325;
	Thu, 19 Nov 2026 00:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ot71gs7a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF5F1F000C4;
	Thu, 19 Nov 2026 00:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048020;
	bh=J54cHfpX1q4NKev6Z4r4bhyaXXDMRZjuBXUeno4bSiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ot71gs7ao6A0EmeDJjGcyy3MgOJeTx1HiqIv5IDS730/xVfYBW17Pyp8SHuT9hoST
	 75NCvf10xx81azcND79KJbzJuSIjQtLcsahwUlRFEr598+mxH9SyrBpByT542s0iry
	 EvuqOg74dxJxcgRnlxcR5cbh94vUIoJHSzd1AFSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1845/2857] power: supply: bq2515x: Propagate charge-enable read errors
Date: Wed, 18 Nov 2026 15:47:59 +0100
Message-ID: <20261118150307.676372508@linuxfoundation.org>
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
index 4f76ad9c2f18e..cb6d5d436f470 100644
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



