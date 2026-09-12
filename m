Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89AB3403F5;
	Sat, 12 Sep 2026 08:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200414; cv=none; b=HFvAPp/RNb3ybtjriZ/AjxmIYajhK2aq3/8kNxUcRxKDmcFMQFkNDLBs5+RUtetDiAelJn1soLLjyUNK1aWIbMLfBcwCaMlHKx6qtRt13J2HDY95HUjXjPmXK6UmyOOM1QWjiCnK1lNceR/KZOev2Pi+phcMkNBBH2tZ6NveWDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200414; c=relaxed/simple;
	bh=bZCzk4IIc3eHRImGhz/ccIW+5clkgNpB+r9hDrJpm/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKxaoLBC5nxKhYeC/z5RJ1KA3dQTkmJIxVdD1st7L1sWTLLoxzlD9MU7lfsjG/YuXCvJc3dIVDDIpAWvVTqh4kwI0dZ6swPwoVPQZCDVyiRn9eFaN0UwsznbDv6wEN68yx/lAerMbgwkkU9YoX1eqZ91uZdp5mGDNP/PAbP1N8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z98thSKp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z98thSKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DB41F000FF;
	Sat, 12 Sep 2026 08:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200413;
	bh=VfttBvan3Oq8GAXzVcqkBXc1NyXeQt9jGdhpy+Q9iaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z98thSKph1gn1rvseAkmTsUqOhIxUbohbwb8hqSo0G2dGZrn65dIVKvEWwdihdOKm
	 ZGkaNuaOqy6rSeSAMT9qX6n338UNthUeTnXCrA9Gtb0z7T9/sgLhkEFj+liJcRmBKJ
	 ocCQoUxNIZGAl8oqG/nAuD0hOhj+PUTzBSu/FA0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0786/1815] arm64: dts: qcom: sc8280xp-crd: Fix the pin index for misc_3p3_reg_en
Date: Sat, 12 Sep 2026 08:42:16 +0200
Message-ID: <20260912065707.361111164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index dcdeefd287283..ee85d5e09520e 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
@@ -182,7 +182,7 @@ vreg_misc_3p3: regulator-misc-3p3 {
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
 
-		gpio = <&pmc8280_1_gpios 2 GPIO_ACTIVE_HIGH>;
+		gpio = <&pmc8280_1_gpios 1 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 
 		pinctrl-names = "default";
@@ -915,7 +915,7 @@ kypd_vol_up_n: kypd-vol-up-n-state {
 	};
 
 	misc_3p3_reg_en: misc-3p3-reg-en-state {
-		pins = "gpio2";
+		pins = "gpio1";
 		function = "normal";
 	};
 };
-- 
2.53.0



