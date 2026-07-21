Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA0F40B112;
	Tue, 21 Jul 2026 17:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655785; cv=none; b=SXPxGrt8Wwy55SCza8d6rub+ewNod0miMRAOiUBUXDlLVEsf8vn2/k89T+P04tXEhiZxNUILsIw1rn5HhOQztvNHzDKH4JYep798fMZjxNvo3efuh70r//x1l2vRgNrz6TNxa8YAPgR6WciH2pNSWmBkZG0GkqweP0AyBBfZ+lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655785; c=relaxed/simple;
	bh=rAwxxMSn4vDIqAYbu5heYLrA8YNUyixSDExy5RoHVQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/9uhC8sez2iHQFUB50XK6fOcex12sYS2NidfR0dqNOmc0upDlK9aWoj60bCPdAZCTCJNNzOvmlIBFFlEc293gce22DXSSLw9SwnRPWzbWVU7BoYk9jxeCRUvY3r0t5t//j7PF51OKB0h+CujEvlFIorQ4//Pp/oD5VML9jAoHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y5NONAcX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y5NONAcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D0A1F000E9;
	Tue, 21 Jul 2026 17:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655783;
	bh=USUCZrZlb0UE1M2VLfodUxbJTfm8HMchvhMrctTx/8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y5NONAcXMmR2G2ZG3FlqaiXq2WE455VioZLIGoquk1dlo4crBpuF1/KH/FiXhyu3W
	 sy+GiPWI/4oYZjcwWO6Mfa4vnHYy2v3106ORWHQBxQ7W3/2+jgB/H7va1bYdFIVjxx
	 FDvEaWDbsTx5ajsn3X2UN0SHjtaNYEitw40N5Yfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0138/1611] arm64: dts: qcom: kodiak: Fix ICE reg size
Date: Tue, 21 Jul 2026 17:04:14 +0200
Message-ID: <20260721152517.977898088@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

[ Upstream commit fa9c7403af64d3e56a6c20dedc60e0a55b527509 ]

The ICE register region on Kodiak is currently defined as 0x8000 bytes.
According to the hardware specification, the correct register size is
0x18000.

Update the ICE node reg property to match the hardware.

Fixes: dfd5ee7b34bb ("arm64: dts: qcom: sc7280: Add inline crypto engine")
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260402-ice_dt_reg_fix-v1-1-74e4c2129238@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 4b04dea57ec8cc..07cabbb2058f81 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2573,7 +2573,7 @@ ufs_mem_phy: phy@1d87000 {
 		ice: crypto@1d88000 {
 			compatible = "qcom,sc7280-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
-			reg = <0 0x01d88000 0 0x8000>;
+			reg = <0 0x01d88000 0 0x18000>;
 			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
 		};
 
-- 
2.53.0



