Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B3017CA12;
	Mon, 10 Mar 2025 17:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629023; cv=none; b=JWqcZA488yIijQI3b9F51/Qbo4RZUIinIrVCjEFLyIFLUSfQxE0Wipm6gbWMFdTC+ec/jEV6uqvbNNyF/H4ma0JE9h5x+6/WKlmtKPIFMBmcNA/O0tTpgD0tHfM1jap0M2XJ/eioNuv/SzcaEmRB1/AsBNEc3t5OFmmvMRFwgdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629023; c=relaxed/simple;
	bh=fSzmUCbUa990q4VD298wIyBXzn98o8/gV4BoNtPrnX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daAZaEfOSJt+H68Tgj+rHvszvwuzQ2yrAiwB7Mudtjy1L7biQ/L3lGRYtEsZj/tgSdt7bWL86wh02xcaLQhTVyCStfw3UEupx6iaCesuSDO36a3iO7o+RAoH5G6NDXwkPjrHYJ1jfQXw2oOdUgcg7ybhEK3VQQaYIi6qSItD5Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iFufHNtn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iFufHNtn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DC9C4CEE5;
	Mon, 10 Mar 2025 17:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629023;
	bh=fSzmUCbUa990q4VD298wIyBXzn98o8/gV4BoNtPrnX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iFufHNtnHs5lAnFa2rpmTenlOqRhvDoBDaIz4mbXzS8odnhZqQlDlv9o6vEVmVauk
	 OodUlARTdePIXrZsvwLyGks3qxh885yOJSegXviHWqB8pQoctITRmaVAfpDeEdHsQ/
	 B+XAck0V9Har6TkWBwTE9MkSQavYVj8B3YNCbZAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/620] arm64: dts: qcom: msm8916: correct sleep clock frequency
Date: Mon, 10 Mar 2025 17:59:25 +0100
Message-ID: <20250310170550.299696135@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 668674059d485..79d5f1433800f 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -105,7 +105,7 @@
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <32768>;
+			clock-frequency = <32764>;
 		};
 	};
 
-- 
2.39.5



