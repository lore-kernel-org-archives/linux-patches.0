Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6A918C903;
	Tue, 30 Jul 2024 16:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355520; cv=none; b=PVWL23EONm/OM5xnhrUTN33BqDRGhJuuAsf+u0GPnHKS5GQgI3d59slhUqUKOSrOdY2T0O3UaJcS/fv9V/h0SPn0aDPZI5Yr1A+AIRWwWzlXMzNICPG9V11iYvTsq44F2U9EEfSdsFIFo8RqC63/eCqhFxMSeXR3duy2xAFULqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355520; c=relaxed/simple;
	bh=YI6+lp9QH+DZToK/rpUtrDSSZX1ssvB2FxLbA3LqoW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CL/sHGuZG/A7jvj2sW5zu0WlYtcLAgd0eR8yj9NWC+vi1Hd2gSxPQkAEfcO4LcFTzQOEk+iUtF//+IqYfPuROwJ6jylXMwytsRlLX2mofpvieacXbHsFlyVmM2c9xWxjnTc68p9EHycQWMAU71dUus/iel6RhRtPPjv6dXrKkd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+2Mp0pj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+2Mp0pj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DC3C4AF0C;
	Tue, 30 Jul 2024 16:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355520;
	bh=YI6+lp9QH+DZToK/rpUtrDSSZX1ssvB2FxLbA3LqoW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+2Mp0pji9cDldwoX/zvUWm5ML5hpHb0WchyMryHjd5OIJ1b/zYzzg2C3WFayJhBu
	 ciSkT/z1V7ZyLJvaBD3EM3PzqJRSuGMbrcTRFOXpBzJKcPvVTGztb1sZDM1x6Rmo5y
	 5Poyz2Na47mdt1K7l0Eh9SmO51x6kwlLW/Pm7ME0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yassine Oudjana <y.oudjana@protonmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 053/809] arm64: dts: qcom: msm8996-xiaomi-common: drop excton from the USB PHY
Date: Tue, 30 Jul 2024 17:38:49 +0200
Message-ID: <20240730151726.742736976@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit c1aefeae8cb7b71c1bb6d33b1bda7fc322094e16 ]

The USB PHYs don't use extcon connectors, drop the extcon property from
the hsusb_phy1 node.

Fixes: 46680fe9ba61 ("arm64: dts: qcom: msm8996: Add support for the Xiaomi MSM8996 platform")
Cc: Yassine Oudjana <y.oudjana@protonmail.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-13-f1fd15c33fb3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996-xiaomi-common.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996-xiaomi-common.dtsi b/arch/arm64/boot/dts/qcom/msm8996-xiaomi-common.dtsi
index 5ab583be9e0a0..0386636a29f05 100644
--- a/arch/arm64/boot/dts/qcom/msm8996-xiaomi-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996-xiaomi-common.dtsi
@@ -405,7 +405,6 @@ &usb3_dwc3 {
 
 &hsusb_phy1 {
 	status = "okay";
-	extcon = <&typec>;
 
 	vdda-pll-supply = <&vreg_l12a_1p8>;
 	vdda-phy-dpdm-supply = <&vreg_l24a_3p075>;
-- 
2.43.0



