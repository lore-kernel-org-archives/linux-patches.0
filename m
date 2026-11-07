Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063012;
	b=bHI7advyrXw28GEV9y1i2O4ncnvv0mRPEGppjzum+xL/v7m6iGVweofsO3a4IbuKkH+7
	 FWNbC0XjOQXWWgfPv/zFHluD+qEf8xxIjdg73Sc0K0fdNq1YAi2RMCVgSyizdrDYXVQZx
	 ia0RieVRkGfeDsdYKF84q+NEGjVU8+yv2j4aXxz7BfsR0xgwKIVCHCPwkcRv6mf5yjcqr
	 9eQcwRjz/qpQ0yMlno+UgKx2R6nHiAKvdG0ebqeLB2tKhjWFA+rvQSWfP14E1adUb90ad
	 hTT/7IejUVfoFK3TJHUlLOfzMc4FoT/zg8AoQfBLzBbqj1UzceD+6rP6NJJiJ7oNsLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K9EAgYkxxuNObD6xFKn8hDhmgrgVkqgk2jnFTIaDhRM=;
	b=AzHjZruK8PUVndq5AaDtOsiF+q8Z3rdbtNlCGset/0ubRtuUTR29e+ETJtleMu2zcYnA
	 VSck8tLJ0yRo+jahP0XP7gxLiaaFkfwkak1jqxfFFpXr/RnLACWH9D1G+GFCN5jxWWaRA
	 aMtthP+zhifZ80Eb3snTwmrIM/yauX+d3dvWPSR1Mf2JC4T1MMgLUZSgOWtapDVswvGzE
	 dczfHHM5u39aaFF8UWlqL5/ws5pYnzs43qtW5f/Tpq0XEwmw1HRFFYcJwM0bvzpM/rIc6
	 NghiX+ZXYNKX3FqeNA79J/U9RFOIhiTNdlGOuMQR9AohlMkBhZZzeY61NefEacgSPsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="r9Ja1/y0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0172606D801;
	Sat,  7 Nov 2026 14:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r9Ja1/y0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4601F008A1;
	Sat,  7 Nov 2026 14:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063011;
	bh=K9EAgYkxxuNObD6xFKn8hDhmgrgVkqgk2jnFTIaDhRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r9Ja1/y0D4go97J5/4JEXwl1nooUlOyVRsGzNroqTVeqmpsfsZcY6oG4ZCtSS4jDV
	 Gox2cMgdvJPFeg4MwIT1s1ZQicqk95OTM+AOBO8UMYzPujUOmbM+ZJdXzLcBl8HdP3
	 fbSti4OujxVqDMI3yVyX6dpzWwopFHe/bjzyQpBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 263/869] arm64: dts: qcom: ipq9574: Wire up USB3 PHY PIPE clock to GCC
Date: Sat,  7 Nov 2026 08:49:05 -0500
Message-ID: <20261107134900.655486460@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>

[ Upstream commit 117d8d40be1ded4f35f3252efa83607a7134d5e0 ]

Connect the QMP PHY USB3 output to GCC so the USB3 PHY pipe clock can
propagate to the USB controller.

Cc: stable@vger.kernel.org
Fixes: a98bfb31f676 ("arm64: dts: qcom: ipq9574: Add USB related nodes")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921-ipq_clk_changes-v1-4-d242e3d49648@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq9574.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq9574.dtsi b/arch/arm64/boot/dts/qcom/ipq9574.dtsi
index 86c9cb9fffc98..d3895259f25cc 100644
--- a/arch/arm64/boot/dts/qcom/ipq9574.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq9574.dtsi
@@ -432,7 +432,7 @@ gcc: clock-controller@1800000 {
 				 <&pcie1_phy>,
 				 <&pcie2_phy>,
 				 <&pcie3_phy>,
-				 <0>;
+				 <&usb_0_qmpphy>;
 			#clock-cells = <1>;
 			#reset-cells = <1>;
 			#interconnect-cells = <1>;
-- 
2.53.0



