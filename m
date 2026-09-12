Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CA137E5D1;
	Sat, 12 Sep 2026 12:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216540; cv=none; b=WFgczoaD6m4YjiHjvUoM3yO6/uwcObgK/Y6KPZqUxILSNnJrR+gaFzw9RHfkZEgwZv8eOii9r0fDCg3qI9n1VjVLfZMdiD5xcwhwahg8Xq+ZcVpwgUBicbTUATXYUxZUkJ1vCcKVCN0L9PnFAVnwKsyYeJ2g0W4exhMlZmu07Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216540; c=relaxed/simple;
	bh=1T/6ox+G74W3nqMfu0dlBa2LodoCRuaBJOf9XqaorjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auN86ux1tdPlTPgyOG7uUZLFEh0VgPNDGmPd1UnCuUU5hlMJT5G80bSZXL3Slso/Jb6ru7cG+gsfvHmCAn/CVt2dd2HnFYdoSIGJ2kg4Gb+bjSkVPatl/O+Nb/5arevtIgnRJ6twy2gYV2h8NUrMLePLiXgzP2Rpk8r4xnIAV5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVsTjmIO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVsTjmIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F651F000FF;
	Sat, 12 Sep 2026 12:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216539;
	bh=0pdCyiFtrgq8If/LrWGqCrC+Bb+y5MGmYC5Smsg+9L0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bVsTjmIOv194MABQrpY3jjz5tFuVEGBV9syV/jFF77KHFLpFuwMpR1P66hOYFi0Mk
	 Ks9dbN6vXpRWR5f2udMeFBArm7IhPZr3MOjAJzUjM/iVV8ksZo3vUv7pGizritC4+Z
	 iZ6kHMvznT4WaQl4PTeUx57avOrfN89hep3JXnO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0758/1376] arm64: dts: qcom: sc8280xp-crd: Fix the pin index for misc_3p3_reg_en
Date: Sat, 12 Sep 2026 08:53:04 +0200
Message-ID: <20260912065624.433687725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 0e05c183f3b97427f00d619132ba5984494f6886 ]

The correct pin is GPIO1. Fix it.

Fixes: ccd3517faf18 ("arm64: dts: qcom: sc8280xp: Add reference device")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260701-topic-8280crd_fixups-v1-2-3fe92ee9636b@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp-crd.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
index 6020582b0a59d..36beb71d7d2f4 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
@@ -167,7 +167,7 @@ vreg_misc_3p3: regulator-misc-3p3 {
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
 
-		gpio = <&pmc8280_1_gpios 2 GPIO_ACTIVE_HIGH>;
+		gpio = <&pmc8280_1_gpios 1 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 
 		pinctrl-names = "default";
@@ -759,7 +759,7 @@ edp_bl_reg_en: edp-bl-reg-en-state {
 	};
 
 	misc_3p3_reg_en: misc-3p3-reg-en-state {
-		pins = "gpio2";
+		pins = "gpio1";
 		function = "normal";
 	};
 };
-- 
2.53.0



