Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7934A188006;
	Tue, 30 Jul 2024 16:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355445; cv=none; b=l+3CmD4G1JhNKtZvIOYJvuMPRsrwEyfpsVLro2gLHwIg/coEP2cHUPX0Oi7FirGNOkJGvk1rviF0delHTcYFi+dG2Ed1o78ZLO70tSvHfQCha4FtH9QUja4fFWmsLO2gf2xSTifLL0VX/m6IGftICjJ6uoR29rFodJTh4txyPH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355445; c=relaxed/simple;
	bh=ojugEbsliIyTHj/w14j3pP8eH7Hg+azQZ33SzGJsnz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msDxthySJVIWR/ATm3t62KtgX7VDFwrhP8oTd6XnOMNaIEwSY53AWNJANgpzEZriESWUDAGm/Cu96Z0HO9qjOEwVl9BfMy0gv5TKUNYBV0Akq5fxrwZREnoHcZqzOwfIqWapNsLgjiLoJohQsasHkq1yYwDiHe2iaekcMeSF6Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lbq15Iyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lbq15Iyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996FDC32782;
	Tue, 30 Jul 2024 16:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355445;
	bh=ojugEbsliIyTHj/w14j3pP8eH7Hg+azQZ33SzGJsnz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lbq15IyrhB6G2iU2lRaqj5B3WhyIlIDiXw1XO8hCpg0jiOBUxQMINDivEIG+Mldx3
	 JCj5AoALgWw5H8iwNNv0q1bgX2gHYxpEj8g/ThXzPLYMGTmtzSbtexwiZEi2orh1uo
	 mFa6ffrJ6kiZkMDBpSIXlbcgvIWmEv2ji0A7A26Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 051/809] arm64: dts: qcom: sm8350: add power-domain to UFS PHY
Date: Tue, 30 Jul 2024 17:38:47 +0200
Message-ID: <20240730151726.663839134@linuxfoundation.org>
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

[ Upstream commit 634acc8cea1584b507801315831a330443f819b4 ]

The UFS PHY is powered on via the UFS_PHY_GDSC power domain. Add
corresponding power-domain the the PHY node.

Fixes: 59c7cf814783 ("arm64: dts: qcom: sm8350: Add UFS nodes")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-10-f1fd15c33fb3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index f7c4700f00c36..da936548c2ac3 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1779,6 +1779,8 @@ ufs_mem_phy: phy@1d87000 {
 				      "ref_aux",
 				      "qref";
 
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 
-- 
2.43.0



