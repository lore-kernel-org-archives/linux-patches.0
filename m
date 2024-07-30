Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5888A19F467;
	Tue, 30 Jul 2024 15:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355184; cv=none; b=jZrPc+bxjED2hY37clOi61vIENNDa3wkZvY7s2VsdbdpvqRmN+oN6ypTAz9yGM1CLpnGdIW2iDIvMvgToYwHySfLr1Vr7esmkeK9ToLq2oXUmUJ2PFQHhUkQRagt8/POKN+D+6NALTLplcdxzesniym+gYaPrUVX0qET83BVrpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355184; c=relaxed/simple;
	bh=C7MtfRcR6QJSWIggq8G+bJeFDI12i8axoOL3NCrziqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNNFbVIi8I82HsZL8SkveaA1ZxbABcEi6FSKed+KzAhlZodhua9FcI0uGho7FtTteZkEFsuZtOjmn0QZ41IYlYDqVSqaQecQdwJ5tWrEWpgLtdR+CVg2Ut3oqg77dcXTkzXn0Qsb0b5oFS84zbbyxGt5ZYOYAjJQDE5Ef+gORlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CR+PetrQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CR+PetrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48793C32782;
	Tue, 30 Jul 2024 15:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355184;
	bh=C7MtfRcR6QJSWIggq8G+bJeFDI12i8axoOL3NCrziqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CR+PetrQ7azs3We5hwLbp/J/xgUZPuLH9QAIFSwtoDii4savry4scN2JzELEcHGCo
	 VcTwAw/92BJI/2MrHROlXCED2Jsi2ZUzJjSTe4dQZRl2Pgp3mAPomsEn8XYIOdDDJX
	 5FG7t8X6mrQZsC4X4Tcq/uY+gmVIFtnuFLE6vy2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/568] arm64: dts: qcom: sm8250: add power-domain to UFS PHY
Date: Tue, 30 Jul 2024 17:42:22 +0200
Message-ID: <20240730151641.210529027@linuxfoundation.org>
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

[ Upstream commit 154ed5ea328d8a97a4ef5d1447e6f06d11fe2bbe ]

The UFS PHY is powered on via the UFS_PHY_GDSC power domain. Add
corresponding power-domain the the PHY node.

Fixes: b7e2fba06622 ("arm64: dts: qcom: sm8250: Add UFS controller and PHY")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-9-f1fd15c33fb3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index a67a12b466f34..b522d19f3a132 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2227,6 +2227,8 @@ ufs_mem_phy: phy@1d87000 {
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
 			#phy-cells = <0>;
 
 			status = "disabled";
-- 
2.43.0



