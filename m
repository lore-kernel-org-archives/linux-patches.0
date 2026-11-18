Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030262;
	b=RkTpA0kQQVOdthaQw9KXm+vn8oLEJpGt6FZFTs4wwHQIPGzb+Fe267Uzp6zz5bOQzyR0
	 HNGowxaaD9gk/zn71CQASBubJSdsK+bo71grMFbg7zohlbslNoeLrJ1qP0ZG5ZuFXbqF2
	 YBjSmnhTt03sw68lnkI2SxUiIeXZP6udQjMka17STmYHxEELUQ60Dhhl4qF4Sd05vqGdl
	 bMF093GTbHR8gYYKmXzntNoFSTifCoNbsfleQ/glWj7+07hf+Y+RkhxMwDOiH7u4wI9+9
	 9TZ8F46TrWcZqbXFoHYHNvwoIPslJsxIJHBMH1M6KMW9Bg9tagdIKpVCYFKk3L58s3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030262;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gO+qIOiYUPx0cQLKS6UOYZkLvyg5XEoXKlXsy0M6jz8=;
	b=wEW/ftsUcD6ekD23CEAAcV9wabpa+RcsfcICg0OwCGrfrVJqyQB1XmCFLTF2M5T99XU/
	 oFsybnhdJziZoZ4TcUg1GKlYT4rBlQ1YHneRlINaAtfmm8+RL7X3JrMK7i2zwnV+615az
	 qFLKq0DvkBP50PuPCWCa8NaJC18mJ3OhnRiL+KBZPBUEe/yfnmhi+NIIsgqPcMYZRk85q
	 k+Xv2b93NhDhlkrn8bnTHwAkn18VNEW0UT/oLe4f3qGqb3s4kqrgjPgaOA2bbMgw8Y7Fl
	 mi8Jh652wFOjSyKUgBOkyYwCth5EZ3utCu9SWuJJEiKJqqt/uGODuOMrdBZKVbxwHew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XXTdPXww;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10287606F533;
	Wed, 18 Nov 2026 19:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XXTdPXww
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228E91F000C6;
	Wed, 18 Nov 2026 19:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030261;
	bh=gO+qIOiYUPx0cQLKS6UOYZkLvyg5XEoXKlXsy0M6jz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XXTdPXww6d18cJqwIIHLSrjucqfYHgGLskVXX1y6pCF3ip8u5FSqGjACptd6gfndR
	 kvnPQgbBLEhCAvmAZnQjJCDXPaVlE/rD/0kYQa2Minlmt1OJvhLIW9JuUnCQIws+JX
	 1hZdInDzp0ms4KZXJY3skDxr8uYvYRSpi3ons+6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0605/1756] ARM: dts: qcom: msm8974: add MDSS reset
Date: Wed, 18 Nov 2026 15:45:32 +0100
Message-ID: <20261118150033.043019218@linuxfoundation.org>
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
index 2f540414807f0..87d02f4113b65 100644
--- a/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi
@@ -9,6 +9,7 @@
 #include <dt-bindings/interconnect/qcom,msm8974.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/reset/qcom,gcc-msm8974.h>
+#include <dt-bindings/reset/qcom,mmcc-msm8974.h>
 
 / {
 	#address-cells = <1>;
@@ -1910,6 +1911,8 @@ mdss: display-subsystem@fd900000 {
 			interrupt-controller;
 			#interrupt-cells = <1>;
 
+			resets = <&mmcc MDSS_RESET>;
+
 			status = "disabled";
 
 			#address-cells = <1>;
-- 
2.53.0



