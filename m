Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922581FC0FC;
	Wed,  5 Feb 2025 14:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767235; cv=none; b=Q2JWujqhQ7z9elWuOjds8RMkMVRg0rAAX7Q7is02ky6Dha6Hhev2fKw+2jVLICTjAM1TQuK9A4PI6lROORJVJbLkOFjfO5sEbnkq1WAN5Ti91rycqGWXNzJt8BuI+KBPziwqI1FLaMHFm2OKPntNWJWGW+/yuWtmxcSLoXxoZ1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767235; c=relaxed/simple;
	bh=DvZwyeDAd7X377xuCUKXBQxW6u1gL+6i0NnjlhXsLtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umMuE4cLORJAmBZSOEEmcUeRVLTpM4Yv5IeA6ZrGEbvOMjj+bhsbliERy+/qarJUeFwKq8oz5GaKPn0rvxk8D7PZOFau3XWG9yC3bq90uMNDJPQ4WXtO2+mCfbdr4cBRqK2yBv9e3iCtKXW+rG+jfFudSCwk+FB3V6PXzVbi1GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RBVr7Qo4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RBVr7Qo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B23AC4CED1;
	Wed,  5 Feb 2025 14:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767235;
	bh=DvZwyeDAd7X377xuCUKXBQxW6u1gL+6i0NnjlhXsLtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBVr7Qo4wNifVM818yLtKu7yKoMm/Ht7M3MBHigjvi2jhuL6yBArrteyNTOxJZytM
	 HzD1nHHS1vr4mwdflacE8NykmqWSi24HwC2TsZHCjHSFuFw6ps7ZpvH+VzlkemDo3A
	 AGsPfmYb3Eb9yHZHNndptV319cur2dsKAz0oT+kA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 376/623] arm64: dts: qcom: msm8916: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:41:58 +0100
Message-ID: <20250205134510.604587624@linuxfoundation.org>
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
index 5e558bcc9d878..8f35c9af18782 100644
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



