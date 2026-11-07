Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063470;
	b=brbSbJXhPhv3O4k5s1QOsJwRkjjEv17EKcMdKicmnzq+kx7ymZrHIcEyA6dGT9CDjNGC
	 NUH3mUh64n7i2lD+Zt7ZFtXfCx59XpxRj3BXXZeQjYsb9Q7Bx6jyDt9D5N+o3AGCjcCCv
	 gCeSlnSPKdr1TWEiayyFdSebJdkjKxkE++oyudaJbhxHMpX7XBT1JeI8v7TzMLEB4NwMg
	 Wq63wWc15fuCKLHbH07F/ig911gYlQEM96UU09mz9yFy5S+pjaoLXlZr2gQ1HJBJDHwpH
	 e2/kWnIvuC5o+QMbsGYH3EJSk1RvA+BqN8rF79HHA9HKWVtPlMCYkxe+88sx1Sg+KMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eaCwefF2LEbzB8VWleTI4wH4r+VbMhsSep1dIqfXf8g=;
	b=xD0UyHXM+tldwp4KLT4z5tNX/8cj7OykphJN6Xao7oA6UWW891U2P1DB7DQM22X0E5OQ
	 CdjX6ZBJ5f8KgzwDW0nxC2qAQeokQAQejKDQuBBApqBGfkY37PDHhqk9TtVeVy7dBIry3
	 DlFkD1yFphqCxYu8Gmzxh9CwKkp1YrynkK3B3IOzhqhsBanbSE1PXYwMDJI+rJCNflTAL
	 kTFp8PQD76VMEvO1SoUKPdnrX+Borpz6Uc72cc1aUzJW5MlJBYInjMdUCBRObjUHcZFJZ
	 k6J/8Q1FWgv9owA2NeikKVzJLPSw8aXwfbGe0/ro4KuA6732jXlONmnoVyj76w6+vAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xkMIhIIn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AA5606EEA3;
	Sat,  7 Nov 2026 14:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xkMIhIIn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBED11F008A2;
	Sat,  7 Nov 2026 14:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063470;
	bh=eaCwefF2LEbzB8VWleTI4wH4r+VbMhsSep1dIqfXf8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xkMIhIInoCnmy6ikT1kVUEPBYH9qhdaDZjVv87BQqv78iSHE3r8JuWShqQ6K/9n+C
	 Bnx/EpscXqB2xLqvv01mkTcpDI6uiI+0oJzuIuWGq19ExFaiBuH7nWse5L+Eh3DxhQ
	 Gfy/56uckcpvMmfgGxfV5if6OkquIgx8nvHP8QXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brandon Williams <turbine.bmw@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 623/869] power: supply: qcom_battmgr: Notify charger supplies of online changes
Date: Sat,  7 Nov 2026 08:55:05 -0500
Message-ID: <20261107134914.134839794@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_battmgr.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/qcom_battmgr.c b/drivers/power/supply/qcom_battmgr.c
index 7454ec0e99633..03ffaad3b53df 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -1258,6 +1258,23 @@ static unsigned int qcom_battmgr_sc8280xp_convert_temp(unsigned int temperature)
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
@@ -1327,9 +1344,12 @@ static void qcom_battmgr_sc8280xp_callback(struct qcom_battmgr *battmgr,
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
 		if (battmgr->info.last_full_capacity != 0) {
 			/*
 			 * 100 * battmgr->status.capacity can overflow a 32bit
-- 
2.53.0



