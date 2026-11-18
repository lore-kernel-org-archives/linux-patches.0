Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040221;
	b=tlSsA82QwvUdU66I9YeeNz9Ta1MyBSG8dqX0rfpwcQU+mvG9UxpUxHI2TzwPJSDnWfeE
	 OduDJXg0RiDd0Js6xi+GtfpPxobBWqDKodmRlwtx4s98IfEVHkZFSpVBGkx2rjFkPs4FT
	 hQ79LXL/5OEMUO3wxaf0m2w3tvIe7S5mGBCPNk1jbggkykOw1qu/lVE7kC1Zu4IN2m3GK
	 G5LCgAUA/c+gk6OcgDTfTAOk/K6g8ZBLVxQzKHMbfsBqWHTOsG9JjqgoYJhLVRIxfTqkV
	 lYUv44Mh5bZUSIxAaAtFb04/7G+CcXQ04h2T6FwvcYx34ClaXd4WXBxn7AaPU6qWq6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9PT1QbOpvJSg2RR+ipisn83inLyqR3VlR7MvCecT/uA=;
	b=43m1vbUWhwYVL0SlaFhg/aRqW6hzatNadW9UlSuZBkYXd5QIPYSGy01LsihVhOokGzT/
	 NkGQptT5HVqyT7ApvFl6CMKoM6KjUcOwUm6/CY4q5NsuxlqBVOZlROd03lgnacwc8gUz1
	 VHkQw40FbWvYKsJkqGG/HqgGExCEBmREsKgjFIOk+Mv/JDjGGRxTQPFVgufUItxue8HNw
	 BjGay7zJfF+RyPJUC5o5WLNlVvvCM6iOi/x3Ats934CSZto80Y277R7PcM5/D4rLQAaN5
	 CkhKb4F8O+uIpQkFDZXPnvJA5zbbsHaeaKUQ3nFcFdINanSUEDAXUNUI2UwDiqZ98zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iOs9rHEe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB54606A32A;
	Wed, 18 Nov 2026 22:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iOs9rHEe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C375E1F000C4;
	Wed, 18 Nov 2026 22:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040221;
	bh=9PT1QbOpvJSg2RR+ipisn83inLyqR3VlR7MvCecT/uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iOs9rHEeTZQGyeSrimE9VbsFWaBhP+U5x0NLWLVhXv0JsINTrht0G/gJ49O/dJc/9
	 tiSVZwpHllDUpO2kq5pPRGMZ5xlVIinXy9bOmf1uES+ywPxAU03COJmxBCLeHyGi9S
	 ueFABtAm0ArenaXAEG67k4WwjRziHTE9jX3CV1sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca@lucaweiss.eu>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2380/3318] ARM: dts: qcom: msm8974: Sort header includes alphabetically
Date: Wed, 18 Nov 2026 15:50:02 +0100
Message-ID: <20261118150432.940451702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca@lucaweiss.eu>

[ Upstream commit 4cf8d541f4716444b61a919e3fe6f04814165782 ]

Before adding more headers in a random order, let's sort the includes
once so that's done.

Signed-off-by: Luca Weiss <luca@lucaweiss.eu>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250621-msm8974-rpmpd-switch-v1-3-0a2cb303c446@lucaweiss.eu
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 542991a1d77e ("ARM: dts: qcom: msm8974: add MDSS reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom/qcom-msm8974.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi
index 132233cf0d61c..bc550ccc5c581 100644
--- a/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi
@@ -1,14 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0
 /dts-v1/;
 
-#include <dt-bindings/interconnect/qcom,msm8974.h>
-#include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/clock/qcom,dsi-phy-28nm.h>
 #include <dt-bindings/clock/qcom,gcc-msm8974.h>
 #include <dt-bindings/clock/qcom,mmcc-msm8974.h>
 #include <dt-bindings/clock/qcom,rpmcc.h>
-#include <dt-bindings/reset/qcom,gcc-msm8974.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/interconnect/qcom,msm8974.h>
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/reset/qcom,gcc-msm8974.h>
 
 / {
 	#address-cells = <1>;
-- 
2.53.0



