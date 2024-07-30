Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E54519F467;
	Tue, 30 Jul 2024 15:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355127; cv=none; b=Dr4qwEuko/NW0mo/QliuCUOTmfat1InLhBUSrq7kKKfIzCCOJbRggDkiHtG4HRqSAcItk0gTYprgInC7q3pYeQCcK28QvPtt+ryqbB9C59k+QDCcP+HBwaVZzJ3GXw8bkj3txvws/NrMNDcAb0CGJqgrNjD4RkP3f7IxTEyhyew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355127; c=relaxed/simple;
	bh=Eml7yy1NQ9JeiBPt5QLh59BrcKXRK41K/DNObgac0Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pq5hKqyOuUNSoMb75SQnmLkn1loV99emgEcgEqW04XaWDgzs6oyPWcr0nPmEgms0tlKvyJMyYtXzlWLAJZSg9MBGiIDaWrwdpltasJ646n4gj0Mth8w9Z7icVeS/g9GrDReN3dxh25LwZFniqs1PxlVXOzsgeFGCHVr3KoC+tU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPeT/kFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPeT/kFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6D7C4AF0C;
	Tue, 30 Jul 2024 15:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355127;
	bh=Eml7yy1NQ9JeiBPt5QLh59BrcKXRK41K/DNObgac0Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPeT/kFs4e1jeEHO7Xgf5OauG8FpiqMtQFVCRvqogdPRt57f7cvkSEa2pvtO9quy9
	 CbrSFoHUQ9mYimw8m4Z+s54L8bsNTFW4I+Q78S73UIpOcnFrK9aSDbp4q2L2Ke1los
	 lmzj4HXSgVnjwSqgmAfSSlPRtLVjjhM4tse90xlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/568] arm64: dts: qcom: sc8180x: add power-domain to UFS PHY
Date: Tue, 30 Jul 2024 17:42:17 +0200
Message-ID: <20240730151641.016851697@linuxfoundation.org>
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

[ Upstream commit 9a80ecce60bd4919019a3cdb64604c9b183a8518 ]

The UFS PHY is powered on via the UFS_PHY_GDSC power domain. Add
corresponding power-domain the the PHY node.

Fixes: 8575f197b077 ("arm64: dts: qcom: Introduce the SC8180x platform")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-5-f1fd15c33fb3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x.dtsi b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
index d310d4c4d0953..92b85de7706d3 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -2142,6 +2142,8 @@ ufs_mem_phy: phy-wrapper@1d87000 {
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
 			#phy-cells = <0>;
 
 			status = "disabled";
-- 
2.43.0



