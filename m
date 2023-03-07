Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB43DBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E981C433D2;
	Tue,  7 Mar 2023 17:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678208929;
	bh=9vHsDlBQRGZKEYWZ/bM+QxaK/De0crNj224vrBc564Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NB3bqz67GBUzn0fQvxYKsv/0sAWml+G+axhTtkpUQ5lHwiG3N1je6XREjAH/nCp7+
	 QC0yoUyDE5EbKSKSHiJa6bVUXwl8t1QSK8wvum/Fmw1d8uCVKAv728BCpbYDlI7INy
	 EVWRGZRx0LlL5mufDQZYwbyamNCIjexDIDCSewF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0054/1001] arm64: dts: qcom: msm8956: use SoC-specific compat for tsens
Date: Tue,  7 Mar 2023 17:47:06 +0100
Message-Id: <20230307170024.471670832@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 0b3aa9aa629c10928e86f6c9666a5e0b14655b2a ]

The slope values used during tsens calibration differ between msm8976
and msm8956 SoCs. Use SoC-specific compat value for the msm8956 SoC.

Fixes: 0484d3ce0902 ("arm64: dts: qcom: Add DTS for MSM8976 and MSM8956 SoCs")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230101194034.831222-16-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8956.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8956.dtsi b/arch/arm64/boot/dts/qcom/msm8956.dtsi
index e432512d8716a..668e05185c21e 100644
--- a/arch/arm64/boot/dts/qcom/msm8956.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8956.dtsi
@@ -12,6 +12,10 @@ &pmu {
 	interrupts = <GIC_PPI 7 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_LEVEL_HIGH)>;
 };
 
+&tsens {
+	compatible = "qcom,msm8956-tsens", "qcom,tsens-v1";
+};
+
 /*
  * You might be wondering.. why is it so empty out there?
  * Well, the SoCs are almost identical.
-- 
2.39.2



