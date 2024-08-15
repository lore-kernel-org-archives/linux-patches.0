Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318CA19DF60;
	Thu, 15 Aug 2024 13:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729185; cv=none; b=KV+VG6nL/V/d5UVkYwtUBZo45OGiK1b5ZR2cxP3yfp0teYApSZvvGB8+eCqVwyfmziO9f/jTzxA4SZh55+E8Kj++4FYpjuqr3/IFsZG8PC52AGJ8jre5EQZRH0KJnPUd6tya7ZQl1vzwucZCJ3UkxwJLf4PmRahvfab5zRDiBGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729185; c=relaxed/simple;
	bh=xifX7vPvK41qi28MR4gHzrNqOfpmtQ9c2LRj2EPF+UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aw7C6Ff8Bj8WHG7MEvPk9GSDnaRwaSPw4CDN5pvjqF7W/cf5y9PGUg/aTjGbSAwVfFI+ptrhOwtCwoahVQqCu8fvfwdc7ZeBDxhPNpT4KJAKPARsbIcPYYS8v/e1B4leAoiMCLb4Njj13Qs+G5RPRvE1xQWpnUnGmiQf05MF2kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBlsXMGL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBlsXMGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE575C32786;
	Thu, 15 Aug 2024 13:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729185;
	bh=xifX7vPvK41qi28MR4gHzrNqOfpmtQ9c2LRj2EPF+UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wBlsXMGLLC4wXi8FGLSX/G2A6QEpecnURWiN/Tb8h/HZWZBe9PIuQvXWhOwEoT262
	 3LFc79KfjL62w7IPjx0P5IwjtXL+4MqW7diQE9bG+ajPMC5LowOUmrNy0vJgq98IEe
	 t2Xrd6+hqiL+WK1UtnG6d5brBefr4lL0JDlMG1+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/484] arm64: dts: qcom: sdm845: add power-domain to UFS PHY
Date: Thu, 15 Aug 2024 15:17:56 +0200
Message-ID: <20240815131941.975837853@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit fd39ae8b9bc10419b1e4b849cdbc6755a967ade1 ]

The UFS PHY is powered on via the UFS_PHY_GDSC power domain. Add
corresponding power-domain the the PHY node.

Fixes: cc16687fbd74 ("arm64: dts: qcom: sdm845: add UFS controller")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-6-f1fd15c33fb3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 6f7061c878e4a..cff5423e9c88d 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2299,6 +2299,8 @@ ufs_mem_phy: phy@1d87000 {
 			clocks = <&gcc GCC_UFS_MEM_CLKREF_CLK>,
 				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>;
 
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 			status = "disabled";
-- 
2.43.0



