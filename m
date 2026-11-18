Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024528;
	b=OIjZSGFPxF4hTJDWt3XlmD2xdToPlYmYTxPddR7TdifkVbKZT4smtyT3ZggJaC04QCwT
	 oCXkKJIbsCy9B07oAeaOEmkhWw6Rr/ux9MT1uhUNcF6MkvrN4WCDypuhdfKs3WjBA8GT3
	 357vtpZLcDRdFt+hsVy1UCa8hzHxLyibu3ocKClrUUUSw26a7MB8ZtViytteIU+8Wg8OO
	 w4cJrynU1FR1dU7/kYxNND+Hdio7LY78oANLdhs6rd5sgDId/t+22ExhgxE7wxLYLUXEc
	 TiFNip9ls4kmF0vp/hspaEvv3Nd3g7g0qRVQsdVz9s9AaDAqobKMtXAFk8ZIZCayzog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024528;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IN8kNUO5glBjtTFjf4t3B5lpRq7gRIJePqWHuBgv5wE=;
	b=2CideKDH+TU01KttSUHccFc4m9nbrQTn19VC84os637YZ0yzQb2iF7fLfYkhdHNaAiPl
	 GMszL6lsOivORSbbU2nKZ+vebkxFF+K4b7VZ0GCdHF8oOabjGPvnf6JfRA/Hdvc/iUQns
	 pefLcgYWSWS3skiBy7SME5NGI74gHbEyeLuIbA8pZ1gI4U2KkKyh10zNbaFi3nYdfkmuc
	 +mv+A8yyumfU1TLJqH23pdHJPiJHsphX6+fz7rvvd+vutgFnhy1cHnnOusagqmAas1FQ2
	 1vtaSMQzFCi+rxgRYflj1yjs2aXQ6MM/6SqXsjpHdEpEtvjFtSJ1TFH3z3l7tnhqfCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oLqGrepP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CCE606A325;
	Wed, 18 Nov 2026 17:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oLqGrepP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4941F000C6;
	Wed, 18 Nov 2026 17:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024528;
	bh=IN8kNUO5glBjtTFjf4t3B5lpRq7gRIJePqWHuBgv5wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLqGrepPXgTYU3j9Xio4R6sAz4IgYAScvg9I6aqcKKvertwkuuNZHTYqX7j54nyyj
	 Q9i9R2VR8vzgA8F3B6fsM3A7OvpBvO5wzGMsGoQGbCQ00yd9Fm3T4WOFLRJQyDL/IQ
	 8d0arNmRY8YL6zs2esGkbin6Pn5i4KiAA9tRrwEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca@lucaweiss.eu>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0757/2151] ARM: dts: qcom: msm8974: Sort header includes alphabetically
Date: Wed, 18 Nov 2026 15:41:32 +0100
Message-ID: <20261118150149.625720589@linuxfoundation.org>
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
index 7e119370f3375..8459a840d9ffe 100644
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



