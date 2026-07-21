Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A7746D563;
	Tue, 21 Jul 2026 15:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648700; cv=none; b=uyBYRde4/YcjSMVkiwoxee8hfFHpzB2IDGkndnlDzRbsr9BQPjcuQvbeRIZuN9VqeiW+HsdyRObZONGZJ/l5R3w140R1XzbnZ+kA8I5lPa8MMBdlyNa/C1UMW6+/Otdd6+Kj4T7j+ND4yWU3BqMBKBlvCAHGA0SRKbFfxL3PsYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648700; c=relaxed/simple;
	bh=d6U7pqGXN/HcGz6g2LXOxf2GXTXWuP11XhPztSWnPNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2c0UzhbxK9lyoJJ8Q78fmm2dpMxyCpEHb6ro6USmj/xZ45eSE5F2zOICvYonjcE3StOTrTlfCRrwloDyC/sFZpVsVsiFgKbKnbPWIRqln4eq1xKmRsrX0WI7KidgH6unDlJC0J+RFxoO68q2G4BTTriYEAqrm86O+wjdNrUucg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVP7pHil; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVP7pHil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3346E1F000E9;
	Tue, 21 Jul 2026 15:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648698;
	bh=2QM7bu9IrUtVUj3Y4KQL55VNHF8PYTGSeMqwCsCf80o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EVP7pHilBDg5mGfYo2WHLMFopKlhasGF9lUQBrPBliu48Cil/J6uJ7oeN1W0UHyb5
	 VZYp2OtlYTvkaNep0o+a50Pi8luCF6NPjXjfk+BCqYbegLvD9EEGGY2YBt7GVlOTql
	 088bieCMOXm8Qc4a+x1WY1m7w4Wmg1jrwuQyDQ9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0271/2077] arm64: dts: qcom: sm8650: Add power-domain and iface clk for ice node
Date: Tue, 21 Jul 2026 16:59:04 +0200
Message-ID: <20260721152559.070362306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshal Dev <harshal.dev@oss.qualcomm.com>

[ Upstream commit c62b084d5d1564f808408a2f7d4c514e57cd4106 ]

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the UFS_PHY_GDSC power domain is enabled. Specify both the
UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sm8650.

Fixes: 10e0246712951 ("arm64: dts: qcom: sm8650: add interconnect dependent device nodes")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260416-qcom_ice_power_and_clk_vote-v5-10-5ccf5d7e2846@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 1604bc8cff3735..e2d98cf6adca8f 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -4081,7 +4081,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d88000 0 0x18000>;
 
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc UFS_PHY_GDSC>;
 		};
 
 		cryptobam: dma-controller@1dc4000 {
-- 
2.53.0



