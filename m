Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4B43F7ABC;
	Wed, 20 May 2026 18:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300694; cv=none; b=P7/6/qYBm1wQqnZV37AiQf44orcqvTWczuRajWqqyY9Wj5qHWT2NkLqRYT4hBJzxWA76l0eldNIAD2PFu0JVFa+7hWIARACcKpuM6W1XWJ3o1aFEVrUckZZRgQCP5v9+GKI9yFsAjB6UO9YbSVZsF7O3FGAxoaU9MRfrHEJWq7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300694; c=relaxed/simple;
	bh=HkAfpxwuVhpGShdIJIMZyM1temQD9dm9MmruoDaURiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MP0BCMEnPTWD60PNKEpnOtYuUbSsdSthOhfsgQQLVG11KGDHzVAiJZNpv7DBhCVrEjy3lStaxB+OFsspmi4rh0oxvippONAu8vZPvLWVAMHnJvPRmFEQENZuwaGjcmyFexbdNdC3rKt/ZAnnc6F/iWsxFK2N5cUoT22Fz0/dWq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xG/HjZsc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xG/HjZsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED7A1F00893;
	Wed, 20 May 2026 18:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300693;
	bh=dgZPLW+BbT+f+PATM5M8QSnmlAaOl1IOngaErbDw0U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xG/HjZscaFgVHveZpR9HKbqlNHublagSbwm2//SGdp0XVFGInfhxyWv0kt+prspsQ
	 W71U2Jjk9F8PdNPM1xSZJqAXGOvGVH7yhixrDVzCC9MFMtX9im0idW8gdrKg34zi6F
	 l3A/hgIAQvn/5oecbh9t3DGdU4QV3qz9RqLoNuwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akari Tsuyukusa <akkun11.open@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 272/666] arm64: dts: mediatek: mt7981b: Fix gpio-ranges pin count
Date: Wed, 20 May 2026 18:18:03 +0200
Message-ID: <20260520162117.110741917@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akari Tsuyukusa <akkun11.open@gmail.com>

[ Upstream commit b62a927f4a46a7f58d88ba3d5fb6e88e1a4b4603 ]

The gpio-ranges in the MT7981B pinctrl node were incorrectly defined,
therefore, pin 56 cannot be used.
Correct the range count to match the driver.

Fixes: 62b24c7fdf0a ("arm64: dts: mediatek: mt7981: add pinctrl")
Signed-off-by: Akari Tsuyukusa <akkun11.open@gmail.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7981b.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7981b.dtsi b/arch/arm64/boot/dts/mediatek/mt7981b.dtsi
index 5cbea9cd411fb..63da296bebad6 100644
--- a/arch/arm64/boot/dts/mediatek/mt7981b.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7981b.dtsi
@@ -200,7 +200,7 @@ pio: pinctrl@11d00000 {
 			interrupt-controller;
 			interrupts = <GIC_SPI 225 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-parent = <&gic>;
-			gpio-ranges = <&pio 0 0 56>;
+			gpio-ranges = <&pio 0 0 57>;
 			gpio-controller;
 			#gpio-cells = <2>;
 			#interrupt-cells = <2>;
-- 
2.53.0



