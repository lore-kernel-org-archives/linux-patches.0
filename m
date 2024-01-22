Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84D95D8FD;
	Tue, 23 Jan 2024 01:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974978; cv=none; b=gdUWnpX77RKMGVT94l51XTH3xcZvdLoPRJ/aHgXL8BWixhaTSXnWoOSqDsAoWT58mYLd3G71BbYsiNtYdesqDDu22SHrYuIQs2wzBfW1ryr1uCdazCQG0PQBktxdbF4iT2KAtMk8wd6FLGjnsjeimDoFMpUWRd+d+XJEivJHsLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974978; c=relaxed/simple;
	bh=8xa1o9Q1H7wqKDLTveOXzEB53uo/Wcq53fTdxupHNkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRtMyG/9eH88Z2weVPXhnZ/F17+l4ICCW1lI2jYg9C5FF3ooI+fsTr15Vy/xknij0482ucY4VL6trzYS3M1zWM2C/ma6FTx+s21KPeoHZBI94Ag1WXejMvp2L93ZZqHHOGBsBV/NKsaKEs1aulFKaSRZkRLv097wF+Sh0ZZ9nJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JnjHgFVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JnjHgFVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D264C433F1;
	Tue, 23 Jan 2024 01:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974978;
	bh=8xa1o9Q1H7wqKDLTveOXzEB53uo/Wcq53fTdxupHNkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JnjHgFVd0ze9e5798lpGlMSmjvUnigHMsy9a7bfKzcbWym+qkYN+Y9FDmrMWTSBwe
	 edTmOXiAnCX9XvOGm6Pw4r1x23ClVBqyQ89iW1+VYpBxdJjY0jDkWifUtHFeH0B9AH
	 1f/ALlDe3Fcq6kw8C0wXqgmUk0oVJvLJVixVY1xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 177/583] arm64: dts: qcom: sm8150: make dispcc cast minimal vote on MMCX
Date: Mon, 22 Jan 2024 15:53:48 -0800
Message-ID: <20240122235817.433119639@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 617de4ce7b1c4b41c1316e493d4717cd2f208def ]

Add required-opps property to the display clock controller. This makes
it cast minimal vote on the MMCX lane and prevents further 'clock stuck'
errors when enabling the display.

Fixes: 2ef3bb17c45c ("arm64: dts: qcom: sm8150: Add DISPCC node")
Acked-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20231215174152.315403-2-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index d7a2c3567532..32045fb48157 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3959,6 +3959,7 @@ dispcc: clock-controller@af00000 {
 				      "dp_phy_pll_link_clk",
 				      "dp_phy_pll_vco_div_clk";
 			power-domains = <&rpmhpd SM8150_MMCX>;
+			required-opps = <&rpmhpd_opp_low_svs>;
 			#clock-cells = <1>;
 			#reset-cells = <1>;
 			#power-domain-cells = <1>;
-- 
2.43.0



