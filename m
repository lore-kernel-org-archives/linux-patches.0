Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6858756B7A;
	Tue, 23 Jan 2024 01:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974027; cv=none; b=cpUSznQPGfxzXbUlN3wut5ZYGdNWp6yovsWfdfDrEzqhXmgsDfiwqGSfpfzze+OEL0kxdFX+kYs4KGANg3BSjMVD44oUNx2R0CojPlw/rxKzmdT4sSNk3OU8gdUz/BsyKpvQYyyY57BIUZGaGsng/KdUjyi2G1IDxizArzo+NV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974027; c=relaxed/simple;
	bh=/DCyUE2W0rSoLnwyS/sSRWfx5qBtKA9ufobmcs7bYsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LnmU68/0qGq15WqM98y8uxxXFuCJyg/dL65ND8n+th7ErcK/reKnLqFGLRLQDKH9zHLwHX/sQwidipZanMwl5EfDk6SjrPCkIj3HGMzTmoeiFtn8KoZUT/x8xy21GbpfGTbGnY0erSAaTpOLlntwXznywZEJKedZF4tR9c+PZUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTj6ueup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTj6ueup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB90FC433C7;
	Tue, 23 Jan 2024 01:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974026;
	bh=/DCyUE2W0rSoLnwyS/sSRWfx5qBtKA9ufobmcs7bYsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTj6ueupCqoQ9L4GMwYapBuRLSHjrNi7AVDkJjMf73gQ3rmqMXCkKq3EiLhMq3IxX
	 N92Z2GQksi3t7QxBfFazqsypIFI1Q7hzFdNt4ZI8r6kRSVPrxlxuwh8wafSjuxy+yQ
	 opeUBBBMgs0nwUypZGdJV/0DWYG0BADgtSdmKnzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 131/374] arm64: dts: qcom: sc7280: Make watchdog bark interrupt edge triggered
Date: Mon, 22 Jan 2024 15:56:27 -0800
Message-ID: <20240122235749.202505309@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 6897fac411db7b43243f67d4fd4d3f95abf7f656 ]

As described in the patch ("arm64: dts: qcom: sc7180: Make watchdog
bark interrupt edge triggered"), the Qualcomm watchdog timer's bark
interrupt should be configured as edge triggered. Make the change.

Fixes: 0e51f883daa9 ("arm64: dts: qcom: sc7280: Add APSS watchdog node")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20231106144335.v2.2.I11f77956d2492c88aca0ef5462123f225caf4fb4@changeid
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index dc4aab258ff6..9971b8763e08 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -1711,7 +1711,7 @@ watchdog@17c10000 {
 			compatible = "qcom,apss-wdt-sc7280", "qcom,kpss-wdt";
 			reg = <0 0x17c10000 0 0x1000>;
 			clocks = <&sleep_clk>;
-			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 0 IRQ_TYPE_EDGE_RISING>;
 		};
 
 		timer@17c20000 {
-- 
2.43.0



