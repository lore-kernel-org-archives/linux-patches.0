Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC5F2BAF7;
	Wed, 25 Feb 2026 01:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983010; cv=none; b=A2mkNgcOhJZ3mL1ZIFo8Yxt9IeiTd640GwBLCjQgRRV0hjiVt6MX5mmdgoJyGnult4J9VY5u8Ft865SULE/qtxiY2K2D6JmCGlbjBCu2P+48Iu7Bw9dmjLnZRa1Fk0RK0IeqKqPUn+9jBk4CR7jAZoB8PV+KhKOc8bnxwVECLXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983010; c=relaxed/simple;
	bh=PYtDFhYwoLbTD0dko14iWHn0DZxxzzNMUHbZ0m/rECs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFP4qFML2sxtfdzTYvgi4sH3aA2GxO6iv9j0sPk+9LIYlnbHzT7qgDSkAZzgSqpeJ0OnRaC1F2TBd7R9HyMs58TpfA7CTnvF8AGtXYQkZhCYttC2sGVEJfc9kksJcXqplUtDIo9oA2+Xdon9tn/dBYrtEiIzfEfTmOQERjarsb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WiUwv2tE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WiUwv2tE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AB0C19423;
	Wed, 25 Feb 2026 01:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983010;
	bh=PYtDFhYwoLbTD0dko14iWHn0DZxxzzNMUHbZ0m/rECs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WiUwv2tE23QciBMft68GJ3EsupnS87QWpoUZSNvV+O2nx7ENYzIr4tWDvSXzEQdOd
	 efZ63vatfQr5GgQ+AErGyvxhCVAuOG8242MU42Ru8eHLbpwAlRrOo4XbnEQ5qCN+rk
	 j7w59QB72LwYCwmcZZzL0XXxO2XOKgRrUclIKRM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 179/781] arm64: dts: amlogic: g12: assign the MMC A signal clock
Date: Tue, 24 Feb 2026 17:14:48 -0800
Message-ID: <20260225012404.035712889@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 3c941feaa363f1573a501452391ddf513394c84b ]

The amlogic MMC driver operate with the assumption that MMC clock
is configured to provide 24MHz. It uses this path for low
rates such as 400kHz.

Assign the clock to make sure it is properly configured

Fixes: 8a6b3ca2d361 ("arm64: dts: meson: g12a: add SDIO controller")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260114-amlogic-mmc-clocks-followup-v1-6-a999fafbe0aa@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 0085612cf7351..00609d2da6743 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -2431,6 +2431,9 @@ sd_emmc_a: mmc@ffe03000 {
 				 <&clkc CLKID_FCLK_DIV2>;
 			clock-names = "core", "clkin0", "clkin1";
 			resets = <&reset RESET_SD_EMMC_A>;
+
+			assigned-clocks = <&clkc CLKID_SD_EMMC_A_CLK0>;
+			assigned-clock-rates = <24000000>;
 		};
 
 		sd_emmc_b: mmc@ffe05000 {
-- 
2.51.0



