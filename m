Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FC8DF59;
	Wed, 20 May 2026 18:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302231; cv=none; b=nHJWYyHNuP/fDBpnN+km+64EBNcjEXCR98c67/+kIJJowz17SGe0MD13cJN9RWVSlm33XOGL4XFAAIbzTb1PFfDt+zlkFU95D2uYPKTyzM8TXN3Rl/U+mHhdcuFeQoFqifqOLjY+BOyqNG/ngdr0+qKOrh1QoQKAjZM/2dYzMrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302231; c=relaxed/simple;
	bh=IL0skcsJjElpN11R3Kb/664q6oXDhVcBfQIczKNViuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVp1dopEM6zmn4F4l0bB8LN/ZBPShLxYpIMonj443GV6anWP7NewE71Vfvc4l4RFEECJJYI9kHE8hxGG1mCC/4SLvsZ5ljukeJQ281LwxRUU6P3dBEddpRgw0FGeBRxbKrCPIrQqeujUV8Es7z+Q7/a16e6zpQBXVccT2qr2JwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxfQdUWK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxfQdUWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B838D1F000E9;
	Wed, 20 May 2026 18:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302230;
	bh=ord1e2DLAwFpXGF256hDi9x8WZcMAm0goy9PrgRZn3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JxfQdUWKMcHYWxrnAwbkCJxH0Eiy45+bUq9AGgxiS3Vire86TiGMqsaxSknStCJ5s
	 x0xwIG4T1zVXE5VoNAnjexjpYtcs2KLrueNZ47umHXy3pwq83bII7PSb43G6Q4099V
	 xud+fM1/oLR7XVYNxVV2GJ41BNFCpgMeZQcAJLrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akari Tsuyukusa <akkun11.open@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 188/508] arm64: dts: mediatek: mt7986a: Fix gpio-ranges pin count
Date: Wed, 20 May 2026 18:20:11 +0200
Message-ID: <20260520162102.710073895@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akari Tsuyukusa <akkun11.open@gmail.com>

[ Upstream commit 820ed0c1a13c5fafb36232538d793f99a0986ef3 ]

The gpio-ranges in the MT7986A pinctrl node were incorrectly defined,
therefore, pin 100 cannot be used.
Correct the range count to match the driver.

Fixes: c3a064a32ed9 ("arm64: dts: mediatek: add pinctrl support for mt7986a")
Signed-off-by: Akari Tsuyukusa <akkun11.open@gmail.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index 559990dcd1d17..05bd2938242fc 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -187,7 +187,7 @@ pio: pinctrl@1001f000 {
 				    "iocfg_lb", "iocfg_tr", "iocfg_tl", "eint";
 			gpio-controller;
 			#gpio-cells = <2>;
-			gpio-ranges = <&pio 0 0 100>;
+			gpio-ranges = <&pio 0 0 101>;
 			interrupt-controller;
 			interrupts = <GIC_SPI 225 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-parent = <&gic>;
-- 
2.53.0



