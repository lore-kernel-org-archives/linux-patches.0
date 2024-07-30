Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085CC184535;
	Tue, 30 Jul 2024 16:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355650; cv=none; b=laRJmh3oyWjCD65hTIePRwojvoaV/gqwreYDbe9a03djU4J9DtSyf1jSOV05bKHssU1fK5lKPoYck+9htgotpUyQJDPHuvsXWAqeXip0YiL1S0k9JNVW96AxPMB9UhJS1zAiE8041Ys/Swj802XIRs2E0LnFZsRgyea3k2S0uDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355650; c=relaxed/simple;
	bh=7/pWH99Tvl3iA/0Vo/woFAo7vO+mEAx/ooJR1AdAXsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyE6xe4CnzKsfJj3hIDs8DyfIRsTFtHAaKZQh8S12wI7uM05Y7bSYnOgSMuIWLdlHaVjNd50tpHQLzR9lfOeKaNWgg4bMO85Ibt5cKL3fFZDGWI1Fh1NZHvNBJpZplaHKOL6EMSpaBNiR1lmiGX9Pn1UGBwxLfcwAoEV2Yiz7JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dA8kCc74; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dA8kCc74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FC7C32782;
	Tue, 30 Jul 2024 16:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355649;
	bh=7/pWH99Tvl3iA/0Vo/woFAo7vO+mEAx/ooJR1AdAXsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dA8kCc74Qze22dDP0ujzrhNLgEBrv4jwtV/ypOoFtsHZBbt7BvS/p5JLGKrz1rtHp
	 0SRkd1WcQSNUR7QcBL/O+E3n9Xs5qK09GF/P3ZKXF8sYzu4qvCAus9CqQoxv0hgNGD
	 67Ey3f0ZqfIwakZY2ql6tk2ttjhWzyvcJfqmtyQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 050/809] arm64: dts: qcom: sm8250: add power-domain to UFS PHY
Date: Tue, 30 Jul 2024 17:38:46 +0200
Message-ID: <20240730151726.625208843@linuxfoundation.org>
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
index 8ccade628f1f4..b2af44bc3b78c 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2580,6 +2580,8 @@ ufs_mem_phy: phy@1d87000 {
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
 			#phy-cells = <0>;
 
 			status = "disabled";
-- 
2.43.0



