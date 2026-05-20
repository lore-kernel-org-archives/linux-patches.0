Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC203A3833;
	Wed, 20 May 2026 16:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295814; cv=none; b=Cb1kcX9KcLAxtUqC8FWBLCxE5JwZ+h68CsbOLYdOxw+CObKQ0joCWXKRLJKT/SIM8P0bHJwCx4d8F/ZuDGFFtjyWHWbk5Q2d4LJmyEu+TGsHAWu3a6GDet3Lp8RJILhsrXVmFlKgWuEnmwW/B0BE+0NcGJcR6k2/MVC9NTx6z/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295814; c=relaxed/simple;
	bh=6Yygg52Qg0k0Nx3sSciR1s1LcIa/SBOG5GEIEnWfi+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdZkolw1N0BrfgpvxEa0LPWwMxNIgbJ1rnDQRxYEKs3pwESaw0aIK/tfEVzebzAQ4YSfzkqtRJIjlnjinA8kLQ0gO3vrwfyTl4M2C9+I19Nzp6jQ9u12IitOy0emNbtrwQtsZnnnvSHu1rLdBbqYIE1BGsVqgm0QjC/s5CZAhmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHWY5DIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHWY5DIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BBA1F000E9;
	Wed, 20 May 2026 16:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295813;
	bh=d4lKQEGQK30Cs6SlCK4WXU2E/9TL2uMCyFE7CZR07I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sHWY5DISuVcQNnAE9jkDadITbSctkWTl35xTWxofy3Di2YKOsPSw+O1YosNR05KpW
	 2x2HsIuzXyJmkyMZGXi2PYMBTY2DyV+8blLzQYctrWMfwLNacTLVaL0GaW4R7lfHuz
	 qVMpPlaLp8dRCCVFlF8bjdPRw1sPvf3u92jvvrBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0521/1146] arm64: dts: qcom: sm8650: Fix GIC_ITS range length
Date: Wed, 20 May 2026 18:12:51 +0200
Message-ID: <20260520162159.974621990@linuxfoundation.org>
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

[ Upstream commit 6c8e2ca1263d0da5976418ed285eaec430e8d87f ]

Currently, the GITS_SGIR register is cut off. Fix it up.

Fixes: d2350377997f ("arm64: dts: qcom: add initial SM8650 dtsi")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260317-topic-its_range_fixup-v1-5-49be8076adb1@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 9437360ea2153..070e8f706c239 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -7219,7 +7219,7 @@ ppi_cluster2: interrupt-partition-2 {
 
 			gic_its: msi-controller@17140000 {
 				compatible = "arm,gic-v3-its";
-				reg = <0 0x17140000 0 0x20000>;
+				reg = <0 0x17140000 0 0x40000>;
 
 				msi-controller;
 				#msi-cells = <1>;
-- 
2.53.0



