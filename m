Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061995;
	b=wIY9IOc+WvTypbu8OtpRlA4m4xIkpRF4Wt8o4CHxF92YmsN/7qhyFN4/aeFe7fmud0hG
	 OVMuFFXG2+34girtXVDSH8/0BSCDki5TpgvKPQyAfVkE1G6weAuJXUdhvYicyDrWLEsjp
	 et/sxYw7TH6QpRSN8l+XOe8ERaVGUOCAd/T5UZNTdconMsBeXTewrx3vAA/cbcyZMFDt7
	 HGOAA9vBQ99vafCVop1yT1zZ3SoWb7vyrR8m6W1MeAU6hKzriq5GoBhWQj45rWniHfALl
	 7fzjyiiDMwnTxDskgD4FAMs3iqV/MiCrv1enLYib6cI8FUyL9sm9QObsHvjugkCM/ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B10Q5y3xUbZeKxb4AeQ3/yCN+iSDJcys0ZpOTIRDwE8=;
	b=mpyzHCuGzOOi8YT58uGqq1CvSaM7nExN7FCcHR853Q8R287/0gNCVMEfd2WdSXQDP7wV
	 lD1HgRH6CfR+TRnf5K0NeJIAd5PoRlUOylsNCACIb5eYFmCLhuuGUS2WoTotc4qnpv7iv
	 0pW+LYn/Emw15h3jpw6f4PGx7xIqmxfNx0zmFjHO8VI46dSHENLDnqcJxrvaqHSSSOM3X
	 +XYxvYF1PIJmmXbaypWFRP5InfpDDhDo9QS0gVXbhruKVgZoZ5w3bgisL8mWE5CaFooM9
	 EQEuDNFnMiQ7a3bi5jMgQRFUFvRXDtDO8xZblHPw4q5a9HgiD1mSI28Kv77fcBbeAKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jSf9Tgo5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078A2606A32E;
	Sat,  7 Nov 2026 14:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jSf9Tgo5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EE31F0089F;
	Sat,  7 Nov 2026 14:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061994;
	bh=B10Q5y3xUbZeKxb4AeQ3/yCN+iSDJcys0ZpOTIRDwE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jSf9Tgo5mliJ98j6aHp5u7rmdoJBBS9U+4kKIP2JUdrNt0kjQPf+4v0ZNU9hIRXMY
	 zrcKz4B9yetf76pHRYH0Lk9oAVYYsCv3QJVa2zL/TMgm7wal/cNV7zoGsEY9O5EOmB
	 OD8K9+e6rCaTcN7VGloUScC3UV5ry81vrPWcDmP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0985/1536] ata: ahci_st: Assert the power down reset in the probe() error path
Date: Sat,  7 Nov 2026 08:50:01 -0500
Message-ID: <20261107135025.322306063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 96d285d68def9..165ec8bc700b6 100644
--- a/drivers/ata/ahci_st.c
+++ b/drivers/ata/ahci_st.c
@@ -83,18 +83,27 @@ static int st_ahci_deassert_resets(struct ahci_host_priv *hpriv,
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
@@ -159,18 +168,23 @@ static int st_ahci_probe(struct platform_device *pdev)
 
 	err = ahci_platform_enable_resources(hpriv);
 	if (err)
-		return err;
+		goto assert_pwrdwn;
 
 	st_ahci_configure_oob(hpriv->mmio);
 
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
@@ -178,20 +192,15 @@ static int st_ahci_suspend(struct device *dev)
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



