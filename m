Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2E711710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACC0C433C7;
	Mon, 11 Sep 2023 15:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445322;
	bh=AwmRuq+wYqpk85GftRvpjlCtAaL7hr+lW26GV9twmpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zhGh2gsiGwgMJsxJGCgXo8I2xs+/avp0Bgzdn6rbfpiPuw2lbSmRCzO67YMJmua14
	 w76xqrqtnOF/2OunENV2eSq0XsW+5uujkmFtKxuDmGDexS9qMJlEkan1BGe1YmyXaq
	 1lsGjcGGjQZnjvcnbpxD/rNwWgBYkjLNWA/RAHAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 307/600] arm64: dts: qcom: apq8016-sbc: Fix ov5640 regulator supply names
Date: Mon, 11 Sep 2023 15:45:40 +0200
Message-ID: <20230911134642.696792525@linuxfoundation.org>
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

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 43a684580819e7f35b6cb38236be63c4cba26ef4 ]

The ov5640 driver expects DOVDD, AVDD and DVDD as regulator supply names.

The ov5640 has depended on these names since the driver was committed
upstream in 2017. Similarly apq8016-sbc.dtsi has had completely different
regulator names since its own initial commit in 2020.

Perhaps the regulators were left on in previous 410c bootloaders. In any
case today on 6.5 we won't switch on the ov5640 without correctly naming
the regulators.

Fixes: 39e0ce6cd1bf ("arm64: dts: qcom: apq8016-sbc: Add CCI/Sensor nodes")
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230811234738.2859417-3-bryan.odonoghue@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/apq8016-sbc.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/apq8016-sbc.dts b/arch/arm64/boot/dts/qcom/apq8016-sbc.dts
index e3e90ad92cc59..9650ae70c8723 100644
--- a/arch/arm64/boot/dts/qcom/apq8016-sbc.dts
+++ b/arch/arm64/boot/dts/qcom/apq8016-sbc.dts
@@ -289,9 +289,9 @@ camera_rear@3b {
 		clock-names = "xclk";
 		clock-frequency = <23880000>;
 
-		vdddo-supply = <&camera_vdddo_1v8>;
-		vdda-supply = <&camera_vdda_2v8>;
-		vddd-supply = <&camera_vddd_1v5>;
+		DOVDD-supply = <&camera_vdddo_1v8>;
+		AVDD-supply = <&camera_vdda_2v8>;
+		DVDD-supply = <&camera_vddd_1v5>;
 
 		/* No camera mezzanine by default */
 		status = "disabled";
-- 
2.40.1



