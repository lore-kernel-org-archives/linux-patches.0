Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941A31FBEAF;
	Wed,  5 Feb 2025 14:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766766; cv=none; b=YAP4k/3Tr2GztnqX9pm4w1gR+g3NWffdfoSSIELBMTe5nTVzS53yWF8p/0mxI3kBiRqy++uBsZY4daRzAsjj1HVKLwnqC52b3KUjTtWESEobnX+Bjprh4cD1kYXi/x6KquT2HWRUhwCXzVIMAgc3ZXGkNyTwx58LmhGiPL80K+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766766; c=relaxed/simple;
	bh=PXn1fvyj326SKCEOWIXgA+5/EWtQ4D/Y/3K1lSwdkfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTxtN2VwPH+pndhEaDuyAsxN0A21QpzHjOL13/PW5Ew6YVceM0JUNfoa9PRY6hMjp+G/ExPFU2xn/QY9nyyDn5vh/koAhNabX4GdgDh1hpiT0PNm/4fLdymebCxuktS7Z1ODN3FrJTPNrw8hlhXmxdR3n8gY7kUskOdTYz5giv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhYOc6w6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhYOc6w6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123A7C4CED6;
	Wed,  5 Feb 2025 14:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766766;
	bh=PXn1fvyj326SKCEOWIXgA+5/EWtQ4D/Y/3K1lSwdkfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhYOc6w656HAU8nEj6dSTZMBT90RCjrhmEQEUaBYwl5+85CFWhPJDXmPnFCqOqeiC
	 l0FiPRLOFVOBpj9actyyWBvZpZhSF5lHNTrngNj03hiiGiBE5lGDf6Ds79mBgPAF8A
	 KTAG9A8eqN/20rf+OC6Cp8pia1BbqPzbWNTVBFJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 358/590] arm64: dts: qcom: sm8650: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:41:53 +0100
Message-ID: <20250205134508.964552469@linuxfoundation.org>
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

[ Upstream commit 448db0ba6ad2aafee2cbd91b491246749f6a6abc ]

The SM8650 platform uses PMK8550 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 6fbdb3c1fac7 ("arm64: dts: qcom: sm8650: add initial SM8650 MTP dts")
Fixes: a834911d50c1 ("arm64: dts: qcom: sm8650: add initial SM8650 QRD dts")
Fixes: 01061441029e ("arm64: dts: qcom: sm8650: add support for the SM8650-HDK board")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-17-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650-hdk.dts | 2 +-
 arch/arm64/boot/dts/qcom/sm8650-mtp.dts | 2 +-
 arch/arm64/boot/dts/qcom/sm8650-qrd.dts | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650-hdk.dts b/arch/arm64/boot/dts/qcom/sm8650-hdk.dts
index 127c7aacd4fc3..59363267d2e0a 100644
--- a/arch/arm64/boot/dts/qcom/sm8650-hdk.dts
+++ b/arch/arm64/boot/dts/qcom/sm8650-hdk.dts
@@ -1117,7 +1117,7 @@
 };
 
 &sleep_clk {
-	clock-frequency = <32000>;
+	clock-frequency = <32764>;
 };
 
 &swr0 {
diff --git a/arch/arm64/boot/dts/qcom/sm8650-mtp.dts b/arch/arm64/boot/dts/qcom/sm8650-mtp.dts
index c63822f5b1278..74275ca668c76 100644
--- a/arch/arm64/boot/dts/qcom/sm8650-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sm8650-mtp.dts
@@ -734,7 +734,7 @@
 };
 
 &sleep_clk {
-	clock-frequency = <32000>;
+	clock-frequency = <32764>;
 };
 
 &swr0 {
diff --git a/arch/arm64/boot/dts/qcom/sm8650-qrd.dts b/arch/arm64/boot/dts/qcom/sm8650-qrd.dts
index 8ca0d28eba9bd..1689699d6de71 100644
--- a/arch/arm64/boot/dts/qcom/sm8650-qrd.dts
+++ b/arch/arm64/boot/dts/qcom/sm8650-qrd.dts
@@ -1045,7 +1045,7 @@
 };
 
 &sleep_clk {
-	clock-frequency = <32000>;
+	clock-frequency = <32764>;
 };
 
 &spi4 {
-- 
2.39.5



