Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7617929A2;
	Tue, 30 Jul 2024 15:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354911; cv=none; b=H+02l+/Sj/lluIGjDHa0Hi/W5+jT5+3P+aoQzN87MhJyWF/U5y3ylGWMbPUPZ1cd8J6NZCcZsKI3eSptky80pO2wMpWGgNWDIyLRXyxidonMyct/GTOTz29P7BT8Qj7nM29JFFuj9eE/hONacMdiL7PmOPQigm5BthtSJy4w+GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354911; c=relaxed/simple;
	bh=3a0E9fgLxT72Kn35ryQRojh6UvnfxtvynYmsKLeAARY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiXL24rwMWMUwbJMDUjWJnXAhggGjDdkD5dc9FwanJ9/LIUwy05zvdktxeQ28e6OuJNyuWbbbdtWZn2uyk9bdho3ITitz8QZiIjoHudwLAks4bjE6FcpLUrvbXTcnZ8514sMrIQgn6xAyVM2nGoe8i8pwQsepTbuVImbU7PVb4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKh1mSD+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKh1mSD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2506C32782;
	Tue, 30 Jul 2024 15:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354911;
	bh=3a0E9fgLxT72Kn35ryQRojh6UvnfxtvynYmsKLeAARY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKh1mSD+5lU5Cp17fPHq2vwwVEB16PV2cubpdLIo0yBkrPbGGLOSDWz0KO/LGY1fU
	 jq9u/Ik3cKOf937x2cCN4pHDFYfARABqVcsNuXuf98vjn4uvc3rckvUVUmG1zgh8sd
	 2Ff6w8j7w9/HWU/KjRo2fCpzOtFZeRU8n1swkJoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/440] arm64: dts: qcom: sm8450: add power-domain to UFS PHY
Date: Tue, 30 Jul 2024 17:44:28 +0200
Message-ID: <20240730151617.135530602@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 128542582b3d8..aa0977af9411a 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -3153,6 +3153,8 @@ ufs_mem_phy: phy@1d87000 {
 				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
 				 <&gcc GCC_UFS_0_CLKREF_EN>;
 
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 			status = "disabled";
-- 
2.43.0



