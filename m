Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804EB1547E9;
	Wed,  5 Feb 2025 14:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767480; cv=none; b=NE1X+WmHR1Ym8bEzRV+UsfJICPPZ/6s7rS8fAW5BulH/1YJOOEciMjim8+19K+ffpBwgToahslk5awXQQE+RplSqhgvDJ1JYuxrGbnE4BvGisEGrCBuuornXFOa+ZxpdrxICv6QrwIRBlLrvmFHiof4gSrP2B+9OwkstD1umpII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767480; c=relaxed/simple;
	bh=abgb3gDk3lsCXylqzjjVFahxPAZHMO23HWyR1bZ6XSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxglqYwEF2exYgiGxk9tlZnbtNd3ClyqJsb62L0OWvFBhKxj13svTusO1bJmxJA0gjdL77/c/xzk3PtzONz9jNofx+KXCqfKqAU3kH6jeSVUSW4JqFo3E2hSFkEBVHpkeyeW9ZDi5mMBK5fx6bt9d2gCKwJCW/CMuFsXPwyETQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWge3TWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWge3TWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72A2C4CED1;
	Wed,  5 Feb 2025 14:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767480;
	bh=abgb3gDk3lsCXylqzjjVFahxPAZHMO23HWyR1bZ6XSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWge3TWWelNBVTHvSfdFmxCWtZj9hgrZs8rnJn7mKPM9z6nuTPGItQQtnuNiBCPO/
	 llwjt2cBouymVxEOGDjct2ComciWHV9y3nQmabYkc5MrKTAHQpilKUpSx6NBUtCmSR
	 dU3JuqXIcSsntdVhVCVtqZ0OeR/p8bs/wV/Wre6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 410/623] arm64: dts: qcom: sc8280xp: Fix up remoteproc register space sizes
Date: Wed,  5 Feb 2025 14:42:32 +0100
Message-ID: <20250205134511.909452742@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 7ec7e327286182c65d0b5b81dff498d620fe9e8c ]

Make sure the remoteproc reg ranges reflect the entire register space
they refer to.

Since they're unused by the driver, there's no functional change.

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20241212-topic-8280_rproc_reg-v1-1-bd1c696e91b0@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index ef06d1ac084d3..c97d1eeaf890f 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -2743,7 +2743,7 @@
 
 		remoteproc_adsp: remoteproc@3000000 {
 			compatible = "qcom,sc8280xp-adsp-pas";
-			reg = <0 0x03000000 0 0x100>;
+			reg = <0 0x03000000 0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 162 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_adsp_in 0 IRQ_TYPE_EDGE_RISING>,
@@ -5254,7 +5254,7 @@
 
 		remoteproc_nsp0: remoteproc@1b300000 {
 			compatible = "qcom,sc8280xp-nsp0-pas";
-			reg = <0 0x1b300000 0 0x100>;
+			reg = <0 0x1b300000 0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 578 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_nsp0_in 0 IRQ_TYPE_EDGE_RISING>,
@@ -5385,7 +5385,7 @@
 
 		remoteproc_nsp1: remoteproc@21300000 {
 			compatible = "qcom,sc8280xp-nsp1-pas";
-			reg = <0 0x21300000 0 0x100>;
+			reg = <0 0x21300000 0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 887 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_nsp1_in 0 IRQ_TYPE_EDGE_RISING>,
-- 
2.39.5



