Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E657A1F7060;
	Tue,  3 Dec 2024 15:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240376; cv=none; b=brdtnk9GuO8P33IKlRoObns74CSJchqCyzeHF9150yCQsZGtq+FCXZoz6bNwSj8OgCD3u+G09Tdih3/dvTpBcOrpG2S0Z2gjZmAYMuF4xp4yRr/2ax/Vzxw9CHjanHg44PWk9D0PkK8UDsgSCbQGTrVaWRgqsY4tPrHBMENjMEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240376; c=relaxed/simple;
	bh=U3yUetKsjXekdg2csgr/vom8q+lxVTUrLe+9+EPZPbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5kxKc4mzOkuA7wxMsxvQqZ46+t3d0sJQd3ubCxKRAHDDMmkZgX2MGPFNjw+BbqL6TG2uC7idpyH4WsyNBIlttmJN2o5qC6u0YwSRAdDE5JLmgZ9mOKW2vx2fgnCDVozBiFERoCR+sXwzmrKwKq1flnSbgMy4wsJwsO6w8EbC9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UPrW7dnp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UPrW7dnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A18C4CECF;
	Tue,  3 Dec 2024 15:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240375;
	bh=U3yUetKsjXekdg2csgr/vom8q+lxVTUrLe+9+EPZPbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPrW7dnpT+wq7bFnGyh9EVO/8IRCIt6YXmt5B1wNOIU8fn2MpsBSdGoDp6xXXLRhq
	 FeHpTyR8UKsin3Ni7eBM2uHa9sv/uJAAoRaP8DQ9hVJa4NoMP2MAt8B8T6jO4i9HA0
	 JhIlgC69inUW8nzrobHE2FpMAT6aldTIYGB79Vs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/826] arm64: dts: qcom: x1e80100-slim7x: Drop orientation-switch from USB SS[0-1] QMP PHYs
Date: Tue,  3 Dec 2024 15:37:25 +0100
Message-ID: <20241203144748.346990975@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit eb2dd93d03b16ed0e8b09311f8d35cc5a691a9b7 ]

The orientation-switch is already set in the x1e80100 SoC dtsi,
so drop from Slim 7X dts.

Fixes: 45247fe17db2 ("arm64: dts: qcom: x1e80100: add Lenovo Thinkpad Yoga slim 7x devicetree")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20241014-x1e80100-dts-drop-orientation-switch-v1-1-26afa6d4afd9@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts b/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
index 0cdaff9c8cf0f..f22e5c840a2e5 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
@@ -898,8 +898,6 @@ &usb_1_ss0_qmpphy {
 	vdda-phy-supply = <&vreg_l3e_1p2>;
 	vdda-pll-supply = <&vreg_l1j_0p8>;
 
-	orientation-switch;
-
 	status = "okay";
 };
 
@@ -932,8 +930,6 @@ &usb_1_ss1_qmpphy {
 	vdda-phy-supply = <&vreg_l3e_1p2>;
 	vdda-pll-supply = <&vreg_l2d_0p9>;
 
-	orientation-switch;
-
 	status = "okay";
 };
 
-- 
2.43.0



