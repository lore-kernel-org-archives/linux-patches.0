Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBBD14AD1F;
	Tue, 23 Jan 2024 00:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969258; cv=none; b=F3i24oUe6ZHRoCe/O78+Lvyhse1Tj8WE8j3i+cLXI5iJzBeNwmq+3UgnbYzCwAXGWX9sY/454Oz7NWQeGLP/NWPIAdzzC7GRD9dw/Fq9CXWklqw9m53K6fW9h1ym/DrLZRsFMbZ/ewZbg7TOnMMw67/N2Xlz1QjVIc+/ETc3vM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969258; c=relaxed/simple;
	bh=Zev4VHcSyKPtLv+2yXT61uMkK7J7lNAgshfV2aQCw4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3hVEEwpKbopZ9c2vFHJLaplvip5vct1lrF3W8E6YCoRWoIyhSAOTQ0niH2y+HhUSxwuQugIkHy99MuzNWO0Z/ZAgyYOOn96JlZqbi7aoOmJIr0Dp8FKheBpxDGzRxaLc7RDnHWJG8ObUY1O5BRyZU0eF4z+Su7CZudeE7iyK+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHO8nVaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHO8nVaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DC6C433F1;
	Tue, 23 Jan 2024 00:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969258;
	bh=Zev4VHcSyKPtLv+2yXT61uMkK7J7lNAgshfV2aQCw4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHO8nVaWV7Hw+3T2TUwx9eTmPyJiJ4q7l/SP1xIz9IsE9145M55aaA8R5Lgjs1z1Q
	 uUnwPphVA7Awuy3mZWjCc4U28Y8UsE8S1fZ1FasVCSpDZ2SEs2y7Qll43XRB7uwPrx
	 zzbqnMZhzQ5WlkzirWQSxgqxBQE+/Jcr5wDHSbMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 127/641] arm64: dts: qcom: sm8250: Make watchdog bark interrupt edge triggered
Date: Mon, 22 Jan 2024 15:50:31 -0800
Message-ID: <20240122235822.028462804@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index be970472f6c4..72db75ca7731 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -6018,7 +6018,7 @@ watchdog@17c10000 {
 			compatible = "qcom,apss-wdt-sm8250", "qcom,kpss-wdt";
 			reg = <0 0x17c10000 0 0x1000>;
 			clocks = <&sleep_clk>;
-			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 0 IRQ_TYPE_EDGE_RISING>;
 		};
 
 		timer@17c20000 {
-- 
2.43.0



