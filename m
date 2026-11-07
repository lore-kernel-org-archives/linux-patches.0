Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063467;
	b=hkRr5WwTUTYEOaABtlSMg2Q86Bj8ZB5jGFbUEje1KLFJHDs3T85/zxTj6hD0iCXsacD+
	 l5RbvBfcTnoGST5zwfLJJ2v/2aFBfocMP/caq9MgalojfutlbCE1nDGE/DLej5qU+r3Ij
	 jmo55ONxbHy+lbL4iYzLSdeZDlizTuXid9uaic7nKScje0+Obte08eNdoKYEWwHnwphP0
	 sI5cAoZ2oj7ns29e5gqtQ+8r+Jo/qc2BGpNeAlOXXBAR89hGlja02wVFXArwR3JCFJLK4
	 bkuLLZEM+Asu+hXPxUigzzTcKAbC0d49PL20WBF6gg+9unk0EAlpPqV6qUeaZh5oIqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=WRRQZfjYMzAWBpch66R6WRouWDkETciUP0myOD8oPgo=;
	b=ud7VNjiQMM0zbWckyGWH9UBMoP9lvqTfF1oqYg3ELmrhq+VUwm3ReGYa3dWv5/e2RPV+
	 POjWH3u+EfouzNFy2Jxe07NkdCOwy0F6MHIYmNpYmPE0raGUeCRqH8ELWKlq8wUAm6pW0
	 LMZcFI6M1Iex9QutI0cupK8s/2Gw5k6fq8GsKd37zSkBNIUizp+0BaaebDUbEQh7P7dpD
	 Nf7kfpma0WsFAnWl+RuhUkg6DZC6dhg1czFbG7cIgVw3K/MDih3QTMcLAJIJlQiiJHY0F
	 2RnQm+JESFw2Cp8iCObxyYpG2llqxp4j7kzsz3/kwKQRcZhDhaFqNThTqlivXX4NWaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rldKPd/R";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D04A6082BEE;
	Sat,  7 Nov 2026 14:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rldKPd/R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403DE1F008A3;
	Sat,  7 Nov 2026 14:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063467;
	bh=WRRQZfjYMzAWBpch66R6WRouWDkETciUP0myOD8oPgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rldKPd/Rw3kR7DEa9ZLw3pfGY7h8LpJd9JEE5AyZV1ZqrQQKvO+hVml87vf93VUih
	 xIN9GKdFXGsdPuK65l9XSS1dnj8LCme51cgm/knQ/WrSWVSh6qspHM/ZlpInmNWYK9
	 KLM9e0fpzD/n0BGrmyY4Lni5me0rWHVOfpWKnhkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Pam <andrew@fastmailteam.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 621/869] power: supply: cros_charge-control: restore EC state on resume
Date: Sat,  7 Nov 2026 08:55:03 -0500
Message-ID: <20261107134914.080317738@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Pam <andrew@fastmailteam.com>

[ Upstream commit 1f2a40f954c848dff9d8bb6d81e404f9e47f0e81 ]

The EC resets its charge control configuration when the AP powers off,
so configured sustainer thresholds and charge behaviour are lost across
hibernation.

Nothing notices the reset. Commit 4fc88ba435da ("power: supply:
cros_charge-control: adopt EC charge state on probe"), in the
power-supply tree, made the driver adopt the EC's charge state, but only
at probe, and a resume is not a probe. Sysfs therefore keeps reporting
the configured values while the EC charges the battery to full. On a
Framework Laptop 16 (Ryzen AI 300, charge control command version 3)
with charge_control_end_threshold set to 80, a hibernate and resume
cycle leaves the attribute still reading 80 while the battery charges
past it to 100%.

Add a system sleep resume hook that reprograms the EC from the cached
state. The same EC behaviour and the same fix already exist for another
driver, see commit 2643187ccb86 ("platform/x86: ayaneo-ec: Add suspend
hook").

Reprogramming the EC is only strictly required after hibernation, but it
is cheap and idempotent, so hook every resume path rather than rely on
the EC preserving its state across each kind of sleep transition.

Note that re-reading the state from the EC on resume, by reusing
cros_chctl_init_state() or otherwise, would be wrong even on the command
versions that support GET: the EC has been reset to its defaults by the
time the hook runs, so adopting that state would silently discard the
configuration the user asked for. The driver's cached state is the only
remaining record of it, which is why it is pushed to the EC rather than
refreshed from it.

Fixes: c6ed48ef5259 ("power: supply: add ChromeOS EC based charge control driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Andrew Pam <andrew@fastmailteam.com>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Acked-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://patch.msgid.link/20261005043418.243937-1-andrew@fastmailteam.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cros_charge-control.c | 29 +++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/cros_charge-control.c b/drivers/power/supply/cros_charge-control.c
index 53e6a77e03fcf..6a6022f377b7a 100644
--- a/drivers/power/supply/cros_charge-control.c
+++ b/drivers/power/supply/cros_charge-control.c
@@ -14,6 +14,7 @@
 #include <linux/platform_data/cros_ec_commands.h>
 #include <linux/platform_data/cros_ec_proto.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
 #include <linux/types.h>
 
 #define EC_CHARGE_CONTROL_BEHAVIOURS	(BIT(POWER_SUPPLY_CHARGE_BEHAVIOUR_AUTO)             | \
@@ -294,6 +295,7 @@ static int cros_chctl_probe(struct platform_device *pdev)
 
 	priv->dev = dev;
 	priv->cros_ec = cros_ec;
+	dev_set_drvdata(dev, priv);
 
 	if (priv->cmd_version == 1)
 		priv->psy_ext = &cros_chctl_psy_ext_v1;
@@ -319,13 +321,38 @@ static int cros_chctl_probe(struct platform_device *pdev)
 	return devm_battery_hook_register(dev, &priv->battery_hook);
 }
 
+static int cros_chctl_resume(struct device *dev)
+{
+	struct cros_chctl_priv *priv = dev_get_drvdata(dev);
+	int ret;
+
+	/*
+	 * The EC resets its charge control state when the AP powers off, so the
+	 * configuration is lost across hibernation, while the values exposed to
+	 * userspace still describe it. The cached state is the only remaining
+	 * record of that configuration: reprogram the EC from it rather than
+	 * re-reading the EC, which would adopt the reset defaults instead.
+	 */
+	guard(mutex)(&priv->lock);
+	ret = cros_chctl_configure_ec(priv);
+	if (ret)
+		dev_err(dev, "failed to restore charge control state: %d\n", ret);
+
+	return ret;
+}
+
+static DEFINE_SIMPLE_DEV_PM_OPS(cros_chctl_pm_ops, NULL, cros_chctl_resume);
+
 static const struct platform_device_id cros_chctl_id[] = {
 	{ "cros-charge-control", 0 },
 	{}
 };
 
 static struct platform_driver cros_chctl_driver = {
-	.driver.name	= "cros-charge-control",
+	.driver = {
+		.name	= "cros-charge-control",
+		.pm	= pm_sleep_ptr(&cros_chctl_pm_ops),
+	},
 	.probe		= cros_chctl_probe,
 	.id_table	= cros_chctl_id,
 };
-- 
2.53.0



