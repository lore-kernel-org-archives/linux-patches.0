Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4B98F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8218AC433C7;
	Sun, 16 Jul 2023 20:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538253;
	bh=frsJeiiVIP81AALRxp/8OqiSqUC6C0yZ+J42aElDjwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dMm4tZ2I8ItXLvNpK42mZANLSDq0AJDuZQIzpBUGayodW1//169Tw/s068c5CmxP9
	 0IFWQ0vlbcn0bLUSk2YDNsYmKhitxNcl6A3nu+TeQNFaXeqk9skqtLzktVDzkZ+O0L
	 stovQHuVaHkBZ4GqK7+W3TEIM7BOVIUu1qL7u+0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 384/800] arm64: dts: qcom: qdu1000: Flush RSC sleep & wake votes
Date: Sun, 16 Jul 2023 21:43:57 +0200
Message-ID: <20230716194957.994208226@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit ab033e7846f91953244d0626b28ce66412b813b3 ]

The rpmh driver will cache sleep and wake votes until the cluster
power-domain is about to enter idle, to avoid unnecessary writes. So
associate the apps_rsc with the cluster pd, so that it can be notified
about this event.

Without this, only AMC votes are being commited.

Fixes: 6bd20c54b589 ("arm64: dts: qcom: Add base QDU1000/QRU1000 DTSIs")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230531-topic-rsc-v1-3-b4a985f57b8b@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qdu1000.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/qdu1000.dtsi b/arch/arm64/boot/dts/qcom/qdu1000.dtsi
index fb553f0bb17aa..6a6830777d8a8 100644
--- a/arch/arm64/boot/dts/qcom/qdu1000.dtsi
+++ b/arch/arm64/boot/dts/qcom/qdu1000.dtsi
@@ -1252,6 +1252,7 @@ apps_rsc: rsc@17a00000 {
 			qcom,tcs-config = <ACTIVE_TCS    2>, <SLEEP_TCS     3>,
 					  <WAKE_TCS      3>, <CONTROL_TCS   0>;
 			label = "apps_rsc";
+			power-domains = <&CLUSTER_PD>;
 
 			apps_bcm_voter: bcm-voter {
 				compatible = "qcom,bcm-voter";
-- 
2.39.2



