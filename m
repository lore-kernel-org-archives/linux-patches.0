Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6C046AA89;
	Tue, 21 Jul 2026 15:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648432; cv=none; b=fLZySs7FDHnhfEHEoQ9HIxz+GSZ+1QkoS7M0SeuvoM5ZrBxoDvcoUQxgFRU9d8NVfiT1qezm09K7SR+TQDe20TvfBU3wdcQ/2P1Uv1sDvKPuFHdj6k6bRYzzVm1qbkH5qJaAkoo3UhVO+HLe2q1hDfbQe69RKoMzrQ5v73yC2Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648432; c=relaxed/simple;
	bh=HGS3OMIzr8E/UhOV96Ux9bRPMDNN5w7fOyWgiaSy8LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6FJbPLdCSC+ROJ1N73GkHW2M652ptq+tmATJMu/rl5oPg8PXpC7hqaQJVgJ1M2VBpzvWZBCHEL87gR6WX7+spfzzwgpd9Y+eXQSjqB/ElSLbCTWKXBdbB436zoiNNRR5QzUlJvYck/nAya2KEDmlOKboQuTYMijyKyI+IOc5yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQgIcKtD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQgIcKtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EA21F00A3A;
	Tue, 21 Jul 2026 15:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648431;
	bh=OW+lsfuLY08AV3M0dUCkhYCWj3K97cDN8FCiCx8mc1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PQgIcKtDablsYNiIxkb0CJQNMjYuDdKFHBb5aVbk4vQqqceFdpU9kT+oMU2YRzwf9
	 +W5aELNqQAnPb019eJ9s8D1aIeCgWmbXbzt4A7VMpsohrjzO7yKzpKdF6fw2Da+GuE
	 mLFSR4E35+HvFlr3+xMv0a1HL8yn6OtTkvpH+5nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0197/2077] arm64: dts: qcom: sm8450: Fix ICE reg size
Date: Tue, 21 Jul 2026 16:57:50 +0200
Message-ID: <20260721152557.327399135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 03bf30b53f289e..e0c37ce3042a22 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -5373,7 +5373,7 @@ ufs_mem_phy: phy@1d87000 {
 		ice: crypto@1d88000 {
 			compatible = "qcom,sm8450-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
-			reg = <0 0x01d88000 0 0x8000>;
+			reg = <0 0x01d88000 0 0x18000>;
 			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
 		};
 
-- 
2.53.0



