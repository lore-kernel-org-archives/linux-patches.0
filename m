Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623638;
	b=B7d6ujLmRUCoecVY+FwsdeogKVbrFhXVozQJdwWcjBwRvIXCOn8N4VubI8MfAui7MDGv
	 a3YQXlZT6seuaU3EIXa7EXszIRQQinH/aB3iVnWFDT8Y0rhDbWeYk7+tq4obhh4UF2jH0
	 GxZwnrYB8L2JfZ6HoYXYHKHGeyk5eEY2foyv1SYb/67D8XIdvJnGETttXC5otEndX5nZX
	 tv+2Lp/Sw7i1AgK554n4gfICM4vwPfHgl8cqcUAmq7DPtgNuc6ku16CRTA/L8T0hGfgwO
	 2cFQTuh0MrQqxNGOZQ23e6sjA7VNZy50G4Jwz6x/gv5wR/09wFXGu6f9CRP5av1WNzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CG+c9XT8dpPI0R273EH9qpVpS0l0BVWvmsp/teqX8Uk=;
	b=2JKnLQOoHsIKVXTEsQ7QJGFm76daPXhTx/zZLA5ePIGevusI1H9BzIdl37qUCcPBoImH
	 us6kE4tK9SVKw5O0Cth9EPhXX2J5K5T1+48hAVBlfIhXpCV0u8lQAY6xxewnqRUjh3I/R
	 tVT7hHiYbnEYkQM1EMtsstmjc6nVncIqC8IJx6RXEd3FNenLIhyFfPyre4yLLnsWHmj9K
	 i+yy39FeG6yQ3eYFHiQGkQL0xz06hL19XgEfoHqYuQU9HmOZCGr6JB/QRiB+14AETE8iS
	 U2LrhOt9dwMfuVGRfgUEkNkcsoMdVW4Odfws+Jbm9yvHUw11dDzIAO+BTMnbIvsNjpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hBW4CSmC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A62606A68E;
	Wed, 25 Nov 2026 16:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hBW4CSmC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCD31F0093C;
	Wed, 25 Nov 2026 16:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623638;
	bh=CG+c9XT8dpPI0R273EH9qpVpS0l0BVWvmsp/teqX8Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hBW4CSmC2i6T07jmSTxonQyR/u3XgAHBeSfFe6oaag5NyZPs5K0y9SKUozzFGBv3w
	 nO3tWP1sVoS7MHLcL7tPtlhRIql/FAcbgpZgEF8Gns7gE2i6agVFc7MlUgQVkmZ3wY
	 Kn/fALEwWvzTuWAQJ3hZHt6tIO37yCAXMZRFGYn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.18 922/990] usb: dwc3: xilinx: fix system suspend and resume PHY handling
Date: Wed, 25 Nov 2026 15:38:09 +0100
Message-ID: <20261125143843.596482693@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -395,13 +395,26 @@ static int __maybe_unused dwc3_xlnx_runt
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
@@ -415,15 +428,20 @@ static int __maybe_unused dwc3_xlnx_resu
 
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


