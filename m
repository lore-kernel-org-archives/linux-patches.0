Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591546;
	b=VTRZW6+HlObAEyGhATVrsXTNumz2bXUOAtYaEG+3BzG6EGvd5buBNyD0VYAAfj9v7nz9
	 Q2KZ930gk+wiX9D9UNyxjaUxBi9CP/Vw2fl6/mzU19vjeGPvscP2Mxu1yoBpmTRr2szSM
	 FYClAAYGBB0thNRq0S49FrtC5+GOdj9oZXXBMwC55EDgopCEA+g2V0DesLkrgIRU8/hY7
	 UYMn4RmPRgX3xVyalDuBLq0n0woOK/Me3BXiFSnLSF2NrtQPExpC1rLLF3iC4FVFOahqV
	 FbGtc3l5EGWOjXdl3UWMDKaXxDG5dg8zlaDit6t3pMwmDKS6XCXXpRQq+xbPAjIy01Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HpCTUGaw+GUnuhfFFxkzekzvs+yCTlZ1KcgbG0B0ckI=;
	b=H9UyffprXtJTYfI1PtvTTmRgSjL5dg0m1BE873JNnr884eVM3WIH/Rko+MY2UWc2uYB5
	 nfoTctitYeg04L9Tpt3Rws68mvV2w66HjBycjZ/h6E7D0Tu61Nt9yxyHxSSM0tkUV7u8B
	 bVcfBn/Um7PafxDp+qrv+pqdq90wGg+T/DHu4Qi83801djt9gVBBdftl15oUtbwxPurtS
	 uI0rVWI9T5PZyW9E2jLyyGMCw+U6tEoacv4GENbJL3pyFy0Isziq38wnWY7ikfdIlg+hQ
	 iIHZZ5hxSWWu8031QNaEo25gUTh7l4w7Jnt2H2lgpJApN9krmaIEFuJrw3+1jmMLfhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sdao9OBC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8530606D4BF;
	Fri, 13 Nov 2026 17:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sdao9OBC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B061F000C4;
	Fri, 13 Nov 2026 17:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591546;
	bh=HpCTUGaw+GUnuhfFFxkzekzvs+yCTlZ1KcgbG0B0ckI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sdao9OBCxR0Z7ehvrjiFXz5ZBPciQc034XV/H6fWPI0jxbyHgU1CrKot2UTfnGVr8
	 OoYKoIAN8AWxmyuumEC6qJKbe7q1hBVmt4gBCYP0JoSlCFLJm/RHNTVfa3JBid3WZ8
	 XpjtFw0unmCMErisTadvIML2Xbeoj9r9wpq0R/v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 599/670] power: supply: bq27xxx_battery: register power supply with power_supply_register()
Date: Fri, 13 Nov 2026 10:52:43 -0500
Message-ID: <20261113153832.118232182@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 1011646d4bd6c2eedb68d131ba7ddaf9ecd2aa9e ]

devm_power_supply_register_no_ws() is going to be removed.
Switch to the general registration API.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://lore.kernel.org/r/20241005-power-supply-no-wakeup-source-v1-4-1d62bf9bcb1d@weissschuh.net
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: db560f4b1c52 ("power: supply: bq27xxx: Ensure poll work is cancelled on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index 19c73aad769a5..fc76fd9e2b96f 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -2163,6 +2163,7 @@ int bq27xxx_battery_setup(struct bq27xxx_device_info *di)
 	struct power_supply_config psy_cfg = {
 		.of_node = di->dev->of_node,
 		.drv_data = di,
+		.no_wakeup_source = true,
 	};
 	int ret;
 
@@ -2189,7 +2190,7 @@ int bq27xxx_battery_setup(struct bq27xxx_device_info *di)
 	psy_desc->get_property = bq27xxx_battery_get_property;
 	psy_desc->external_power_changed = bq27xxx_external_power_changed;
 
-	di->bat = devm_power_supply_register_no_ws(di->dev, psy_desc, &psy_cfg);
+	di->bat = devm_power_supply_register(di->dev, psy_desc, &psy_cfg);
 	if (IS_ERR(di->bat))
 		return dev_err_probe(di->dev, PTR_ERR(di->bat),
 				     "failed to register battery\n");
-- 
2.53.0



