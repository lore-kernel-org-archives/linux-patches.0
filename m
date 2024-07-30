Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CA6187FEC;
	Tue, 30 Jul 2024 16:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355409; cv=none; b=nVNfuCaMWzyuy3ZDuOVpIQfewePVKv2RWYMeHBYya71Q9HjfT/CBNtcZSSXzj+ncyAi2PkldHdsBZK/+Ao0lrrEJl986YF5GubJfEFlUw01ZjQadA3rt50IboS3nCZRwh8PqQ+VMX/53PY9+xMsUJ94PyYdAXqcmUTK8lIflTgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355409; c=relaxed/simple;
	bh=/n+F+4a4rxjIwPpE6/vImIm9+3TuC8xljEdHrchLJr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFACvUWdvDTtKE0e5Ru604ncFZJn0HfSsSKnfptgbEyqx1OvWhTmc+Hj2gwg9C+5CasvmXwdWzTe8xeGN4ED9/dOvKx5BNlf5ed4fEwzESywSWo8DXP3mM/Xudc1WIYA8lPIHVJ3G39ex7/glBC1SsMqGaEZ4P3uhjglLR5Rlio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DwN5ZJQ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwN5ZJQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B526C32782;
	Tue, 30 Jul 2024 16:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355408;
	bh=/n+F+4a4rxjIwPpE6/vImIm9+3TuC8xljEdHrchLJr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DwN5ZJQ0wXWJkW95iiZJN1VzBdWLAgLmTTlO9cJMsG2AM2JGbZqGeE5leGvP2jAuC
	 4jUEFk/9Jcyy6EAc40llMgDoyoaA4n+Vh8xffWXQmYEVkKcZxZTMg22bI6ywUOB+0K
	 wfXDzRNd2tGM6myBXYtWL6flZg4eCvSyjx6qP+CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 048/809] arm64: dts: qcom: sm6115: add power-domain to UFS PHY
Date: Tue, 30 Jul 2024 17:38:44 +0200
Message-ID: <20240730151726.548421320@linuxfoundation.org>
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

[ Upstream commit a9eb454873a813ddc4578e5c3b37778de6fda472 ]

The UFS PHY is powered on via the UFS_PHY_GDSC power domain. Add
corresponding power-domain the the PHY node.

Fixes: 97e563bf5ba1 ("arm64: dts: qcom: sm6115: Add basic soc dtsi")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-7-f1fd15c33fb3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6115.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm6115.dtsi b/arch/arm64/boot/dts/qcom/sm6115.dtsi
index b4ce5a322107e..8fa3bacfb2391 100644
--- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
@@ -1231,6 +1231,8 @@ ufs_mem_phy: phy@4807000 {
 				      "ref_aux",
 				      "qref";
 
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
+
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 
-- 
2.43.0



