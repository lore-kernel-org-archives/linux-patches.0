Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005462641FC;
	Wed, 25 Feb 2026 01:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983005; cv=none; b=dpxw2blYxE7iRKcBCe2aUdOPxpR/BYxOKNaUOP8QtLR9ERtERRYBoDEfZ+f22V0aQVU3EKtgMgEzyJzhNPtdI2smwx2Wc6LHPhwRBXHwasG20sypzqbiHmHxjEfqQObc+udO5jlqbtTRomw45tdg2XGUnsqDkwJHrKjvLbKogv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983005; c=relaxed/simple;
	bh=kNN+xtpbi+P9KjULDwCooB9p6e3In1n2r4tCkXPzzEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYiYd8Oo6nM8N3XQ1V1diBNDLYYP6nS+KPRZVsGii8cOu11+iX6gJUQuywNSMQN7roCzrMs8ElVcfUlEnrhobTYntO3nQ9GyZEWOMQjTHIkQiszSljgL43tChtLTvPt2QJq9tjLQ6Zsli9Woj6anxscqHMM6YKuuCnQlJhpA3tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ivu5n7KQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ivu5n7KQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE30CC116D0;
	Wed, 25 Feb 2026 01:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983004;
	bh=kNN+xtpbi+P9KjULDwCooB9p6e3In1n2r4tCkXPzzEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ivu5n7KQrOxvponcqmInMSzIGUHqr8QDAdnqbdogdws3l0rvVpBHWm6D5vAtV0B+a
	 m+NbPQbd5YznjSoJ2uKhj0TXsS46KBBiRdKEtkmYWhchAcRZxK43Qf3Csbhfe3blUY
	 HRoJ3/BD7K/Wa/4oJqVcBv5/efHou3B03YiLCEZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 175/781] arm64: dts: amlogic: c3: assign the MMC signal clocks
Date: Tue, 24 Feb 2026 17:14:44 -0800
Message-ID: <20260225012403.941109804@linuxfoundation.org>
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

[ Upstream commit 69330fd2368371c4eb47d60ace6bca09763d24a0 ]

The amlogic MMC driver operate with the assumption that MMC clock
is configured to provide 24MHz. It uses this path for low
rates such as 400kHz.

Assign the clocks to make sure they are properly configured

Fixes: 520b792e8317 ("arm64: dts: amlogic: add some device nodes for C3")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260114-amlogic-mmc-clocks-followup-v1-1-a999fafbe0aa@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi b/arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi
index 13b7ac03f9b20..885d9d64e9e4e 100644
--- a/arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi
+++ b/arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi
@@ -969,6 +969,10 @@ sdio: mmc@88000 {
 				no-sd;
 				resets = <&reset RESET_SD_EMMC_A>;
 				status = "disabled";
+
+				assigned-clocks = <&clkc_periphs CLKID_SD_EMMC_A>;
+				assigned-clock-rates = <24000000>;
+
 			};
 
 			sd: mmc@8a000 {
@@ -984,6 +988,9 @@ sd: mmc@8a000 {
 				no-sdio;
 				resets = <&reset RESET_SD_EMMC_B>;
 				status = "disabled";
+
+				assigned-clocks = <&clkc_periphs CLKID_SD_EMMC_B>;
+				assigned-clock-rates = <24000000>;
 			};
 
 			nand: nand-controller@8d000 {
-- 
2.51.0



