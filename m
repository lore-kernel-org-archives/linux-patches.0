Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE5C477E21;
	Sat, 12 Sep 2026 16:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230317; cv=none; b=ZoFH9h8xYGGbLt8jCfQRcfwcGkieKP7v9zSbsaEL9wiEFBHEJz0si9U4VWk3H2petr113pKwAXXhqP6SwurizapDaymzxRPFsVTulcA0Fxdr7oNkY1vtUz0Q9ah3hiYthN6bQq4OGx+MfKem84RqtRIyJLK5u46n5SdttCs0PDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230317; c=relaxed/simple;
	bh=9hZlFJzeVapSId7SxPz5GP7Si31vw35jHKW2cYi14Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7qnxcxPkZc2vVSX/e8nU/xZb5+Xywa1tuajORcmKPwuQsoKwt8touwfInFQ1Eutb2gqUmCgFrylIqZ/EXmxfw3y9eGc9x3+UaEda2hXQ7Yj/i8/+7eHYVazovkJm5+wd3UmUNYik2cH7IxVLvUt1iNfO4mtJroyM9yka1Vi+h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bwMFs9VO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bwMFs9VO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3F51F000FF;
	Sat, 12 Sep 2026 16:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230316;
	bh=Io6V41+oXAcbXuQu0+JEK86EM5/K13n38IR2NMyVw0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bwMFs9VOaAKsUwHruaNtqQLhGKpTHSTLTQqFhieMoq3E0UsOP8D1PdC7o4mFwpv9d
	 a3X3K4EFWBS/67X5mKlPgoPGNKHry/dnmM8CfRDUuDYUruoa4m8C/uB2Je6fVsheYV
	 Cz/mONmqod9ClUStBvseEafYfAPmL1PFEHDqRmYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0768/1191] arm64: dts: qcom: sc8280xp-crd: Fix the pin index for misc_3p3_reg_en
Date: Sat, 12 Sep 2026 08:58:16 +0200
Message-ID: <20260912065605.527746590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 38ec8acb7c40d..5e30349efd204 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
@@ -57,7 +57,7 @@ vreg_misc_3p3: regulator-misc-3p3 {
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
 
-		gpio = <&pmc8280_1_gpios 2 GPIO_ACTIVE_HIGH>;
+		gpio = <&pmc8280_1_gpios 1 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 
 		pinctrl-names = "default";
@@ -364,7 +364,7 @@ edp_bl_reg_en: edp-bl-reg-en-state {
 	};
 
 	misc_3p3_reg_en: misc-3p3-reg-en-state {
-		pins = "gpio2";
+		pins = "gpio1";
 		function = "normal";
 	};
 };
-- 
2.53.0



