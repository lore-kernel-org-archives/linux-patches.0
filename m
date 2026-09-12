Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495CD39A066;
	Sat, 12 Sep 2026 08:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201893; cv=none; b=Py3Vkz9lwkZ3XPagGAFSzy5axGZnqgrYBg3S2ckD79NwzBDMqLd112wpPMDwgX/qKfGqu71dVfWhXzZ6te0pObuIjsZdkjZQgSfd6e1SaFRO8M6u5yJVdE2MCuwpyaMTPCRAoyoXbGTCTJJtafSextIPAlafSVOCcXnIj+f4fyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201893; c=relaxed/simple;
	bh=b6cDdKlJUOY0RAMbyMUrXsvlZe/Zz1o6GyClD2INRv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouFdyFp29lAMFZR7WDxSW1TgMkFTMBINp/Ql7MexFQicGkJAKy2+X8eq6wSFOJEGbdz3UOMOosd2irUt5lgCZIpjzg08Iul6l8H2ClIFBcPecmHUxMqdMD1EUUlqGP0XZv6n8LTzZWGCDmFNU0qIWPqOUbPqCUTFJx4wWuV5Y5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQUJiEKm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQUJiEKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E011C1F000FF;
	Sat, 12 Sep 2026 08:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201892;
	bh=YQcn0udVhTN+4zTfDtUGSCypAHNlyD6kxvWezYW62fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQUJiEKm9CI8Na5kt2nVFE+12H9B6INxuY+RIPFqMsuhSsUb1sTthxUKDpnFSrLg+
	 i9U5qQapHcug/arFPWe/zcO6zH7vdMNs/+HN0vaP0smNTp+EWDGYIpvHd+phEyj36Z
	 Txy0tU5Dn6pPWV18e76SA0AKmJ1MTnTPnvLYhsBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1088/1815] arm64: dts: qcom: eliza-mtp: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:47:18 +0200
Message-ID: <20260912065714.563520683@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 6b1195eeb204b455973fb05e10563a63bdd71c57 ]

The QMP PHY expects the vdda-phy supply to be the lower voltage (~0.8V)
and the vdda-pll supply to be the higher voltage (~1.2V), as used by the
UFS QMP PHY on this SoC. But these two supplies are swapped for the USB
QMP PHY on this board, feeding 1.15V to vdda-phy and 0.72V to vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 49dab7311f57 ("arm64: dts: qcom: eliza-mtp: Enable USB and ADSP support")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-26-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/eliza-mtp.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/eliza-mtp.dts b/arch/arm64/boot/dts/qcom/eliza-mtp.dts
index 1374afd9d14e3..9d58ef20213a0 100644
--- a/arch/arm64/boot/dts/qcom/eliza-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/eliza-mtp.dts
@@ -535,8 +535,8 @@ &usb {
 };
 
 &usb_dp_qmpphy {
-	vdda-phy-supply = <&vreg_l3g>;
-	vdda-pll-supply = <&vreg_l7k>;
+	vdda-phy-supply = <&vreg_l7k>;
+	vdda-pll-supply = <&vreg_l3g>;
 
 	status = "okay";
 };
-- 
2.53.0



