Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620643;
	b=n+UiTssGeTzMVE+Sf3aYXG5WVSSwAY1iP0zqNsprEw6I8udF0l1D6eCW6baVohLEjxx4
	 mhcz7/rjI6TjYKLKCoGUXfKhYVVRrRcC7weS8ZCe8t3l+b+Uq9nGFYsOCKym6lKF34QHD
	 //ZHKxyCSqnoeRgTG6KZcV3eLrwYt1RaRALN2uFLFuwVLuNPSF6F9QpJlfB6d4AgBUtDo
	 k4yVP4HU21JE8wzoEkw8RI748EdkA3OZCbdPusW1K8LTxpwywNQBb88FI7b0yI/Vuu2JL
	 5SAUDxsbY5q/kKLWN3RuaT1W5ykJrpTUnLkl+XSr3GMGSui0WabifwaM2FL81I0coPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j65ibqxnFWoPmqGawxqr4FwXZ3tIMKTBl9WA6n5z+a0=;
	b=e0zRxjzEzyVd0Ju/Ddb5nvcL9VEqpDKnFVgTjOB4LxZyHfrRQkPAFDe8LBYFdVlHzA2U
	 wVw/JtorA0QtoVyl6hWYUrp9dCCo7dawUX0fmmBgKpVeMYVA+H8qQ1tA6iTRuWwzGBdfL
	 J/uTo1H/P4YEtX8SW41VNP/1BH45HK/Ons+HH26THYPkb+3X+NBKK+nqb1aSDxcrgKnLo
	 xUT0qcLzHf2ifTeCSYTTlhPhzS3O9k/baWjTh7JDkND27Mp5CwdeJ8dLG634TKKd9zQpL
	 f7UiDPrXqLkBtjZIhSXqs3nxVPs02Q4jSRRowOpKnGShbRnnu9ux5f2Gcr80KXipFxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Nsre/zlf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045EC606A327;
	Wed, 25 Nov 2026 15:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nsre/zlf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADD21F000CA;
	Wed, 25 Nov 2026 15:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620642;
	bh=j65ibqxnFWoPmqGawxqr4FwXZ3tIMKTBl9WA6n5z+a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nsre/zlfQluOVrkN5xdzmEfi3eJHMcN66/owoBcm8HHMYav5J5gaO2Jq2ceUoXtO2
	 mi9LAtAkHuEOxbE67miK1XWCBua3qCWmF8S1c+9xaslHDVYMWmplkidgXg8a1q/hhD
	 sG6CWTNxJPyNbc7qAaYVUGx7ce8YPuq4tyEOQSpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 7.3 0941/1005] usb: dwc3: xilinx: re-assert resets on ZynqMP init error paths
Date: Wed, 25 Nov 2026 15:37:59 +0100
Message-ID: <20261125143843.723901348@linuxfoundation.org>
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

commit f33f0dd2eb014bffda02ecfd182de3ddab058596 upstream.

If reset deassert or PHY setup fails partway through
dwc3_xlnx_init_zynqmp(), re-assert the resets that were already
released before unwinding the PHY.

Only undo the reset cycle the function actually performed. The cycle is
skipped when no usb3-phy is present, because asserting the core resets
can break a USB3 configuration that is live but missing from the device
tree, so the error path skips it for the same reason. Asserting an
already asserted reset is harmless, so one block covers however far the
deasserts progressed.

Save the ZynqMP reset handles in driver private data so later probe
teardown can re-assert released resets.

Fixes: 84770f028fab ("usb: dwc3: Add driver for Xilinx platforms")
Cc: stable <stable@kernel.org>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/20260928120015.3152461-3-radhey.shyam.pandey@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-xilinx.c |   55 ++++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 19 deletions(-)

--- a/drivers/usb/dwc3/dwc3-xilinx.c
+++ b/drivers/usb/dwc3/dwc3-xilinx.c
@@ -48,6 +48,9 @@ struct dwc3_xlnx {
 	void __iomem			*regs;
 	int				(*pltfm_init)(struct dwc3_xlnx *data);
 	struct phy			*usb3_phy;
+	struct reset_control		*usb_crst;
+	struct reset_control		*usb_hibrst;
+	struct reset_control		*usb_apbrst;
 };
 
 static void dwc3_xlnx_mask_phy_rst(struct dwc3_xlnx *priv_data, bool mask)
@@ -112,7 +115,6 @@ static int dwc3_xlnx_init_versal(struct
 static int dwc3_xlnx_init_zynqmp(struct dwc3_xlnx *priv_data)
 {
 	struct device		*dev = priv_data->dev;
-	struct reset_control	*crst, *hibrst, *apbrst;
 	struct gpio_desc	*reset_gpio;
 	int			ret = 0;
 
@@ -124,25 +126,25 @@ static int dwc3_xlnx_init_zynqmp(struct
 		goto err;
 	}
 
-	crst = devm_reset_control_get_exclusive(dev, "usb_crst");
-	if (IS_ERR(crst)) {
-		ret = PTR_ERR(crst);
+	priv_data->usb_crst = devm_reset_control_get_exclusive(dev, "usb_crst");
+	if (IS_ERR(priv_data->usb_crst)) {
+		ret = PTR_ERR(priv_data->usb_crst);
 		dev_err_probe(dev, ret,
 			      "failed to get core reset signal\n");
 		goto err;
 	}
 
-	hibrst = devm_reset_control_get_exclusive(dev, "usb_hibrst");
-	if (IS_ERR(hibrst)) {
-		ret = PTR_ERR(hibrst);
+	priv_data->usb_hibrst = devm_reset_control_get_exclusive(dev, "usb_hibrst");
+	if (IS_ERR(priv_data->usb_hibrst)) {
+		ret = PTR_ERR(priv_data->usb_hibrst);
 		dev_err_probe(dev, ret,
 			      "failed to get hibernation reset signal\n");
 		goto err;
 	}
 
-	apbrst = devm_reset_control_get_exclusive(dev, "usb_apbrst");
-	if (IS_ERR(apbrst)) {
-		ret = PTR_ERR(apbrst);
+	priv_data->usb_apbrst = devm_reset_control_get_exclusive(dev, "usb_apbrst");
+	if (IS_ERR(priv_data->usb_apbrst)) {
+		ret = PTR_ERR(priv_data->usb_apbrst);
 		dev_err_probe(dev, ret,
 			      "failed to get APB reset signal\n");
 		goto err;
@@ -156,19 +158,19 @@ static int dwc3_xlnx_init_zynqmp(struct
 	 * absent.
 	 */
 	if (priv_data->usb3_phy) {
-		ret = reset_control_assert(crst);
+		ret = reset_control_assert(priv_data->usb_crst);
 		if (ret < 0) {
 			dev_err(dev, "Failed to assert core reset\n");
 			goto err;
 		}
 
-		ret = reset_control_assert(hibrst);
+		ret = reset_control_assert(priv_data->usb_hibrst);
 		if (ret < 0) {
 			dev_err(dev, "Failed to assert hibernation reset\n");
 			goto err;
 		}
 
-		ret = reset_control_assert(apbrst);
+		ret = reset_control_assert(priv_data->usb_apbrst);
 		if (ret < 0) {
 			dev_err(dev, "Failed to assert APB reset\n");
 			goto err;
@@ -179,7 +181,7 @@ static int dwc3_xlnx_init_zynqmp(struct
 	if (ret < 0)
 		goto err;
 
-	ret = reset_control_deassert(apbrst);
+	ret = reset_control_deassert(priv_data->usb_apbrst);
 	if (ret < 0) {
 		dev_err(dev, "Failed to release APB reset\n");
 		goto err_phy_exit;
@@ -195,21 +197,21 @@ static int dwc3_xlnx_init_zynqmp(struct
 		writel(PIPE_CLK_DESELECT, priv_data->regs + XLNX_USB_FPD_PIPE_CLK);
 	}
 
-	ret = reset_control_deassert(crst);
+	ret = reset_control_deassert(priv_data->usb_crst);
 	if (ret < 0) {
 		dev_err(dev, "Failed to release core reset\n");
-		goto err_phy_exit;
+		goto err_reset_assert;
 	}
 
-	ret = reset_control_deassert(hibrst);
+	ret = reset_control_deassert(priv_data->usb_hibrst);
 	if (ret < 0) {
 		dev_err(dev, "Failed to release hibernation reset\n");
-		goto err_phy_exit;
+		goto err_reset_assert;
 	}
 
 	ret = phy_power_on(priv_data->usb3_phy);
 	if (ret < 0)
-		goto err_phy_exit;
+		goto err_reset_assert;
 
 	/* ulpi reset via gpio-modepin or gpio-framework driver */
 	reset_gpio = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
@@ -230,6 +232,21 @@ static int dwc3_xlnx_init_zynqmp(struct
 
 err_phy_power_off:
 	phy_power_off(priv_data->usb3_phy);
+err_reset_assert:
+	/*
+	 * Undo only the reset cycle performed above.  That cycle is skipped
+	 * when there is no usb3-phy.  The deasserts stay unconditional so a
+	 * core the bootloader left in reset still comes up, but they are
+	 * deliberately not paired with an assert here: resetting a USB3
+	 * configuration that is live but missing from the device tree could
+	 * break it.  Asserting an already asserted reset is harmless, so one
+	 * block covers however far the cycle's deasserts got.
+	 */
+	if (priv_data->usb3_phy) {
+		reset_control_assert(priv_data->usb_hibrst);
+		reset_control_assert(priv_data->usb_crst);
+		reset_control_assert(priv_data->usb_apbrst);
+	}
 err_phy_exit:
 	phy_exit(priv_data->usb3_phy);
 err:


