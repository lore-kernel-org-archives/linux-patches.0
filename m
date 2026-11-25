Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626321;
	b=dzVFuQBatg0sjNj+hTn+CaODarXtuEMqQZLO5RAmfYXeppY7rh31nvN5o/H9jcgOKjAU
	 M1CQIqQcGnGQDSpU5Kck6sfGHtdXhKYGwIPV4Ns49pWTnO+Mv/moWYOMyWV3EghXkhuuL
	 WTIqd8eZKe+63qAa42hKryTtOBRnC3mfbR4gthTDhock2056MilNCT2JqWoLGf6RN85lb
	 iCNumY5hhG79zQQYKz40lQQ8MzG6frjsUTaC6YNjKl9LyretXwO5A6Ifm5EY1Zt2TasTA
	 OtJJfmscMS7n6zqDRhyjt1DWZ4Tzde2PmuWlCf8Zzh+t7Itvpl9Xs9mv+c0EdfHnqEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626321;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QYwZ6Da6tEtKEnJbbIPlDKoQy8OmPwBdjWPkbW2jcic=;
	b=25hkLcaOVIS0be7exDMyDOqRZfwtRfc/tpODUtf2jcB9KFgtk1KqsFsWp0dCi8FU42zB
	 LJP+EyflfPI6GaGGquqnN1UH0yLncMmF9wh4F616JJtXYt3vIO1Iui/pSAXJfTaF9La7B
	 PnN46Zeuy4+vyWobShw6O+4l/tc7TeRmGaEWUlOHg8a44cdppQ49Ox9Ak4FdC3EIOhzNJ
	 scm61elY0s2NnKDfoi/159NDur6CTRdWP8CUrqSulUMy+EzfpX+tmuSZTuJ5HcgG0RYfa
	 lm4oDdqUXiCBo4muIrLEdDENfkrBEgosLALsTNWfUIPQkxSBRwclMDr2qYXYV6Z8HAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PpSpwQ2W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873E6606A31E;
	Wed, 25 Nov 2026 17:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PpSpwQ2W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC131F000D0;
	Wed, 25 Nov 2026 17:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626320;
	bh=QYwZ6Da6tEtKEnJbbIPlDKoQy8OmPwBdjWPkbW2jcic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PpSpwQ2WKIuCmfCS2A/L13NNKN9gB5GFFBF8o9L6T/BAyuey1ZdJJHXwzEjzgG5+B
	 Gzcb30AIdSiBxuOr64ZGlR1YG+vXCW00MfXI5aAP+mBrt+krbCOy2SeBpx65DKUuJO
	 M1wgiY/2Bo205RtQKF+KOLs7hJYFZcmUhzfDvtmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 759/816] usb: dwc3: xilinx: fix system suspend and resume PHY handling
Date: Wed, 25 Nov 2026 15:38:27 +0100
Message-ID: <20261125143906.741763704@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
@@ -384,13 +384,26 @@ static int __maybe_unused dwc3_xlnx_runt
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
@@ -404,15 +417,20 @@ static int __maybe_unused dwc3_xlnx_resu
 
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


