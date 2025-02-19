Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2061DE2CE;
	Wed, 19 Feb 2025 09:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956374; cv=none; b=mqn7kxm2As6lawiaPh/DWVUeho8waMN7JSDSC7JOeIZs5+tUna1AmlT2xDA5xyvwGpxXH0ts2data9x7GbrAWJMECJAL3qyKvH8XbAqYOjsDhzkKc+4TbfjUknnpl/Cymy+FwsjvYN0WHngH7qIR3KW0DaVMgEGomMy3JcemGGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956374; c=relaxed/simple;
	bh=FR7ZbS6qc7cipqYySKpr2JFgyZu+135OdNu3Tc9uItU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTnr4Jx4rsyhICoHe9ZHWFn4FCgoNyofCw1dghXK1LbTPptEKmWii6vzjAPj6GjU60GJNicvNpa35JEgqAJYOchB2gVUA43bknhCvfa8wmMn3aQ3/ZV9+J+0ffFcoF+Vcvv7bIWtxLP1c9HcGkaA/T7764UlHbGF27Ku/dol/Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m6u10VMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m6u10VMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E04C4CED1;
	Wed, 19 Feb 2025 09:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956374;
	bh=FR7ZbS6qc7cipqYySKpr2JFgyZu+135OdNu3Tc9uItU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6u10VMgxFwFaQ1q8fLqcPFF6qMLarhMnSAOXUBhbgFEQWeHaFxSF/ANnVK13mkT8
	 NPecLxfYG1hgHcEzhHbfLhQ1wJlfM6MC+GUJMsrteVWMqzHNHksFBtrcMrvO6MLRFw
	 d4AHZbbrLOF1QOObtQcm6XYUm+NtrNsvVAOpl4pI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/578] arm64: dts: qcom: msm8994: correct sleep clock frequency
Date: Wed, 19 Feb 2025 09:22:42 +0100
Message-ID: <20250219082659.188579007@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit a4148d869d47d8c86da0291dd95d411a5ebe90c8 ]

The MSM8994 platform uses PM8994/6 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: feeaf56ac78d ("arm64: dts: msm8994 SoC and Huawei Angler (Nexus 6P) support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-3-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8994.dtsi b/arch/arm64/boot/dts/qcom/msm8994.dtsi
index 5fe9a9be7903a..0eb8eca13ad9d 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -33,7 +33,7 @@
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <32768>;
+			clock-frequency = <32764>;
 			clock-output-names = "sleep_clk";
 		};
 	};
-- 
2.39.5



