Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636C31FBEA6;
	Sat, 12 Sep 2026 16:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230809; cv=none; b=tOF1nX/6p89YVeavYx7y3q37sibcnj0yZRb/M2XV0Cg2e4k60jgvwWZ3Q68A2v4/mT5Zn4MoqmmKkFusqjT5hTAqLpOjd9qOtraIANOjYKcGS5iEhoOYQzu+2fjPMtZg/VhPyZCtDsbV+mJqHTYBKuSbL8H7vd0s2d7l3UPKXF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230809; c=relaxed/simple;
	bh=j7g05WADwlt7hy+BxrF5eQgS5eZmmcNgL+3FcXhSslg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIuw/xj3RJ/6CjQCOVPTACl3eCDNDsBTyzoa0DPTcm/znuoXz/vhr1yAzp765Rs0zM705SaiUzrvtp4VOg+W7w6dR7oNcVDU1eTsA6If20+q9D0bMEPtYDcIF4wrCE9FKNuckO5TzZdZ6CDHVW9CbPmbV/rrvTf+nQbCi1/nZ9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGw4Y4yr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGw4Y4yr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E181F000FF;
	Sat, 12 Sep 2026 16:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230808;
	bh=G/s2fLOxSsIzqd7065dq7ldU0oT+vYIOipfbC3RK5kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGw4Y4yrKasoSn8YGQTG12GwbQI78d2qUNEIV1yBScY473oKn90WlUx0kc9i/Mwvl
	 B2AAXTQ/8HuIsHsEHMDnIC/VJoL87h6WBRsqgCGJWmK9VN0MtnCjm3ZNLt1xpOc54W
	 QG3Ke6tJBNMT/seS2ziAhLcJ6h1vdTCxBdtoOUWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0868/1191] arm64: dts: qcom: sm7225-fairphone-fp4: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:59:56 +0200
Message-ID: <20260912065607.752166352@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit a3b3a060b696d964c769a7d9dc5835c79e4fe964 ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHY on this board, feeding 1.2V to vdda-phy and 0.9V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 4cbea668767d ("arm64: dts: qcom: sm7225: Add device tree for Fairphone 4")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-14-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
index 131e6c40a39b9..ba0535762d4db 100644
--- a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
+++ b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
@@ -468,8 +468,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vreg_l22a>;
-	vdda-pll-supply = <&vreg_l16a>;
+	vdda-phy-supply = <&vreg_l16a>;
+	vdda-pll-supply = <&vreg_l22a>;
 
 	status = "okay";
 };
-- 
2.53.0



