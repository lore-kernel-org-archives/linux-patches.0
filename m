Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE5D3630AF;
	Wed, 20 May 2026 16:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295715; cv=none; b=ZNUyJON+OSoEeyqAUNFJpwgVI84WHHOgCSoEMR+0G+NXMRxbc7Z4OYXVXjslisjAf6ibYcFuRenOEHuWe/qdhbVFm/cWsxZyssN31OUp8YEO/hfiPkBzyobmw2kijlhFSwN+KMF2shwr5rxij8z+w5L6R6K034GtI7pWwZWBnk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295715; c=relaxed/simple;
	bh=das5MQs4PNCHgL8yXnagjqSowIWnC8r5lj28tDkVivY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0Knud1r+2trNsNpb7QVqNRSbfcqyCqb9vktTicUv7UDRFQlf6pjRr4m8glztbQusQ75bJX7ddC5nivhG/6ZD/X7mmm3nOaQQ1R1aJWWjD4leBKUzVst7PF3O+TTIdMbNpy+QyNCFWT0F9xuEHm9eX+pxGjDE6RCavxMep2/LEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MUA5z5Yn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MUA5z5Yn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B151F000E9;
	Wed, 20 May 2026 16:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295713;
	bh=QXZ1CqAMdIYIGbR6+yUVHyZgnHhB5HNwgHYJnGQA68Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MUA5z5YnYlltCBo6t2zZMWb1v8W4R4guxsdob19wp+xEC10R6UqsKQxio4v09WaCh
	 KlQ7ecy9M8adIShxYsO9725jQ+IEf8Dtng0ZFEwNZX8Y7VyR8Mh6ski0D8W3PtDaJa
	 /NQc3i+Qoje+O4J1RD2pkbsFGl7PgHZlyjy6A+w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0525/1146] arm64: dts: qcom: hamoa: Fix xo clock supply of platform SD host controller
Date: Wed, 20 May 2026 18:12:55 +0200
Message-ID: <20260520162200.062934243@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit d094f79960e1da20c1380083c95945371baa3668 ]

The expected frequency of SD host controller core supply clock is 19.2MHz,
while RPMH_CXO_CLK clock frequency on SM8650 platform is 38.4MHz.

Apparently the overclocked supply clock could be good enough on some
boards and even with the most of SD cards, however some low-end UHS-I
SD cards in SDR104 mode of the host controller produce I/O errors in
runtime, fortunately this problem is gone, if the "xo" clock frequency
matches the expected 19.2MHz clock rate.

Fixes: ffb21c1e19b1 ("arm64: dts: qcom: x1e80100: Describe the SDHC controllers")
Reported-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20260314023715.357512-4-vladimir.zapolskiy@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/hamoa.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/hamoa.dtsi b/arch/arm64/boot/dts/qcom/hamoa.dtsi
index f01b363009826..cb95549275ca8 100644
--- a/arch/arm64/boot/dts/qcom/hamoa.dtsi
+++ b/arch/arm64/boot/dts/qcom/hamoa.dtsi
@@ -4714,7 +4714,7 @@ sdhc_2: mmc@8804000 {
 
 			clocks = <&gcc GCC_SDCC2_AHB_CLK>,
 				 <&gcc GCC_SDCC2_APPS_CLK>,
-				 <&rpmhcc RPMH_CXO_CLK>;
+				 <&bi_tcxo_div2>;
 			clock-names = "iface", "core", "xo";
 			iommus = <&apps_smmu 0x520 0>;
 			qcom,dll-config = <0x0007642c>;
@@ -4767,7 +4767,7 @@ sdhc_4: mmc@8844000 {
 
 			clocks = <&gcc GCC_SDCC4_AHB_CLK>,
 				 <&gcc GCC_SDCC4_APPS_CLK>,
-				 <&rpmhcc RPMH_CXO_CLK>;
+				 <&bi_tcxo_div2>;
 			clock-names = "iface", "core", "xo";
 			iommus = <&apps_smmu 0x160 0>;
 			qcom,dll-config = <0x0007642c>;
-- 
2.53.0



