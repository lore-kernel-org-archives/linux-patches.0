Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8180F1E633C;
	Wed, 20 May 2026 16:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295799; cv=none; b=NOWCPA5cCrsZqZ3OPufJ6f6NCuCXNW5FZequiG5QfzCAaNoz/Te/mvXb0C+U9LWhGBcPrxctyHI+hcP+S0QGZrbxvCwfWIyX4jCxrWIPgFxYSg2mACjBO7xtxuAL/sBoAr5nCjoItNrrFUe0nxedveYkqcBmLrCB0hs9BbORuNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295799; c=relaxed/simple;
	bh=AbB4QbLPmtco/EWYoDzvrsiKOXfYug8MaeW5eBoYhak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLCrz77bw/UO11i3vchJ9LaBmETJy+u1MMbRNgvAFoMRakUk/HzdBKTPIkP8FwTRHZeb5SgQ7SBQIZcyocqw64br1Mn6cSmGNMLLDfN5ApgACXOJUA+5ecRhFfz/AOrMdT/Qy6N780zpXR08iTfyEDdzsPzyDVeZbluBfSoeB8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0u5h28R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0u5h28R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE83A1F000E9;
	Wed, 20 May 2026 16:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295798;
	bh=BQeoKKTxXrSBnBpplYCBqk5hFlfGX+s1j9Mk3lcPja0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V0u5h28RsYSUv4xJ9vfcINi8qY12Ucz/NhiT2MCMn7HWf4ivo8LESRJ3vmIlpN4p/
	 BLrg6KeKRuBopiR1aTvhuRIep4n+fqHZAYr2SMDsfAE8RebtjPHinoQZbL+q4duzjT
	 qBYr3Esny6dce41PIMunK/VB4yP0AdpEOFbOKM5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0519/1146] arm64: dts: qcom: sm8450: Fix GIC_ITS range length
Date: Wed, 20 May 2026 18:12:49 +0200
Message-ID: <20260520162159.930123250@linuxfoundation.org>
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
index 920a2d1c04d0c..1ac74ff586b86 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -5104,7 +5104,7 @@ intc: interrupt-controller@17100000 {
 
 			gic_its: msi-controller@17140000 {
 				compatible = "arm,gic-v3-its";
-				reg = <0x0 0x17140000 0x0 0x20000>;
+				reg = <0x0 0x17140000 0x0 0x40000>;
 				msi-controller;
 				#msi-cells = <1>;
 			};
-- 
2.53.0



