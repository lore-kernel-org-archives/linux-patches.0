Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB17611706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECE6C433C9;
	Mon, 11 Sep 2023 14:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443622;
	bh=X2HFYFZBr6hfqjYuk6ZkDGk54TTCmhJNMtBKulp82DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBuBQNbUMxRh5lqbLQdZEvut5RNVlf4VeP5OlEEy53q/n9izpf+xdFhUfDIbhqo4G
	 gN+MBZSemqoAb7zJELVZFbphQ/+B4CCwmSafJGJjrZuOhg/jVlklb9IFbAa4BXVorZ
	 KXprPRMMIPmxfOL4QRCyQYbrO/FrYX6iJQFKMfVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imran Shaik <quic_imrashai@quicinc.com>,
	Rob Herring <robh@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 442/737] dt-bindings: clock: Update GCC clocks for QDU1000 and QRU1000 SoCs
Date: Mon, 11 Sep 2023 15:45:01 +0200
Message-ID: <20230911134702.944900721@linuxfoundation.org>
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

From: Imran Shaik <quic_imrashai@quicinc.com>

[ Upstream commit df873243b2398a082d34a006bebe0e0ed7538f5c ]

Add support for GCC_GPLL1_OUT_EVEN and GCC_DDRSS_ECPRI_GSI_CLK clock
bindings for QDU1000 and QRU1000 SoCs. While at it, update the
maintainers list.

Signed-off-by: Imran Shaik <quic_imrashai@quicinc.com>
Acked-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20230803105741.2292309-2-quic_imrashai@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 06d71fa10f2e ("clk: qcom: gcc-qdu1000: Register gcc_gpll1_out_even clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/clock/qcom,qdu1000-gcc.yaml | 3 ++-
 include/dt-bindings/clock/qcom,qdu1000-gcc.h                  | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/qcom,qdu1000-gcc.yaml b/Documentation/devicetree/bindings/clock/qcom,qdu1000-gcc.yaml
index 767a9d03aa327..d712b1a87e25f 100644
--- a/Documentation/devicetree/bindings/clock/qcom,qdu1000-gcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,qdu1000-gcc.yaml
@@ -7,7 +7,8 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Qualcomm Global Clock & Reset Controller for QDU1000 and QRU1000
 
 maintainers:
-  - Melody Olvera <quic_molvera@quicinc.com>
+  - Taniya Das <quic_tdas@quicinc.com>
+  - Imran Shaik <quic_imrashai@quicinc.com>
 
 description: |
   Qualcomm global clock control module which supports the clocks, resets and
diff --git a/include/dt-bindings/clock/qcom,qdu1000-gcc.h b/include/dt-bindings/clock/qcom,qdu1000-gcc.h
index ddbc6b825e80c..2fd36cbfddbb2 100644
--- a/include/dt-bindings/clock/qcom,qdu1000-gcc.h
+++ b/include/dt-bindings/clock/qcom,qdu1000-gcc.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause */
 /*
- * Copyright (c) 2021-2022, Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2021-2023, Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #ifndef _DT_BINDINGS_CLK_QCOM_GCC_QDU1000_H
@@ -138,6 +138,8 @@
 #define GCC_AGGRE_NOC_ECPRI_GSI_CLK			128
 #define GCC_PCIE_0_PIPE_CLK_SRC				129
 #define GCC_PCIE_0_PHY_AUX_CLK_SRC			130
+#define GCC_GPLL1_OUT_EVEN				131
+#define GCC_DDRSS_ECPRI_GSI_CLK				132
 
 /* GCC resets */
 #define GCC_ECPRI_CC_BCR				0
-- 
2.40.1



