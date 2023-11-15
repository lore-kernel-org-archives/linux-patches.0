Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613FD3DB97
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ByyjsGDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11097C433CA;
	Wed, 15 Nov 2023 19:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078233;
	bh=qh/7Ue3oLPGOnTSPP3tuVq8BWPdnVgDqPFynI6Y0bUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ByyjsGDONARZTTxZ53STkZUOILc3/VSMkCHk0M6v9RIsOCQ93PBZCbzFyw57hfKYP
	 NaujUWDk2A3Kexk2Hrc4oykDhcOjTLS0+Cu4MbnlMPABF6aSK6wADStr/F/UA99FAm
	 vOnyVmhAIxPRf2iNCRCH75vmvfqSDwX95L9XmOqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan@gerhold.net>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 169/379] arm64: dts: qcom: apq8016-sbc: Add missing ADV7533 regulators
Date: Wed, 15 Nov 2023 14:24:04 -0500
Message-ID: <20231115192655.116385244@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 33e9032a1875bb1aee3c68a4540f5a577ff44130 ]

Add the missing regulator supplies to the ADV7533 HDMI bridge to fix
the following dtbs_check warnings. They are all also supplied by
pm8916_l6 so there is no functional difference.

apq8016-sbc.dtb: bridge@39: 'dvdd-supply' is a required property
apq8016-sbc.dtb: bridge@39: 'pvdd-supply' is a required property
apq8016-sbc.dtb: bridge@39: 'a2vdd-supply' is a required property
        from schema display/bridge/adi,adv7533.yaml

Fixes: 28546b095511 ("arm64: dts: apq8016-sbc: Add HDMI display support")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230922-db410c-adv7533-regulators-v1-1-68aba71e529b@gerhold.net
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/apq8016-sbc.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/apq8016-sbc.dts b/arch/arm64/boot/dts/qcom/apq8016-sbc.dts
index 9650ae70c8723..9d116e1fbe10c 100644
--- a/arch/arm64/boot/dts/qcom/apq8016-sbc.dts
+++ b/arch/arm64/boot/dts/qcom/apq8016-sbc.dts
@@ -200,6 +200,9 @@ adv_bridge: bridge@39 {
 		pd-gpios = <&msmgpio 32 GPIO_ACTIVE_HIGH>;
 
 		avdd-supply = <&pm8916_l6>;
+		a2vdd-supply = <&pm8916_l6>;
+		dvdd-supply = <&pm8916_l6>;
+		pvdd-supply = <&pm8916_l6>;
 		v1p2-supply = <&pm8916_l6>;
 		v3p3-supply = <&pm8916_l17>;
 
-- 
2.42.0



