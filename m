Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030736;
	b=ayLKJb8OXcZ6EX8RgGll69mkmZkYpuVHQYW7KITyAqQvd5f/xQl+GyrkzDYqqBm0m1Vi
	 Cnvnagi3iIrSYT2bRQAAZv57jqipc/iqsxH3J2AHgIQLTTEXVY765Ec5tbFaeDj+shB8g
	 rvrEI++gLqEkEMJi6JD3Ukbgr29CV2b5E/vTqzNeX+5yNuq9G6tkTpI7JUI3t9r3e8Ksh
	 A6x0osVKPwp77ZlMJGFxTtidgLZPNL3ELZ26AUwgxdD1Xr6Q5rRp2NIMGoENMrFuEXxPz
	 AM7OYx5KluQIex8TmJDbohgSSBU0dwPD4NGtGFfHhtviIc4dSSKBIm1XlUVaooHLR9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uyAmPF/6O2J3aBHaHBm04DuB81ULJYcftPyaNxSPhPQ=;
	b=aKCypQ5RMODVTPGtU548ELt9vFRUM4djncNbFIADcYH0IwtRWQFpAcy9+MI1o2uJoXc0
	 vaqVoM70AOVjM23/GYOp3QOEz+BZfP+yF0gGMTkiILLK1ywAwpBSTaqsb99KgtdOXlJzi
	 /cEk/Qy4QBWQUsl1CBScDnxk2fcq4V2NWh2zWnuxcTnwxPpItj3VEE4smdJ2NA+7iDLJD
	 AQEnnYNXWzXG3tZ8DKqWne1ddzh1I/nTyKo6fcdDbgmQLsaJiBiyWv0ACEfe+IRb5wPnn
	 EJekcjdFrCcQLPLw8Bg3ouQyVq6K4qHX4TsczxSY7lYOY+JN0993bcY0NnNkBuY6dLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LFgbF3aa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F31606A333;
	Wed, 18 Nov 2026 19:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LFgbF3aa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0CD1F000C4;
	Wed, 18 Nov 2026 19:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030736;
	bh=uyAmPF/6O2J3aBHaHBm04DuB81ULJYcftPyaNxSPhPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LFgbF3aanjRXTB6Im0ogL/wSmlFzt7sEoJ1RzNS7J0Bf4s8RbfwAiAU6ewoXzOB55
	 BHjCfX9aJLyJX8/Nz3/epQcfQ+iZ0jQoVnEJHTgRd2G0SwjgAWnbP7WsMqlRc6v5et
	 GJ3mybCO2lozbeZnWmZkBEg+R8t3zmu5JAInPpU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0810/1756] power: supply: bq24190: Remove redundant pm_runtime_mark_last_busy() calls
Date: Wed, 18 Nov 2026 15:48:57 +0100
Message-ID: <20261118150041.869799943@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 2453753f395e68af947d9ac6ce37bf0eb40f7123 ]

pm_runtime_put_autosuspend(), pm_runtime_put_sync_autosuspend(),
pm_runtime_autosuspend() and pm_request_autosuspend() now include a call
to pm_runtime_mark_last_busy(). Remove the now-reduntant explicit call to
pm_runtime_mark_last_busy().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://lore.kernel.org/r/20250704075442.3221283-1-sakari.ailus@linux.intel.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: e0844bd22a9f ("power: supply: bq24190_charger: don't reset registers across system suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq24190_charger.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/power/supply/bq24190_charger.c b/drivers/power/supply/bq24190_charger.c
index 35611eca057e1..08ba33a1aae6b 100644
--- a/drivers/power/supply/bq24190_charger.c
+++ b/drivers/power/supply/bq24190_charger.c
@@ -502,7 +502,6 @@ static ssize_t bq24190_sysfs_show(struct device *dev,
 	else
 		count = sysfs_emit(buf, "%hhx\n", v);
 
-	pm_runtime_mark_last_busy(bdi->dev);
 	pm_runtime_put_autosuspend(bdi->dev);
 
 	return count;
@@ -533,7 +532,6 @@ static ssize_t bq24190_sysfs_store(struct device *dev,
 	if (ret)
 		count = ret;
 
-	pm_runtime_mark_last_busy(bdi->dev);
 	pm_runtime_put_autosuspend(bdi->dev);
 
 	return count;
@@ -560,7 +558,6 @@ static int bq24190_set_otg_vbus(struct bq24190_dev_info *bdi, bool enable)
 	else
 		ret = bq24190_charger_set_charge_type(bdi, &val);
 
-	pm_runtime_mark_last_busy(bdi->dev);
 	pm_runtime_put_autosuspend(bdi->dev);
 
 	return ret;
@@ -603,7 +600,6 @@ static int bq24296_set_otg_vbus(struct bq24190_dev_info *bdi, bool enable)
 	}
 
 out:
-	pm_runtime_mark_last_busy(bdi->dev);
 	pm_runtime_put_autosuspend(bdi->dev);
 
 	return ret;
@@ -636,7 +632,6 @@ static int bq24190_vbus_is_enabled(struct regulator_dev *dev)
 				BQ24190_REG_POC_CHG_CONFIG_MASK,
 				BQ24190_REG_POC_CHG_CONFIG_SHIFT, &val);
 
-	pm_runtime_mark_last_busy(bdi->dev);
 	pm_runtime_put_autosuspend(bdi->dev);
 
 	if (ret)
@@ -673,7 +668,6 @@ static int bq24296_vbus_is_enabled(struct regulator_dev *dev)
 				BQ24296_REG_POC_OTG_CONFIG_MASK,
 				BQ24296_REG_POC_OTG_CONFIG_SHIFT, &val);
 
-	pm_runtime_mark_last_busy(bdi->dev);
 	pm_runtime_put_autosuspend(bdi->dev);
 
 	if (ret)
@@ -1373,7 +1367,6 @@ static int bq24190_charger_get_property(struct power_supply *psy,
 		ret = -ENODATA;
 	}
 
-	pm_runtime_mark_last_busy(bdi->dev);
 	pm_runtime_put_autosuspend(bdi->dev);
 
 	return ret;
@@ -1415,7 +1408,6 @@ static int bq24190_charger_set_property(struct power_supply *psy,
 		ret = -EINVAL;
 	}
 
-	pm_runtime_mark_last_busy(bdi->dev);
 	pm_runtime_put_autosuspend(bdi->dev);
 
 	return ret;
@@ -1673,7 +1665,6 @@ static int bq24190_battery_get_property(struct power_supply *psy,
 		ret = -ENODATA;
 	}
 
-	pm_runtime_mark_last_busy(bdi->dev);
 	pm_runtime_put_autosuspend(bdi->dev);
 
 	return ret;
@@ -1704,7 +1695,6 @@ static int bq24190_battery_set_property(struct power_supply *psy,
 		ret = -EINVAL;
 	}
 
-	pm_runtime_mark_last_busy(bdi->dev);
 	pm_runtime_put_autosuspend(bdi->dev);
 
 	return ret;
@@ -1852,7 +1842,6 @@ static irqreturn_t bq24190_irq_handler_thread(int irq, void *data)
 		return IRQ_NONE;
 	}
 	bq24190_check_status(bdi);
-	pm_runtime_mark_last_busy(bdi->dev);
 	pm_runtime_put_autosuspend(bdi->dev);
 	bdi->irq_event = false;
 
@@ -2160,7 +2149,6 @@ static int bq24190_probe(struct i2c_client *client)
 	if (ret < 0)
 		goto out_charger;
 
-	pm_runtime_mark_last_busy(dev);
 	pm_runtime_put_autosuspend(dev);
 
 	return 0;
@@ -2247,7 +2235,6 @@ static __maybe_unused int bq24190_pm_suspend(struct device *dev)
 	bq24190_register_reset(bdi);
 
 	if (error >= 0) {
-		pm_runtime_mark_last_busy(bdi->dev);
 		pm_runtime_put_autosuspend(bdi->dev);
 	}
 
@@ -2272,7 +2259,6 @@ static __maybe_unused int bq24190_pm_resume(struct device *dev)
 	bq24190_read(bdi, BQ24190_REG_SS, &bdi->ss_reg);
 
 	if (error >= 0) {
-		pm_runtime_mark_last_busy(bdi->dev);
 		pm_runtime_put_autosuspend(bdi->dev);
 	}
 
-- 
2.53.0



