Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2969BA4C
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C23C4339C;
	Tue,  7 Mar 2023 18:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214718;
	bh=nN9UHVg1y2giMF2UVgCSbCKVXlVc41JyuHah5rIo2X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8OPn3M3uakjAAf65QrMOkGsCed9tYDaIz3DEJauoHPBR2WZqxdnz68iy7zz5oYZw
	 Yle50nA/EEebu9ffvDDU3lUY6VM1GXfWbWOgIHxHAxe6sA3MNWJ5q3Ekmzw04qMPF6
	 msKkb1CilFeYEgNg1L5vzRvr4zHBbOCelZTPCIEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <petr.vorel@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/567] arm64: dts: qcom: msm8992-bullhead: Fix cont_splash_mem size
Date: Tue,  7 Mar 2023 17:55:55 +0100
Message-Id: <20230307165906.670510550@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
 arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
index d7d06553bf9ec..8e20bb13bd65e 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (c) 2015, LGE Inc. All rights reserved.
  * Copyright (c) 2016, The Linux Foundation. All rights reserved.
- * Copyright (c) 2021, Petr Vorel <petr.vorel@gmail.com>
+ * Copyright (c) 2021-2022, Petr Vorel <petr.vorel@gmail.com>
  * Copyright (c) 2022, Dominik Kobinski <dominikkobinski314@gmail.com>
  */
 
@@ -48,7 +48,7 @@ ramoops@1ff00000 {
 		};
 
 		cont_splash_mem: memory@3400000 {
-			reg = <0 0x03400000 0 0x1200000>;
+			reg = <0 0x03400000 0 0xc00000>;
 			no-map;
 		};
 
-- 
2.39.2



