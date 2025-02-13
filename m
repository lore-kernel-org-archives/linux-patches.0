Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B5B26B080;
	Thu, 13 Feb 2025 15:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459474; cv=none; b=V3TKODsutF6yN1rzteLnHtcWCOh2J9fE4DoZHLvxl0fL2eVQ9ggBdDHT42UprwiTJ9OJ+ECa/xLYYToWjaPo7BsGGBbdGZ0hPhU0OVkINB3wdCAhH5KmeKZvzAxCm3MICMQ330/HHoXBAOhcE0fidAOmVNxrQuTeNQp/LAA1BP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459474; c=relaxed/simple;
	bh=fyIPk867cxBLMYDlo9XpH4iOlPbMjUZdLCfzL7qzqbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kosel5/lM+JI63DpevMA6+q6yPlKgkCh/aIxrHAz97wynqqL9AoL9TfZsJX/24G+3eP/e06rD0n0fiGE0Nf90fw6W0YZ0Pnl7FsqomzUj5uRsSdthZCqfYdRueG7DvrhOPtXr5HiSa77gB9XdDZXldwCnCJNwtt6L28u0TT3L+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvwENeAo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvwENeAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715F7C4CED1;
	Thu, 13 Feb 2025 15:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459473;
	bh=fyIPk867cxBLMYDlo9XpH4iOlPbMjUZdLCfzL7qzqbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvwENeAoxc8N/rgJgZknVvTOaeDyZPZeZ/WUMC6Q2YLg8AYrMH6iRk/QZUX4nn4aK
	 766MHeNtxszD5wMEWgYC6RPbwaduFwiax8wkKl7OmXzOrCwvUnqdvm+DWS372tRleB
	 l2ZyHQoAnash8tw1qC/+5kJbWfv1c3OzG4N4XIpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 243/443] arm64: dts: qcom: x1e80100-qcp: Fix USB QMP PHY supplies
Date: Thu, 13 Feb 2025 15:26:48 +0100
Message-ID: <20250213142449.993065414@linuxfoundation.org>
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


