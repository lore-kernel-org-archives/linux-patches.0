Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040224;
	b=SSc4A+kyIS1JOgeyn1Z2iyRxHgAWlmIWOmqg0VEgrHAew7pgTErpORtdsAJ1i4BOquJ0
	 k9AFTYCrKq7agYYj7ta1VPlJA3zJtz3TowFOWCNJeicDOzXr/dlJndw1oZWfKG+NLLuvC
	 Cuf5EG1+ATtApHx/Cg4bk894B+1rlItylYe2BJ1cCGtg+9LkRPSTHnB/TcoXXX1gtpIh2
	 vZE6hpu1kVgFW94N69/v/YadajkibsR9lPgpsuAApD33flvq/YjIl/n67y6JX3ul90shW
	 IY6lyF8gd/ihPCdZ7o0ET/mgmACUzjFofx9DlV1/9E0+PJ35WrSlUuVDPokhWspPw4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mx/RDrqvX3LQAhpGwx4oARYB9J4QX20UmxTFbh9Dj4A=;
	b=Gt7RvlXQ7eFEwF7g6EavQSQixr2hC7jvMuidJ0AQHx8MI25QmnT1hi1zZbw4+q+KRmzY
	 jGU3mVOs+yEx8zfZRGkX6dWVMrX9D6cUUSTcE01JGd+jk5AAO9RB1ucfWVzYMFPUIvAXp
	 YP4o+mUc6xYvX9kJR0jiBFfrh8dSfyk1H2m6vXCJusKrejIZdBbR2R69g6DvsQMXhsrNN
	 s9s+/ji4Kkad8eBaK/JanuGqNJkLkhqfqRhFuUFLubutCd0zNwV1ByO5fEjJiLtxqhR3o
	 nlD9hvslyf7AHHmdxhMRAlWCaK4bNydVXXy3oLlGh7RtzewVHKAEUGK73AehrY0/1sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jvrglgDU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B316606A31C;
	Wed, 18 Nov 2026 22:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jvrglgDU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4A51F000C4;
	Wed, 18 Nov 2026 22:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040224;
	bh=Mx/RDrqvX3LQAhpGwx4oARYB9J4QX20UmxTFbh9Dj4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvrglgDULaHiE2ASYcpxz3rVK2rHZge1Um/EHt1ZMT/B3xIKXM6+beKl+ypzWf15P
	 CZJBQ/miIF83IAxWaWjw0pd58bloeMg7dwW/jviho/bU5esNvDyptLxFUIC/CCrVve
	 lsiIMHopq+l+5TYipio58saK9y+FNB9NwPE0kq7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2381/3318] ARM: dts: qcom: msm8974: add MDSS reset
Date: Wed, 18 Nov 2026 15:50:03 +0100
Message-ID: <20261118150432.970553441@linuxfoundation.org>
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
index bc550ccc5c581..ccd4d87ff179e 100644
--- a/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi
@@ -9,6 +9,7 @@
 #include <dt-bindings/interconnect/qcom,msm8974.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/reset/qcom,gcc-msm8974.h>
+#include <dt-bindings/reset/qcom,mmcc-msm8974.h>
 
 / {
 	#address-cells = <1>;
@@ -1876,6 +1877,8 @@ mdss: display-subsystem@fd900000 {
 			interrupt-controller;
 			#interrupt-cells = <1>;
 
+			resets = <&mmcc MDSS_RESET>;
+
 			status = "disabled";
 
 			#address-cells = <1>;
-- 
2.53.0



