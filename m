Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D27B1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9269EC433C8;
	Mon, 11 Sep 2023 14:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441328;
	bh=lASbElQAZhzMUIkMIRUtBfgvWJJdbX3vU08Yox9Qd9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRnshk3joUfI74p7d/wpl6NthlazRB+W7EicLnTGGmVA5mn0c2YQuoX2KyCIbijr5
	 oF4hS3AMFcd1IqbpHmzme4/MdYlI+CapDqKBVgPwmWH8JsOFyoQe1Q+TAxfCYMT7op
	 xIbFqGfApA1fgYxiQL7ZTScHzGOL6Wzz4nOO/6C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohit Agarwal <quic_rohiagar@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 348/739] ARM: dts: qcom: sdx65-mtp: Update the pmic used in sdx65
Date: Mon, 11 Sep 2023 15:42:27 +0200
Message-ID: <20230911134700.838296243@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rohit Agarwal <quic_rohiagar@quicinc.com>

[ Upstream commit f636d6c356b339b0d29eed025f8bf9efcb6eb274 ]

Update the pmic used in sdx65 platform to pm7250b.

Fixes: 26380f298b2b (ARM: dts: qcom: sdx65-mtp: Add pmk8350b and pm8150b pmic)
Signed-off-by: Rohit Agarwal <quic_rohiagar@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/1691415534-31820-7-git-send-email-quic_rohiagar@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom/qcom-sdx65-mtp.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom/qcom-sdx65-mtp.dts b/arch/arm/boot/dts/qcom/qcom-sdx65-mtp.dts
index 02d8d6e241ae1..fcf1c51c5e7a7 100644
--- a/arch/arm/boot/dts/qcom/qcom-sdx65-mtp.dts
+++ b/arch/arm/boot/dts/qcom/qcom-sdx65-mtp.dts
@@ -7,7 +7,7 @@
 #include "qcom-sdx65.dtsi"
 #include <dt-bindings/regulator/qcom,rpmh-regulator.h>
 #include <arm64/qcom/pmk8350.dtsi>
-#include <arm64/qcom/pm8150b.dtsi>
+#include <arm64/qcom/pm7250b.dtsi>
 #include "qcom-pmx65.dtsi"
 
 / {
-- 
2.40.1



