Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058205;
	b=ZeflRZpM0Vb1vC8pU8mJe2rcIpI9gnsRT2Vr3f9s386UskzXFW03/tASo4ZVXyUG8/Yp
	 P0GTMMOc9AFm8WIAQpHfJC0vepI4FhvsUX8KHecLWpfzgn5gwZx5ysqr28+STpjyXm9Tg
	 vFlXNF11Xv8EkCKvYaZNEwA7QIGrtOr48O7l3IKSqlwhK82ACleKqVxMCrgmMbPrTCm/y
	 pN52PrqT9o3CnB8JRPo6wLsqd6JKDIohRGDds3QcWuzrxp25XXOJSv1upifFEoPPV+E4V
	 kc9Iq4aEPwWlMqS2tJyxWDN7fvBgAhYlRNZ9NE42/6sJzM7cSizj4ntiXotlKGEbPDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+fp7yOV/V8HzmdGoWDJWmjR5jR3DBxEfcAejJV1TBXk=;
	b=ne10pIVCkKe/KzvDBJlQZNmRK8mSB2Ari8ri4Q3igyUISkghdnxBfqjZX0MYJDQoV6uC
	 geb2AwJOWY7GyoK7te/lFnhrcLzpFCSrVVDb0aZtOCnLC7ceO+9LVykKm/WYE0dyPcd/x
	 ijoM3jyvc3HNdJXfel1tYQbug1OwPGVA7A5dHubLT7l25c+EO2c96csgvqGe53uxKDjQr
	 VO39cboPqz+QFHlTtvFyt09w63P+YVdTb+Hze2z4oa1zp1t0lc3A8hKrO7XhC5gFczYBy
	 D4FcTYJ31hdMQYqLzzpmyj9SYfUKAgMoQRtudxtn+cNi7Z/rl0TRGFO/boGjOBeMWZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n1JBUcYH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D346E606A31C;
	Thu, 19 Nov 2026 03:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n1JBUcYH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301621F000C4;
	Thu, 19 Nov 2026 03:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058205;
	bh=+fp7yOV/V8HzmdGoWDJWmjR5jR3DBxEfcAejJV1TBXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n1JBUcYHLwlFUBG4UtlL/Jp2dxdCzQGGMONOjwpfrtDbc1QzHy5G3fEsIHGnLDh7O
	 HJIG9fUvE3CiGn0swsYwbExRZCpmzPrU5iTn4FP+GeAbaK0l40rWbkd6lzTiCjYDFs
	 hQG9dJS/0Ay8jLWWfXUxeX0sXyoc5PoprnKZv804=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0396/1848] ata: ahci_st: Assert the power down reset in the probe() error path
Date: Wed, 18 Nov 2026 15:40:34 +0100
Message-ID: <20261118145930.383965256@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 91e0a7452d7a81e924a499b23f30f3bf85fddbd2 ]

st_ahci_probe_resets() deasserts the "pwr-dwn" reset, but the probe()
error path of st_ahci_probe() only releases the host resources, so the
SATA IP is left powered up when probe() fails after
st_ahci_probe_resets() has succeeded, e.g. when
ahci_platform_enable_resources() fails.

The reset is asserted by st_ahci_host_stop(), however ->host_stop() is
only called through the ata_host_stop() devres action registered by
ata_host_start(), so it does not cover any failure happening before the
host has been started.

Factor the assert out into st_ahci_assert_pwrdwn() and call it when
either ahci_platform_enable_resources() or ahci_platform_init_host()
fails. The "pwr-dwn" reset control is an exclusive one, so asserting it
once more from st_ahci_host_stop() is harmless.

No functional change intended for ->host_stop() and st_ahci_suspend().

Fixes: 76884cb2f7da ("ahci: st: Add support for ST's SATA IP")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20260915084127.692494-10-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci_st.c | 51 +++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/ata/ahci_st.c b/drivers/ata/ahci_st.c
index 98ec746d4a2ca..e5ee7adba07a2 100644
--- a/drivers/ata/ahci_st.c
+++ b/drivers/ata/ahci_st.c
@@ -84,18 +84,27 @@ static int st_ahci_deassert_resets(struct ahci_host_priv *hpriv,
 	return 0;
 }
 
-static void st_ahci_host_stop(struct ata_host *host)
+static int st_ahci_assert_pwrdwn(struct ahci_host_priv *hpriv,
+				 struct device *dev)
 {
-	struct ahci_host_priv *hpriv = host->private_data;
 	struct st_ahci_drv_data *drv_data = hpriv->plat_data;
-	struct device *dev = host->dev;
 	int err;
 
-	if (drv_data->pwr) {
-		err = reset_control_assert(drv_data->pwr);
-		if (err)
-			dev_err(dev, "unable to pwrdwn\n");
-	}
+	if (!drv_data->pwr)
+		return 0;
+
+	err = reset_control_assert(drv_data->pwr);
+	if (err)
+		dev_err(dev, "unable to pwrdwn\n");
+
+	return err;
+}
+
+static void st_ahci_host_stop(struct ata_host *host)
+{
+	struct ahci_host_priv *hpriv = host->private_data;
+
+	st_ahci_assert_pwrdwn(hpriv, host->dev);
 
 	ahci_platform_disable_resources(hpriv);
 }
@@ -161,7 +170,7 @@ static int st_ahci_probe(struct platform_device *pdev)
 
 	err = ahci_platform_enable_resources(hpriv);
 	if (err)
-		return err;
+		goto assert_pwrdwn;
 
 	st_ahci_configure_oob(hpriv->mmio);
 
@@ -170,12 +179,17 @@ static int st_ahci_probe(struct platform_device *pdev)
 
 	err = ahci_platform_init_host(pdev, hpriv, &st_ahci_port_info,
 				      &ahci_platform_sht);
-	if (err) {
-		ahci_platform_disable_resources(hpriv);
-		return err;
-	}
+	if (err)
+		goto disable_resources;
 
 	return 0;
+
+disable_resources:
+	ahci_platform_disable_resources(hpriv);
+assert_pwrdwn:
+	st_ahci_assert_pwrdwn(hpriv, &pdev->dev);
+
+	return err;
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -183,20 +197,15 @@ static int st_ahci_suspend(struct device *dev)
 {
 	struct ata_host *host = dev_get_drvdata(dev);
 	struct ahci_host_priv *hpriv = host->private_data;
-	struct st_ahci_drv_data *drv_data = hpriv->plat_data;
 	int err;
 
 	err = ahci_platform_suspend_host(dev);
 	if (err)
 		return err;
 
-	if (drv_data->pwr) {
-		err = reset_control_assert(drv_data->pwr);
-		if (err) {
-			dev_err(dev, "unable to pwrdwn");
-			return err;
-		}
-	}
+	err = st_ahci_assert_pwrdwn(hpriv, dev);
+	if (err)
+		return err;
 
 	ahci_platform_disable_resources(hpriv);
 
-- 
2.53.0



