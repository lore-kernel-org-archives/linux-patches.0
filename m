Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E6F1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD1EC433F0;
	Wed, 28 Dec 2022 15:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239875;
	bh=zv2iTeoDC2wxSOAAe5JxO8Pa2mb8m0RXw9vuiXCvrbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVgR7eNkhSNw6gB3gCopKDZv87QaOnbR/+Kn5yo+nJ2Ft3HOwth59NbReNNLnGFRP
	 St5rK6ZvaHbrbC3SqkJkEUwdSiuUI9D66a4WEyayKjsaq/B1yJcPA496FKkPB+dRIb
	 ngHjP7rIWERyY0hnjElmFn4UE2au3JeD7K6REC80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0053/1146] arm64: dts: qcom: sc7280: Mark all Qualcomm reference boards as LTE
Date: Wed, 28 Dec 2022 15:26:32 +0100
Message-Id: <20221228144331.604048862@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sibi Sankar <quic_sibis@quicinc.com>

[ Upstream commit 3c800bcf07a5957da01593e8f83d797b285a37e0 ]

When the modem node was re-located to a separate LTE source file
"sc7280-herobrine-lte-sku.dtsi", some of the previous LTE users
weren't marked appropriately. Fix this by marking all Qualcomm
reference devices as LTE.

Suggested-by: Douglas Anderson <dianders@chromium.org>
Fixes: d42fae738f3a ("arm64: dts: qcom: Add LTE SKUs for sc7280-villager family")
Signed-off-by: Sibi Sankar <quic_sibis@quicinc.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221110070813.1777-1-quic_sibis@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280-idp.dts  | 1 -
 arch/arm64/boot/dts/qcom/sc7280-idp.dtsi | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280-idp.dts b/arch/arm64/boot/dts/qcom/sc7280-idp.dts
index 7559164cdda0..e2e37a0292ad 100644
--- a/arch/arm64/boot/dts/qcom/sc7280-idp.dts
+++ b/arch/arm64/boot/dts/qcom/sc7280-idp.dts
@@ -10,7 +10,6 @@
 #include <dt-bindings/iio/qcom,spmi-adc7-pmr735a.h>
 #include "sc7280-idp.dtsi"
 #include "pmr735a.dtsi"
-#include "sc7280-herobrine-lte-sku.dtsi"
 
 / {
 	model = "Qualcomm Technologies, Inc. sc7280 IDP SKU1 platform";
diff --git a/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi b/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
index 7772dfba94ec..ca50f0ba9b81 100644
--- a/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
@@ -13,6 +13,7 @@
 #include "pmk8350.dtsi"
 
 #include "sc7280-chrome-common.dtsi"
+#include "sc7280-herobrine-lte-sku.dtsi"
 
 / {
 	aliases {
-- 
2.35.1



