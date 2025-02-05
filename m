Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27538158218;
	Wed,  5 Feb 2025 14:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766773; cv=none; b=pPKGlTTDhk8CRBp26Z6QpaywrmPVWGcvES7wscCe9b2Grf4Qepo7X9xWniQlqqHyBC0jIrjR13Aiaq9IoW1vKePsee2reBR2yx+5hPilroF3WHztfknwlJbUztkEVbtjbomqTlwgjoj6hguDzRLt+EebQxvh7yuAmceZysHzJ7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766773; c=relaxed/simple;
	bh=FMFYGv/EhxjebEaDn3tKPYsG4WbIhld8YhNS5iuW9sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxF03uruCtekhUfldKxVgOjwgFGQk2U2ve+/GbGnMfvDvnbMzFPC1Uz0yjIbAcVwP7VQxq3km+pRkuFTGXW6a+MhPpQTDiEV5J/nrhNiZ974mB612ipptSHWmiIN2oj86c2YRl9k1H4gNHDhYb/q4sBWUnALkx3bkgvU1hTb0bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qqfppyAA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qqfppyAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E56C4CED6;
	Wed,  5 Feb 2025 14:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766773;
	bh=FMFYGv/EhxjebEaDn3tKPYsG4WbIhld8YhNS5iuW9sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qqfppyAAgSHczMT3BDZTggFkMACwSeQgOkZPzm7Lbnea/NviHbwCqB0YFQxHfMMpB
	 yPIzQV+vtVVpGaq3exdoRjqpY1rPBFOfDbkcUcHStx58r+MmWJzwmf/fSS6pdJB1n0
	 3+CLfCahmxoc7R6L2zUg9QbUTwlJv9vuSwVV/t6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 359/590] arm64: dts: qcom: x1e80100: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:41:54 +0100
Message-ID: <20250205134509.002509195@linuxfoundation.org>
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

[ Upstream commit 67e25a3e12d128336114a5d1572e055a8bd33129 ]

The X1E80100 platform uses PMK8550 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: af16b00578a7 ("arm64: dts: qcom: Add base X1E80100 dtsi and the QCP dts")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-18-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index a97ceff939d88..f0797df9619b1 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -38,7 +38,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 
-- 
2.39.5



