Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E553019D8;
	Sat, 12 Sep 2026 14:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224198; cv=none; b=MQPZk7CgnHmXWNQjBrLXwICmswRH0zxLDOoCJjOIYTHPAYImR6CZQ1D/Xtsje9saVIrYG4y6ZEpkBIncdNLpGcIw28Gmlh4m6ZUk+9dg768lEdooCU7QaIKnT6nxo4zYDS91OzhgVgYS35wBKJqghdxxHltGAhJp3AerYF1ywB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224198; c=relaxed/simple;
	bh=ipC0eQ5YOx+l08Hmcmcm8GhczD1zXC3V+T4dG3OZr8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOPezCvZ16vDsghW9RDcnDTcSg+5q5Ug5wo8Uv2sgK2M+Y5eMHeeHFJtWQ3Aarvf8XNlHZzgzQjB3poQ+9smfkqXxkCVNx4GL7zuGRsJUxIVJBOcGlZsrHs1yXECI4UmH1StC1+3eOQJgG2eW9n7pp1ovcNydvLgel0rD/xBJdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wg6+6h6N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wg6+6h6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6131F000FF;
	Sat, 12 Sep 2026 14:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224197;
	bh=jRwJL5aNsbsc7NVZ74ln17nIx7BYUfioGTbv4nEt9Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wg6+6h6NCAuHE1XcCnzuFab7/RihSzbtuu6R85UWC390BF6Ur5ag1zgtAXgy5qWXR
	 qFO8Ai9XrxZJ226iuHs1xhlnEsgLhJkKqByKkRBFQJTNt62jP9zpMtr2xb6kpZNpVG
	 zPfxwdBj4/7ZRjeJHjiJuZt/mPC8dInkKqmV3si0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0943/1424] arm64: dts: qcom: sc8280xp-crd: Fix the pin index for misc_3p3_reg_en
Date: Sat, 12 Sep 2026 08:56:15 +0200
Message-ID: <20260912065628.437356139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ffc4406422ae2..b985d76a4cdac 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
@@ -167,7 +167,7 @@ vreg_misc_3p3: regulator-misc-3p3 {
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
 
-		gpio = <&pmc8280_1_gpios 2 GPIO_ACTIVE_HIGH>;
+		gpio = <&pmc8280_1_gpios 1 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 
 		pinctrl-names = "default";
@@ -757,7 +757,7 @@ edp_bl_reg_en: edp-bl-reg-en-state {
 	};
 
 	misc_3p3_reg_en: misc-3p3-reg-en-state {
-		pins = "gpio2";
+		pins = "gpio1";
 		function = "normal";
 	};
 };
-- 
2.53.0



