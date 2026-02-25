Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD471F03DE;
	Wed, 25 Feb 2026 01:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983886; cv=none; b=WeFfbvylti5nhKZBQHc4C0gUcxT/qZwb2Ree4MlFp4K9zonxMKOqdkc3SWJhkg4i4BuCeT+YDf2carasz5RlmNDxWwt98rQZbQWUtEkQ5MSgAwa58jlJ6UYMJnok6QkIh5IA1l9YUDyHDM7UXLhjHN5EcnFsvVVROIz+HWhkHKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983886; c=relaxed/simple;
	bh=UCl8WhMBgv+Lmi4Q87Nny1AigDhOb6kXC1jUtfhMbN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fiW5+eMho6F2UZzKvUfKFu2bYRM7oBMaxoeXaCkg/GJUt44daSqAx0163iOnnSEtcVh6MWtOUOW+qJ+H8hKkMrb7SFZ3DKDjl7woUAs5Qvq8WqmqA4sOW07ZUW0V35VM4xbQ58blmGXGU9+Cu2wgdp4R5X9H9bMSN1EJGCjttqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9+Sg//y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9+Sg//y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A3DC116D0;
	Wed, 25 Feb 2026 01:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983885;
	bh=UCl8WhMBgv+Lmi4Q87Nny1AigDhOb6kXC1jUtfhMbN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9+Sg//ybVQv1Y2CeOdRzQFBw6qZE13msx0liSptaqfmuBSaOX0BUVtYAFxHO2jUt
	 cnaLjyGBN0s/AElxy4nOFfHMMHPatXojE7MFOyYXxASnG8FjmsVY+8G5FzAqU9IyC7
	 ZfxP+C0pLqmT5gfPtTCtdo28izJR4R09VsQnUa7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 159/641] arm64: dts: amlogic: g12: assign the MMC A signal clock
Date: Tue, 24 Feb 2026 17:18:05 -0800
Message-ID: <20260225012352.927303636@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 6724405eaa6f5..8d8ab775404d9 100644
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



