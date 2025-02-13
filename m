Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561E6281369;
	Thu, 13 Feb 2025 14:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457815; cv=none; b=ndW6fIcum+PfXLIeT7QNU9isstuUDg5lr7K0RK1TPqwH5DIj/UR5lerLKLHJrNEfosYCH5dyxsoj4s66pr+gWhnO1AfEehSeFxaj1ggbfWeCG2VDCNaA3b07NhZqkLPqqg+kyUZvI3iiHJ/lh7pU4tZMHX2vsOcokDS+XP2Qu7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457815; c=relaxed/simple;
	bh=+p+9+YmIn+Af8nGnbfIOP3+Pa9UtwXnTEtBvxvpln4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcKPsDifMXoQGXeFy5PXQ4/QypAQOoyxttGNTXMUAaPe2vUGcYTewx2dydYw2bU0XUqrUS4oDwhP7+xDBXaaZixen9ppMLu7Wra/s2RbsEI9jiuSB4WgWP6Fm9KnpAuuCnVCEGSIyDFbIbKWfeT5ZhRueyfIUs2dN92J2GQgfE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pxYCgPWY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pxYCgPWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96E9C4CED1;
	Thu, 13 Feb 2025 14:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457815;
	bh=+p+9+YmIn+Af8nGnbfIOP3+Pa9UtwXnTEtBvxvpln4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pxYCgPWYHZoMKKoEhk9QOGsKehE4C58W+rcz+lY9/2D/527P+IaAGtPVQ2M6kBJcs
	 bx1IMmuu9X0Vk4Mk9hoy7tCZ0AMMmjkm8FAnbbQlnwPOzgV6/xZGxV6uzZq0M49Lih
	 5dlPSebpshwHL51ITo9vKWW7YxuPPz3eF6eLVx0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 220/422] arm64: dts: qcom: x1e80100-qcp: Fix USB QMP PHY supplies
Date: Thu, 13 Feb 2025 15:26:09 +0100
Message-ID: <20250213142445.026911466@linuxfoundation.org>
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

commit 4861ba7cf5a49969dee258dda2bf8d4e819135d1 upstream.

On the X1E80100 QCP, &vreg_l3e_1p2 only powers &usb_mp_qmpphy0/1
(i.e. USBSS_3 and USBSS_4). The QMP PHYs for USB_0, USB_1 and USB_2
are actually powered by &vreg_l2j_1p2.

Cc: stable@vger.kernel.org
Fixes: 20676f7819d7 ("arm64: dts: qcom: x1e80100-qcp: Fix USB PHYs regulators")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20241210-x1e80100-usb-qmp-supply-fix-v1-8-0adda5d30bbd@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
@@ -896,7 +896,7 @@
 };
 
 &usb_1_ss0_qmpphy {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
+	vdda-phy-supply = <&vreg_l2j_1p2>;
 	vdda-pll-supply = <&vreg_l1j_0p8>;
 
 	status = "okay";
@@ -928,7 +928,7 @@
 };
 
 &usb_1_ss1_qmpphy {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
+	vdda-phy-supply = <&vreg_l2j_1p2>;
 	vdda-pll-supply = <&vreg_l2d_0p9>;
 
 	status = "okay";
@@ -960,7 +960,7 @@
 };
 
 &usb_1_ss2_qmpphy {
-	vdda-phy-supply = <&vreg_l3e_1p2>;
+	vdda-phy-supply = <&vreg_l2j_1p2>;
 	vdda-pll-supply = <&vreg_l2d_0p9>;
 
 	status = "okay";


