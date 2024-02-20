Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CE714AD12;
	Tue, 20 Feb 2024 21:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463229; cv=none; b=TsYwM0m6FXEz3aVojjSdVSLhmfI0ASutFT7pElERN3PLA9+Zh5MkIaOWaLplA1WU5unfcsnBgj+YUnvRP5M4+hD5vSKg3pOjNskGwUdrL0NsxQnPWmQgFybP+gSmg+2ynsDPitYY8wEbHP9SyuxoFmPoAgQjlAPIQHxIf3UIE4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463229; c=relaxed/simple;
	bh=keQ6cz6T8GE7x+5T+PWQVI9X78kocp0OtrzpTHoEA08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CuW6YoyziE9A7iEt3URi/h+WnIekbpvocg601yjy+U9wfTceTPjCVKiPPGbe0QIQH2MLa3YH5PNN28glWlw+BIAZWWNoeOgITDDj6zJb0j5LL/5ygn+fogj4XJNzuNovSqRAv5zSTLkhrHKZ5CYkv+rdFho/LaAPIgpG+wy1hGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=efn5ud3O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efn5ud3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2211FC433F1;
	Tue, 20 Feb 2024 21:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463229;
	bh=keQ6cz6T8GE7x+5T+PWQVI9X78kocp0OtrzpTHoEA08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=efn5ud3Ooo+yNnU5VP5SQLrH7acEU0liJYfVjMBHf6OVgkDkZpap/PuDg5ilpkgX3
	 FPO7XOyYnzn/W9cFk4O3bL25oWV3d9BlvhnPLeFEytE0/xRUgTHp8o+6TWqSwa0l5Y
	 Pfvl8QhDymgTFdoaTzpTL0+9pPFZAMZl/CSgbN74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan@gerhold.net>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 177/197] arm64: dts: qcom: msm8916: Enable blsp_dma by default
Date: Tue, 20 Feb 2024 21:52:16 +0100
Message-ID: <20240220204846.365474877@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 0154d3594af3c198532ac7b4ab70f50fb5207a15 ]

Adding the "dmas" to the I2C controllers prevents probing them if
blsp_dma is disabled (infinite probe deferral). Avoid this by enabling
blsp_dma by default - it's an integral part of the SoC that is almost
always used (even if just for UART).

Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230107110958.5762-2-stephan@gerhold.net
Stable-dep-of: 7c45b6ddbcff ("arm64: dts: qcom: msm8916: Make blsp_dma controlled-remotely")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/apq8016-sbc.dts | 4 ----
 arch/arm64/boot/dts/qcom/msm8916.dtsi    | 1 -
 2 files changed, 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/apq8016-sbc.dts b/arch/arm64/boot/dts/qcom/apq8016-sbc.dts
index 9d116e1fbe10..1ac4f8c24e23 100644
--- a/arch/arm64/boot/dts/qcom/apq8016-sbc.dts
+++ b/arch/arm64/boot/dts/qcom/apq8016-sbc.dts
@@ -169,10 +169,6 @@ led@6 {
 	};
 };
 
-&blsp_dma {
-	status = "okay";
-};
-
 &blsp_i2c2 {
 	/* On Low speed expansion */
 	status = "okay";
diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index bafac2cf7e3d..f0d097ade84c 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -1522,7 +1522,6 @@ blsp_dma: dma-controller@7884000 {
 			clock-names = "bam_clk";
 			#dma-cells = <1>;
 			qcom,ee = <0>;
-			status = "disabled";
 		};
 
 		blsp1_uart1: serial@78af000 {
-- 
2.43.0



