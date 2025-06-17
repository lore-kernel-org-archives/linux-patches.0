Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CED32F2346;
	Tue, 17 Jun 2025 16:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176328; cv=none; b=Kzdw/2KjP/XPXiGxqaxoHmLvPNc9RmOnYgx1qmJa+UuD4YH5fGuvlCKv/GbIOWCc+679N+/acH7h1y6lTx9kN7/RMr59qd+CcHvAuijljqzqK8CjNZzrc6Jq/PrPPc3SWHjAOqA2CMFietqFPTw4wAGOQeCEYPFLb5Fht2U/WYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176328; c=relaxed/simple;
	bh=7Y4oolwu2sn3oPJuRYVn1vZ/1qRf7IIp7CPDP7Yk6X8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKP3VdZ84FOn0HU2PfI/cl+QoPwxMhrrIfaIXg4tYxP1MA8ZHsf6SF8k/a0l99K06mt6NWMa4M/12dn0Qy1HF//6jSUrijIQMumvRturpCc9M7HrNTTyATBM2EDEM5NejWhsGhwS/hRLVNK5ZEWnn80qK83No84Y+GjlhU4qCtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5S0e3kU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5S0e3kU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90457C4CEE3;
	Tue, 17 Jun 2025 16:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176328;
	bh=7Y4oolwu2sn3oPJuRYVn1vZ/1qRf7IIp7CPDP7Yk6X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5S0e3kUzIG1LvNHg6NFEecKExVmvcFHVelh3eXvovYtChqZ5v1jv8E2E10m8PlHA
	 ussifLbM+Lo7VfoDo+2Ezexa30Evai3BGrk/SnKgjiH13j6ugegDmUZ17C+9cbXA2H
	 /b9tyRyLYVoXk7NeKEj79MdwUI0mhuN57Oofu+C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 219/512] arm64: dts: qcom: sm8650: setup gpu thermal with higher temperatures
Date: Tue, 17 Jun 2025 17:23:05 +0200
Message-ID: <20250617152428.502415717@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 2250f65b32565eb8b757e89248c75977f370f498 ]

On the SM8650, the dynamic clock and voltage scaling (DCVS) for the GPU
is done from the HLOS, but the GPU can achieve a much higher temperature
before failing according the reference downstream implementation.

Set higher temperatures in the GPU trip points corresponding to
the temperatures provided by Qualcomm in the dowstream source, much
closer to the junction temperature and with a higher critical
temperature trip in the case the HLOS DCVS cannot handle the
temperature surge.

The tsens MAX_THRESHOLD is set to 120C on those platforms, so set
the hot to 110C to leave a chance to HLOS to react and critical to
115C to avoid the monitor thermal shutdown.

Fixes: 497624ed5506 ("arm64: dts: qcom: sm8650: Throttle the GPU when overheating")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250203-topic-sm8650-thermal-cpu-idle-v4-2-65e35f307301@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 64 ++++++++++++++--------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index fddf979de38d1..0c54a89bb3322 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -6354,20 +6354,20 @@
 
 			trips {
 				gpu0_alert0: trip-point0 {
-					temperature = <85000>;
+					temperature = <95000>;
 					hysteresis = <1000>;
 					type = "passive";
 				};
 
 				trip-point1 {
-					temperature = <90000>;
+					temperature = <110000>;
 					hysteresis = <1000>;
 					type = "hot";
 				};
 
 				trip-point2 {
-					temperature = <110000>;
-					hysteresis = <1000>;
+					temperature = <115000>;
+					hysteresis = <0>;
 					type = "critical";
 				};
 			};
@@ -6387,20 +6387,20 @@
 
 			trips {
 				gpu1_alert0: trip-point0 {
-					temperature = <85000>;
+					temperature = <95000>;
 					hysteresis = <1000>;
 					type = "passive";
 				};
 
 				trip-point1 {
-					temperature = <90000>;
+					temperature = <110000>;
 					hysteresis = <1000>;
 					type = "hot";
 				};
 
 				trip-point2 {
-					temperature = <110000>;
-					hysteresis = <1000>;
+					temperature = <115000>;
+					hysteresis = <0>;
 					type = "critical";
 				};
 			};
@@ -6420,20 +6420,20 @@
 
 			trips {
 				gpu2_alert0: trip-point0 {
-					temperature = <85000>;
+					temperature = <95000>;
 					hysteresis = <1000>;
 					type = "passive";
 				};
 
 				trip-point1 {
-					temperature = <90000>;
+					temperature = <110000>;
 					hysteresis = <1000>;
 					type = "hot";
 				};
 
 				trip-point2 {
-					temperature = <110000>;
-					hysteresis = <1000>;
+					temperature = <115000>;
+					hysteresis = <0>;
 					type = "critical";
 				};
 			};
@@ -6453,20 +6453,20 @@
 
 			trips {
 				gpu3_alert0: trip-point0 {
-					temperature = <85000>;
+					temperature = <95000>;
 					hysteresis = <1000>;
 					type = "passive";
 				};
 
 				trip-point1 {
-					temperature = <90000>;
+					temperature = <110000>;
 					hysteresis = <1000>;
 					type = "hot";
 				};
 
 				trip-point2 {
-					temperature = <110000>;
-					hysteresis = <1000>;
+					temperature = <115000>;
+					hysteresis = <0>;
 					type = "critical";
 				};
 			};
@@ -6486,20 +6486,20 @@
 
 			trips {
 				gpu4_alert0: trip-point0 {
-					temperature = <85000>;
+					temperature = <95000>;
 					hysteresis = <1000>;
 					type = "passive";
 				};
 
 				trip-point1 {
-					temperature = <90000>;
+					temperature = <110000>;
 					hysteresis = <1000>;
 					type = "hot";
 				};
 
 				trip-point2 {
-					temperature = <110000>;
-					hysteresis = <1000>;
+					temperature = <115000>;
+					hysteresis = <0>;
 					type = "critical";
 				};
 			};
@@ -6519,20 +6519,20 @@
 
 			trips {
 				gpu5_alert0: trip-point0 {
-					temperature = <85000>;
+					temperature = <95000>;
 					hysteresis = <1000>;
 					type = "passive";
 				};
 
 				trip-point1 {
-					temperature = <90000>;
+					temperature = <110000>;
 					hysteresis = <1000>;
 					type = "hot";
 				};
 
 				trip-point2 {
-					temperature = <110000>;
-					hysteresis = <1000>;
+					temperature = <115000>;
+					hysteresis = <0>;
 					type = "critical";
 				};
 			};
@@ -6552,20 +6552,20 @@
 
 			trips {
 				gpu6_alert0: trip-point0 {
-					temperature = <85000>;
+					temperature = <95000>;
 					hysteresis = <1000>;
 					type = "passive";
 				};
 
 				trip-point1 {
-					temperature = <90000>;
+					temperature = <110000>;
 					hysteresis = <1000>;
 					type = "hot";
 				};
 
 				trip-point2 {
-					temperature = <110000>;
-					hysteresis = <1000>;
+					temperature = <115000>;
+					hysteresis = <0>;
 					type = "critical";
 				};
 			};
@@ -6585,20 +6585,20 @@
 
 			trips {
 				gpu7_alert0: trip-point0 {
-					temperature = <85000>;
+					temperature = <95000>;
 					hysteresis = <1000>;
 					type = "passive";
 				};
 
 				trip-point1 {
-					temperature = <90000>;
+					temperature = <110000>;
 					hysteresis = <1000>;
 					type = "hot";
 				};
 
 				trip-point2 {
-					temperature = <110000>;
-					hysteresis = <1000>;
+					temperature = <115000>;
+					hysteresis = <0>;
 					type = "critical";
 				};
 			};
-- 
2.39.5



