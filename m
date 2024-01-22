Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41121612F2;
	Tue, 23 Jan 2024 00:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970757; cv=none; b=Ukak2WtFl2LTkBD0/1POD6Kbvd1Lf2wLEgmOJUcy1DtZIqqRd8bh/gE8h75bNnK83x0z9S3HaP9HlceNYGRqyxftb4ZEih1pgmgMcAqVW4FeAiSNi8isyQOsARKQQRJppYtVXwx9HGoA/LK9ijissfCTZJglSh5hcm9/4u38vyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970757; c=relaxed/simple;
	bh=c6dlXjZH8uhkSDaF4kALW9BZfuYGjsR6DE43MQh+YTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gq5XGDkacduXvdi36phHWv7rcKy4Pp8jTvmWH116E9QF0Xsjd6a05lJRmYECmj83kElvuMgbfPma3q/wuWIeASsCr1o865GHcFVC4cXbzoJ6WfjETvY9G1QTywgA4S1uvBBwxZay+A6gqlO1i8ys9Thti3q6HCHbMOCpCxTHYUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOiXyvmQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOiXyvmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20905C43390;
	Tue, 23 Jan 2024 00:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970756;
	bh=c6dlXjZH8uhkSDaF4kALW9BZfuYGjsR6DE43MQh+YTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOiXyvmQCwMhTvo/hzXTZM2MOQeaPgCVa5emK0+Uj/hjnFj69CWUBi7BllFwtIEiI
	 F4CZKWxFj8ADqVMJkT70spCXntSMKBmCS04rJuRanbJMJrNkUmgYYRHeRkTSHxj26f
	 ZFc6qnuEoQSZrtPeJMVGeeHvRQVu03mXwzo0s7ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/417] arm64: dts: qcom: sm8250: Make watchdog bark interrupt edge triggered
Date: Mon, 22 Jan 2024 15:54:18 -0800
Message-ID: <20240122235754.812812835@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 735d80e2e8e5d073ae8b1fff8b1589ea284aa5af ]

As described in the patch ("arm64: dts: qcom: sc7180: Make watchdog
bark interrupt edge triggered"), the Qualcomm watchdog timer's bark
interrupt should be configured as edge triggered. Make the change.

Fixes: 46a4359f9156 ("arm64: dts: qcom: sm8250: Add watchdog bark interrupt")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20231106144335.v2.5.I2910e7c10493d896841e9785c1817df9b9a58701@changeid
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 4d9b30f0b284..3d02adbc0b62 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -4879,7 +4879,7 @@ watchdog@17c10000 {
 			compatible = "qcom,apss-wdt-sm8250", "qcom,kpss-wdt";
 			reg = <0 0x17c10000 0 0x1000>;
 			clocks = <&sleep_clk>;
-			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 0 IRQ_TYPE_EDGE_RISING>;
 		};
 
 		timer@17c20000 {
-- 
2.43.0



