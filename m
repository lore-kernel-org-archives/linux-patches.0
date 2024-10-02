Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CCB1D175D;
	Wed,  2 Oct 2024 14:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879460; cv=none; b=XsM0SD6B+XT0zp8DJUwKZ1M/lEfFmRMVkiwbCEhF7VkTVbJ0NJaBYFQ7C4naU3siVSCLp/98oOjSB2wQV8e6jEuBFO/TI4pze7e/KhBjDmc1qKBryUH10gDVqBRbnT0kUutkoVWp6quiSUCLZ4iWax90vBSy5ZJ0qo+7loaOgJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879460; c=relaxed/simple;
	bh=/rXLgI4vTCogAqmwLMxi7DB+POjGX9bWkOn5zh67tz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H7PnAGhcMjnUQ7NcziE1JHCJeD/uCw1STwvP8ECeYuGfcbKaxQjIHLHgobmlryO1YmkfBefrp0L66XPNFdKkF9EBNH1AQmn2rUWB++jseAaz0qfLukG+oocV6wS4GMn/JrX5wfVjHc3Gs0Hyi0jrjFSlwcyHlbHj7DjFNeUeVRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HXGPd1dn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HXGPd1dn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8918CC4CEC5;
	Wed,  2 Oct 2024 14:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879459;
	bh=/rXLgI4vTCogAqmwLMxi7DB+POjGX9bWkOn5zh67tz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HXGPd1dnv3P7fTJjwTFubVnVpa82VIE//SGXBy2yeavCM9Cl5qQFr55bokLK9v9uf
	 JC9NzfXSbU1ThCbbTIvm9cSqT0Oq3qo2Hw5LdKHON0pekX0YSkhS5Lcul992ulBR9p
	 ofiEX0ANSec1Z8Va4qlPKO4WvqimMAklnkLVPBB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@kernel.org>,
	Chris Morgan <macromorgan@hotmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/538] power: supply: axp20x_battery: Remove design from min and max voltage
Date: Wed,  2 Oct 2024 14:56:04 +0200
Message-ID: <20241002125757.179005899@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Morgan <macromorgan@hotmail.com>

[ Upstream commit 61978807b00f8a1817b0e5580981af1cd2f428a5 ]

The POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN and
POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN values should be immutable
properties of the battery, but for this driver they are writable values
and used as the minimum and maximum values for charging. Remove the
DESIGN designation from these values.

Fixes: 46c202b5f25f ("power: supply: add battery driver for AXP20X and AXP22X PMICs")
Suggested-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240821215456.962564-3-macroalpha82@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/axp20x_battery.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/power/supply/axp20x_battery.c b/drivers/power/supply/axp20x_battery.c
index 6ac5c80cfda21..7520b599eb3d1 100644
--- a/drivers/power/supply/axp20x_battery.c
+++ b/drivers/power/supply/axp20x_battery.c
@@ -303,11 +303,11 @@ static int axp20x_battery_get_prop(struct power_supply *psy,
 		val->intval = reg & AXP209_FG_PERCENT;
 		break;
 
-	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
+	case POWER_SUPPLY_PROP_VOLTAGE_MAX:
 		return axp20x_batt->data->get_max_voltage(axp20x_batt,
 							  &val->intval);
 
-	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
+	case POWER_SUPPLY_PROP_VOLTAGE_MIN:
 		ret = regmap_read(axp20x_batt->regmap, AXP20X_V_OFF, &reg);
 		if (ret)
 			return ret;
@@ -455,10 +455,10 @@ static int axp20x_battery_set_prop(struct power_supply *psy,
 	struct axp20x_batt_ps *axp20x_batt = power_supply_get_drvdata(psy);
 
 	switch (psp) {
-	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
+	case POWER_SUPPLY_PROP_VOLTAGE_MIN:
 		return axp20x_set_voltage_min_design(axp20x_batt, val->intval);
 
-	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
+	case POWER_SUPPLY_PROP_VOLTAGE_MAX:
 		return axp20x_batt->data->set_max_voltage(axp20x_batt, val->intval);
 
 	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT:
@@ -493,8 +493,8 @@ static enum power_supply_property axp20x_battery_props[] = {
 	POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT,
 	POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT_MAX,
 	POWER_SUPPLY_PROP_HEALTH,
-	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
-	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_MAX,
+	POWER_SUPPLY_PROP_VOLTAGE_MIN,
 	POWER_SUPPLY_PROP_CAPACITY,
 };
 
@@ -502,8 +502,8 @@ static int axp20x_battery_prop_writeable(struct power_supply *psy,
 					 enum power_supply_property psp)
 {
 	return psp == POWER_SUPPLY_PROP_STATUS ||
-	       psp == POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN ||
-	       psp == POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN ||
+	       psp == POWER_SUPPLY_PROP_VOLTAGE_MIN ||
+	       psp == POWER_SUPPLY_PROP_VOLTAGE_MAX ||
 	       psp == POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT ||
 	       psp == POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT_MAX;
 }
-- 
2.43.0



