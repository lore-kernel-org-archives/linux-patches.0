Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7D411705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EC5C433CA;
	Mon, 11 Sep 2023 14:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443198;
	bh=PbQQcQsTu72xcCsF4rlQr75EZmwaVFwc3YbuVu6xD7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXa7V/PO5NHI8qqWlxDq/Bp2JjJRxR66jiMM0Dw/oAsnYEkAlxN1V94f1LzSovneG
	 FXaaMuad66kjR+IA+wPNqtQ72EdVT+iVzns2UE2lgoUmHZxCGzNB1IlZzR995fzVeF
	 0Otpg48dHz80W9Af0MK8kVnzA1qQ05/hzXlF0eFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 292/737] arm64: dts: qcom: sm8350: Fix CPU idle state residency times
Date: Mon, 11 Sep 2023 15:42:31 +0200
Message-ID: <20230911134658.717882283@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 91ce3693e2fb685f31d39605a5ad1fbd940804da ]

The present values look to have been copypasted from 8150 or 8180.
Fix that.

Fixes: 07ddb302811e ("arm64: dts: qcom: sm8350: Add CPU topology and idle-states")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230705-topic-sm8350_fixes-v1-2-0f69f70ccb6a@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 425af2c38a37f..24eec0eacc3d5 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -246,8 +246,8 @@ LITTLE_CPU_SLEEP_0: cpu-sleep-0-0 {
 				compatible = "arm,idle-state";
 				idle-state-name = "silver-rail-power-collapse";
 				arm,psci-suspend-param = <0x40000004>;
-				entry-latency-us = <355>;
-				exit-latency-us = <909>;
+				entry-latency-us = <360>;
+				exit-latency-us = <531>;
 				min-residency-us = <3934>;
 				local-timer-stop;
 			};
@@ -256,8 +256,8 @@ BIG_CPU_SLEEP_0: cpu-sleep-1-0 {
 				compatible = "arm,idle-state";
 				idle-state-name = "gold-rail-power-collapse";
 				arm,psci-suspend-param = <0x40000004>;
-				entry-latency-us = <241>;
-				exit-latency-us = <1461>;
+				entry-latency-us = <702>;
+				exit-latency-us = <1061>;
 				min-residency-us = <4488>;
 				local-timer-stop;
 			};
-- 
2.40.1



