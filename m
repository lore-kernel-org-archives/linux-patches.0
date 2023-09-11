Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B367C11715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FDB1C433C8;
	Mon, 11 Sep 2023 15:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445091;
	bh=Vd06oWSu2mhjizJKKq/PMzrmG/lwZezzHaXJolkna84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BCxfbb9sOurjA8aw8iXKDVfW1U1uZlRvuBUGg7EIPWJUni6wINQ4TI5Num97kF5XM
	 f/P1ojN+YaoS0eMPcCnQsFNDlwvJzKPwN2XxC/jNVFhhmsNRXBG3TZ0lZkxh4ZZ0+f
	 VmjA5RxWQHbyj81sJAqgG2sW/SO3awqTbF7iaSFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Nikita Travkin <nikita@trvn.ru>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 225/600] arm64: dts: qcom: msm8916-l8150: correct light sensor VDDIO supply
Date: Mon, 11 Sep 2023 15:44:18 +0200
Message-ID: <20230911134640.255214528@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 6a541eaa6e8e5283efb993ae7a947bede8d01fa5 ]

liteon,ltr559 light sensor takes VDDIO, not VIO, supply:

  msm8916-longcheer-l8150.dtb: light-sensor@23: 'vio-supply' does not match any of the regexes: 'pinctrl-[0-9]+'

Fixes: 3016af34ef8d ("arm64: dts: qcom: msm8916-longcheer-l8150: Add light and proximity sensor")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Nikita Travkin <nikita@trvn.ru>
Link: https://lore.kernel.org/r/20230617171541.286957-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916-longcheer-l8150.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916-longcheer-l8150.dts b/arch/arm64/boot/dts/qcom/msm8916-longcheer-l8150.dts
index d85e7f7c0835a..75f7b4f35fe82 100644
--- a/arch/arm64/boot/dts/qcom/msm8916-longcheer-l8150.dts
+++ b/arch/arm64/boot/dts/qcom/msm8916-longcheer-l8150.dts
@@ -163,7 +163,7 @@ light-sensor@23 {
 		pinctrl-0 = <&light_int_default>;
 
 		vdd-supply = <&pm8916_l17>;
-		vio-supply = <&pm8916_l6>;
+		vddio-supply = <&pm8916_l6>;
 	};
 
 	gyroscope@68 {
-- 
2.40.1



