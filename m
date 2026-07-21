Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD11B46EF95;
	Tue, 21 Jul 2026 20:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665683; cv=none; b=ia8F+1EqxuWmoJymkjOGAqL051K9Gslw0aJXheYJHOVB/mlcUZLegDT7Etk95DBp84Rc6eCx7ytMwfIbVfuhE1D9krCIkV8pMzSSdRkS8zhhdHfz4F6qTGeCqeDOy5XdV4/xb0jv2yp67/HnquuUv2JsuUGp+6Fe5Uhsx5LnWRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665683; c=relaxed/simple;
	bh=OlbefpG6fEN/zKiaLo404PigAupO8ppZG1XBAg5LibQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O21ndsfPMFprCAQyFKZrDAX70+zRED+j+5AUPot4jc1wfDL+z4K0OvCMJanbnyKpml0DRCKOeVTbUgk/7tqQwRj7YUbHYRtDLJpZdXPbCCviAUz0yQx2XaQsWyXflEfoMG6WxjiNou6X8bIPJPmIEBsoC5KslmJRhdG6/Ohz774=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bguC2JbA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bguC2JbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4481F000E9;
	Tue, 21 Jul 2026 20:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665681;
	bh=KDr5juxPxbGwVY4FX2NskFpolz2/i3YJ1PdWj0i/XZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bguC2JbA0/7ibFxYmD2rd8MV3YPkPo6F/NZEzXEHu6Qvin1v5JyUAZH1GUZHJ1+09
	 gQmahNpp4VDVoFfOhMOh2zmNqjtuRipMoQBGsa/t3AqGpAvhTLh//s+tt/sycTROgQ
	 aVgeJZ7OZ9/eOgChtq+Y2oVpTbSBfvDm5nRAhDrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0395/1266] arm64: dts: qcom: sm8450: Fix ICE reg size
Date: Tue, 21 Jul 2026 17:13:52 +0200
Message-ID: <20260721152450.667046487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c1c62c6d34bd1d..e6c6db754abb62 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -4223,7 +4223,7 @@ ufs_mem_phy_lanes: phy@1d87400 {
 		ice: crypto@1d88000 {
 			compatible = "qcom,sm8450-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
-			reg = <0 0x01d88000 0 0x8000>;
+			reg = <0 0x01d88000 0 0x18000>;
 			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
 		};
 
-- 
2.53.0



