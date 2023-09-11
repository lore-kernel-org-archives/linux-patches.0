Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9010511184
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F242C433C7;
	Mon, 11 Sep 2023 14:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440918;
	bh=y6p83vg83qWWYEk6PrVej3GR1DmAo07LBEVAoSTSsik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wd9OTaEG2AH05ItVKwHOebJ3xJhmO4SS078pQIVJuDz9nvUKiYydqvIQ7lRWP7WQM
	 4dg5uW8KTjXyyszW+zXiR1JFzQoUnQyEP8d0NdYAOMJjCIxzewC/PdlFypv9FfDIUs
	 Qf0Fzwh/CxpRWKOf/dZb860PuNnCU8iZyeW9zUQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Benjamin Li <benl@squareup.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 224/739] arm64: dts: qcom: msm8939: Drop "qcom,idle-state-spc" compatible
Date: Mon, 11 Sep 2023 15:40:23 +0200
Message-ID: <20230911134657.437339589@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 982f810fc196002808b6d4230ba8f431c993d264 ]

As of today, the only cool and legal way to get ARM64 SMP going is
via PSCI (or spin tables). Sadly, not all chip and device vendors were
considerate of this in the early days of arm64. Qualcomm, for example
reused their tried-and-true spin-up method from MSM8974 and their Krait/
arm32 Cortex designs.

MSM8916 supports SMP with its arm32 dt overlay, as probably could 8939.
But the arm64 DT should not define non-PSCI SMP or CPUidle stuff.

Drop the qcom,idle-state-spc compatible (associated with Qualcomm-specific
CPUIdle) to make the dt checker happy:

apq8039-t2.dtb: idle-states: cpu-sleep-0:compatible:
['qcom,idle-state-spc', 'arm,idle-state'] is too long

Fixes: 61550c6c156c ("arm64: dts: qcom: Add msm8939 SoC")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Benjamin Li <benl@squareup.com>
Link: https://lore.kernel.org/r/20230627-topic-more_bindings-v1-2-6b4b6cd081e5@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8939.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8939.dtsi b/arch/arm64/boot/dts/qcom/msm8939.dtsi
index 895cafc11480b..8a856bd8e8e92 100644
--- a/arch/arm64/boot/dts/qcom/msm8939.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8939.dtsi
@@ -155,7 +155,7 @@ CPU7: cpu@3 {
 
 		idle-states {
 			CPU_SLEEP_0: cpu-sleep-0 {
-				compatible ="qcom,idle-state-spc", "arm,idle-state";
+				compatible = "arm,idle-state";
 				entry-latency-us = <130>;
 				exit-latency-us = <150>;
 				min-residency-us = <2000>;
-- 
2.40.1



