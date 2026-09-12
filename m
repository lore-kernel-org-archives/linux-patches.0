Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF301D514E;
	Sat, 12 Sep 2026 09:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206494; cv=none; b=LZmKHmFB7o5WSlPMe7OlobLvZeR7k3NfhDUfI5rQQUFt008mfozQg7zuJ8H+6p11cvRXyaHtJTRAS+N16ptXs3WWt/g575OtWBoOqGbAO7nl0FnyW37FfXkVQ3TTcHhjEyvhZHMbyIeBS4yqPTqle4R2JZ/0SGzgkaVSR8bsO5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206494; c=relaxed/simple;
	bh=2b4+r1KPu6CsRr/OQYqJWhrhywgVS9eSSlXJIkOQ/Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLca0SAM9/CXw84S7AOuVTPnLnF1uTQNDuHPnSLQxo3O2L0IaIsl2cnu1Oa/tEO9KfoaGxQJn/c7vwK5bzM4COS/M8SBLIxdXPTsqctnh0rbE9+H/CXMeyrGlrP0NsRTvybko7a4ubiHvzKl3eLjJwLLUCNfstQ6gKqUKy6rI7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8aDCrea; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8aDCrea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF071F00893;
	Sat, 12 Sep 2026 09:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206493;
	bh=oiX6UjnFOSN6B6ziI3EQqV0f9Ra+71xnE0PXN/71yhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j8aDCrea5xbC7g5CiGe1DbhOglWNlFcgKtXsEpijiXHuCkSqPsEZ3ILc/RXW/9mDS
	 r5X1F+thp5/l5eHq2ciXWGOokXSpVKTXbq8DwOGjaU/4WqMT33yBz3KewAOHp4zZml
	 a9Kj3RJ1EYMpJwicnynTSGhMo7I9lKHz96VWc88U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Glathe <jens.glathe@oldschoolsolutions.biz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0218/1518] arm64: dts: qcom: sc8280xp-blackrock: switch to uefi rtc offset
Date: Sat, 12 Sep 2026 08:39:47 +0200
Message-ID: <20260912065628.421602410@linuxfoundation.org>
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

From: Jens Glathe <jens.glathe@oldschoolsolutions.biz>

[ Upstream commit f52102fc9ccbbb3c4bc01a29f3194fe07f9602f5 ]

On many Qualcomm platforms the PMIC RTC control and time registers are
read-only so that the RTC time can not be updated. Instead an offset
needs be stored in some machine-specific non-volatile memory, which a
driver can take into account.

On platforms where the offset is stored in a Qualcomm specific UEFI
variable the variables are also accessed in a non-standard way, which
means that the OS cannot assume that the variable service is available
by the time the RTC driver probes.

Use the new 'qcom,uefi-rtc-info' property to indicate that the offset is
stored in a UEFI variable so that the OS can determine whether to wait
for it to become available.

[1]: https://lore.kernel.org/r/20250423075143.11157-4-johan+linaro@kernel.org

Fixes: 16a7fed11714 ("arm64: dts: qcom: sc8280xp-blackrock: dt definition for WDK2023")

Signed-off-by: Jens Glathe <jens.glathe@oldschoolsolutions.biz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260501-blackrock-rtc-v1-1-bddf3e37fa94@oldschoolsolutions.biz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/sc8280xp-microsoft-blackrock.dts    | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-microsoft-blackrock.dts b/arch/arm64/boot/dts/qcom/sc8280xp-microsoft-blackrock.dts
index a40dccd70dfda..3c3607929c2f2 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-microsoft-blackrock.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-microsoft-blackrock.dts
@@ -769,20 +769,11 @@ &pmk8280_pon_resin {
 };
 
 &pmk8280_rtc {
-	nvmem-cells = <&rtc_offset>;
-	nvmem-cell-names = "offset";
+	qcom,uefi-rtc-info;
 
 	status = "okay";
 };
 
-&pmk8280_sdam_6 {
-	status = "okay";
-
-	rtc_offset: rtc-offset@bc {
-		reg = <0xbc 0x4>;
-	};
-};
-
 &pmk8280_vadc {
 	channel@144 {
 		reg = <PM8350_ADC7_AMUX_THM1_100K_PU(1)>;
-- 
2.53.0



