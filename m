Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6051D282F03;
	Sat, 12 Sep 2026 16:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232270; cv=none; b=gDueC3FtTJVC+N2UmIRngJXjvmEXt9LKbmsK9gvsUffL/lV0iDU9R6jFF9NaKGMFiqpI3iklLaRK7N3e1BnjdnLG4Y8hzBxsmrv3zi538uhzyhpOOEI7zzMwhXZ8ij2nxWZX6KVoAkbksxlKFXdhJ9CiJZlvYjgmBQkzo6jjBW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232270; c=relaxed/simple;
	bh=/rvsU2yE4kkcXoDmWg/OO6EbINGJcrKq6mJUnDCeYgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKUAoBGAYCUaVUxwRHFmCwvpYRxUNPTIwCL8DIXmZbfRIvrui63ofqLJ/6Im134NrnXjOfelmf/kV63fJIo2/sIopIPr5c9e1UtAYV6/Mr4xOhlqQu2KLlkr724tls1BbunZAxoyXTj7Bv45TaXiCo5uwja2LFd0cvl6kAcp12w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gal9vXWN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gal9vXWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F771F000FF;
	Sat, 12 Sep 2026 16:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232269;
	bh=GKJtfM7+DxzndIm3Q0EFwID0j5R0l1RpxpJYXL3V4vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gal9vXWNElqg+53Ntu2OpLDGJlhjblfL7lG5bIyER51ISuwb5Zdo2W3pN3N6xu0EU
	 9tfUX2IU1qfdHVoEmPr57eLP6cbpJlUlqTDgfqXTJpnJOu7BW7snZhVa1wQw+9RMta
	 FtJEKH83wE6xv13b9Xq7AmpUWT0sz6viMbz4vhLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1168/1191] arm64: dts: qcom: sm8550: Update idle state time requirements
Date: Sat, 12 Sep 2026 09:04:56 +0200
Message-ID: <20260912065614.373623666@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit ad6556fb45d4ab91ad786a2025cbe2b0f2e6cf77 ]

The idle state entry/exit/residency times differ from what shipped on
production devices, mostly being overly optimistic in entry times and
overly pessimistic in minimal residency times. Align them with
downstream sources.

Fixes: ffc50b2d3828 ("arm64: dts: qcom: Add base SM8550 dtsi")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231218-topic-8550_fixes-v1-12-ce1272d77540@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index a36e85c48a07f..2e7421d80a23b 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -259,9 +259,9 @@ LITTLE_CPU_SLEEP_0: cpu-sleep-0-0 {
 				compatible = "arm,idle-state";
 				idle-state-name = "silver-rail-power-collapse";
 				arm,psci-suspend-param = <0x40000004>;
-				entry-latency-us = <800>;
+				entry-latency-us = <550>;
 				exit-latency-us = <750>;
-				min-residency-us = <4090>;
+				min-residency-us = <6700>;
 				local-timer-stop;
 			};
 
@@ -270,8 +270,8 @@ BIG_CPU_SLEEP_0: cpu-sleep-1-0 {
 				idle-state-name = "gold-rail-power-collapse";
 				arm,psci-suspend-param = <0x40000004>;
 				entry-latency-us = <600>;
-				exit-latency-us = <1550>;
-				min-residency-us = <4791>;
+				exit-latency-us = <1300>;
+				min-residency-us = <8136>;
 				local-timer-stop;
 			};
 		};
@@ -280,17 +280,17 @@ domain-idle-states {
 			CLUSTER_SLEEP_0: cluster-sleep-0 {
 				compatible = "domain-idle-state";
 				arm,psci-suspend-param = <0x41000044>;
-				entry-latency-us = <1050>;
-				exit-latency-us = <2500>;
-				min-residency-us = <5309>;
+				entry-latency-us = <750>;
+				exit-latency-us = <2350>;
+				min-residency-us = <9144>;
 			};
 
 			CLUSTER_SLEEP_1: cluster-sleep-1 {
 				compatible = "domain-idle-state";
 				arm,psci-suspend-param = <0x4100c344>;
-				entry-latency-us = <2700>;
-				exit-latency-us = <3500>;
-				min-residency-us = <13959>;
+				entry-latency-us = <2800>;
+				exit-latency-us = <4400>;
+				min-residency-us = <10150>;
 			};
 		};
 	};
-- 
2.53.0



