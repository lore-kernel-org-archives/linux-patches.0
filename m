Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8005FF16;
	Tue, 23 Jan 2024 01:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974665; cv=none; b=UTQbPmT+D1PgaLgoGXngw+YL/obDTRBPoDQPAmBqCyfDyBuPtHPqD0QSI7ECwvW+JrD22ehm59v1KiakED1ukyfMp9b1ch753jQpcyoOmGOl6Tun9mo+eFoguQt0QpYW2OIHMuwVjOrVh0fg2RkzKfxBXV3qE9833yCS2lD9jbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974665; c=relaxed/simple;
	bh=1yyJu3WuN+BpMWUnJUz+LIm1W4gTGgHiQJqdz8jk9bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBvKYBDkrNeT1gieOeN/78+L58+Mm76pMn6j0ilw/oySF4eHjBjqZcpGjfPxdGZQgRb9ETF3DUqgw5rHVYqKvrBo0HgC4sMGUezCLhKpXAtp0BILwM0ccIoyxFQ6Oqe/FmzQLNngYDsUJjMsSZQ43y+StXoGIdUiHxUHkLPne6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyWvu9i6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyWvu9i6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B85AC43390;
	Tue, 23 Jan 2024 01:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974664;
	bh=1yyJu3WuN+BpMWUnJUz+LIm1W4gTGgHiQJqdz8jk9bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyWvu9i6+ypAabq0P6pzoCzvGxdvla1fpJyDVjVCV4Tbn+TFkBfNBrq+BTMtbajM1
	 +D88NDlR4chIqoAPSYvUlV6RR6TEhfVlAt5x3K/el/UrG9Sevf9udcYn2+ok706iwR
	 WZPh+pSE0Gip1uCqMA/Y7LaH+ivNTli82HqQWX0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 113/583] arm64: dts: qcom: sdm845: Make watchdog bark interrupt edge triggered
Date: Mon, 22 Jan 2024 15:52:44 -0800
Message-ID: <20240122235815.618983475@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 263b348499454f38d36b9442c3cf9279c571bb54 ]

As described in the patch ("arm64: dts: qcom: sc7180: Make watchdog
bark interrupt edge triggered"), the Qualcomm watchdog timer's bark
interrupt should be configured as edge triggered. Make the change.

Fixes: 36c436b03c58 ("arm64: dts: qcom: sdm845: Add watchdog bark interrupt")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20231106144335.v2.3.I16675ebe5517c68453a1bd7f4334ff885f806c03@changeid
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 055ca80c0075..2cf1993a8190 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -5118,7 +5118,7 @@ watchdog@17980000 {
 			compatible = "qcom,apss-wdt-sdm845", "qcom,kpss-wdt";
 			reg = <0 0x17980000 0 0x1000>;
 			clocks = <&sleep_clk>;
-			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 0 IRQ_TYPE_EDGE_RISING>;
 		};
 
 		apss_shared: mailbox@17990000 {
-- 
2.43.0



