Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942D042B32A;
	Tue, 21 Jul 2026 19:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661551; cv=none; b=nwC2vAFRZiZ5WensxliHGbbv0qghWgeyPveOH2FRmhbh3OdAL6EZYD10O9I7Ho6Qkf+NdSfI7A7OA0GEeDsTGjwvN2EiMjFEEtPrFoHVAmEcnbsXDu2StB1TKPJZMkiO4Po/ikYvGDIFIiWCauhik23p8bnkyTj0x/RJ/yPeV3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661551; c=relaxed/simple;
	bh=n+twUS4wuQghuu7rlFmmcT17jVBJHNqrKPzFJ5F1yl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XH0MS5TmkmOgvlpnq1wvKHSOpqCMPgBizFtsu0dgE5yVG5bpXQ1vvt/tPAmRUmjyL1FVvUNsinPMMatAIeMeFSuYqaLu7zFvRXlxEWfDoCGfLu009BLtymBeO2GEw1GzlshP6fg+8mDIqLoQDzSgbakyrZ8W9EgwDicoQO3Pd20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNzCB5Ki; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNzCB5Ki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDB41F00A3A;
	Tue, 21 Jul 2026 19:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661550;
	bh=bIBLyKFVz3Sn5YjItOkV7JJfFMn0kKZ62rHGzriKBKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vNzCB5KiLrROsfnVSpFJ7SpFpJ0+fqQrQD69Oj74Vq38sbO2mkqLU/m1m1+/GeE6M
	 uSAj5Y4bEEbBcZhL+PhCEWr1m0svpMFMJBa9QbdL8znKTv30UfO8RVaa9vRrCdSPff
	 x+s0MitovRcD07UMm5hK2SdqDVl4/EUOkzkRHgAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0109/1276] arm64: dts: qcom: sm8450: Fix ICE reg size
Date: Tue, 21 Jul 2026 17:09:12 +0200
Message-ID: <20260721152448.536941835@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

[ Upstream commit 7fb3d0512dacc0d09217eb45057357f00298203d ]

The ICE register region size was originally described incorrectly when
the ICE hardware was first introduced. The same value was later carried
over unchanged when the ICE node was split out from the UFS node into
its own DT entry.

Correct the register size to match the hardware specification.

Fixes: 276ee34a40c1 ("arm64: dts: qcom: sm8450: add Inline Crypto Engine registers and clock")
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260402-ice_dt_reg_fix-v1-2-74e4c2129238@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index f5be69e3be997a..af53f0a88ee795 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -4543,7 +4543,7 @@ ufs_mem_phy: phy@1d87000 {
 		ice: crypto@1d88000 {
 			compatible = "qcom,sm8450-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
-			reg = <0 0x01d88000 0 0x8000>;
+			reg = <0 0x01d88000 0 0x18000>;
 			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
 		};
 
-- 
2.53.0



