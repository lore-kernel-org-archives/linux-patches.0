Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8F8168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3CBC433D2;
	Mon,  8 May 2023 10:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541791;
	bh=EcHEW2fxCkX8xvjdikGQmUSKlrbCfFMawQG2r9OCvjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6UcCzctSzZ2qhez5IK5vVPF0LBp1O6yleVN6BFiBL1ZbJeU/LaJMqItzEzKSzmlR
	 8ZJS3+gVdOfdCWEPEyD5p2WJQS/0bPkv657WsSUxXDGtO+XdsKDULCq14oA93+TQ53
	 wpxZj5/5FBqVHyjdYEwKfqoBhttzd9CpbFmIEu4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <pvorel@suse.cz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 227/663] arm64: dts: qcom: msm8994-angler: Fix cont_splash_mem mapping
Date: Mon,  8 May 2023 11:40:53 +0200
Message-Id: <20230508094435.674811501@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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
index 7b0f62144c3ee..59b9ed78cf0cb 100644
--- a/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts
@@ -2,7 +2,7 @@
 /*
  * Copyright (c) 2015, Huawei Inc. All rights reserved.
  * Copyright (c) 2016, The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2022, Petr Vorel <petr.vorel@gmail.com>
+ * Copyright (c) 2021-2023, Petr Vorel <petr.vorel@gmail.com>
  */
 
 /dts-v1/;
@@ -31,6 +31,11 @@
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



