Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6738519DF85;
	Thu, 15 Aug 2024 14:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731073; cv=none; b=LFtq82oWoHLrXPmjGXylhBFhaGRwyFx6xlkO51LaQHLfeFVvtrybOYQmajKNl0HO/IsEvnbNx/2bW2KkjlfxEJKRTzE36X2oEd0DkGZEdX+MZGkRhYpx/fo23pZxexFuUCdsqWyfGpvxUFdIyVGQeteERnb8gtcqSzt266Fc+AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731073; c=relaxed/simple;
	bh=03Jjm03iytuTNtF9npHGphlC4245isaGhPYKi8FKyhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwImtPKJFFB7+BsA/VbNZeG6O+j3bqCUKiBlG/jWaNI8FDW4jqceP3pvhSWHF0/w7liJ4R6ZTkknyEXLZEm83Ixax4vDBHk8TbKntrITpl5HtpNWzdzVRhUqjam78I3/V9iR95UYkx0di12zQP8PBmcGropguYQcwhfaoow+UyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RH0kWDLd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RH0kWDLd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18F0C32786;
	Thu, 15 Aug 2024 14:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731073;
	bh=03Jjm03iytuTNtF9npHGphlC4245isaGhPYKi8FKyhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RH0kWDLdF+MpNxN4dO3Y5CXDUStoJzmCAfQQUzlKujWUAr9vCUYM/QjR+oAvsTBsf
	 9y6zeFMoi038ITC3Dv7OjzK+B6rV8b6uTP/PEfs0cSPqZPK/N8UQbDq0374bVtXmRV
	 bKjxr1K8JIcHjLwf4IOwnIahQAPWceG6QsD8yQ6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 015/259] arm64: dts: qcom: sdm845: add power-domain to UFS PHY
Date: Thu, 15 Aug 2024 15:22:28 +0200
Message-ID: <20240815131903.383378384@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b4a0234f66d16..37d45a5ab6f66 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -1420,6 +1420,8 @@ ufs_mem_phy: phy@1d87000 {
 			clocks = <&gcc GCC_UFS_MEM_CLKREF_CLK>,
 				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>;
 
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 			status = "disabled";
-- 
2.43.0



