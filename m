Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024713;
	b=BeqMgd3ztQGLLlxeZDk7tY0p/f2AoKgZlrtMy+P31fGuI6epP6I8eVqd1gGJEdVhQbNv
	 F7S9ywh8yg3DasJaXfek5KNVwGIWXyUYlWH/77T7K3Gz4cByg5YQx/6Bm4fb3QAlo8r1v
	 ZxnOoau6UjB2xY5VGYslgqmpWe5jPUzay0Vvkt7gRyzVsoiVVTGz/Uz4zeiWuI8mxqYuX
	 mIgHmOehSHQq58z9bZzVXA3QnaaMWAAUOQsfoyHqNXRj37HlUi5pfsbGDhEEMVplWImiO
	 MtxzrZMCQ0vxQPAQwVRsPYrXiuZkfpvRgExMyHQxl6fIyNDXRN8QbSsCXOthswA4eiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rj0aVlR+mg5JDY1tB3P3nThUJGqAbzzyryvScjQ3/2E=;
	b=q/nztg5EgUUEGQNA4jE1GFu9G/a7GsOyTosRCKLeuDyDtl39Hcc7FUvtvRhCJzr6s3wH
	 SUSXHkFRiiujKtAfOd2ZMR+pS4AWXyxH84SCV+7U6DKoLTIHGyDegTwGdxxOeKK63ThKq
	 k2lWZhGI8S7ynCo+oFzsOLCWUlEkAJ3+nnXjrxnLIZPAvHXF0m+uvcBx/d5/U+8+eaTCd
	 MzImaZI1b+GAAem5Pjy55Xx75iCDR3TAnHIDNNu9huP/iY77eXU8JAE72d5KbBH8zO6DC
	 8SBMAhLUpYnG6/ns3iAg+b9PgJM1FzUDvl28JNyFIX5hcSaJ5ZxRp3WqWt0gjwA2oIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cSe4+CYS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07ED6606A32C;
	Wed, 18 Nov 2026 17:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cSe4+CYS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5773F1F000C4;
	Wed, 18 Nov 2026 17:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024712;
	bh=rj0aVlR+mg5JDY1tB3P3nThUJGqAbzzyryvScjQ3/2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cSe4+CYShZjxNaBjxjWw5g1tmP61GKhdRED+j5dChHx4AKJpb06TDcKCZTBzEnfe6
	 NwCgkEXzc9pTZ9ZtzscMCwrje2UOVxa56pwZnD2h3OhuyJxPxjDixXbLGQGKrOJT84
	 ebSGYxQyk4H2FcBGDg3wZme31sJtXxS0liIXOT4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Liu <xin.liu@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0782/2151] arm64: dts: qcom: hamoa-iot-evk: use on-board crystal for PS8830 retimers
Date: Wed, 18 Nov 2026 15:41:57 +0100
Message-ID: <20261118150150.595911865@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Liu <xin.liu@oss.qualcomm.com>

[ Upstream commit 723ce02feb131a81224a281872028d584b69b0ca ]

On the Hamoa IoT EVK, each of the two existing PS8830 retimers has its
own 25 MHz crystal wired to the retimer's XI/XO pins. The reference
clock does not come from the PMIC, so the RPMH_RF_CLK4/5 references in
the retimer nodes are wrong: they keep those RF clocks enabled for
nothing and describe a connection that does not exist on the board.

Fixes: c11645afb0e2 ("arm64: dts: qcom: Add base HAMOA-IOT-EVK board")
Signed-off-by: Xin Liu <xin.liu@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260914101233.981643-3-xin.liu@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts b/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
index 368781045d0db..1118f0e44573a 100644
--- a/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
+++ b/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
@@ -33,6 +33,18 @@ mcp2518fd_osc: clock-40000000 {
 			clock-frequency = <40000000>;
 			#clock-cells = <0>;
 		};
+
+		clk_rtmr1_xo: clock-rtmr1-xo {
+			compatible = "fixed-clock";
+			clock-frequency = <25000000>;
+			#clock-cells = <0>;
+		};
+
+		clk_rtmr2_xo: clock-rtmr2-xo {
+			compatible = "fixed-clock";
+			clock-frequency = <25000000>;
+			#clock-cells = <0>;
+		};
 	};
 
 	wcd938x: audio-codec {
@@ -623,7 +635,7 @@ typec-mux@8 {
 		compatible = "parade,ps8830";
 		reg = <0x08>;
 
-		clocks = <&rpmhcc RPMH_RF_CLK5>;
+		clocks = <&clk_rtmr2_xo>;
 
 		vdd-supply = <&vreg_rtmr2_1p15>;
 		vdd33-supply = <&vreg_rtmr2_3p3>;
@@ -728,7 +740,7 @@ typec-mux@8 {
 		compatible = "parade,ps8830";
 		reg = <0x8>;
 
-		clocks = <&rpmhcc RPMH_RF_CLK4>;
+		clocks = <&clk_rtmr1_xo>;
 
 		vdd-supply = <&vreg_rtmr1_1p15>;
 		vdd33-supply = <&vreg_rtmr1_3p3>;
-- 
2.53.0



