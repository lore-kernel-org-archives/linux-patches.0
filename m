Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045013;
	b=eBLonyTsLh17aaSUdBUd0WQRjTN41yyrOKLnPRdfwhG4yw8HuOCnRmXTxoARQU2CySuY
	 3TfOPCiVjYPkJablswrhEsJcIo/rR4ztr6037uVoWrdF5e2wv0F/o4UGn4I8EW7ib+l6A
	 yH0SNjK9GcY07gFfxg1Y7uHWWYJ+1JE5BKKvSo5zwaBY/siYUlgwKAGkjRXUOqIXEF5Tj
	 8UANm3sbEoAsTvT7toDWeG0F9L2sI+VzSsBQLpzsGu2C6xbZRBn9kLniv0RRAUqNkDJpf
	 BoDCUQ9qzFr92kmTBJn3dp0/ewsc/iRKdhe7IrCqnpJTfa/tXOELpBxwxI5nnbpPF9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y6SgZtvGStUu6uMbWrq90wr901zNk4xnRrwQMmyYf6g=;
	b=rZ4E5Iw1b0123tMyn1QomhpfP0scDRonteGjQXBThk421BAKP0TSVkQLTClhD9gXrw79
	 5/L3JCetcZflk8t4nXMnoTd26DljijQNMzUjwjv+lc87h/dcz8UsHkoURbO3g3m9NYIBl
	 sOmhUAK8XiChUXzhyCV/S6AwwlkNahFDbyVdJYMMxrdegKfaCL21lSD7ZSE2hzUlOFRbn
	 kDTLMeXilBpldfVj/cl+MTCiAG2w+3p84sDadPKWMAa90U8SA/7Bftil+EZ/I7w+iwCmE
	 dImyvu1UIQV3RF62ee+IrIsV/cyRxAf1hb0AzTjrkVJQhXSg5gsapIsz17RFrRmiqVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YNPEcL5r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6C8606A320;
	Wed, 18 Nov 2026 23:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YNPEcL5r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CE21F000C4;
	Wed, 18 Nov 2026 23:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045013;
	bh=y6SgZtvGStUu6uMbWrq90wr901zNk4xnRrwQMmyYf6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YNPEcL5rzHaZJMIt4VTnr34hSugJgUAmhriNBpc+kYKvh0guku8PnvXFPRiE5liYg
	 d6nnvwBS9G13jw3GAadUGSx6CvfWpDOjxL/ThCG9jxDKFl7PuYcojK6ofsXS7RmECP
	 ah8INaFEIbtuuTf0IY3ZiO6S46p48+TQsmhWFKcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0770/2857] ata: ahci_st: Assert the power down reset in the probe() error path
Date: Wed, 18 Nov 2026 15:30:04 +0100
Message-ID: <20261118150229.291281220@linuxfoundation.org>
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
index 8da0b769fc0d3..96a92db2b83fc 100644
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



