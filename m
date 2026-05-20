Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEEC29D26E;
	Wed, 20 May 2026 17:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298350; cv=none; b=B6Cbo5mawQNI2wWo3FdTcJ+wyn9nRkBgEBAVKnIZuqeEk+3avYeFqfrUkeoG96xUqU7PGXdjFMRUt1Gd96OdepaM3Wfz+4BosGF0cemYlxvJsNZn7Zk26bj1GzF9I+DxKq4eD1yyl+iRPSbHbDQXAOxAAmmwbfGk9sWpNTt6MWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298350; c=relaxed/simple;
	bh=Xip5loRV3iEo5HYtTOoZ+HC4B03jESpAVAgDMOjOMGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5oSZ9+hZAqE7zepYqzoeooo885SeoosqlwOVqnhJ19/zsJZ5bMN1SMBpF0u+nRjvCgvGBjNhbWMD+kbIkSlhk6WYp+jLqKjGFSrlbVioavGU8eIsAD5bZsmIFEgTbHRBQnIaZTraP0B8P0HPNGZmwQujhclT2TfFFO+39xCQfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x9tOTEuO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x9tOTEuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF871F000E9;
	Wed, 20 May 2026 17:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298349;
	bh=7s8P32oRry9OQwEk51j6Wa/FHe7gMkJLDItVGEqe3S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x9tOTEuOB64QE0l+SNGXw1GaHFnG6XusR1HJtrv52B8psbAjFTg5A0WkfNLvZpI5q
	 /Rh3H59cu3BTkv/+TjWhA9FKjimH/+rYxdQqI77WGAs0gJVqtiG7ZU7vbXtifDtEyr
	 td05FV/Fsu2dBfs0IF+S/ZBz8iaQZn0/cc52gyAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akari Tsuyukusa <akkun11.open@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 377/957] arm64: dts: mediatek: mt7981b: Fix gpio-ranges pin count
Date: Wed, 20 May 2026 18:14:20 +0200
Message-ID: <20260520162142.703950850@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 277c11247c132..88d7c3da3e49b 100644
--- a/arch/arm64/boot/dts/mediatek/mt7981b.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7981b.dtsi
@@ -225,7 +225,7 @@ pio: pinctrl@11d00000 {
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



