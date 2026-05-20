Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BECA356762;
	Wed, 20 May 2026 16:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295741; cv=none; b=jFUGUJ2DCPBH3haqi+meSnJivApbrj6F6iWvkHa8w9fFEO7rokEQin6mVBM70jEZSb5yLf3WaBrnfEbSSnG7uP3J/fYqeqyLDhHzFn4ACEyG0C1U53np/8Y/xqPqLE7OAkDyCsdfa3HmiGrqSeEGNzX2U5x/884bqi7AP0wPt5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295741; c=relaxed/simple;
	bh=qadGBpnZEe2OeMoLQf39bNM+pOflBkjKxHl4T9Tc1WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAg5AGNAna5qE7HNpTn/3+mid121sc0dFZXn5ZPecE0wKg/eVADJ6tFtIGAdctxZRJ6OPjYyhZiAymI9DnNvpwOXceEYNH0LSCR4wTlhqnp82fE9ZYOCF4nQ24bUd2bwVDuJ/Vx1bIkODDsiDrirNG00CAaKMYfDvHIB4cBV/ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWN8t6ud; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWN8t6ud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78661F000E9;
	Wed, 20 May 2026 16:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295740;
	bh=m4+aXRCM0fSl0s8NAodWz5MDhWqffxW9AbeNPDhirOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WWN8t6udHf6KZfwlwMj9FpamLo4+rVnMc3/qCp4wxFtj2AEoEDf8z4enY7GeWJTCO
	 dWXGdy5xRSaai7W6JIxxmNg2GawckGvMxQ5F5mTHB1TZd1e4eqkGbdUhfXVikkPWS/
	 3XIjCacx0QnDWT4HJ9XWwpaTHjYVoVI6VWAIqx+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0517/1146] arm64: dts: qcom: kaanapali: Fix GIC_ITS range length
Date: Wed, 20 May 2026 18:12:47 +0200
Message-ID: <20260520162159.886559643@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 51cf2818376f5ebbc5f8753d5be547b1e7206021 ]

Currently, the GITS_SGIR register is cut off. Fix it up.

Fixes: 2eeb5767d53f ("arm64: dts: qcom: Introduce Kaanapali SoC")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260317-topic-its_range_fixup-v1-1-49be8076adb1@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/kaanapali.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/kaanapali.dtsi b/arch/arm64/boot/dts/qcom/kaanapali.dtsi
index 9ef57ad0ca71d..9be86479ceef1 100644
--- a/arch/arm64/boot/dts/qcom/kaanapali.dtsi
+++ b/arch/arm64/boot/dts/qcom/kaanapali.dtsi
@@ -1239,7 +1239,7 @@ intc: interrupt-controller@17000000 {
 
 			gic_its: msi-controller@17040000 {
 				compatible = "arm,gic-v3-its";
-				reg = <0x0 0x17040000 0x0 0x20000>;
+				reg = <0x0 0x17040000 0x0 0x40000>;
 
 				msi-controller;
 				#msi-cells = <1>;
-- 
2.53.0



