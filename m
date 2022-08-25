Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDD54C75
	for <patches@lists.linux.dev>; Thu, 25 Aug 2022 21:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A01AC433B5
	for <patches@lists.linux.dev>; Thu, 25 Aug 2022 21:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1661461791;
	bh=n0a6k7n5odaZzJQ990FueICSx01DFGufhKve9ryXRSk=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=luQmzsvnLEsn0EBIF9KyNsGPW6uoYAEYuV0vzL0Tik5XEmfACy2IBIrQHy3n0hG4f
	 O9zpe/g2+DKwJx1UisCNASMuPNbpIHxuUBavlbMXyxHLtpppVq8pTI0PhJvZHOm74l
	 xSaXvw4ItO9OauU1jNYuTRoQQ4XDCqRypGvwCq4s=
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2458ECAAA3
	for <patches@lists.linux.dev>; Thu, 25 Aug 2022 21:09:50 +0000 (UTC)
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Thu, 25 Aug 2022 17:09:19 -0400
Subject: [PATCH v1 3/4] arm64: dts: allwinner: h6: Add GPU OPP table
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <20220825-test-endpoint-send-2-v1-3-e732ebcaa48a@linuxfoundation.org>
References: <20220825-test-endpoint-send-2-v1-0-e732ebcaa48a@linuxfoundation.org>
In-Reply-To: <20220825-test-endpoint-send-2-v1-0-e732ebcaa48a@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.10.0-dev-65ba7
X-Developer-Signature: v=1; a=openpgp-sha256; l=2686;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=xHsL8akMQaQv0ELaKyQ5Nu9eO27NYWX0Ir5Aq6drV3Y=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJLZn8qt4LLf8zhyj+/7QKXH05bJrjM/Ksma+5t3Q8OjyfM8
 FcuaOkpZGMS4GGTFFFnK9sVuCip86CGX3mMKM4eVCWQIAxenAEykeS4jQ+v/OOUdE+Qkv8YlTkxXMl
 /1yuM0JxvvBFaVC9a6dQxVfxgZFuovNMz8/t93r9n2mDf1EmpV0XKRFnv6Gh8tOeYnJjuRCQA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E
X-Endpoint-Received: by B4 Submission Endpoint with auth_id=1

From: Clément Péron <peron.clem@gmail.com>

Add an Operating Performance Points table for the GPU to
enable Dynamic Voltage & Frequency Scaling on the H6.

The voltage range is set with minival voltage set to the target
and the maximal voltage set to 1.2V. This allow DVFS framework to
work properly on board with fixed regulator.

Signed-off-by: Clément Péron <peron.clem@gmail.com>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-gpu-opp.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h6-gpu-opp.dtsi
new file mode 100644
index 000000000000..a66204243515
--- /dev/null
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-gpu-opp.dtsi
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
+// Copyright (C) 2022 Clément Péron <peron.clem@gmail.com>
+
+/ {
+	gpu_opp_table: gpu-opp-table {
+		compatible = "operating-points-v2";
+
+		opp@216000000 {
+			opp-hz = /bits/ 64 <216000000>;
+			opp-microvolt = <810000 810000 1200000>;
+		};
+
+		opp@264000000 {
+			opp-hz = /bits/ 64 <264000000>;
+			opp-microvolt = <810000 810000 1200000>;
+		};
+
+		opp@312000000 {
+			opp-hz = /bits/ 64 <312000000>;
+			opp-microvolt = <810000 810000 1200000>;
+		};
+
+		opp@336000000 {
+			opp-hz = /bits/ 64 <336000000>;
+			opp-microvolt = <810000 810000 1200000>;
+		};
+
+		opp@360000000 {
+			opp-hz = /bits/ 64 <360000000>;
+			opp-microvolt = <820000 820000 1200000>;
+		};
+
+		opp@384000000 {
+			opp-hz = /bits/ 64 <384000000>;
+			opp-microvolt = <830000 830000 1200000>;
+		};
+
+		opp@408000000 {
+			opp-hz = /bits/ 64 <408000000>;
+			opp-microvolt = <840000 840000 1200000>;
+		};
+
+		opp@420000000 {
+			opp-hz = /bits/ 64 <420000000>;
+			opp-microvolt = <850000 850000 1200000>;
+		};
+
+		opp@432000000 {
+			opp-hz = /bits/ 64 <432000000>;
+			opp-microvolt = <860000 860000 1200000>;
+		};
+
+		opp@456000000 {
+			opp-hz = /bits/ 64 <456000000>;
+			opp-microvolt = <870000 870000 1200000>;
+		};
+
+		opp@504000000 {
+			opp-hz = /bits/ 64 <504000000>;
+			opp-microvolt = <890000 890000 1200000>;
+		};
+
+		opp@540000000 {
+			opp-hz = /bits/ 64 <540000000>;
+			opp-microvolt = <910000 910000 1200000>;
+		};
+
+		opp@576000000 {
+			opp-hz = /bits/ 64 <576000000>;
+			opp-microvolt = <930000 930000 1200000>;
+		};
+
+		opp@624000000 {
+			opp-hz = /bits/ 64 <624000000>;
+			opp-microvolt = <950000 950000 1200000>;
+		};
+
+		opp@756000000 {
+			opp-hz = /bits/ 64 <756000000>;
+			opp-microvolt = <1040000 1040000 1200000>;
+		};
+	};
+
+};
+
+&gpu {
+	operating-points-v2 = <&gpu_opp_table>;
+};

-- 
b4 0.10.0-dev-65ba7

