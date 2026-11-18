Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047104;
	b=DkkBD+yn9baogEFnAqYuyySlXdaZe1HFrjTLCyufGvpH+u14qJCv43zubTuW8rOiDWgK
	 CtEEGhQG3lM/0/xk2mDrdwiYwWWjAhprXAPnRIYuWDVnVfwV/Hbp9afYAGt3wNH/y3b3B
	 K3k2LgKhewFpL1223EEpdacwsUHEH91HrimOygEfjG+j5sc0g94GGf1ysRJ3V/p/4dQIX
	 YrT/R3r4zPIGe+2jYJhFFq4rtv0cEsWPoGmUUyIuR4WtggLPS8e5KVfgDNUVt5xGqHFaV
	 lKgPGB2u40/wspXqaOkAYI++Y7ek81Yu5xhyP+jUSXhYi39r7TpyHK9hKpxL0v3iltg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=84pGhA0An8xzwhuuZAi34Wsh04CwQQ0SaLhfWHdJiRY=;
	b=sdXwQSUWsQCsA4xmX5xOlTLeeCMVf2AAKOXIGpMwoGwfQKAFP3aUbLywI7IV+Ra5bkyI
	 CHD/j2GE2HUYZoAMicjY75tX8fa3v0Zri3aFpoejHSV5rqY9cStExvya8OTnyt7DtCrF4
	 YQMuzKa3rkakKCdVaY5dHI5nQ/9spJLDg9blayisP1lh2X/DW1LloR9eyl9Un7OTGb/SQ
	 c7yLeefuqwZB7gr67mHrPDewgqtKi44Q0/Hu5kEaui1yFhfKQPVNOzTMY8geHvDW70EVW
	 5WXRNszq6gRe26njNgA3NCA3iU7Ntt1EahV0Sj2rtIHOJckXPBjFt0OmxnYJuML+hqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kj6f1qVf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C144606A320;
	Thu, 19 Nov 2026 00:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kj6f1qVf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B33C1F000C4;
	Thu, 19 Nov 2026 00:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047103;
	bh=84pGhA0An8xzwhuuZAi34Wsh04CwQQ0SaLhfWHdJiRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kj6f1qVfZhnYjp3j1neDQh4xMrHVBra/4T63pQ9dX7KOVmahHctNVpBLoE+U9qiS1
	 LZdL9V1CCj7v87aYjhf2sd1sHTHjiUzn79tdgN17rBKJ9Dfrhkc/4Bq5N2OAgcyTc9
	 +ZpoFkWQVfAHHKPj4Jo5xG0YX9K8NGrBeh5jgtr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1520/2857] power: supply: bq27xxx: Ensure poll work is cancelled on remove
Date: Wed, 18 Nov 2026 15:42:34 +0100
Message-ID: <20261118150256.058112321@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit db560f4b1c5253853f978385db066220e0c218dc ]

The di->work poll work is queued from the poll callback itself and from
bq27xxx_external_power_changed(). The cancel_delayed_work_sync() in
bq27xxx_battery_teardown() runs while the power_supply is still
registered, so external_power_changed() can re-arm the work after the
cancel, and it runs after the driver data has been freed.

Register a devm_delayed_work_autocancel() before
devm_power_supply_register(), so on unwind the power_supply is
unregistered first, after which no new external_power_changed()
callback can be dispatched, and the poll work is cancelled only then.
Drop the now-redundant cancel from bq27xxx_battery_teardown().

This issue was found by an in-house static analysis tool.

Fixes: 740b755a3b34 ("bq27x00: Poll battery state")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260903081312.225535-1-fanwu01@zju.edu.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
[ sashal: replaced manual mutex initialization and destruction with devm_mutex_init() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index a818b002af21d..57b3de34c0242 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -43,6 +43,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/devm-helpers.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/param.h>
@@ -2141,9 +2142,11 @@ int bq27xxx_battery_setup(struct bq27xxx_device_info *di)
 		.of_node = di->dev->of_node,
 		.drv_data = di,
 	};
+	int ret;
 
-	INIT_DELAYED_WORK(&di->work, bq27xxx_battery_poll);
-	mutex_init(&di->lock);
+	ret = devm_mutex_init(di->dev, &di->lock);
+	if (ret)
+		return ret;
 
 	di->regs       = bq27xxx_chip_data[di->chip].regs;
 	di->unseal_key = bq27xxx_chip_data[di->chip].unseal_key;
@@ -2161,6 +2164,12 @@ int bq27xxx_battery_setup(struct bq27xxx_device_info *di)
 	psy_desc->get_property = bq27xxx_battery_get_property;
 	psy_desc->external_power_changed = bq27xxx_external_power_changed;
 
+	/* Cancel the poll work after the power_supply is unregistered. */
+	ret = devm_delayed_work_autocancel(di->dev, &di->work,
+					   bq27xxx_battery_poll);
+	if (ret)
+		return ret;
+
 	di->bat = power_supply_register_no_ws(di->dev, psy_desc, &psy_cfg);
 	if (IS_ERR(di->bat))
 		return dev_err_probe(di->dev, PTR_ERR(di->bat),
@@ -2188,10 +2197,7 @@ void bq27xxx_battery_teardown(struct bq27xxx_device_info *di)
 	di->removed = true;
 	mutex_unlock(&di->lock);
 
-	cancel_delayed_work_sync(&di->work);
-
 	power_supply_unregister(di->bat);
-	mutex_destroy(&di->lock);
 }
 EXPORT_SYMBOL_GPL(bq27xxx_battery_teardown);
 
-- 
2.53.0



