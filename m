Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C0755E5E;
	Wed, 21 Feb 2024 13:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523899; cv=none; b=BkAR5yDRk0XK+OXgWHdQUi9W87dxsohwfxATSaP/lQYP7ouAVMDTG7eFuvQs4SOLVcK67uiEXmzi7lFdlbX1YBauqoRXUYNIkgtvcdM4kJ3GrVTOr0rwAFp54PsWO+wIy0Orm1HYqbXbacUJ24CmQ+3C7vNPhaLlGLNARzpl288=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523899; c=relaxed/simple;
	bh=LK4JbSdqw0nEFce7Xie4+MH2eAMjD3ZLDoeLSpODz94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikI8RUO+Pl5ZU/QDFX/PQeHSQIuBiygvS6Wo9MOhS0txQ96exsCgt3ARrH11mnghCsevdOmaCkmx7iYPOeqQaakwEHPEZApVvzW/yVnf9mUpgo1/PRQeiZOdrFGvZreA/m3Ywy8B81u4EadLzqAwweKweHXtzqW74VpV9aMRt2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xllS6R/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xllS6R/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388E9C433F1;
	Wed, 21 Feb 2024 13:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523899;
	bh=LK4JbSdqw0nEFce7Xie4+MH2eAMjD3ZLDoeLSpODz94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xllS6R/qrkcDpPfTxSLxXmSQ7Rxr1ixelYE97H6A6BFA5u7S7Jp/mSyKgRO/udJG/
	 QKDx+35/sp0Qo4Ou+O8NitesJrwesrXfmirZ+eCxuN484+VVCNXSLB17sqBVCetKtZ
	 vQQeY9jCXyLiokOaX3uJ6LogZuy07wWfANeUI5hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/379] arm64: dts: qcom: sc7180: fix USB wakeup interrupt types
Date: Wed, 21 Feb 2024 14:04:24 +0100
Message-ID: <20240221125957.422301749@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 9b956999bf725fd62613f719c3178fdbee6e5f47 ]

The DP/DM wakeup interrupts are edge triggered and which edge to trigger
on depends on use-case and whether a Low speed or Full/High speed device
is connected.

Fixes: 0b766e7fe5a2 ("arm64: dts: qcom: sc7180: Add USB related nodes")
Cc: stable@vger.kernel.org      # 5.10
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231120164331.8116-4-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 6eb82699a4a1..be40821dfeb9 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -2690,8 +2690,8 @@ usb_1: usb@a6f8800 {
 
 			interrupts-extended = <&intc GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc 6 IRQ_TYPE_LEVEL_HIGH>,
-					      <&pdc 8 IRQ_TYPE_LEVEL_HIGH>,
-					      <&pdc 9 IRQ_TYPE_LEVEL_HIGH>;
+					      <&pdc 8 IRQ_TYPE_EDGE_BOTH>,
+					      <&pdc 9 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 
-- 
2.43.0



