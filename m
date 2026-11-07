Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064977;
	b=SAraZ+GETKgTy5YqDx7g6wnq3z9pH4QP+N7yfkrk13YIMTjJihfViFISWVVQ0g9zj6QH
	 43m3ddzIEJN1YwiCTe36QLTntevsqMA1HZgw3hI8FWySxVz5Ng7o7atYHifDFoALeG0Lp
	 mvQ7WFg2AxTd0lJEGWQcHgJyMySk30NB0E1jnX9L+RfWbZc73Ium/mBYJMRukjShJPUbw
	 raT6goCvtNnBwSWSGn1WIfXN/uhibR0CdsRIeWTyxFZz9tWtNnx7q6Uqkjvpt5o23idRN
	 xJs1O/NBsR0nXyR0eHPOLCsL6mO5GAIe18PrQaCx+StGG2WrDH76g8lfUk3W7umkJLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xfj3DP+yPaOXAPkb3o85FeFvysxJpsKO8hnqOSl9oQA=;
	b=Qj5jC6iLb6tyrJwlBIBWYmSvE2RMIHcCQ/7yDjR3bBWOp29+bm6VAgvesM7uWS9OkDhG
	 RpIYalNIA9d1iltxUDsULrHTxgF0KkDH/QG0C17k51tTbyYOsApypsqR68p1MJox2ibv5
	 RP07P41nft65ptcNFIiwu6CNyK6NITGMITT3UuXnBMlsGPoWJrkul0R6GRXIk2ZSvHNss
	 6HUTOFuSD49MwiNl47+1c6c7nk+1plBxnzTLcbv32mLNl5Ub632pvqB8wzojd8r1kUvdf
	 BcHVm5AisOsrvnhBLVlkjXpIGvlhh5RcJWtMgameC+5OPURBJIhB5j8jUML3uP4mQUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AF+/3zTg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6700606A9DA;
	Sat,  7 Nov 2026 15:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AF+/3zTg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305A01F008A1;
	Sat,  7 Nov 2026 15:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064976;
	bh=xfj3DP+yPaOXAPkb3o85FeFvysxJpsKO8hnqOSl9oQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AF+/3zTg7xbmXCmxhHHWNjXMvQKO1PY/GaOcvk4HQL5qBLA11yxvYnrtw5o5r+LbH
	 abhit++Npt/P4ki6aACfqK4RwRp4t0xbPGUqxcpbbNm2Dn4dwprMvJhQMqkhaGLpfm
	 BIqqK9yhjTlCMcZhxGIF6qfQYfFkh2XyfXrI/Fo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brandon Williams <turbine.bmw@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0855/1257] power: supply: qcom_battmgr: Notify charger supplies of online changes
Date: Sat,  7 Nov 2026 08:52:31 -0500
Message-ID: <20261107135002.946901777@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 7716eb9e1aff5..97c8501c29961 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -1254,6 +1254,23 @@ static unsigned int qcom_battmgr_sc8280xp_convert_temp(unsigned int temperature)
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
@@ -1323,9 +1340,12 @@ static void qcom_battmgr_sc8280xp_callback(struct qcom_battmgr *battmgr,
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



