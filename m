Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3055DF2F;
	Tue, 23 Jan 2024 01:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974399; cv=none; b=QZpzngyyanNrkccwqrw8zQi2096CCYpg7rYiwcgj0visCIc4+pfEP25pNEK2AluUPQuHfGq4tbF/UsY3zgLJNZDivHFpNfB9OLI+xmUAy8qrHBtnQxW6vGOUaInH+rS4BrcWJOzr3nIhKZzY3nyG0pDrt3LQ38abOp/pYy3mjE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974399; c=relaxed/simple;
	bh=9plvsaCSy508dlM/BMjAuVJ7zdwVy8j2V7r4wqcjcG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djXPV1Oq3XaWMYE6unBmU3nmwsiEC1heDDjdnH4R86PPUu2BVo6CKh3TnGtcFqHU8Zapz5JrIL+H9IKLPnU7BxNGMkcTX6AOrJoZ02a0Tp7jpkvSwEixjQ9414ACX7A77PmoU/G8gzJSZD6XSnX+3NlryuWnJIByIXQ1l34G0r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8cx2E0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8cx2E0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23814C43390;
	Tue, 23 Jan 2024 01:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974399;
	bh=9plvsaCSy508dlM/BMjAuVJ7zdwVy8j2V7r4wqcjcG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8cx2E0Q0H4T+v4hBYZJEHY0JP6kjKMfERkOHJdWYXR26X6xKgMx5V29r6TsvXKLZ
	 I/xKTLLpstdVyHCH1uajj4Icz8SUYnxnkJMiTj/VlJ9XA3fK+Hx1UsbhCdShd1gk5L
	 UAuQV1Fdwp1/bKLiqjQ5OQUg5G4wFlcFsB3j9id0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca@z3ntu.xyz>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/583] ARM: dts: qcom: msm8226: provide dsi phy clocks to mmcc
Date: Mon, 22 Jan 2024 15:52:16 -0800
Message-ID: <20240122235814.765296981@linuxfoundation.org>
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

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit 836d083524888069cd358776a4e6c4ceec04962e ]

Some mmcc clocks have dsi0pll & dsi0pllbyte as clock parents so we
should provide them in the dt, which I missed in the commit adding the
mdss nodes.

Fixes: d5fb01ad5eb4 ("ARM: dts: qcom: msm8226: Add mdss nodes")
Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230712-msm8226-dsi-clock-fixup-v1-1-71010b0b89ca@z3ntu.xyz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom/qcom-msm8226.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/qcom/qcom-msm8226.dtsi b/arch/arm/boot/dts/qcom/qcom-msm8226.dtsi
index 44f3f0127fd7..78738371f634 100644
--- a/arch/arm/boot/dts/qcom/qcom-msm8226.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-msm8226.dtsi
@@ -404,8 +404,8 @@ mmcc: clock-controller@fd8c0000 {
 				 <&gcc GPLL0_VOTE>,
 				 <&gcc GPLL1_VOTE>,
 				 <&rpmcc RPM_SMD_GFX3D_CLK_SRC>,
-				 <0>,
-				 <0>;
+				 <&mdss_dsi0_phy 1>,
+				 <&mdss_dsi0_phy 0>;
 			clock-names = "xo",
 				      "mmss_gpll0_vote",
 				      "gpll0_vote",
-- 
2.43.0



