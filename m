Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C1A231829;
	Tue, 21 Jul 2026 17:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655912; cv=none; b=KpSzG/pukyKZvh7TMCCn6mi3WTuM+bQvgLBu5sydFezwcRqlBFRqeSotNZVYDXQV1B6f0+xk7X6zBh2NayMPLZ7Sqw6bNfqg9RqESTPdvnR6L7/ed6klTHrVLYFOxqpw9o1eks3aqghkNPJdDc32d2VeTNIRF5Ow3Rvi+1BpJMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655912; c=relaxed/simple;
	bh=UBfuu0nO2NaimEOsXWMgsoJyyb7DoiVx52QG7TOpR/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrPVmyhyK49BF1E3YQpJzGCwELSYQgCKJx8ykx1TIkMSKQyOlunrNynOvgcUNC9U5fuoLj3a4SEtkJf4zy4DbsQ/EgXY6j7/lfI9cCgEW/kiOsezst+T87+iP5NjIgyhPE0yRQWy+Timm7QQwxxPyzMvPx8uWumeZok4siLI0nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdGEAzpi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdGEAzpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEF81F000E9;
	Tue, 21 Jul 2026 17:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655911;
	bh=ay4JzFYTYAZJ0rMxAx4RcB9oMqvx5DbqQifEj4u1VSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QdGEAzpiOddfC1INA+vh5OQdVH/ViEe/dCb6rWtBMfGtSU5XtKIwYrPzjrFXDnGnR
	 vWuyuZGI+oEogewOYCkFNsuffUsTKbGeuMNuScLg8erSTsP/Y/hmLQtUjH77KVzQSR
	 P7Y7CKI7fHikGrUQ9iMDCehpS+ArPq8cStCzweWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0186/1611] arm64: dts: qcom: kodiak: Add power-domain and iface clk for ice node
Date: Tue, 21 Jul 2026 17:05:02 +0200
Message-ID: <20260721152519.119115815@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Harshal Dev <harshal.dev@oss.qualcomm.com>

[ Upstream commit cca53c338ad87edc4b46d2d82730fd8ca01a164f ]

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
kodiak.

Fixes: dfd5ee7b34bb7 ("arm64: dts: qcom: sc7280: Add inline crypto engine")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260416-qcom_ice_power_and_clk_vote-v5-7-5ccf5d7e2846@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 07cabbb2058f81..ed87bcb0d4b69d 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2574,7 +2574,11 @@ ice: crypto@1d88000 {
 			compatible = "qcom,sc7280-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d88000 0 0x18000>;
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
 		};
 
 		cryptobam: dma-controller@1dc4000 {
-- 
2.53.0



