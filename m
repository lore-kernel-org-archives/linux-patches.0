Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4CE1591E3;
	Wed,  5 Feb 2025 14:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766851; cv=none; b=Lc2JIYXRVJVmj1eb/Z9D/iVrUpNoCb9d362zNKUxOI3G9tyxXd2rh3Y/55t8ro+kxma7KW8VbS1AxZarztjjkOBCtOodiEvqeotBsWlcDDp6Qt+9RODEt/3pNuSe9czt4w+I3hfrz7KMmrTDOu+NwU4CRgsyC/1AHbnDpGEXipU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766851; c=relaxed/simple;
	bh=ziKt5O+2CJgERT69w7Ltz1wWdfJHwUiB6LnmQUZD7hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+Gl5yuLz6i2UaHYZRyZcxKTFpWxJ0TqXBvcDO4PgFcfpLUO2g7gDARVzlFPPJTVtvirLC9hEN1AOr3TaNdp4TQAMeYIQdj3omRRumn1rmdnlLoGEhP/wpEcfpZ6OI0Unnr/jLvIoqjEOSSVypOt7FkkQQDa6KJZ/LQAk08pEPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/Wu9F1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/Wu9F1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1891CC4CED1;
	Wed,  5 Feb 2025 14:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766851;
	bh=ziKt5O+2CJgERT69w7Ltz1wWdfJHwUiB6LnmQUZD7hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/Wu9F1FhtEaF0B3xkhovEz15grA6NrjVot1Z488TH+/yLZwC0AkVqsfoHDc4ZjEs
	 CSKjRaLw5j+VkaEPOMt+eVc7v/Q71ncw5+k0zBSA6NNxHWPFWblJvwirE2hEzNEaEM
	 nqmxYpY+4M7uWaG+kqh3gr0NQWhNWj58f+KwEaws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 343/590] arm64: dts: qcom: msm8916: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:41:38 +0100
Message-ID: <20250205134508.394401839@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit f088b921890cef28862913e5627bb2e2b5f82125 ]

The MSM8916 platform uses PM8916 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: f4fb6aeafaaa ("arm64: dts: qcom: msm8916: Add fixed rate on-board oscillators")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-1-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index 0ee44706b70ba..800bfe83dbf83 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -125,7 +125,7 @@
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <32768>;
+			clock-frequency = <32764>;
 		};
 	};
 
-- 
2.39.5



