Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017419;
	b=PDGTr0j6rKD40rRnTML9iHKwfG9S0uZp1JlLBKo000gPD7LL/YyIYZbyhHPIRJWGBkfK
	 3vPg1qqPcT3OIjCx4LaqVWlF+yNI1GTIFslbAI+xEopHPKZfHGLgpEJQwHT24Ed4y29We
	 x7dG0wRuEubuKzAZmgNgFy6TabLjVi3K4yOeUpIfph0EJf7GZnUBhK9GtxCXebOuAi/RI
	 TuXONMXGDZQLWehhDGBjn++0J9iC5h7BQg46h1O8i1iwM3xl4wzC1gJ3MPrLJgocshHIF
	 XxWemOBJDcWR4HOw3uwbnP2kqd4ly+i/esLPIjgRktQDinGl85v8yQYCH7r9NIhCqdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yn574TqG6Har3AOgXlNJmOvwTPoayMxpiWeeOD2/5WY=;
	b=P4RwM6QzO+JMCpNKN7dix1Su+oxHM3gO2sZJ46SUMorB0ZSMatXjc9tPd3mnjSqoiQs1
	 Y7JI/4azyKWWhF6zAWpB+eMi7xCKDtaINV0TUOzmueJ0VHcTy674R5e+AlyswqVjqfoBH
	 Mbdjr/6FCXlj3ymEhQkNMePzkYB1SSDIIBUZ+KvH87a0McLxygcibaf+uPlbU1LkGjCHA
	 McEuQccOfO4sQC8oNf+7seNPzwmoneURJ4FDsp0HF9A8LaH/kLSKO/VCI2AwT8E3ljXPF
	 k6lMD95/8644LSOQ02bS0w0zdwCozepJnmdbkp45dk93yPhbdgU3tpYIldojPVyJtxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YVRfYXMV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB4C606A32C;
	Wed, 18 Nov 2026 15:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YVRfYXMV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F001F000C4;
	Wed, 18 Nov 2026 15:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017419;
	bh=yn574TqG6Har3AOgXlNJmOvwTPoayMxpiWeeOD2/5WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YVRfYXMVhHlwXxE8jLqSB5qwfJ4OFW0TKODOLdNL9Lv3FIqH/WqG8sefIS8jsGMJ+
	 SeUG44VwwTpJO3stREfLHpqw89O+H3RjX7bQXH85HH0h/6dK9Ru9JqSySGvkQ8S+Wt
	 8YUQuZRjT/ELbSSKiceVlrqWv5cTecietA99Jx1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0879/2651] ARM: dts: qcom: msm8974: add MDSS reset
Date: Wed, 18 Nov 2026 15:35:19 +0100
Message-ID: <20261118150319.501224538@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 542991a1d77e5fea5263c2406773a0cd09a8ec48 ]

Commit 13a4b7fb6260 ("pmdomain: core: Leave powered-on genpds on until
late_initcall_sync") kept power-domains on longer during boot which is
causing DSI clock to get stuck and fail to acquire its configuration on
DSI bringup. Follow the example of other platforms and add MDSS reset to
the display subsystem node, fixing DSI issues.

Fixes: 5a9fc531f6ec ("ARM: dts: msm8974: add display support")
Suggested-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260810-msm8974-mmcc-fix-v2-1-5c787d79c0fa@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom/qcom-msm8974.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi
index 06c0af0aa3176..f300de74c47d4 100644
--- a/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi
@@ -10,6 +10,7 @@
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/power/qcom-rpmpd.h>
 #include <dt-bindings/reset/qcom,gcc-msm8974.h>
+#include <dt-bindings/reset/qcom,mmcc-msm8974.h>
 
 / {
 	#address-cells = <1>;
@@ -1935,6 +1936,8 @@ mdss: display-subsystem@fd900000 {
 			interrupt-controller;
 			#interrupt-cells = <1>;
 
+			resets = <&mmcc MDSS_RESET>;
+
 			status = "disabled";
 
 			#address-cells = <1>;
-- 
2.53.0



