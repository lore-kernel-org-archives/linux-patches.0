Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF38618A6B5;
	Wed,  5 Feb 2025 14:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766759; cv=none; b=rd3RkpBdltP9qaWpmJicyJsxnNBMNneIS4Q1mmhj9RDVMI6X8yC1kMlLIBe/Gr2/jMVkIF6rALTFP5SSg2onhEHtyDzY30fzsqCNnHc1rOh1LZ0udmX9l1yhSwIhEnJNd9jsha1JW9ThWaJcwE/dA6Y2viGrJnrmeA5yB0vVlmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766759; c=relaxed/simple;
	bh=PEP6iBQBvjKdi4LB1LyxbqV7HQ/iwk8oqAQ5tFaU+1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfhAZQwUyHVPTPJUQrUBZQ1kc/tIT1b3bFzO+RLjO1zHT4aEVHMLHovUG9hFfl+RyJoG+SKseBk2cYm/IOK2/4kPuQk8dYqBg9Cg91ltS6o5JA9ZqSzCvHlQSLAhjLl+Ds2uerZI5ME1VZvPx5xsXBT7WXTUnSm1Bp4foEpHZJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LkHsxTT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LkHsxTT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8E8C4CED1;
	Wed,  5 Feb 2025 14:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766759;
	bh=PEP6iBQBvjKdi4LB1LyxbqV7HQ/iwk8oqAQ5tFaU+1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LkHsxTT6jYuoN/n1MWbzwu+OlWTRgCniVhxv+54bqX311iVpSAIYkF5/47l3KOOuJ
	 5wjPEtM7f7jEbrzU2il1+NlD/0sdGXqcH8gFIpPdHa2CDF27mOe0ET/H7fHbFLujmj
	 mQJoy7hJAL+kKZm4FXpRGgU3myXmziUoA1RDG/qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 357/590] arm64: dts: qcom: sm8550: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:41:52 +0100
Message-ID: <20250205134508.926573055@linuxfoundation.org>
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

[ Upstream commit e59334a088c3e722c0a287d4616af997f46c985e ]

The SM8550 platform uses PMK8550 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 0b12da4e28d8 ("arm64: dts: qcom: add base AIM300 dtsi")
Fixes: b5e25ded2721 ("arm64: dts: qcom: sm8550: add support for the SM8550-HDK board")
Fixes: 71342fb91eae ("arm64: dts: qcom: Add base SM8550 MTP dts")
Fixes: d228efe88469 ("arm64: dts: qcom: sm8550-qrd: add QRD8550")
Fixes: ba2c082a401f ("arm64: dts: qcom: sm8550: Add support for Samsung Galaxy Z Fold5")
Fixes: 39c596304e44 ("arm64: dts: qcom: Add SM8550 Xperia 1 V")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-16-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi                | 2 +-
 arch/arm64/boot/dts/qcom/sm8550-hdk.dts                     | 2 +-
 arch/arm64/boot/dts/qcom/sm8550-mtp.dts                     | 2 +-
 arch/arm64/boot/dts/qcom/sm8550-qrd.dts                     | 2 +-
 arch/arm64/boot/dts/qcom/sm8550-samsung-q5q.dts             | 2 +-
 arch/arm64/boot/dts/qcom/sm8550-sony-xperia-yodo-pdx234.dts | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi b/arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi
index f6960e2d466a2..e6ac529e6b721 100644
--- a/arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi
@@ -367,7 +367,7 @@
 };
 
 &sleep_clk {
-	clock-frequency = <32000>;
+	clock-frequency = <32764>;
 };
 
 &ufs_mem_hc {
diff --git a/arch/arm64/boot/dts/qcom/sm8550-hdk.dts b/arch/arm64/boot/dts/qcom/sm8550-hdk.dts
index 01c9216026057..29bc1ddfc7b25 100644
--- a/arch/arm64/boot/dts/qcom/sm8550-hdk.dts
+++ b/arch/arm64/boot/dts/qcom/sm8550-hdk.dts
@@ -1172,7 +1172,7 @@
 };
 
 &sleep_clk {
-	clock-frequency = <32000>;
+	clock-frequency = <32764>;
 };
 
 &swr0 {
diff --git a/arch/arm64/boot/dts/qcom/sm8550-mtp.dts b/arch/arm64/boot/dts/qcom/sm8550-mtp.dts
index ab447fc252f7d..5648ab60ba4c4 100644
--- a/arch/arm64/boot/dts/qcom/sm8550-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sm8550-mtp.dts
@@ -825,7 +825,7 @@
 };
 
 &sleep_clk {
-	clock-frequency = <32000>;
+	clock-frequency = <32764>;
 };
 
 &swr0 {
diff --git a/arch/arm64/boot/dts/qcom/sm8550-qrd.dts b/arch/arm64/boot/dts/qcom/sm8550-qrd.dts
index 6052dd922ec55..3a6cb27913048 100644
--- a/arch/arm64/boot/dts/qcom/sm8550-qrd.dts
+++ b/arch/arm64/boot/dts/qcom/sm8550-qrd.dts
@@ -1005,7 +1005,7 @@
 };
 
 &sleep_clk {
-	clock-frequency = <32000>;
+	clock-frequency = <32764>;
 };
 
 &swr0 {
diff --git a/arch/arm64/boot/dts/qcom/sm8550-samsung-q5q.dts b/arch/arm64/boot/dts/qcom/sm8550-samsung-q5q.dts
index 3d351e90bb398..62a6b90697b06 100644
--- a/arch/arm64/boot/dts/qcom/sm8550-samsung-q5q.dts
+++ b/arch/arm64/boot/dts/qcom/sm8550-samsung-q5q.dts
@@ -565,7 +565,7 @@
 };
 
 &sleep_clk {
-	clock-frequency = <32000>;
+	clock-frequency = <32764>;
 };
 
 &tlmm {
diff --git a/arch/arm64/boot/dts/qcom/sm8550-sony-xperia-yodo-pdx234.dts b/arch/arm64/boot/dts/qcom/sm8550-sony-xperia-yodo-pdx234.dts
index 85d487ef80a0b..d90dc7b37c4a7 100644
--- a/arch/arm64/boot/dts/qcom/sm8550-sony-xperia-yodo-pdx234.dts
+++ b/arch/arm64/boot/dts/qcom/sm8550-sony-xperia-yodo-pdx234.dts
@@ -722,7 +722,7 @@
 };
 
 &sleep_clk {
-	clock-frequency = <32000>;
+	clock-frequency = <32764>;
 };
 
 &tlmm {
-- 
2.39.5



