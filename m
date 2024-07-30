Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3728718455E;
	Tue, 30 Jul 2024 16:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355483; cv=none; b=kLHxcGUq1BaGlF3XIHU1XGH6rS7/YpyLpVgkWnX6PurP6nAkTKR8lzUzXJVxfC4yH+5iep7fZ0QaeNecNlCim4txf3jXqoZjRlf5l5b2dXKdvlm+tLO4sjl8z5WfV52sOH9N7NSuRUxFG+mF/zGXdTUJnNGDb/0/xxP1ha6LNMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355483; c=relaxed/simple;
	bh=0MPaMaAtxZx9Tf5zGeAhbn3ijfJPv75dFeSbHqm1HBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5V/TSih253oGQyZWEpx5v0r7qR/q1UPA1pEGqkNIQBs/TewrMgsfOaDmWh8NgaPGofUYrWi5CkCnOLy6HdG1uBQqIxDI4n1hbCjvctRwzsygee7gSa+weeDrTA1fXEIkqvQ5ByJ0QEz9Ne0bqIcHUAs/Rdt9HeFzWYnX0Dp8Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKECS88v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKECS88v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98199C4AF0E;
	Tue, 30 Jul 2024 16:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355483;
	bh=0MPaMaAtxZx9Tf5zGeAhbn3ijfJPv75dFeSbHqm1HBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKECS88v1X3EmLC0ouZorsAfO2hlHOugX3+uMnoDTU7ge6vzsUzmHmjPbI4mljdX7
	 B50ZjwvkzriU1yQikiXv32i80ow0C7G8cwUVG/G3PyQR5/0aAFIHmm2vPeL8RxBxMX
	 VBezhzk+STKD9wtDzi8wnXoQ8GbfuNDtmZxm1YxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 052/809] arm64: dts: qcom: sm8450: add power-domain to UFS PHY
Date: Tue, 30 Jul 2024 17:38:48 +0200
Message-ID: <20240730151726.703047991@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 27d3f57cf5a71484ea38770d4bfd10f6ef035cf4 ]

The UFS PHY is powered on via the UFS_PHY_GDSC power domain. Add
corresponding power-domain the the PHY node.

Fixes: 07fa917a335e ("arm64: dts: qcom: sm8450: add ufs nodes")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-11-f1fd15c33fb3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 616461fcbab99..59428d2ee1ad8 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -4429,6 +4429,8 @@ ufs_mem_phy: phy@1d87000 {
 				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
 				 <&gcc GCC_UFS_0_CLKREF_EN>;
 
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 
-- 
2.43.0



