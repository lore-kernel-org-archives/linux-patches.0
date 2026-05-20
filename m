Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72A036B059;
	Wed, 20 May 2026 16:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295822; cv=none; b=SR5tSXlkiF86vWHg3vKiuJKHqJ79wquTcdifPnRKAN7ZKINTY2WlEZp2xAHmkiX8FLIxLtVwobnQNRTpSb5m+I2wYPG7yXsPSWOWtU3UCsJ6hcq54RjdFG9haCVGZRWRLnGls6VWP988U2muXQ4Fw0sOxjWqioxowgKimJJXRPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295822; c=relaxed/simple;
	bh=CxWg0lj7NBcjdRjIm1tTU7zVqiYf3pR+lYsF35TifvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltQYTd8tBYQ6PWZw6XQ0FGJ5Alkg9oG7cR98lUzQ+SxOE2PnA2+ULYtj0jVZazQCjwtrrj9UMkRRffIQY57dp+779x0+qYVWg/n1Yj4nfhp/tFOOOTktjCTd428jGwoYSGfopt6MhacWApMqkdIiF/slNq2SnVUkDUfIH0eOqj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKnoAf7a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKnoAf7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1958E1F000E9;
	Wed, 20 May 2026 16:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295821;
	bh=Fi+B3ljpbstvwNCiQS6tCRvbZXKV4FegnmF3/Q8X+lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sKnoAf7aOxM5EbXtrBT0dO6mqiOC5tlZzLLnCqZQQAe316ERmsUyukKAjFGsKmmJC
	 IML25oszFAISYzjqVvy0sP79lM7fF+SbsstM9jqqGOh6UN3fEe4TNqtSbp2nyoPeeM
	 VJY3by/JaY4RkjZyug17e0c+B+RxmIvDuYeWNyvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0524/1146] arm64: dts: qcom: sm8650: Fix xo clock supply of SD host controller
Date: Wed, 20 May 2026 18:12:54 +0200
Message-ID: <20260520162200.040970797@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit 390903efaa057c44fd80e7d9839419c50092018e ]

The expected frequency of SD host controller core supply clock is 19.2MHz,
while RPMH_CXO_CLK clock frequency on SM8650 platform is 38.4MHz.

Apparently the overclocked supply clock could be good enough on some
boards and even with the most of SD cards, however some low-end UHS-I
SD cards in SDR104 mode of the host controller produce I/O errors in
runtime, fortunately this problem is gone, if the "xo" clock frequency
matches the expected 19.2MHz clock rate.

Fixes: 10e024671295 ("arm64: dts: qcom: sm8650: add interconnect dependent device nodes")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20260314023715.357512-3-vladimir.zapolskiy@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 070e8f706c239..75de839f7a2df 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -4957,7 +4957,7 @@ sdhc_2: mmc@8804000 {
 
 			clocks = <&gcc GCC_SDCC2_AHB_CLK>,
 				 <&gcc GCC_SDCC2_APPS_CLK>,
-				 <&rpmhcc RPMH_CXO_CLK>;
+				 <&bi_tcxo_div2>;
 			clock-names = "iface",
 				      "core",
 				      "xo";
-- 
2.53.0



