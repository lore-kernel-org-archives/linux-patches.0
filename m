Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0442DE702;
	Sat, 12 Sep 2026 10:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207476; cv=none; b=Iz4DcyopJe6QuvvYoN17K839i6yHl87XqHvAOgyPQyuAEwGN0g8Hj78qAsuW/ucKIvlulcSJbgfHwbODp76Sk8URkHSAe045r5iqO+QcEoArKFCRGSoefu3fSagO1m49WrLngP+ljyA3Ak5nKmpKV9RY8BTmlThM1IX+UcXzkCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207476; c=relaxed/simple;
	bh=9q3W8W+RX/3mQ8NE6vgZsXAW64La500j0wwzIAwWhBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eF2ZrPG+gGDyD1WNOmEreFp4a/qXlQBcy2wcnYrJMikzFTFwLolwkYx0mUoo1BYdZQT/gr2LEXJbWnVbF4P4lHlHWZI/fQp4i/jD5wG4z35ruHayOFD1gB2QCC5KXSeelaMgdKXKGML6+eK0q8b484JEuTloR85v0snQyHtOPII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SYv44QXT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SYv44QXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199541F000FF;
	Sat, 12 Sep 2026 10:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207475;
	bh=Tn9YxI1uEDS7/22gzwpBMdbOUr0M6jccXFfQwAxW640=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SYv44QXTxn+26HOzKRxfNygXs52IaJKdQbd+DFKn9G2vMRpQ3p0lP5JyEjeOgse+Z
	 KQZhCM9ZRJ1LLdi5YUSdzzKru1RvDpT1REeUsYZzXBDoCgoi9tZfwM1cO82Y2o39NT
	 yxXxnTdrMjnoGUdPS7ZMhj9vosxJREbYgevUAbr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Moussalem <george.moussalem@outlook.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0413/1518] arm64: dts: qcom: ipq5018: Correct CMN PLL reference clock rate
Date: Sat, 12 Sep 2026 08:43:02 +0200
Message-ID: <20260912065632.798052070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f024b3cba33f6..ed1abb41fbe47 100644
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



