Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A583ED3B2;
	Tue, 21 Jul 2026 19:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661753; cv=none; b=Xq00HDHz9VBdRkGOQOCU6F9WojxHONZXPefsZLmpmPCLkOi5xyVvISghqmO2/mSDQys9Oe4SH/oPjPkYF/EEbODiAZ+o4JdxubEo1HPWv/5zwtX/R37nBZgVzeGxNWgyh8LWFWSGyRU9u0kob7NwYfB/gHjDRv93brN3/q7g0+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661753; c=relaxed/simple;
	bh=MXw4Zp++3L3aAONQ2cSfZtHsO7mrSGeR6Abl4DQFHHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcFUb53Xfr9MJXq4o7vJMsMiCxJMByDnJYS+KF1bXyndv0FQS5L34jkg98ennSVwCGNF0lJVll+94+hCvJ2JvC2/F7fdZSsMobLN/Ew/3n0FMpnXczeaIuXaY2qFVlb1iAi4TFU4RPdVcA63hBZTYmufk760M9g/fKWzrhHTrOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ovf7DoyA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ovf7DoyA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7101F000E9;
	Tue, 21 Jul 2026 19:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661752;
	bh=EDLcUekdc+hNRQbE5ORiSxYIyARxyjtNTWQvCQM8+9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ovf7DoyAHS3+N2fhBtTsliYhcdGX2BCEh3ow3Mji72LadEzDihTjoivLyOU4rwiEh
	 9uWXBv+ZuMt+8HWbeBXpK80AldtS4SNGNePiKh8i6pP0J/eXKT5rgy77NH31W3Rl0d
	 4xwvpMFky5apGC5+4edUUHOYtPjzOh6caoh1rcUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0142/1276] arm64: dts: qcom: sm8650: Add power-domain and iface clk for ice node
Date: Tue, 21 Jul 2026 17:09:45 +0200
Message-ID: <20260721152449.278512872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6098206350f90c..b4d9900e17763d 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -2608,7 +2608,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d88000 0 0x8000>;
 
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc UFS_PHY_GDSC>;
 		};
 
 		tcsr_mutex: hwlock@1f40000 {
-- 
2.53.0



