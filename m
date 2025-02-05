Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262BA1C6BE;
	Wed,  5 Feb 2025 14:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766727; cv=none; b=aPV7giCBDjpuiie7ZvsD/nuGSv6OZ74rljn7WSlf52sfUqsbBdg2wyOiypxBQ2247EOZdX36AqXndpxFzhPnHu2LNP/5n529XGarpQcCUwuEqIOH+1zAG3WfUaSWIgt+TCWFryXBEsJDRTlxdFMY2+ZIR4b1y81FY8PRqtNL4gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766727; c=relaxed/simple;
	bh=u2nhCYlGVJjFbRUOtG1syu5bUmMZDVuKCjGBurX16eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJnh1MvxgVRwxxnfJXjktO3T68Dhpf/T/1SDOyVcqsUIcc3XStgJiSGnWBrHNfojhp4ICc+TDsvSFg0Uqwo8e0xpzm39N7OyhVv7zycLC4Yg9n9qa3P88J5sGydbetN2yBLKmDkXx1TxUsAIwxhLFn8rN9fm5erUwInqBXC7fAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dP1bf806; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dP1bf806"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C504C4CED1;
	Wed,  5 Feb 2025 14:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766727;
	bh=u2nhCYlGVJjFbRUOtG1syu5bUmMZDVuKCjGBurX16eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dP1bf806B02FEh+UV53MkRPXm8VnqXmWBzlD4JoehX1vsBXrSBb/o72JwxZ2r4Bw9
	 boRROaO3K+f86ucnYWvAUAItlz7kRtwKMhmGVVibt42HRmulkTkWE/YvwpYTJBj1Dd
	 9y4jCK+v+vDaLJZ8TZvU70nmvrmlwAizf907B0mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 354/590] arm64: dts: qcom: sm8250: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:41:49 +0100
Message-ID: <20250205134508.812755519@linuxfoundation.org>
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

[ Upstream commit 75420e437eed69fa95d1d7c339dad86dea35319a ]

The SM8250 platform uses PM8150 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 9ff8b0591fcf ("arm64: dts: qcom: sm8250: use the right clock-freqency for sleep-clk")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-13-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 630f4eff20bf8..22d99e4cf96d2 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -84,7 +84,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32768>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5



