Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF28E26B080;
	Thu, 13 Feb 2025 15:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459484; cv=none; b=XwOVW+5kXCPXJxMS6lC2ovyoUhetc1AyqZPMdRieIu6vTdINvOt8PaLI3riLVKgpxTlxr/5aOexmeqJ9H4UbFCyp1cETzlQPaCQshnV5oLgG4HTefIfoki9cRSYBVC64S9vxVK3Rp0BlBNGpER5qtnzj7yCIf2LelermJFGbeeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459484; c=relaxed/simple;
	bh=ZVuXIx0WOUnUhYxKHyJbi0da6nT1ZmUAZki7vncwLTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/kk4+jdc1i8AFHbs+pUL+6fj9pVYfviXD2VXk6btExf63SWoMC5Qa1V8fUkkPssNtUBPfQ6GOV9vJVDqTlRQ9m9V1lSK0uyRqr7Kc6j/+1AkcZm2JvfYv/YLcxHUuBRHAe0uiWCwApCfPZcXi9/T4fwd8XWNdRQvc4L9AtcMLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rusNh7hX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rusNh7hX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D318C4CEE4;
	Thu, 13 Feb 2025 15:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459483;
	bh=ZVuXIx0WOUnUhYxKHyJbi0da6nT1ZmUAZki7vncwLTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rusNh7hXNfbXP16tjV66IFhlPf/UNXTYRfb9AEgec97XBzFIOCeEHi8XphwG7qtEY
	 4fKzKhS1X+UTBN3ZUVuD0P0rIg2/gFArzaxUxVUY3g1nxPyQ0/3e9byLbH/agU59V5
	 1vlH95oFxZtLfqRcsRJ0yeopy8AhREPoC0jc7WVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 246/443] arm64: dts: qcom: x1e80100-lenovo-yoga-slim7x: Fix USB QMP PHY supplies
Date: Thu, 13 Feb 2025 15:26:51 +0100
Message-ID: <20250213142450.109075533@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit 6ba8e1b8242d27dd83ed4ce58a104c709e72f45f upstream.

On the X1E80100 CRD, &vreg_l3e_1p2 only powers &usb_mp_qmpphy0/1
(i.e. USBSS_3 and USBSS_4). The QMP PHYs for USB_0, USB_1 and USB_2
are actually powered by &vreg_l2j_1p2.

Since x1e80100-lenovo-yoga-slim7x mostly just mirrors the power supplies
from the x1e80100-crd device tree, assume that the fix also applies here.

Cc: stable@vger.kernel.org
Fixes: 45247fe17db2 ("arm64: dts: qcom: x1e80100: add Lenovo Thinkpad Yoga slim 7x devicetree")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20241210-x1e80100-usb-qmp-supply-fix-v1-6-0adda5d30bbd@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
@@ -908,7 +908,7 @@
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
+	vdda-phy-supply = <&vreg_l2j_1p2>;
 	vdda-pll-supply = <&vreg_l1j_0p8>;
 
 	status = "okay";
@@ -940,7 +940,7 @@
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
+	vdda-phy-supply = <&vreg_l2j_1p2>;
 	vdda-pll-supply = <&vreg_l2d_0p9>;
 
 	status = "okay";
@@ -972,7 +972,7 @@
 };
 
 &usb_1_ss2_qmpphy {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
+	vdda-phy-supply = <&vreg_l2j_1p2>;
 	vdda-pll-supply = <&vreg_l2d_0p9>;
 
 	status = "okay";


