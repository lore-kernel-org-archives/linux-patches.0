Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2F017C9E9;
	Tue, 16 Jul 2024 15:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144957; cv=none; b=NIZRK7vLgcuT6xwmYEdeHpEcVBqnYs9+GPZyQekr+i9+KH+yAYVG6phItRDpgDGWDhmCDwN0KK+JWDmZIB1QalAiVnZoU6hVAHjhaY8roK8IgpHegeIyaZKMawOohEN1JNgd7gsVeliYAPPL/xB67A43ltipHvqgw94xh2rypUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144957; c=relaxed/simple;
	bh=d25bFW1HqRPIsrILpxoTcsG+Z0s8JAUkkPYsr2MVrkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWtOqsqoGS0RgFUtbiAXtPZ0eAQWU0C9wfnkMyuGFkGXUxBgwfK8lWPg9QqGDYSQj9ppC4TsQmObLpQiWguyTiUU8QSU44+LNotEYEhkZZN1Xn3+X50pmZ33w43DOu0Os7hCufVeK5hLtMRfXqXkgwzYYN93v4r1COMTREN75qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2twzC5AJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2twzC5AJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891D7C116B1;
	Tue, 16 Jul 2024 15:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144956;
	bh=d25bFW1HqRPIsrILpxoTcsG+Z0s8JAUkkPYsr2MVrkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2twzC5AJX93Ws6rIr0eDyhCKDIko1qVuofUpUdqn9coEU/PgVIrfArrKcehmJKSfx
	 Epz/YRIu1uM9E62FtuWP8aoQlMie08Y4I+sLAW2vUKgAC8LZBO6ysG0WxuvuznVU2V
	 DotvmmEC91a4uQ+R+m448T+vj3Rt4nL8zm1phgQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Komal Bajaj <quic_kbajaj@quicinc.com>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 050/143] arm64: dts: qcom: qdu1000: Fix LLCC reg property
Date: Tue, 16 Jul 2024 17:30:46 +0200
Message-ID: <20240716152757.910543353@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Komal Bajaj <quic_kbajaj@quicinc.com>

[ Upstream commit af355e799b3dc3dd0ed8bf2143641af05d8cd3d4 ]

The LLCC binding and driver was corrected to handle the stride
varying between platforms. Switch to the new format to ensure
accesses are done in the right place.

Fixes: b0e0290bc47d ("arm64: dts: qcom: qdu1000: correct LLCC reg entries")
Signed-off-by: Komal Bajaj <quic_kbajaj@quicinc.com>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240619061641.5261-2-quic_kbajaj@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qdu1000.dtsi | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qdu1000.dtsi b/arch/arm64/boot/dts/qcom/qdu1000.dtsi
index 832f472c4b7a5..ceed9c4e8fcd6 100644
--- a/arch/arm64/boot/dts/qcom/qdu1000.dtsi
+++ b/arch/arm64/boot/dts/qcom/qdu1000.dtsi
@@ -1459,9 +1459,23 @@
 
 		system-cache-controller@19200000 {
 			compatible = "qcom,qdu1000-llcc";
-			reg = <0 0x19200000 0 0xd80000>,
+			reg = <0 0x19200000 0 0x80000>,
+			      <0 0x19300000 0 0x80000>,
+			      <0 0x19600000 0 0x80000>,
+			      <0 0x19700000 0 0x80000>,
+			      <0 0x19a00000 0 0x80000>,
+			      <0 0x19b00000 0 0x80000>,
+			      <0 0x19e00000 0 0x80000>,
+			      <0 0x19f00000 0 0x80000>,
 			      <0 0x1a200000 0 0x80000>;
 			reg-names = "llcc0_base",
+				    "llcc1_base",
+				    "llcc2_base",
+				    "llcc3_base",
+				    "llcc4_base",
+				    "llcc5_base",
+				    "llcc6_base",
+				    "llcc7_base",
 				    "llcc_broadcast_base";
 			interrupts = <GIC_SPI 266 IRQ_TYPE_LEVEL_HIGH>;
 		};
-- 
2.43.0



