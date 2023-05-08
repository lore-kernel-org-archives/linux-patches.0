Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E058168C2
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9800BC433EF;
	Mon,  8 May 2023 10:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540038;
	bh=21NkILGOuTckfruxlIq1s16EsMW4f3GQZ8z9iQC4NxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hua1NXVLQ4tUf00LIk88tgBEX95Pq9fYrS0EV+gxDhAICBRMLpc2rLIRrU8vlhVe+
	 S8I1QgdyQd5KQksK5BpED+9fH7z5ewzen0edLGkeGBM1lJLrfYFcx2J+EaIKnGL//V
	 PySCF9O8mn+gtBneKRKiQFX7tDbC2CRWkih8lisg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <pvorel@suse.cz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 219/611] arm64: dts: qcom: msm8994-angler: Fix cont_splash_mem mapping
Date: Mon,  8 May 2023 11:41:01 +0200
Message-Id: <20230508094429.516252950@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Petr Vorel <pvorel@suse.cz>

[ Upstream commit fe88480a6be92ecbf6f205ff3a7d7e5ded0562dd ]

Angler's cont_splash_mem mapping is shorter in downstream [1],
therefore 380cd3a34b7f was wrong. Obviously also 0e5ded926f2a was wrong
(workaround which fixed booting at the time).

This fixes error:
[    0.000000] memory@3401000 (0x0000000003401000--0x0000000005601000) overlaps with tzapp@4800000 (0x0000000004800000--0x0000000006100000)

[1] https://android.googlesource.com/kernel/msm/+/refs/heads/android-msm-angler-3.10-marshmallow-mr1/arch/arm64/boot/dts/huawei/huawei_msm8994_angler_row_vn1/huawei-fingerprint.dtsi#16

Fixes: 380cd3a34b7f ("arm64: dts: msm8994-angler: fix the memory map")
Fixes: 0e5ded926f2a ("arm64: dts: qcom: msm8994-angler: Disable cont_splash_mem")

Signed-off-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230131200414.24373-2-pvorel@suse.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts
index 7e2c0dcc11ab1..4c47d8015482c 100644
--- a/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (c) 2015, Huawei Inc. All rights reserved.
  * Copyright (c) 2016, The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2022, Petr Vorel <petr.vorel@gmail.com>
+ * Copyright (c) 2021-2023, Petr Vorel <petr.vorel@gmail.com>
  */
 
 /dts-v1/;
@@ -30,6 +30,11 @@
 		#size-cells = <2>;
 		ranges;
 
+		cont_splash_mem: memory@3401000 {
+			reg = <0 0x03401000 0 0x1000000>;
+			no-map;
+		};
+
 		tzapp_mem: tzapp@4800000 {
 			reg = <0 0x04800000 0 0x1900000>;
 			no-map;
-- 
2.39.2



