Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8CC1DA4E;
	Tue,  3 Dec 2024 15:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238202; cv=none; b=neCj0jYPFvau8GB4T1JjTLLgZa9qjk+/led3eqHhedGKNWGJ4F1dITipelSkey6eDc4ioOIe+ykTVcvFmluc1IWx/tCI30xBmPu07928+cyBuY3w6eh2/XdZdB8UFOMJH0vOGOwnJkoeYhls1mPDFZgpB8RjFqWCBzWdHDRIDv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238202; c=relaxed/simple;
	bh=EvZN41rEKYFxwlyI+8HdS/MHeMeSK1LPS57TZC2q5QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJqDGDZ1oTrV0F3rzHI8Ec11eX5oY1tUtBNYDfbA9IRcWOvj6SSjAc67HVJ5Un3Ubrc4F7fovJpSPCayjOxLvKBi8QgLmx7KBLiMFBa3v+/3EilBHz1DM5H+/3UTfaaVr+O5SbAmZYRxqvdeL70UavrCHeVdRVHl2TmrP3MuUhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLQRkDaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLQRkDaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8F0C4CECF;
	Tue,  3 Dec 2024 15:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238201;
	bh=EvZN41rEKYFxwlyI+8HdS/MHeMeSK1LPS57TZC2q5QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLQRkDaQcPo6YqPfzYaXR3oS9Hilzrmy4CnNcgBt4bEjKhpVQOabTHvxJorBJg3mz
	 exSn+Qr8n1SCsWOCp2s7L7Uap0we9aTce2tZ2msG74QJAZ6OwY8E/Yhtda6WtRDKoC
	 QrLZT9SfmVYBXrierx0d6sCDL9nUqGYO19WNw/5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 196/817] arm64: dts: imx8mn-tqma8mqnl-mba8mx-usbot: fix coexistence of output-low and output-high in GPIO
Date: Tue,  3 Dec 2024 15:36:08 +0100
Message-ID: <20241203144003.389861066@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit c771d311b1901cd4679c8fc7f89a882fe07cf4a0 ]

Fix the issue where both 'output-low' and 'output-high' exist under GPIO
hog nodes  (rst_usb_hub_hog and sel_usb_hub_hog) when applying device
tree overlays. Since /delete-property/ is not supported in the overlays,
setting 'output-low' results in both properties being present. The
workaround is to disable these hogs and create new ones with 'output-low'
as needed.

Fix below CHECK_DTBS warning:
arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl-mba8mx-usbotg.dtb: sel-usb-hub-hog:
   {'output-low': True, 'gpio-hog': True, 'gpios': [[1, 0]], 'output-high': True, 'phandle': 108, '$nodename': ['sel-usb-hub-hog']}
       is valid under each of {'required': ['output-low']}, {'required': ['output-high']

Fixes: 3f6fc30abebc ("arm64: dts: imx8mn: tqma8mqnl-mba8mx: Add USB DR overlay")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../imx8mn-tqma8mqnl-mba8mx-usbotg.dtso       | 29 +++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl-mba8mx-usbotg.dtso b/arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl-mba8mx-usbotg.dtso
index 96db07fc9bece..1f2a0fe70a0a2 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl-mba8mx-usbotg.dtso
+++ b/arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl-mba8mx-usbotg.dtso
@@ -29,12 +29,37 @@ usb_dr_connector: endpoint {
 	};
 };
 
+/*
+ * rst_usb_hub_hog and sel_usb_hub_hog have property 'output-high',
+ * dt overlay don't support /delete-property/. Both 'output-low' and
+ * 'output-high' will be exist under hog nodes if overlay file set
+ * 'output-low'. Workaround is disable these hog and create new hog with
+ * 'output-low'.
+ */
+
 &rst_usb_hub_hog {
-	output-low;
+	status = "disabled";
+};
+
+&expander0 {
+	rst-usb-low-hub-hog {
+		gpio-hog;
+		gpios = <13 0>;
+		output-low;
+		line-name = "RST_USB_HUB#";
+	};
 };
 
 &sel_usb_hub_hog {
-	output-low;
+	status = "disabled";
+};
+
+&gpio2 {
+	sel-usb-low-hub-hog {
+		gpio-hog;
+		gpios = <1 GPIO_ACTIVE_HIGH>;
+		output-low;
+	};
 };
 
 &usbotg1 {
-- 
2.43.0



