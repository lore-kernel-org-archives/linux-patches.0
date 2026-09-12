Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E867B33C198;
	Sat, 12 Sep 2026 10:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208665; cv=none; b=PL148sCDlDUsG2mIEIPnnGXyMFiemxEP42P02kbEE+PoKsg/7OWOeeX6qCyHQWgESRVRE0Aek8X4pb3Bty+nWwa7LEVITV2SwDDNXstKDZw0Zv+ZU3ErdxvHPScTSXRHToWV8rbheA+Lq+H9REz9pAyfAJ6BdA6tmoTm0mMrnI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208665; c=relaxed/simple;
	bh=hL8yMK11fAnszcmD/7wANqqIe7x670iUl/QohaQ4XTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PshWIGQhOTEGZTSJpv8or0R0GqgbMJq+EHwYcK6d8Lj4/XDnZOnXuo7eK6FPJoKUUw8Nh+ixqFoJSSjAE1C2UY6gMSHa+84pxkhHIGlxIqvGUoZgY+U+bCbnV572J0B+O+ffWBlXEQQGkY/sRev1sOlFgqa/SFobpBGrA++a+tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPydeg+C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPydeg+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21961F000FF;
	Sat, 12 Sep 2026 10:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208663;
	bh=laqSYERCRdFnxkOeM6L4JSWea1HBSgAousrdWLmzd9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lPydeg+CgJuEKOfpLnV/wk45bXuFqvVVsF0D3a4Y6PIPTTACt3UgCP0o8Myx5ihsp
	 YFhRovd6h5cqnkvJEbWcrqMW9A8dR30ohcYojykYpQuLnsmqqia2rfNfauXQnzLD8/
	 9KIKfTru/OTK4LYnddcPfX43feU2bqcK839i9Au8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0663/1518] arm64: dts: qcom: msm8976-longcheer-l9360: Fix accidental node override
Date: Sat, 12 Sep 2026 08:47:12 +0200
Message-ID: <20260912065638.431108194@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit bd0bb7d97773026c9f5d5f8ff1dcf987f8051045 ]

The active and sleep pinctrl states for the touchscreen interrupt pin
shared the same node name, creating a single node, accidentally
overridden immediately after the definition. Alter the names to make
them distinct and to silence DT checker warnings.

Fixes: 79b896e7da7e ("arm64: dts: qcom: msm8976-longcheer-l9360: Add initial device tree")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260717-topic-june26_dts_fixes-v2-2-797cd46e5d9f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8976-longcheer-l9360.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8976-longcheer-l9360.dts b/arch/arm64/boot/dts/qcom/msm8976-longcheer-l9360.dts
index 18832a3b9a1c3..57f549f06f73c 100644
--- a/arch/arm64/boot/dts/qcom/msm8976-longcheer-l9360.dts
+++ b/arch/arm64/boot/dts/qcom/msm8976-longcheer-l9360.dts
@@ -455,14 +455,14 @@ sdc2_cd_sleep: sdc2-cd-sleep-state {
 		bias-disable;
 	};
 
-	ts_int_default: ts-int-state {
+	ts_int_default: ts-int-default-state {
 		pins = "gpio65";
 		function = "gpio";
 		drive-strength = <2>;
 		bias-pull-down;
 	};
 
-	ts_int_sleep: ts-int-state {
+	ts_int_sleep: ts-int-sleep-state {
 		pins = "gpio65";
 		function = "gpio";
 		drive-strength = <2>;
-- 
2.53.0



