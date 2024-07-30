Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CBF1BBBFA;
	Tue, 30 Jul 2024 16:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355209; cv=none; b=CdgugPeTInAgfRIDn3nWJpn5AGie1l0ZPf517XqcMBSrAqQyWoJmicNAnzv2c64r1ShFm+Fd6QDs+8gh9uW1PY/XN9LoqeqtqKNgWmnNhNgET2u9G5rx0N2kM59FIJVZB5+J1ZA0h6ljpopwXLGC447kUt8C/22RbfmWF8+ypCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355209; c=relaxed/simple;
	bh=ZHhqdF+50qKW8WdOHSCBTShF5ePVPmtdjR8V2sDY8zE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZG5ZhisZo9HKw0Nxm70FPaEnZQsg9rxfjFptar/m96daYylA24MWIVNVrsZlDI6nfhLRiLwdcEQ7L0ShzISEGOp9ga1mFsyKWj7FbAUs8Yfhg2/Zs4OnG39kJ1kReD34KbAh/Ylb0CRHhcar505VPaojBXSPEVemNy1NB2MQ2kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tQ6ljGwx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tQ6ljGwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63494C32782;
	Tue, 30 Jul 2024 16:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355208;
	bh=ZHhqdF+50qKW8WdOHSCBTShF5ePVPmtdjR8V2sDY8zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tQ6ljGwxARiGK3pkTJtRnfL+kMERjHUrftz4nDejPaILK1KC+XXfcK6Ghs3K8QBMN
	 YtcvoHZa9FGrnq+a0M4sqv8M44VoRgQbvMko1uRrSPGo52k/VWNd7mHeJopM/u+1q4
	 GKQzUGPKkENijX1z3Hym9gesuWQmbHUTJVa+wpVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/568] arm64: dts: qcom: sm8450: add power-domain to UFS PHY
Date: Tue, 30 Jul 2024 17:42:24 +0200
Message-ID: <20240730151641.289295788@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index 0229bd706a2e9..a34f460240a07 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -4200,6 +4200,8 @@ ufs_mem_phy: phy@1d87000 {
 				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
 				 <&gcc GCC_UFS_0_CLKREF_EN>;
 
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 			status = "disabled";
-- 
2.43.0



