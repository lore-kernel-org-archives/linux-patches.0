Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D341F759C;
	Tue,  3 Dec 2024 15:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240523; cv=none; b=YTnPLXYJo+7Eqh4LQLnFxM5MKaflmaH6siYHSvA62WfAljb5J0VABvBOimEAuhR9392p5LcC6+LuXA67dOkYKapOaI57LKTfVzRkV3koZ+nwDASiXeKlRppBGwSlbQDyaFUlT+QmyqxO7DCERjgNInia6rCvwnD2uPE1tdq2hs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240523; c=relaxed/simple;
	bh=mHJ1SmiOHaYQsb5g4ORYkG+GivuKDFtE1+k5FzAk06g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQJg6HQLdqtX6UZ5KYIeby4Al5whw/1rQXTyCO6UnRSh5BHpySqQIWqARylQcfdUXJOKh/PeRSdgaxEE6SKrJEKVdS6mCCIJYIZ8MNxtPGEBMWK7RxF3bchYmxKZEPPyLPtnjRuKDuDJUlOiOUwZgeBuLlJDdOAdUKi4f80JQfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvyRok9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvyRok9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A1DC4CECF;
	Tue,  3 Dec 2024 15:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240522;
	bh=mHJ1SmiOHaYQsb5g4ORYkG+GivuKDFtE1+k5FzAk06g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xvyRok9sRIWrXZ+0AYckHy1w77Brw0L9jDxAqtExFZEeFlV0qJJhdLUxrLoexg4y2
	 jpPtpske39nld+qzxMghHsIqCpnAFaZwlyKuAxokTz3uTBy+T7L4r4Vw0cdvGlSU2u
	 WoYtBKfkRZfzOuCrscpQ1HF4vKSmxCVi7IkgFLVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 160/826] arm64: dts: imx8mn-tqma8mqnl-mba8mx-usbot: fix coexistence of output-low and output-high in GPIO
Date: Tue,  3 Dec 2024 15:38:07 +0100
Message-ID: <20241203144749.982355444@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



