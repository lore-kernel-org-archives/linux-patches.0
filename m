Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6EF26B096;
	Thu, 13 Feb 2025 15:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459467; cv=none; b=T3jwBnBTmEdlYOkYPSmyDh5Bl0hJGBRygtGtfPCaGRnv3ajyXSquJFweABi4Xi0M/NIuUb00wjySAu4EwtOOUasp559n12iJVrtWjhwTyuGScxe1lOraWL6i8uP9Q3FIT4PaQ3NXuwVj52Lb0ypnHuwVZbSMsQLRobdWnO4i1CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459467; c=relaxed/simple;
	bh=Wy3Snt3pIoGvLDM7VAtSal23l/GsAIVS0iJO379AiJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6grO0vRdcy5tMN2hDk+TEJXlvk2Tj2fk/HVq+mnUw239EZqNM/xTR0M3JPSibD2YEuZ4b5A7FL1ocv++fnZyho+JP3UNPg3MOgsPUjEh5XkdS/L53ybtpK8f8rOz1iFZMnTIrAqE63QmGs9v0g+D18Kfti+VYfg+pALk6m9ARs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6NmK1LB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6NmK1LB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D05C4CED1;
	Thu, 13 Feb 2025 15:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459467;
	bh=Wy3Snt3pIoGvLDM7VAtSal23l/GsAIVS0iJO379AiJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C6NmK1LBLXpxC47/m6BSwMGTnjKSyJyR2irwSGtEEjoR3gG8WM9dSyzEAdl1Fiai8
	 vXelhVfP6MX+sWzBCixjf4LnDVNt8ciRE37obLlDjXI8FvSPM3aqgjCUkBMsG2/vAq
	 9T/rMOz47s7LPpvYpdhmDVj4SjpmKkCUOY2LDpx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Maud Spierings <maud_spierings@hotmail.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 241/443] arm64: dts: qcom: x1e80100-asus-vivobook-s15: Fix USB QMP PHY supplies
Date: Thu, 13 Feb 2025 15:26:46 +0100
Message-ID: <20250213142449.916688945@linuxfoundation.org>
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

commit bf5e9aa844ca74e9c202d8de2ce7390d24ec38a4 upstream.

On the X1E80100 CRD, &vreg_l3e_1p2 only powers &usb_mp_qmpphy0/1
(i.e. USBSS_3 and USBSS_4). The QMP PHYs for USB_0, USB_1 and USB_2
are actually powered by &vreg_l2j_1p2.

Since x1e80100-asus-vivobook-s15 mostly just mirrors the power supplies
from the x1e80100-crd device tree, assume that the fix also applies here.

Cc: stable@vger.kernel.org
Fixes: d0e2f8f62dff ("arm64: dts: qcom: Add device tree for ASUS Vivobook S 15")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Tested-by: Maud Spierings <maud_spierings@hotmail.com>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20241210-x1e80100-usb-qmp-supply-fix-v1-3-0adda5d30bbd@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts
@@ -591,7 +591,7 @@
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
+	vdda-phy-supply = <&vreg_l2j_1p2>;
 	vdda-pll-supply = <&vreg_l1j_0p8>;
 
 	status = "okay";
@@ -623,7 +623,7 @@
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
+	vdda-phy-supply = <&vreg_l2j_1p2>;
 	vdda-pll-supply = <&vreg_l2d_0p9>;
 
 	status = "okay";


