Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D582226B098;
	Thu, 13 Feb 2025 15:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459376; cv=none; b=uzeM0bu7TQDQoGiDUAZ40wuoyxT+qYT7H22AQG/HcyszoEMftdQkuM9W/YYEXLXUadMbZOsF6MGPA4iQ3SRo62dxLCeFP9R7Loh1wEGhcF2eoBKZUZmB+NC24cqh2UEryVmBLCqWUjuTJEA0yKSiHGW0T8lcyFMIVaOuASHqF0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459376; c=relaxed/simple;
	bh=IrBKqIF3B1TYKGqEMmCii+EwEP1UTjs6hsCuVPiWATs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJlTHqSTon6oovb485j+Js7CyBRa8R28iv/x8/QfjPWhIGPKGF9W9gLlxkP3hgZz77TRZPbbcpz65G64q6AuErALlzaYj6vMXIKr3OFdJJz7iNr84sJPJpVqp7kQvscKHPTpBrcdIubAFPOkmlCi0JbUYWMVP3HjjyMGH1y/7bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hoz+Zfmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hoz+Zfmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4375DC4CEE5;
	Thu, 13 Feb 2025 15:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459376;
	bh=IrBKqIF3B1TYKGqEMmCii+EwEP1UTjs6hsCuVPiWATs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hoz+ZfmvIZvaFXp3Q09/vRYihtiNGkY1ey5uHU2L9Xy6Rlb8ztQmSRcvvpdWWA/QO
	 bl7WyVsfZx4tYovUzVcemAsSuOcNODIu0AkgFeJHvlw/yS0n/deAJlxlT1lWBH/SDS
	 D2I2zxcPb++7aKcrTF1F05bd9sVDjDU0hHKUIDrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 247/443] arm64: dts: qcom: x1e80100-microsoft-romulus: Fix USB QMP PHY supplies
Date: Thu, 13 Feb 2025 15:26:52 +0100
Message-ID: <20250213142450.146904905@linuxfoundation.org>
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

commit c0562f51b177d49829a378b5aeda73f78c60d0fc upstream.

On the X1E80100 CRD, &vreg_l3e_1p2 only powers &usb_mp_qmpphy0/1
(i.e. USBSS_3 and USBSS_4). The QMP PHYs for USB_0, USB_1 and USB_2
are actually powered by &vreg_l2j_1p2.

Since x1e80100-microsoft-romulus mostly just mirrors the power supplies
from the x1e80100-crd device tree, assume that the fix also applies here.

Cc: stable@vger.kernel.org
Fixes: 09d77be56093 ("arm64: dts: qcom: Add support for X1-based Surface Laptop 7 devices")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20241210-x1e80100-usb-qmp-supply-fix-v1-7-0adda5d30bbd@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi
@@ -823,7 +823,7 @@
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l3e>;
+	vdda-phy-supply = <&vreg_l2j>;
 	vdda-pll-supply = <&vreg_l1j>;
 
 	status = "okay";
@@ -855,7 +855,7 @@
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l3e>;
+	vdda-phy-supply = <&vreg_l2j>;
 	vdda-pll-supply = <&vreg_l2d>;
 
 	status = "okay";


