Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064972;
	b=Q/+8/78ucy9kEVx8kz5cYoWrWoS+nCG/DILr5txAX6wTglzALv2eyGitXkQ0MVOohdgQ
	 glsKGTkZrgOpXwZZKBdU18Zd+rxl3fH7FoTQzn/PNZ0DNub0DEhWnPBlewq2HXaiEHJZw
	 yusvqh74l3yhWdSm8DrzpvwXCuqdUH6GB8jdRplqDOyAj9cYt3LSgKQeZ8ZGLFnKnFygP
	 XkPJZxBG2ja3w/tJJPkiVFqVrFT7qYaKC/rwxg9+1p24PsxXiO692+5LT86snK9NBIevr
	 lizsusuSlS7zUMPKYJqhX4vRtGYeASo0rrs2doWbXPVo7xgGOfxbC+r9URbC4icBTIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FGxj7Ad9quHFEy/ZvktPodwDEJL4LCjh8YqX4qpolb0=;
	b=mnkI8HeBevRK0xE5UX4nywnHaJzmBjPP09nR8quGfx560HS2suYllFCa0fo9cflwe4en
	 w7KUPVQ5HuqRXUby9UmC+nHV0R0KGnSus8tUL44FFaPq7M2JLseqfePu43P1lwQ08+ILX
	 VHWrFtsnCrb5e4k4J7JCcX0aqX7vx/minmF7mT/N0xW3ytmRNx9VQc6XhdijZc7Ncag1r
	 n72qXsrteGpdmBk+y5HfihhAgxgnNWqrdYn2j4qaqIzOR60I44OyNrRzTk7iHtIF5DG2v
	 cLuV4930rQ8v1iLvKi6C/ScauZvih06yZiD22wYpxHlVikmHjIXwaAPZhGwxjwE8eUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NGtbUnLA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40956606A334;
	Sat,  7 Nov 2026 15:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NGtbUnLA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11161F0089F;
	Sat,  7 Nov 2026 15:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064972;
	bh=FGxj7Ad9quHFEy/ZvktPodwDEJL4LCjh8YqX4qpolb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NGtbUnLANHav9nKMhSzuWiZDUr02FJ8pWn6Bb6eUyaT5ZJk36NjtDhodMIccmnSs/
	 OGvlaBMRsITa2qiBjgNmlB1kJu00K2C7HXZtIaz0ij9yAuknKGyp5Zxza3mV9Rrd9F
	 DNeq/PzOGl6V35wWNTjuWwZ5fERV9cszVTnMZQrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabricio Akio <fabricioakio@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0852/1257] power: supply: qcom_smbx: set the charge enable after software control
Date: Sat,  7 Nov 2026 08:52:28 -0500
Message-ID: <20261107135002.860013005@linuxfoundation.org>
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
index f5557b8cc92ae..8c6b7c46b85f0 100644
--- a/drivers/power/supply/qcom_smbx.c
+++ b/drivers/power/supply/qcom_smbx.c
@@ -819,11 +819,7 @@ static const struct smb_init_register smb_init_seq[] = {
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
@@ -844,6 +840,13 @@ static const struct smb_init_register smb_init_seq[] = {
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



