Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625144;
	b=qM9baHPcjwEjwDLZ5bmY3emzsaBmfumkB5XzXg/d4bb+z2CUqV6agOr5ojpiNx91mILz
	 ehTFTAODJLThTlJiqwPKulJWQEpjuoZoVWciMnlT4Fea9U4b8uq+hnZywYG82y4DIIgtd
	 cdIszwC4U4z7+SjcEDky1ldgQ8RWUPh86vhGi/wIYgLcbA85vxzx4u4tHp1cpBctfA51/
	 ZusHXIRabYARB8WcoWHgpkL5tZ8DzTjJB3HWUOUS8R4/JLqad5GsYF3ntz8T076a43+cX
	 uozC/oSdY9aBpNjRTztUecRiEnHfcrL2IP7tyx1PnFVXcGLPRIGjkHpj52BnPV17BGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jHI85wXVezRIVUFCfK8GmVfk99/lzL/qG0kfaaZ9oqY=;
	b=esciAjpqVuFMRqZ6sV3g8ppPs6ws3QHCGd37d8E3ls2GVXfyq8YLp/hQivkzJzWoIoVx
	 SlqT3qnBhBr2fnUHiojhvdLtB1FZH1OOXxC3eS38yUP3YPq50ZLh48DfFcKoLwLZtFW1N
	 /SCRUTBb1R5N9MRSMXcR8pYA0/PLtDyYwj73JPuIgetWQWOmJSbnOQCX9llztjYHU7+sp
	 iNMDJDzjmcnur/hvYSdW7FyQgYlJKUiUVlC3lLDwdhTuQFXe1WerxXla38ThQytw+gmun
	 d1vGpr/G3Hbg6ZF8B3giF1Aa1URcI9FKqSq1wXcgQvxG3P0LmGeV67r0+gfieHNWuGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OMZ23KdS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A3A606A6A3;
	Wed, 25 Nov 2026 16:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OMZ23KdS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8251F00ACF;
	Wed, 25 Nov 2026 16:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625143;
	bh=jHI85wXVezRIVUFCfK8GmVfk99/lzL/qG0kfaaZ9oqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMZ23KdSiEJw3+gYtYWsKgS6fVb6ktN77+U4qzSBZn7kWZ4eg2yXwx4vfpxIszdOz
	 0bx1TuNOACQp5R7oHILvyeDfOCUfu6qMI04brhfSH7dvXAUiD2I4OjQGDfaKsPmWPa
	 K3J0BJxPWFdqhNDHlI1Ge0fYESdyj7HfsCeyfmcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabricio Akio <fabricioakio@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 376/816] power: supply: qcom_smbx: set the charge enable after software control
Date: Wed, 25 Nov 2026 15:32:04 +0100
Message-ID: <20261125143857.907545402@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1f35416b0d939..772198e792dc4 100644
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



