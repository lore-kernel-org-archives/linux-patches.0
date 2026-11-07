Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063466;
	b=EnFQ+teaEl1adlLRoNEJW/5sg/1W1vSaKVOmmIETF9RMaKbUny4t7IUqcrrgTFlVHw8c
	 SaLeIluNtb8BopFyj2WLdmts8Enpa9WR3pphW6HSqM7K2Ccg0+KLP7O1jBukT7AytIrsS
	 M01j+A69Hf8iaJWLxK+FObA6MMEQZgOdSPo/rTLOtvTFEkBw4WBXIoKzOU7CqduXP5tec
	 L5b4VTEhVU4jyE7JakjF8rBWnDTZ0J5fGw4PGSpAMamhlWxePghljXiImEGCW7o5dmE2N
	 Prryqfu8YyTXNv8AC19UeHHN31oxrRomoHN0j1/jCEe4nscy0B57FlpWfryGtrBrUsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PsWDN2nez1tRltJ6GOYq3IkOR1aJgXj7ZYelWFsaGG0=;
	b=QVoJRp03Xx/YoNMTMUOwXGPAscQin3oo6vKcEOM4X4ek7MYwW1XIDQ5mooOWHQ7ztFCA
	 mp+olmzdeUSrihTaGp9XXfojBULOU93UzTOCFIl3oCLjtBA6IqNpwXJn0zosxIcAyndEw
	 t7RTBK59bPh0ZkZtZnEDDaqP35093/SB7QzPQY4081+Trr4E5MVYRB4yuu/EyfTKyuv26
	 bHS9vJbc06fDJ9Fs9UmOC5Ymxn6Q9K5FB2ofzLHTgzIWDYjxD2LFGl4hnbbmGeluTd2b3
	 LHnrtHd7Y+9d8H6sfssMKgukNe3ZTx2wgKqtnAB9x4ICNnejaTmbO+v7YOb9lX9omWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PtTOGXUj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580176082BEE;
	Sat,  7 Nov 2026 14:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PtTOGXUj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39DA1F0089F;
	Sat,  7 Nov 2026 14:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063466;
	bh=PsWDN2nez1tRltJ6GOYq3IkOR1aJgXj7ZYelWFsaGG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PtTOGXUjuPxFcSfPxWBa0hb1m4FbsjmHc9dgLQnH7tNLU8QbRlIAKa1dSSdjsiezW
	 PMPu3dr9gAplcGc19s4iywsfqdB5Usi2Ki1/9RQTEFyvfNWX9gyKSyPnH0sfqN+EUT
	 1+XOtbvcowrrRYQi4WwLKeLM04irMJprBjAipeZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabricio Akio <fabricioakio@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 620/869] power: supply: qcom_smbx: set the charge enable after software control
Date: Sat,  7 Nov 2026 08:55:02 -0500
Message-ID: <20261107134914.052489893@linuxfoundation.org>
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

From: Fabricio Akio <fabricioakio@gmail.com>

[ Upstream commit 1fba787142011145e1071cee9448b3677fb2323d ]

The init sequence sets CHARGING_ENABLE_CMD before CHGR_CFG2 selects
software control of the charge enable.

The Motorola Moto X4's bootloader leaves the charger watchdog armed to
disable charging when it bites, which it does after a few minutes in
fastboot. Charging then stays disabled in the next boot until the cable
is replugged. Setting the command after CHGR_CFG2 re-enables it.

Fixes: 8648aeb5d7b7 ("power: supply: add Qualcomm PMI8998 SMB2 Charger driver")
Cc: stable@vger.kernel.org
Signed-off-by: Fabricio Akio <fabricioakio@gmail.com>
Link: https://patch.msgid.link/20261002-qcom-smbx-enable-order-v1-1-7df92bd809db@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_smbx.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/power/supply/qcom_smbx.c b/drivers/power/supply/qcom_smbx.c
index 55fe31aa3df3d..ad2cf516e2ded 100644
--- a/drivers/power/supply/qcom_smbx.c
+++ b/drivers/power/supply/qcom_smbx.c
@@ -812,11 +812,7 @@ static const struct smb_init_register smb_init_seq[] = {
 	  .mask = SOC_LT_CHG_RECHARGE_THRESH_SEL_BIT |
 		  VBT_LT_CHG_RECHARGE_THRESH_SEL_BIT,
 	  .val = VBT_LT_CHG_RECHARGE_THRESH_SEL_BIT },
-	/* Enable charging */
 	{ .addr = USBIN_OPTIONS_1_CFG, .mask = HVDCP_EN_BIT, .val = 0 },
-	{ .addr = CHARGING_ENABLE_CMD,
-	  .mask = CHARGING_ENABLE_CMD_BIT,
-	  .val = CHARGING_ENABLE_CMD_BIT },
 	/*
 	 * Match downstream defaults
 	 * CHG_EN_SRC_BIT - charger enable is controlled by software
@@ -837,6 +833,13 @@ static const struct smb_init_register smb_init_seq[] = {
 		  AUTO_RECHG_BIT | EN_ANALOG_DROP_IN_VBATT_BIT |
 		  CHARGER_INHIBIT_BIT,
 	  .val = CHARGER_INHIBIT_BIT },
+	/*
+	 * Set the enable command only once CHGR_CFG2 has selected software
+	 * control, or a charger its watchdog has disabled stays disabled.
+	 */
+	{ .addr = CHARGING_ENABLE_CMD,
+	  .mask = CHARGING_ENABLE_CMD_BIT,
+	  .val = CHARGING_ENABLE_CMD_BIT },
 	/* STAT pin software override, match downstream. Parallel charging? */
 	{ .addr = STAT_CFG,
 	  .mask = STAT_SW_OVERRIDE_CFG_BIT,
-- 
2.53.0



