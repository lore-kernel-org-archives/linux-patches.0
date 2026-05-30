Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA05933F8A2;
	Sat, 30 May 2026 17:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161290; cv=none; b=jy/nwHddXs+Lvfdyy3cD/+gyW95bhLu7GW06X+xG9uVWZaGLvIpsbra1sr3GQeHzcMp2RzB1f6E6EZWicGPjM0gey53dClUbNLoqz2TzXKnXudMWOfoQzPCfoiikSEWMcxac12xRDsmOh3L4qE+DKWQ2NdkXEntB0VN00LR/Nas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161290; c=relaxed/simple;
	bh=QGy1GLBlOE49iAtzAQcgudGR6lH3MtHv1q1FwZcSqug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MO9vZ7S5sZF2k21GL0F0lLlTtFZfGFebHDGBUclUfHBynU++mILYollkGqdlJ6sG3gvchE3tPsc5zL/PlBP34PhhWgXJUJtTBvZSoVhNvT4H7SWh7MwR/1+ELWfA1YKl8TrOYbsHANx09isWDMr4B3bJ97awGd6iOXKD/umVQPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSHaCB2o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSHaCB2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DA01F00893;
	Sat, 30 May 2026 17:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161289;
	bh=t3dnfZ+AgBIpAo9wbAu698T+7mU3lw4AjJGB3+4EkgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSHaCB2ot31DCyzoqcMCisLnX22xvMkiZePKgsJeTntWE2GCFoEy4MDFgv40hOa19
	 9OTrotX+hENPYhi1jGy7mAdC78Z7W9esBQ/OpCdobYvRb+RnE3Spl7cuxeOCBK9etz
	 NPpcpVh176pJg51CR5iLVoBDN5UdPDd362RFGmSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 581/969] arm64: dts: qcom: sm8450: Fix GIC_ITS range length
Date: Sat, 30 May 2026 18:01:45 +0200
Message-ID: <20260530160316.453689534@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 14044fa192c50265bc1f636108371044bbdcf7b7 ]

Currently, the GITS_SGIR register is cut off. Fix it up.

Fixes: fc8b0b9b630d ("arm64: dts: qcom: sm8450 add ITS device tree node")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260317-topic-its_range_fixup-v1-3-49be8076adb1@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 9420857871b1e..49502cdd1d4e0 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -2915,7 +2915,7 @@ intc: interrupt-controller@17100000 {
 
 			gic_its: msi-controller@17140000 {
 				compatible = "arm,gic-v3-its";
-				reg = <0x0 0x17140000 0x0 0x20000>;
+				reg = <0x0 0x17140000 0x0 0x40000>;
 				msi-controller;
 				#msi-cells = <1>;
 			};
-- 
2.53.0



