Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C1C1FCD0D;
	Wed,  5 Feb 2025 14:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767326; cv=none; b=DCDmaL9kYk89CxXsayC+JEyVS4lsvP4nFtaIRtYFGcrLu3jh8ys4cyEfSeoBsvXp0hUQG1mlSxoXwnJwhB436tzfU4Q1NgZa+lchXhVEBM54Yp70iByz8GZy1NVhlXgC7Q4oi7Pkxfigkp1kxKvEb8/VLblGPIf6KOONCKrVEzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767326; c=relaxed/simple;
	bh=eqOya2+wzaKZ99u7P5gaX3sdp8cdgsNlyeDGCTM4nA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItGcIgZgJSZkQL+xJDcikpihWJL/FeAQXn9cXD6iTyDcEXRd5jr1upadIvv9F3GDcp05S8ugY348Rkr4A+h7UJ0rhZ75diwOdEuAs3iE1RabHySa+qQjHwSZY9AZ8mS/Vac3XKcK1u3OaMSD0CJKA4G+itK2tzaGMSCE4nNNXJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FermMYSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FermMYSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD5EC4CEDD;
	Wed,  5 Feb 2025 14:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767326;
	bh=eqOya2+wzaKZ99u7P5gaX3sdp8cdgsNlyeDGCTM4nA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FermMYSRhYpYQXNaSYgi7FFG9blSdRqRnH3GjeZhV0UHBVfFJRRc8i/xRwTCo/Wq8
	 APoBrkOqnM1L6JMDoDjf3FfZAa9dz+SHH2xDDk4HL5gythaCwQ3JDiTj1WkisScK9M
	 R4mY2iOayoq5iWe7r9ezZCQxHVlj4E+KFThuFH7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 388/623] arm64: dts: qcom: sm8350: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:10 +0100
Message-ID: <20250205134511.065539990@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit f4cc8c75cfc5d06084a31da2ff67e477565f0cae ]

The SM8350 platform uses PMK8350 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: b7e8f433a673 ("arm64: dts: qcom: Add basic devicetree support for SM8350 SoC")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-14-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 877905dfd861e..15b7f15b3836d 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -42,7 +42,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5



