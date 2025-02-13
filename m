Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7198B281369;
	Thu, 13 Feb 2025 14:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457832; cv=none; b=YLURdslyPa+uNS3zm+lh6nGw9OfAvLJxLRD0lRpuNPH4UfXPH/0j8I6NdJUoRTpvmnlF0jxHsFfnumskXS9XdqVPiN59Vkxaa1qUwPeLkt3J6FxTiDYcImMRWeH1VpxfEy4K95Adaag7+De1zNzloCkZw72qh/4lGso7nwj4bCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457832; c=relaxed/simple;
	bh=i3VurCqUxBAdmgpfuz8TbsX6+PZeRKU81zjSpK9YXsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5KpEycxzeDHlHv+cj+3Xe7FGuRZ1uP4ge6mfcJ2om3aVyrQlI7Xfgp6pCPl401TJqrhh5SNMw+zhNfoIe2qUfVgoMX++N44ApozPpxVHZLGLoMc8Ob6eww5XcLYsOwB5RsSQZkSmDraog8DRxn3YDLq8DcrILjik03aVGh6mDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=At3Ds87C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="At3Ds87C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0878C4CED1;
	Thu, 13 Feb 2025 14:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457832;
	bh=i3VurCqUxBAdmgpfuz8TbsX6+PZeRKU81zjSpK9YXsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=At3Ds87Cuke07Z/qXBUL6lzxJ9pg//NgW0YWyRDyasx9WdTgFb4UzrNV5J6iJ1KpP
	 q8cGOg8IJ5UntHUBXWhxTQajM/U3euMZXBeWqnSC21iaWbGexoksXbPhxXdEuRDHAY
	 XEXNxycj/40edAyDlwu0wMrA+tsPjTBtD7eooBWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 224/422] arm64: dts: qcom: x1e80100-microsoft-romulus: Fix USB QMP PHY supplies
Date: Thu, 13 Feb 2025 15:26:13 +0100
Message-ID: <20250213142445.181407842@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -782,7 +782,7 @@
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l3e>;
+	vdda-phy-supply = <&vreg_l2j>;
 	vdda-pll-supply = <&vreg_l1j>;
 
 	status = "okay";
@@ -814,7 +814,7 @@
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l3e>;
+	vdda-phy-supply = <&vreg_l2j>;
 	vdda-pll-supply = <&vreg_l2d>;
 
 	status = "okay";


