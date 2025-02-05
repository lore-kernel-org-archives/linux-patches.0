Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7B3155A30;
	Wed,  5 Feb 2025 14:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765194; cv=none; b=qWC4b3BZ3HwetBvdYrnbgbRk4DEiTvcdIM8nWaKXp2zobV3dW5mQtTL/tUhx2thwPjDWq0Ub7ivvOcNVG+Wc5WrEgNPzI6+ZyZp8Otjy7UhwutVkM9JVkfYUUPR9RwP+Sj3nXLSmmch0cjbcVBcQIutfPqKEnxEmJ45uXv9Q9jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765194; c=relaxed/simple;
	bh=vcuTVuNfjUZWTRIOtUNd8hU9Q7BIX21YrIFfkkC0PDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJ2z6K1HfLz1c50Kr/iwRbbeBz+mYzMY6K+2AaJEBCTBdSY80MSIAxph6U8KVTvanSSWtAKRsmUtDwOLAczjMQc4S9EdohmtJCoLEbjnv9n+SP6bPaPDU6aUpjAMekJIWwrHUPORyBiLFY5a5mp0Y1AxTljVh29yQkIqKrp7Lws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1+apFlg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1+apFlg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C260C4CED6;
	Wed,  5 Feb 2025 14:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765194;
	bh=vcuTVuNfjUZWTRIOtUNd8hU9Q7BIX21YrIFfkkC0PDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1+apFlgzFrhoI0HaGdJycLCkMbIF5FE2Tmrv6p1dUo3Yp4dlX4aJHETgDbKRuET5
	 40KGjQm1s3sZch5yXpcwZGU9W9NCNaIb/VJMfMGxNih0gkA4jOIfPbtkyoCRDbR+l9
	 g9iCbe0/kbHehhCTdekgZ2SSDjkE7Hs82oqRCspg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 242/393] arm64: dts: qcom: sdx75: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:41 +0100
Message-ID: <20250205134429.564392408@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit b8021da9ddc65fa041e12ea1e0ff2dfce5c926eb ]

The SDX75 platform uses PMK8550 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 9181bb939984 ("arm64: dts: qcom: Add SDX75 platform and IDP board support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-9-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdx75.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdx75.dtsi b/arch/arm64/boot/dts/qcom/sdx75.dtsi
index e180aa4023eca..0d1b5712c5067 100644
--- a/arch/arm64/boot/dts/qcom/sdx75.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdx75.dtsi
@@ -29,7 +29,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5



