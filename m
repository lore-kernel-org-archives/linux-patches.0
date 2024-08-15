Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2777B19E7EF;
	Thu, 15 Aug 2024 13:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729332; cv=none; b=k58APhF+yzIEyKBlCZdzml4H0VfLt9xToDEkcL9gUD4AvSFBIQBsiqTZXBcQFn8v8yp444KnjwqGPqCtNiMOh0gvhWYNsgcZEHvL8FD0BcAbcwyNRgoo2++SMX5rM1Nxcte2WYPUC8HvKN1bJQMM71D5eA7QA7GXm6TgI3Uk4IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729332; c=relaxed/simple;
	bh=uzTXY+lF5VDsJtwUQEauuuqWq4kmiZ+6au0cdJjmy+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=drH7TkwYE2EJCYnpIk28HDRTNeidrKeyZfp9xkKGCJExpHf8EcDjeU8Kcj2sOjFLnpQboClPNVjlY2fSx8nd5MIxQEMQVqHfTFn0r7GilFbT1j1BLXkCAKgmEaueOKIwcTN3lqi/Yzi6A+nsGlehG8YEsT44SUIIztJlyyrsbfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fI5CWWhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fI5CWWhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902F4C32786;
	Thu, 15 Aug 2024 13:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729332;
	bh=uzTXY+lF5VDsJtwUQEauuuqWq4kmiZ+6au0cdJjmy+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fI5CWWhvwSCvr53YcfidofmR3RU8uUB6c5BuOrELNt9UvAHIP6BypkKK5BmG6vKSY
	 osrbMINUkrNstqNAvV6eQ5LZBM+GDjmb3PF33xJZm7abRfqgb98cFP8ovzFYXQywos
	 jKrYvSscVTX67Qx5zhBDXcr74dzqJkYYJJO/ruFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/484] arm64: dts: mediatek: mt7622: fix "emmc" pinctrl mux
Date: Thu, 15 Aug 2024 15:18:11 +0200
Message-ID: <20240815131942.553609558@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit aebba1030a5766cdf894ed4ab0cac7aed5aee9c1 ]

Value "emmc_rst" is a group name and should be part of the "groups"
property.

This fixes:
arch/arm64/boot/dts/mediatek/mt7622-rfb1.dtb: pinctrl@10211000: emmc-pins-default:mux:function: ['emmc', 'emmc_rst'] is too long
        from schema $id: http://devicetree.org/schemas/pinctrl/mediatek,mt7622-pinctrl.yaml#
arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dtb: pinctrl@10211000: emmc-pins-default:mux:function: ['emmc', 'emmc_rst'] is too long
        from schema $id: http://devicetree.org/schemas/pinctrl/mediatek,mt7622-pinctrl.yaml#

Fixes: 3725ba3f5574 ("arm64: dts: mt7622: add pinctrl related device nodes")
Fixes: 0b6286dd96c0 ("arm64: dts: mt7622: add bananapi BPI-R64 board")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240604074916.7929-1-zajec5@gmail.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts | 4 ++--
 arch/arm64/boot/dts/mediatek/mt7622-rfb1.dts             | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts b/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts
index 483f7ab4f31c7..b4aa9a9712fe5 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts
+++ b/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts
@@ -285,8 +285,8 @@ asm_sel {
 	/* eMMC is shared pin with parallel NAND */
 	emmc_pins_default: emmc-pins-default {
 		mux {
-			function = "emmc", "emmc_rst";
-			groups = "emmc";
+			function = "emmc";
+			groups = "emmc", "emmc_rst";
 		};
 
 		/* "NDL0","NDL1","NDL2","NDL3","NDL4","NDL5","NDL6","NDL7",
diff --git a/arch/arm64/boot/dts/mediatek/mt7622-rfb1.dts b/arch/arm64/boot/dts/mediatek/mt7622-rfb1.dts
index 28e17a7e2a5a6..e1ad840dc3175 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622-rfb1.dts
+++ b/arch/arm64/boot/dts/mediatek/mt7622-rfb1.dts
@@ -249,8 +249,8 @@ &pio {
 	/* eMMC is shared pin with parallel NAND */
 	emmc_pins_default: emmc-pins-default {
 		mux {
-			function = "emmc", "emmc_rst";
-			groups = "emmc";
+			function = "emmc";
+			groups = "emmc", "emmc_rst";
 		};
 
 		/* "NDL0","NDL1","NDL2","NDL3","NDL4","NDL5","NDL6","NDL7",
-- 
2.43.0



