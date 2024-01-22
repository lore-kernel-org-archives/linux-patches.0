Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6240062A1F;
	Tue, 23 Jan 2024 01:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974991; cv=none; b=A0V6ldgNw/i4WVVnOxvTMgxyrp68qP63IkRrTvqU9kKO/1cxRXOaDhGQG0OH7M1kTr9fYj3T3UzTv9QUZOkHuyqyeZ2g94BoC2BUUfE5c0ib+x3GVZWqtaABzIOBkclnalJSXpTg4GhvdaPmqafQHI6uD9pMfQXUP1wMEWSnyl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974991; c=relaxed/simple;
	bh=n+GCtK1UsLqPMKdQEQ2I3a0f0Bq7fAIFc0NdIPXAB/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKMylyQnJFfrx0oVTDkUFPIRKptbNqWrThxz3XM2WNvgSM3lRGDa3ZmIqJDSaHYjQwzls5bg6JzQXAm/jtagAQXPY4iDZPSVUwtMMStuX6VwT5GWX9kwJTiiF/s1a4gNake/UxPszeJJoZxU8uU1EpvPRG51F70Enr0mod3ANq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mK0A+A0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mK0A+A0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB3FC433F1;
	Tue, 23 Jan 2024 01:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974990;
	bh=n+GCtK1UsLqPMKdQEQ2I3a0f0Bq7fAIFc0NdIPXAB/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mK0A+A0TU4SBXVChTwYW+cBbr60d1o4Vpcp1xUCZy7Hc50HVS1srB45VuTbkeCjlT
	 H+YyF4dcAElNqH6G5D9B8iCbfIY2jc54+3EuUM7orwwqI+1KUnezWO4VuFhU/QkJlg
	 Fc+snmra+ko3A2oYqVLQmQIbV3xO3VvvR8g8hp1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 183/583] arm64: dts: qcom: sm8550: Separate out X3 idle state
Date: Mon, 22 Jan 2024 15:53:54 -0800
Message-ID: <20240122235817.603699023@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 28b735232d5e16a34f98dbac1e7b5401c1c16d89 ]

The X3 core has different entry/exit/residency time requirements than
the big cluster. Denote them to stop confusing the scheduler.

Fixes: ffc50b2d3828 ("arm64: dts: qcom: Add base SM8550 dtsi")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231218-topic-8550_fixes-v1-11-ce1272d77540@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 045cef68a256..15d91ace8703 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -298,6 +298,16 @@ BIG_CPU_SLEEP_0: cpu-sleep-1-0 {
 				min-residency-us = <4791>;
 				local-timer-stop;
 			};
+
+			PRIME_CPU_SLEEP_0: cpu-sleep-2-0 {
+				compatible = "arm,idle-state";
+				idle-state-name = "goldplus-rail-power-collapse";
+				arm,psci-suspend-param = <0x40000004>;
+				entry-latency-us = <500>;
+				exit-latency-us = <1350>;
+				min-residency-us = <7480>;
+				local-timer-stop;
+			};
 		};
 
 		domain-idle-states {
@@ -398,7 +408,7 @@ CPU_PD6: power-domain-cpu6 {
 		CPU_PD7: power-domain-cpu7 {
 			#power-domain-cells = <0>;
 			power-domains = <&CLUSTER_PD>;
-			domain-idle-states = <&BIG_CPU_SLEEP_0>;
+			domain-idle-states = <&PRIME_CPU_SLEEP_0>;
 		};
 
 		CLUSTER_PD: power-domain-cluster {
-- 
2.43.0



