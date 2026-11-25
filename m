Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620640;
	b=uEf9nLqJ5J0XYl2YwcZQmy17vfUbyyMqZk7tGjIR4z18ty3e+YRS48TvB9KV4JiNiA4A
	 ajm0B+39pwr/82O1kl9b2V/hWHIfFeNCixsuDOQXPnKCcRdvr8Vnqa8GCOvmJmfbT5TzG
	 1m+DmAMxPDJUHKujXrwOkx8C+j92ZCkb1EqVpEgiDnHcAOK4TvnZ42WmodBCuxQWtpKnm
	 ocsQLFxkVy1QoKUEqr8DmtUskDPFFFvXRMd4sneBK9/FweWoKyDciMecuTE4bh46yVFw6
	 ThjocsRNKtT7AcSFrredmK5f3bkEkntMxm7yJdXdl55GNgd57ASR7Cl9oW/LBCHJdRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9ql1fgHR8PdxWjmJ7gjKhwpSuX14RxQ1bn/e4Or/RPI=;
	b=Ea8O1sILBXmJ8u8jIwcYjY1urw9E0Fo/wYsggZctfyup9AjKWO/KF+VAu358nvZ4lbqo
	 6KYUWHdFDWRiXlI8QretEJ/T+hsDGWfgLywioKJXba0xiCM/6lrexCX1S/k+Aizn5YCf5
	 olmT9sBcNNV+jFP5Mtax/ZpAv9Sdhraxi/KlES3Yn+Yjh88+R8gFZ5kq3ZRXqhlCdzyQ3
	 /AK1GQzbfCvaDaJK4Q+phnEEJ8vY1vasBsbaVdI3X0+Zu25z92E92Y0sWgNvCC0Pe9u+S
	 aYsFyK8Sd+qdEa6AEXFSjsyIn3EjdKWpzo6F9vl3Jjq+sqiGV1fuzoRwsEUDrJSYUgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xb2dgrJ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9CA606A31E;
	Wed, 25 Nov 2026 15:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xb2dgrJ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0741F000C0;
	Wed, 25 Nov 2026 15:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620639;
	bh=9ql1fgHR8PdxWjmJ7gjKhwpSuX14RxQ1bn/e4Or/RPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xb2dgrJ2b3VWviv/KfwX0+MhxavxxGds1Wfw/9ZjZ0GlN/519mvvCAI4jbI3Ai0Ms
	 88YArcA88VSCU0wuNPiG/rAhg63Yst7SjFWN6RtkuKOGUsx5iczL30jls0yeec3rmW
	 L1sT/6eQKGPbnCXgagdEO4JuOqxCqp5cF4LUB2NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 7.3 0940/1005] usb: dwc3: xilinx: fix system suspend and resume PHY handling
Date: Wed, 25 Nov 2026 15:37:58 +0100
Message-ID: <20261125143843.700385074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

commit 2fad8d241a6833d0c7aeafa0ab596e83c7b4ec9c upstream.

System suspend and resume error paths do not handle PHY and clock
resources correctly. Suspend calls phy_exit() without first powering
off the PHY and ignores failures, while resume can leave clocks
enabled if PHY reinitialization fails.

Propagate errors to the PM core and unwind resources to ensure a
consistent state on suspend and resume failures.

Fixes: d6edcdc1ef06 ("usb: dwc3: xilinx: fix usb3 non-wakeup source resume failure")
Cc: stable <stable@kernel.org>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/20260928120015.3152461-2-radhey.shyam.pandey@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-xilinx.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/usb/dwc3/dwc3-xilinx.c
+++ b/drivers/usb/dwc3/dwc3-xilinx.c
@@ -383,13 +383,26 @@ static int __maybe_unused dwc3_xlnx_runt
 static int __maybe_unused dwc3_xlnx_suspend(struct device *dev)
 {
 	struct dwc3_xlnx *priv_data = dev_get_drvdata(dev);
+	int ret;
+
+	ret = phy_power_off(priv_data->usb3_phy);
+	if (ret < 0)
+		return ret;
 
-	phy_exit(priv_data->usb3_phy);
+	ret = phy_exit(priv_data->usb3_phy);
+	if (ret < 0)
+		goto err_phy_power_on;
 
 	/* Disable the clocks */
 	clk_bulk_disable(priv_data->num_clocks, priv_data->clks);
 
 	return 0;
+
+err_phy_power_on:
+	if (phy_power_on(priv_data->usb3_phy))
+		dev_err(dev, "failed to restore PHY power after suspend error\n");
+
+	return ret;
 }
 
 static int __maybe_unused dwc3_xlnx_resume(struct device *dev)
@@ -403,15 +416,20 @@ static int __maybe_unused dwc3_xlnx_resu
 
 	ret = phy_init(priv_data->usb3_phy);
 	if (ret < 0)
-		return ret;
+		goto err_clk_disable;
 
 	ret = phy_power_on(priv_data->usb3_phy);
 	if (ret < 0) {
 		phy_exit(priv_data->usb3_phy);
-		return ret;
+		goto err_clk_disable;
 	}
 
 	return 0;
+
+err_clk_disable:
+	clk_bulk_disable(priv_data->num_clocks, priv_data->clks);
+
+	return ret;
 }
 
 static const struct dev_pm_ops dwc3_xlnx_dev_pm_ops = {


