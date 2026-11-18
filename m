Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036070;
	b=d8cvFXaMA48MTfhLdZypU1pAb4rEWt9TzDIddAx4fzwaRYuOEiqiQlS/wrQB9bYqQDKq
	 tepkhsSLeooEOO2U3fz0SZFj5bgQd+RF+cHLVtllIMN3ZCiB6vZjoLSG6Bf7GdcNw7xEb
	 OVwcn4rfV6FdFKN+JPHutVAALLqO63F711uf+RTK0VsmbmhQwByCd9vNKIq1k5vIIfYag
	 4PL6DwbnFrfQvT2+VckTfXmeVZcheiMEeMql2y5egBkFyKrBpH/wgUKXAZAVWzparwot4
	 eU4wjhhKEBUdTPCF8Mq6cciFSRRseYZDbv2MNWKK6jos3R+0KQsme3pJ08kP7gw515Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GrhJSppgeaxCnb426lcuG7/00kgK00AzlTte8RTYa0g=;
	b=vZ/y9SAAukRvRCv/eREsm5p00Gz6shVSZG2u4s3HCjcTjXpcapcA1SY2XmrqkpM7126F
	 9cpi/PBSPVD0NfZF2LwNbVvh1IzbUIqV9jitstYeREU0QETq3tr7zQU4g6sqtlybMJCPD
	 bNW7PolaXrNdvDjav8UWHuX5sYrYJkHQMDUBTaAwfZ0MnITlQ3sH1stl2TME1ufHi/kfx
	 8SAwqGb5Wry02EmmfmkoRWyM35o0EH7l1jHq2PNr+CCnQ/xmlyJCG+AFoyt0TpMCfQuEI
	 vjxelrjUBvEbCA6W3D0eBz46RQKd8lopctwKc5owrA96UIpa5+a87NY8eK/p80Y5Rag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0MDyu1Pj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC5C606A325;
	Wed, 18 Nov 2026 21:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0MDyu1Pj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948921F000C4;
	Wed, 18 Nov 2026 21:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036070;
	bh=GrhJSppgeaxCnb426lcuG7/00kgK00AzlTte8RTYa0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0MDyu1PjS9fq1hRTe4Nh7Arzy4XieQEO1QzPEPv6LQLxnqG0dZtQe8EMOGNYQ8uq7
	 wgxXAUIKaK16NdH/GHsICZx80WTIRKjU5sOUnm4rEmUbwZItipI9TeNoNdD5vP2Y8u
	 PDj05dzcCdaFxKcJX1fVE+HeEKYx3phe4VVVV4m8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0875/3318] ata: ahci_st: Assert the power down reset in the probe() error path
Date: Wed, 18 Nov 2026 15:24:57 +0100
Message-ID: <20261118150345.557265151@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 39775429c8c0c..e08d5dffd67ce 100644
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
@@ -160,18 +169,23 @@ static int st_ahci_probe(struct platform_device *pdev)
 
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
@@ -179,20 +193,15 @@ static int st_ahci_suspend(struct device *dev)
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



