Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAAF2DECC2;
	Sat, 12 Sep 2026 07:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198787; cv=none; b=bAUvLwMX+2S5FO6CnxE31577/pcwPCyzyUHu6J5Xa9EN1dA72Sur62CLy8f6/SKbCsCBa+w/QtYbN6U4+zvrzG0UVeq93x/+uAny9gKlFxxBjRHT6ggmLHi0qHhGbTM0Lu8FfDeciXjWB34FeFoMqzeboUxmSpUGliVh/pIi5ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198787; c=relaxed/simple;
	bh=GEmYCGYNlS3Jyf1/9sx2JTlb95SVaKryCEJ1prxZmbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stDP3TOL558ebb3HTTWn8a8xmjl1ICEKgtskvy1JU2uNDbNRJQwJNsOSEOAIanGyjoEeBK1efVdmYhsPqedI+kAaL/CBFvNvW6UQjqSdjseepNnFqzgXN1K7vNzQQLApDWh7Y0or6KELi+Rpybu6n0uHKwMgJIcx8fXCVZXYY50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TgoHKYlV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TgoHKYlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CEE51F000FF;
	Sat, 12 Sep 2026 07:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198786;
	bh=OckYt+f9PpeV4fIPFvY5x8BYYZEFBUzEEj1xZIp8IV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TgoHKYlVt32yqGxWqW6xGDPcHJGUPSrE+yB5COLzC4z8HbfriDFdNkuR2kpjW7l1U
	 ZVgy9Ss6jKVI5VQ20Ryxtw+ms1/79FYoMVG9yBxjRs/NU4QlmOIgG80soAbASB4pXj
	 LSeKXC3+ihOk4aMDo9bxoMuOivGB6tKaKobAvedI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Moussalem <george.moussalem@outlook.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0450/1815] arm64: dts: qcom: ipq5018: Correct CMN PLL reference clock rate
Date: Sat, 12 Sep 2026 08:36:40 +0200
Message-ID: <20260912065659.456107010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Moussalem <george.moussalem@outlook.com>

[ Upstream commit 5e92312a1d7542be9a0e588467bfbb2ca123eaac ]

The correct CMN PLL reference clock rate for IPQ5018 is 4.8 GHz.

The CMN PLL driver did not account for the ref clock divider which is 2
for IPQ5018. Therefore, the computed rate was twice the actual output.

With the driver now accounting for the CMN PLL reference clock
divider (commit: 88c543fff756), set the correct reference clock rate.

Fixes: c006b249c544 ("arm64: dts: ipq5018: Add CMN PLL node")
Signed-off-by: George Moussalem <george.moussalem@outlook.com>
Acked-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260521-ipq5018-cmn-pll-rate-fix-v2-1-04b28a92e0f2@outlook.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq5018.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq5018.dtsi b/arch/arm64/boot/dts/qcom/ipq5018.dtsi
index 6f8004a22a1ff..f6cf2cca44eb0 100644
--- a/arch/arm64/boot/dts/qcom/ipq5018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq5018.dtsi
@@ -256,7 +256,7 @@ cmn_pll: clock-controller@9b000 {
 				      "sys";
 			#clock-cells = <1>;
 			assigned-clocks = <&cmn_pll IPQ5018_CMN_PLL_CLK>;
-			assigned-clock-rates-u64 = /bits/ 64 <9600000000>;
+			assigned-clock-rates-u64 = /bits/ 64 <4800000000>;
 		};
 
 		qfprom: qfprom@a0000 {
-- 
2.53.0



