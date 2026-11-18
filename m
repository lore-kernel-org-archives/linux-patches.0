Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030231;
	b=KracHC42pYOV3R8FLD8fIOjLPZUt7MtpaubjD07o8QjFz1/midBwsi8IPeeFdVeasqZQ
	 iPn5E/pQ576uUuvDaCo2sOrXuy6dsz/xMW50ZH9baBlMqsQXH+fFGykmQE34KwJJ+u8YB
	 B3xbPzBHwmVESSm6l2m9z9cf4rIajzqic1yxmDZAGxSHZ0qHWFDCi+KXWlkehVz6Bg/zC
	 Fpp63x17KhcnJog5OyoZep65hIUUUQjtjI6fEEQJ2eYT0wb4Cfw0zgYFcpGFRjCAzPuNq
	 itqpiubDCueLMLjTzJhlHn7pc8nM6rcgSt5kbTMqNVd7MmoNSuMhEjftf4Toj2xxflQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030231;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F1cZ58kk585GjFE9tK29ecDbLcNaxt1si9gTviQ9mes=;
	b=KQa+DK9eqWc1d04otBGElOCMD8+EqsxRM8T2kJMsGerOS0Lsa3GNcFB5i6iEhE018urF
	 l5Ck4c2Ct/RXiBqst92p8MMTdPgo6TxzYXzdoXrncCGCsJxFllSsXnceGz6UlDZSam7Zr
	 zrewurfiH/ROO8rcZBKa/AWD15Exs1c2kNbH2WihLAqbS+Gn0u9kHKeIY5KA/6dbYWNEN
	 R1eOqhpiy+2co2QkUDKpwwqnNfaILae0lBI4lvbv3pkhFhcoH9jGq9YS/YnxG458WYE+8
	 yOyLVqKIRLN3YUwSB9Vw3jmwMTDTc7wbgy/J9nE1zEBUMqM9RzCqcr+fiND6zjwdP5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rrgKWZAg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D70F60A5BE5;
	Wed, 18 Nov 2026 19:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rrgKWZAg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A531F000C8;
	Wed, 18 Nov 2026 19:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030230;
	bh=F1cZ58kk585GjFE9tK29ecDbLcNaxt1si9gTviQ9mes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rrgKWZAgb7NB67w8rsCTrfPh32pyCjf4mByPfQwURt3ILh+py5e4nXx8Ux6Zlm1au
	 +v8zJLjTpel4JLYhBby5en80kERdIQDDuRwyT4kBjhPsMdasimZIIAFq0vaWD3r9ho
	 3Jk4CQH0kGVxOsnqcs6j0l2B2o+r5assctLWSah0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca@lucaweiss.eu>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0604/1756] ARM: dts: qcom: msm8974: Sort header includes alphabetically
Date: Wed, 18 Nov 2026 15:45:31 +0100
Message-ID: <20261118150033.006188171@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0fd2134934b92..2f540414807f0 100644
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



