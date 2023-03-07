Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67889BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE892C433EF;
	Tue,  7 Mar 2023 17:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678208923;
	bh=6xQUAXCdwIT0EYTxfyrTrkY9/OdHOYI8F8U8ao95c0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mto/Pwqyv1OJa9MVIy7Pc3lXnCsN4TusAZI03doG1kommMunZq1b2zPQe5SN1bzdc
	 /kw+2jsOudM/T3guIShyWmRhLBAt6p0rkW8/BF1lJATSbzfp9AEsKDaUIo36/7OjOb
	 bdONdfZW/wYKKsNC71EEXVtjqkvJIVHXSLtw9OTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <petr.vorel@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0052/1001] arm64: dts: qcom: msm8992-bullhead: Fix cont_splash_mem size
Date: Tue,  7 Mar 2023 17:47:04 +0100
Message-Id: <20230307170024.380723855@linuxfoundation.org>
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

From: Petr Vorel <petr.vorel@gmail.com>

[ Upstream commit 26a91359aea4d89e7d3646d806eed0f3755b74bd ]

Original google firmware reports 12 MiB:
[    0.000000] cma: Found cont_splash_mem@0, memory base 0x0000000003400000, size 12 MiB, limit 0xffffffffffffffff

which is actually 12*1024*1024 = 0xc00000.

This matches the aosp source [1]:
&cont_splash_mem {
	reg = <0 0x03400000 0 0xc00000>;
};

Fixes: 3cb6a271f4b0 ("arm64: dts: qcom: msm8992-bullhead: Fix cont_splash_mem mapping")
Fixes: 976d321f32dc ("arm64: dts: qcom: msm8992: Make the DT an overlay on top of 8994")

[1] https://android.googlesource.com/kernel/msm.git/+/android-7.0.0_r0.17/arch/arm64/boot/dts/lge/msm8992-bullhead.dtsi#141

Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221226185440.440968-2-pevik@seznam.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
index 79de9cc395c4c..123ec67fb385a 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
@@ -2,7 +2,7 @@
 /*
  * Copyright (c) 2015, LGE Inc. All rights reserved.
  * Copyright (c) 2016, The Linux Foundation. All rights reserved.
- * Copyright (c) 2021, Petr Vorel <petr.vorel@gmail.com>
+ * Copyright (c) 2021-2022, Petr Vorel <petr.vorel@gmail.com>
  * Copyright (c) 2022, Dominik Kobinski <dominikkobinski314@gmail.com>
  */
 
@@ -49,7 +49,7 @@ ramoops@1ff00000 {
 		};
 
 		cont_splash_mem: memory@3400000 {
-			reg = <0 0x03400000 0 0x1200000>;
+			reg = <0 0x03400000 0 0xc00000>;
 			no-map;
 		};
 
-- 
2.39.2



