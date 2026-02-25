Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EE62BAF7;
	Wed, 25 Feb 2026 01:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983008; cv=none; b=R0Aoq8uK6elQipeYorqJM0VbEY46IJwO4FdhMiaMXzrXmkGcgxVkBROxqE0NFGP9PGEqGPdDK6LS4gy3i0TStZH/g5/Uzikm2y75264tYJDjLLo2i74vWEa95B323Gv6xVsH234rXhWzW3szUSQGIJS5naief14gUF/+9TGEDOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983008; c=relaxed/simple;
	bh=ncMEqRLPRmT8eqmW90e6HNgKVIoQlC4NnXfDCxYNxPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBDCSEEBeWCaA3BuuqCL0qUkcgKh5/tEkJcZVmasQXxPYWrG/FiQLtAo/HrlXXucS78UTGlFUtdQVhqwNGDCB27Grf7bgSq9G6fzCE/mdwggoy35DEZlsmyVdM3nEtlzBoFUigJzAm8ElrJHoJ+NYY5Q/ZCQtvsBj+dgs4ieLzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mawL1XzB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mawL1XzB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025CAC116D0;
	Wed, 25 Feb 2026 01:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983008;
	bh=ncMEqRLPRmT8eqmW90e6HNgKVIoQlC4NnXfDCxYNxPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mawL1XzBmSMjPrh+fMnJcoUNIfQ7BDyDJqkR0AB4rfN71ac/UuaBvSvE7XDBLfzIB
	 aIumAunrUbOkFdZWHGgTrcY090ir7+LZS6ZtxXKT9Jx2MV3dSuC4SeAhJVEKeG817g
	 CGz8YV1hpbsZE1hc0r3+ZeAFdWbfRramf3RHOFmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 178/781] arm64: dts: amlogic: g12: assign the MMC B and C signal clocks
Date: Tue, 24 Feb 2026 17:14:47 -0800
Message-ID: <20260225012404.010512391@linuxfoundation.org>
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

[ Upstream commit be2ff5fdb0e83e32d4ec4e68a69875cec0d14621 ]

The amlogic MMC driver operate with the assumption that MMC clock
is configured to provide 24MHz. It uses this path for low
rates such as 400kHz.

Assign the clocks to make sure they are properly configured

Fixes: 4759fd87b928 ("arm64: dts: meson: g12a: add mmc nodes")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260114-amlogic-mmc-clocks-followup-v1-5-a999fafbe0aa@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index ca455f634834b..0085612cf7351 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -2443,6 +2443,9 @@ sd_emmc_b: mmc@ffe05000 {
 				 <&clkc CLKID_FCLK_DIV2>;
 			clock-names = "core", "clkin0", "clkin1";
 			resets = <&reset RESET_SD_EMMC_B>;
+
+			assigned-clocks = <&clkc CLKID_SD_EMMC_B_CLK0>;
+			assigned-clock-rates = <24000000>;
 		};
 
 		sd_emmc_c: mmc@ffe07000 {
@@ -2455,6 +2458,9 @@ sd_emmc_c: mmc@ffe07000 {
 				 <&clkc CLKID_FCLK_DIV2>;
 			clock-names = "core", "clkin0", "clkin1";
 			resets = <&reset RESET_SD_EMMC_C>;
+
+			assigned-clocks = <&clkc CLKID_SD_EMMC_C_CLK0>;
+			assigned-clock-rates = <24000000>;
 		};
 
 		usb: usb@ffe09000 {
-- 
2.51.0



