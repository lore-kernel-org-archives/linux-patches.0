Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A341170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E72C433C8;
	Mon, 11 Sep 2023 14:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440989;
	bh=ewJ0/MnH0f818qozDCHMjlrNXYbyXQ0TcClzhjEYAXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qWTaxqMFEDpZ9H/6LbjMb8FNvRjsfnUYC1S4Lvj7yAUUe8UcgBXkga6R2bNjZtaFf
	 LQQvSQR8CD9niIdQgA7+etuLXRPaVH431A/9lVd28h6YeDaIcGWjysSvYIuW9qFOMb
	 N7BRlte4EPuEDjE8hpQ2ypXuc3hNvJwvTGEtA9r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 230/739] arm64: dts: qcom: sc8180x: Fix cluster PSCI suspend param
Date: Mon, 11 Sep 2023 15:40:29 +0200
Message-ID: <20230911134657.596604960@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 9c31a3f5abc9eeb6509d06041b1e5f12deb39c4d ]

The value was copypasted from 8150, but 8180 expects a different one.
Confirmed with both downstream device tree and Windows DSDT, not tested
on hardware (sorry, I don't have any).

Fix it.

Fixes: 8575f197b077 ("arm64: dts: qcom: Introduce the SC8180x platform")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230705-topic-8180_sleep-v1-1-c5dce117364e@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x.dtsi b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
index be78a933d8eb2..e58f931c2e459 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -298,7 +298,7 @@ BIG_CPU_SLEEP_0: cpu-sleep-1-0 {
 		domain-idle-states {
 			CLUSTER_SLEEP_0: cluster-sleep-0 {
 				compatible = "domain-idle-state";
-				arm,psci-suspend-param = <0x4100c244>;
+				arm,psci-suspend-param = <0x4100a344>;
 				entry-latency-us = <3263>;
 				exit-latency-us = <6562>;
 				min-residency-us = <9987>;
-- 
2.40.1



