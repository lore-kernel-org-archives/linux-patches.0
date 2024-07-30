Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279BE8BE8;
	Tue, 30 Jul 2024 16:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355374; cv=none; b=YDS8/P1OX+VzNssPjvBfq+54gcfbHse3M6zeKbWfvqItSXQhKBECcEcI3QaHPTTCOSPEAv68NCZPOAkUIlGO1TW4B3ogWHzlnrcKVGIYljd9DRT2KdM6X+QL38q64+C/5feKKS/QJbT/yFVOcd7HwZntMrZOHSmWM5xlx4aOa9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355374; c=relaxed/simple;
	bh=f2I1MQSHOSFY5nz7bz8IgzP+/CmyIqRMikA99fskqpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLz1zrsyesYkFCaEA5nld+R/WolSf6M0Z5G78IpObt40FknGsxls7X0Ep3gxIxi6psWTMl1Nh5vGAFvI/QvzPD5psNtuaiguHoCGwJjgMg+VNEfrLW0aLcjKWRsgg/yQl7ZQIJ5tMx7xbV1yRJCH90u+68luXOG+mhYd8QZBXCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xuQVFb9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xuQVFb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897AAC32782;
	Tue, 30 Jul 2024 16:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355374;
	bh=f2I1MQSHOSFY5nz7bz8IgzP+/CmyIqRMikA99fskqpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xuQVFb9upYr8pEUifMN3sdqFss5B/FYsM42LfZfqqtNA27lSjNmmuUqyuwKIDgtB
	 sz7+m0SPQQvaDQfXCZ5P5R5A1YZ9PwsCrm3hHHs0BfOKNSmceNg8G1EK6/LsaRVeiB
	 xKm/Atf08X5SH8jipwUNfR7E9NzDBsD21gy+LIFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 045/809] arm64: dts: qcom: sc7180: drop extra UFS PHY compat
Date: Tue, 30 Jul 2024 17:38:41 +0200
Message-ID: <20240730151726.432086160@linuxfoundation.org>
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

[ Upstream commit 48299f604d27dad1168cc90b89f33853162c6e33 ]

The DT schema doesn't have a fallback compatible for
qcom,sc7180-qmp-ufs-phy. Drop it from the dtsi too.

Fixes: 858536d9dc94 ("arm64: dts: qcom: sc7180: Add UFS nodes")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-4-f1fd15c33fb3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index e9deffe3aaf6c..9ab0c98cac054 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -1582,8 +1582,7 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 		};
 
 		ufs_mem_phy: phy@1d87000 {
-			compatible = "qcom,sc7180-qmp-ufs-phy",
-				     "qcom,sm7150-qmp-ufs-phy";
+			compatible = "qcom,sc7180-qmp-ufs-phy";
 			reg = <0 0x01d87000 0 0x1000>;
 			clocks = <&rpmhcc RPMH_CXO_CLK>,
 				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
-- 
2.43.0



