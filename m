Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920EE5384;
	Tue, 23 Jan 2024 00:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970811; cv=none; b=nQ2phtfNduf0Jd4j1bSG1wPq4F/kLA4MD5CQHxzzoAJrTW7P9aTq5pCDnrmbTIHs51Z/ltIxrobg3MjTUXLPbcq36HT2CxOh0zaj76lI5LK84UXDh4/427AlMGvtfp01v5jQrXoNFI5tE2V/p86XIknt7KZOMy0tO/jpIAej51A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970811; c=relaxed/simple;
	bh=Em+Nwcbn6YMykwTVRfmCLQ0hX+CpwpswwSP77hUiMQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4pbeq2YLoIx0V8izq4iphU2YX9kt4n857iIfIfSy2mxmeOJbj9YduDJUS1747hKuuCTZs44OeDNZ5OX3m4jhuZf7rIJkC3SCWp9XZ81SwJRrzLLtl3E+e4kd1uBYTV9ndScNtBPgmDDnkgr6NgJp0UH6G/agyc09c3jAeLMZnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nLrSAQ2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLrSAQ2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5DBC433C7;
	Tue, 23 Jan 2024 00:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970811;
	bh=Em+Nwcbn6YMykwTVRfmCLQ0hX+CpwpswwSP77hUiMQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLrSAQ2CfoSW4pGBgsfDCLrYyi0IlVAwiYRUvxG0NpBQldZ/pFBRnuBZCdgE9jKXo
	 euerCUJZEWHbi3/naqnbiNQResiM/d18f07ICijxhdVyIPH+0KzP3YKIih0QYrmRrw
	 rBO9JH+9XtpHLUT15/xmI16iq7CtzruT4b3Y4Dt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/417] arm64: dts: qcom: sm6350: Make watchdog bark interrupt edge triggered
Date: Mon, 22 Jan 2024 15:54:20 -0800
Message-ID: <20240122235754.883958781@linuxfoundation.org>
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

[ Upstream commit 5b84bb2b8d86595544fc8272364b0f1a34b68a4f ]

As described in the patch ("arm64: dts: qcom: sc7180: Make watchdog
bark interrupt edge triggered"), the Qualcomm watchdog timer's bark
interrupt should be configured as edge triggered. Make the change.

Fixes: 5f82b9cda61e ("arm64: dts: qcom: Add SM6350 device tree")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20231106144335.v2.8.Ic1d4402e99c70354d501ccd98105e908a902f671@changeid
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/qcom/sm6350.dtsi
index cea7ca3f326f..9da373090593 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -1462,7 +1462,7 @@ watchdog@17c10000 {
 			compatible = "qcom,apss-wdt-sm6350", "qcom,kpss-wdt";
 			reg = <0 0x17c10000 0 0x1000>;
 			clocks = <&sleep_clk>;
-			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 0 IRQ_TYPE_EDGE_RISING>;
 		};
 
 		timer@17c20000 {
-- 
2.43.0



