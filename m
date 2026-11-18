Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039485;
	b=NAg251f72vq9e6eyqlPwftWs3wVSSuftnisyVPCLo7Hiv/0fX0rGxFXNgEcdkLJVMkLV
	 3hzieYwPGj173XMPAnnLNCMA36FF4+w7J6ThZoufaMxPLLSCu34+dBj3xjjP3rpjz7u7W
	 7Zy73fapzQF9YF4c4PI2iSPCBUvBHPGrYuhdPrcxYMmfN7gShRe2myk33pMLswzlyYinR
	 eZLiLc/lNzWOr7iRGVE1EbnRnFNa3AEAgW4GGujAeEEoGiEfI84TGDUK3mNjFMLDWEqoT
	 xXKKVWkD1009gltPH6SYZEKZY5qT9yyuiFcflcOFETqwjAVXGmnDhiYNANSUb522tmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V3KAKFYPOpnUoPKLJs/ocSkxUPM9FbZWqiD9HZjW+UU=;
	b=NZ4qm2XQN2j9T42v5Wzm6c7RonVrZnXFVN5GuTnz6SpwJmAV/exIoV3mgPswBLwA2Wdp
	 zIBS3T+J1onEARSwzhc3WJuhsv9RmUBoYGF2NaCpylMyM3xeLzZ1236CKzLMhWV3B9tbp
	 bM2+TFE7SMpfjcoKWWbgdlbr479UdNWtJONyyMRyTxRfJm9+VoxU6DezHxrFgfKdSB22J
	 SfHeGs6ijk0mFxyUv4Uo2ZJMaYufmXn59bgpTMAIcGIKPu1/dHWiQva8TfmjeTBzbfcuJ
	 PYfvdMLVMIxIYqJp+f/pcLdtQYmuKz7XhLCFIdfHIYLzXTFvPAXbgrHo/mYWE1Q1Zwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UqXyuqAI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A96606A320;
	Wed, 18 Nov 2026 22:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UqXyuqAI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6769B1F000C4;
	Wed, 18 Nov 2026 22:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039484;
	bh=V3KAKFYPOpnUoPKLJs/ocSkxUPM9FbZWqiD9HZjW+UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UqXyuqAIfvi/iaRFUfY7e/Jb7tkedCYCNju6X1S77k1YunmmDQLHsXF6ed19ju4ic
	 K8h/MyFm3WF68kz3j+hdAVGwuunQvmuqgqMIiB4XDW+EofXU0aC43kjVHSqI/JKx6s
	 bC7yM+xQ6LQvakuZDALRmzfwrKh99NgA6Y4UoJUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2117/3318] power: supply: bq2515x: Propagate charge-enable read errors
Date: Wed, 18 Nov 2026 15:45:39 +0100
Message-ID: <20261118150425.576261555@linuxfoundation.org>
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
index 1dbacc9b015d7..bdcbdf9e909c0 100644
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



