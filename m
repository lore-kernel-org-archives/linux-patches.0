Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6375146D563;
	Tue, 21 Jul 2026 15:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648615; cv=none; b=qA1XZO/YOaaQ2T+JLWHcKBjV2iy0opaAJ02eLsIhKprGPJYT0o//1IKBGc0qoFw98/rQR3x7WryxPHXsYMfG+EMFLPwEi6NQRgy28JLwSwFuHeKjFsGP5O2QfxeJUmHfsIOOFrmVUEiQFoSsVHH9p0bjkP3iAp8L55jFBNwXg8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648615; c=relaxed/simple;
	bh=LX3lElhje8r9AR1xM+Iy+apiwH7+5MERVZ2G9E+Q8cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ias+5vDWjaqhsnSt/zUYg8fWDZrDwCKiJVL4SJq+Oe0L8AtPQgvfHQDVYrjMi8BIUI9CqQQPsx/epLCdQuE38xl00ZhXh04UM76g/Um5a0o4YJ+Q6Km/IJ8ecOSPg9coIKczMMh+22SjxTCbXBYaZWj4buvfAcvrK5c/I/CjWAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gv+4VGJJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gv+4VGJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA6A1F000E9;
	Tue, 21 Jul 2026 15:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648613;
	bh=u0A8x4FgTAOKA4TYTNvQjp35446Rn7eEAFiP0wPq0zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gv+4VGJJSfRDXz8A4Alic8TiiRWDe0LIXXPLcOnpCbqkNI3B8bHZnK7eZmZFOM95t
	 WplzEcVFODG3eGbuoOBR2WkbKCWCOjYmyd7wExCv96d9uJHKWTGu8iEcOnM/acQyFM
	 gcLcL8Gn2OD8YPMPVDsCqWG5mpKz967UCvRJNFII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0264/2077] arm64: dts: qcom: kaanapali: Add power-domain and iface clk for ice node
Date: Tue, 21 Jul 2026 16:58:57 +0200
Message-ID: <20260721152558.905356681@linuxfoundation.org>
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

[ Upstream commit 11b48f6d5ed505ced9cd3645d6615279198a7a54 ]

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
kaanapali.

Fixes: 2eeb5767d53f4 ("arm64: dts: qcom: Introduce Kaanapali SoC")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260416-qcom_ice_power_and_clk_vote-v5-3-5ccf5d7e2846@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/kaanapali.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/kaanapali.dtsi b/arch/arm64/boot/dts/qcom/kaanapali.dtsi
index 7cc326aa1a1aab..14e362a4899b61 100644
--- a/arch/arm64/boot/dts/qcom/kaanapali.dtsi
+++ b/arch/arm64/boot/dts/qcom/kaanapali.dtsi
@@ -2538,7 +2538,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0x0 0x01d88000 0x0 0x18000>;
 
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
 		};
 
 		tcsr_mutex: hwlock@1f40000 {
-- 
2.53.0



