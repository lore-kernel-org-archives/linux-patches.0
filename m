Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2BDBA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86BA0C4339B;
	Tue,  7 Mar 2023 17:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211972;
	bh=1jjYl03Ecp9nCYiEsfVilLgWW1IVgu1i3TwsDZsb17A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZNXfPzGuI/drfmJLpJ5mbtDRtPGfRnpIs2L/RNrFxZbMX0YUBPYvWpRs3zDuu8nF
	 ha1dnugCmu1boJKX1+PUjicRw9g/6yI1vxoN/h+wAn26gU5JMekIUPiiwaIrQPqp3K
	 rmlR7SVMbKNaZigqGrIGeHXD8nwEUoQXd6QIA7q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <petr.vorel@gmail.com>,
	Dominik Kobinski <dominikkobinski314@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/885] arm64: dts: msm8992-bullhead: add memory hole region
Date: Tue,  7 Mar 2023 17:49:29 +0100
Message-Id: <20230307170003.185585716@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dominik Kobinski <dominikkobinski314@gmail.com>

[ Upstream commit 22c7e1a0fa45cd7d028d6b4117161fd0e3427fe0 ]

Add region for memory hole present on bullhead in order to
fix a reboot issue on recent kernels

Reported-by: Petr Vorel <petr.vorel@gmail.com>
Signed-off-by: Dominik Kobinski <dominikkobinski314@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Tested-by: Petr Vorel <petr.vorel@gmail.com>
Reviewed-by: Petr Vorel <petr.vorel@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221211100501.82323-1-dominikkobinski314@gmail.com
Stable-dep-of: 26a91359aea4 ("arm64: dts: qcom: msm8992-bullhead: Fix cont_splash_mem size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
index 71e373b11de9d..37bcbbc67be51 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
@@ -2,6 +2,7 @@
 /* Copyright (c) 2015, LGE Inc. All rights reserved.
  * Copyright (c) 2016, The Linux Foundation. All rights reserved.
  * Copyright (c) 2021, Petr Vorel <petr.vorel@gmail.com>
+ * Copyright (c) 2022, Dominik Kobinski <dominikkobinski314@gmail.com>
  */
 
 /dts-v1/;
@@ -50,6 +51,11 @@ cont_splash_mem: memory@3400000 {
 			reg = <0 0x03400000 0 0x1200000>;
 			no-map;
 		};
+
+		removed_region: reserved@5000000 {
+			reg = <0 0x05000000 0 0x2200000>;
+			no-map;
+		};
 	};
 };
 
-- 
2.39.2



