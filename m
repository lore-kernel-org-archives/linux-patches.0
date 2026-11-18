Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038713;
	b=ctkLjMiGHTREQbhFKsH0BVqBWF+/CyLsqKL2pxenCiuK08U+qU+ppOcopF1/k+pXW4TH
	 JE33tkNfvnUsWAMrcRV/uLx76l/EapgfS10/6SqGhNBqg7zmfYTAQX7XSG4jgEjdbqEY7
	 FS21bnxEncgMW1EjExUToqqph5ia1gv455Aq1lywYzsMIHSCbTjIxUlDHgZZ+bNxYMuSb
	 MXyqIw+uqV4bqHEwKWUmTuEAmiqr0VIcwCL6091/0f+dCWe6HLpIXRibIrlGw9Qf4hB1w
	 F6cQvFaVzObQVdhV+dpO4cXbQzzqZy4ma9QxibOHIX0g+JMkA2/dPxr0iOGtlNd14ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GViHWSQkTPspjxzgIh3m/1LaVFqpPURyJTfEnhj4Tpk=;
	b=Uzihmg1Cq6XKCIk3daBFPzjP4f37ejmVc5nzeUU17AC7l/Rt5bcilpzjw40XR9OFMbSu
	 dCzmhrp9+EsSVwdasPZq+ZClW/eGlqjj0DSAbEzO5OM/edLktlCsJk1txabUpAMncRf7k
	 kanaT8gqpVeJgt+XLaAUubkeVCid0CxJyLt/yyncL0dhXAC1+qSFGBGXM7uAS367skLWP
	 LjH8DGWG+bQygxNdFsmDHSX2BnsluIfNmZ1GXis+NbZDdg4zKJS1y9Wy6oYTapNb3weBi
	 /acniNw0mW6egiYjZNpU0DLNNURnjtRWB5R9PjHLRybPt4sXoYr564JF1XMFEIhHwhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RIZ045TO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7036606A333;
	Wed, 18 Nov 2026 21:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RIZ045TO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438E51F000C5;
	Wed, 18 Nov 2026 21:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038712;
	bh=GViHWSQkTPspjxzgIh3m/1LaVFqpPURyJTfEnhj4Tpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RIZ045TOqiEMQ/bgaL2SsfUm030VEK6P9vdRFdgI6gl581p/9x1Lv5IfySqSD2r+8
	 MFd8Bsf5tE2GQypoQvlAwvuwSNbbESIwkPlutOh0ey94FDptIaUDXo/u04bd+imkds
	 hPiyZH5/C3bGaGJMUSxBqjj8XQCmRmGZr2eBmSAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brandon Williams <turbine.bmw@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1842/3318] power: supply: qcom_battmgr: Notify charger supplies of online changes
Date: Wed, 18 Nov 2026 15:41:04 +0100
Message-ID: <20261118150417.117485660@linuxfoundation.org>
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

From: Brandon Williams <turbine.bmw@gmail.com>

[ Upstream commit 87fd20da8ca8bacdaa9bff5860167f208077dc51 ]

On SC8280XP and X1E80100 the AC, USB and wireless supplies take their
online state from the charging source in the battery status response.
The firmware sends no notification for those supplies when the charging
source changes, and the driver only announces the battery, so userspace
never learns that the charger was plugged in or out. UPower keeps the
state it read at startup: a laptop booted on the charger never goes on
battery.

Call power_supply_changed() for a supply whose online state changes when
a status response is parsed. A supply that is not registered yet, when
the battery is read during probe, reports its state when it registers.

Tested on a Microsoft Surface Pro 11 (X1E80100): after restarting UPower
on the charger, unplugging now sets OnBattery, and plugging in clears it.

Fixes: 29e8142b5623 ("power: supply: Introduce Qualcomm PMIC GLINK power supply")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Brandon Williams <turbine.bmw@gmail.com>
Link: https://patch.msgid.link/20261013-upstream-battmgr-charger-online-v1-1-731973e133a0@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
[ sashal: adjusted callback context because the last_full_capacity block is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_battmgr.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/qcom_battmgr.c b/drivers/power/supply/qcom_battmgr.c
index 7b51f827c34cd..65140d4985af1 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -995,6 +995,23 @@ static unsigned int qcom_battmgr_sc8280xp_convert_temp(unsigned int temperature)
 	return DIV_ROUND_CLOSEST(temperature, 10);
 }
 
+/*
+ * The charger supplies' online state comes from the battery status response,
+ * and the firmware sends no notification of its own when it changes, so
+ * announce the change here. A supply that is not registered yet announces its
+ * state when it is.
+ */
+static void qcom_battmgr_sc8280xp_set_online(struct power_supply *psy,
+					     bool *online, bool value)
+{
+	if (*online == value)
+		return;
+
+	*online = value;
+	if (psy)
+		power_supply_changed(psy);
+}
+
 static void qcom_battmgr_sc8280xp_callback(struct qcom_battmgr *battmgr,
 					   const struct qcom_battmgr_message *resp,
 					   size_t len)
@@ -1062,9 +1079,12 @@ static void qcom_battmgr_sc8280xp_callback(struct qcom_battmgr *battmgr,
 		battmgr->status.temperature = qcom_battmgr_sc8280xp_convert_temp(le32_to_cpu(resp->status.temperature));
 
 		source = le32_to_cpu(resp->status.charging_source);
-		battmgr->ac.online = source == BATTMGR_CHARGING_SOURCE_AC;
-		battmgr->usb.online = source == BATTMGR_CHARGING_SOURCE_USB;
-		battmgr->wireless.online = source == BATTMGR_CHARGING_SOURCE_WIRELESS;
+		qcom_battmgr_sc8280xp_set_online(battmgr->ac_psy, &battmgr->ac.online,
+						 source == BATTMGR_CHARGING_SOURCE_AC);
+		qcom_battmgr_sc8280xp_set_online(battmgr->usb_psy, &battmgr->usb.online,
+						 source == BATTMGR_CHARGING_SOURCE_USB);
+		qcom_battmgr_sc8280xp_set_online(battmgr->wls_psy, &battmgr->wireless.online,
+						 source == BATTMGR_CHARGING_SOURCE_WIRELESS);
 		break;
 	case BATTMGR_BAT_DISCHARGE_TIME:
 		battmgr->status.discharge_time = le32_to_cpu(resp->time);
-- 
2.53.0



