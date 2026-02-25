Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA74919FA93;
	Wed, 25 Feb 2026 01:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983871; cv=none; b=FAgSoLRrZcsJhYUIh1NV7qHj2OasaUuYkWfe/l2xtmRfPlR1Megrvg914uuI0MIakyefDpUS09O78fvhI7QEu9PfVPWNkPHiFDb5XS/RhTZp6liCo5a+5Z55lC0QQYCZkqA3AyJ++WbUlhPFb9R4tG6DWfI0smSyx+qYGqacTLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983871; c=relaxed/simple;
	bh=hZHGz/mZi+JWnIrh9QEhSD3DX/CYbZ5cW4djWR0GeRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uB2cmnjgyzyWeA+Q8vDYxtnMOgne2c0tQ4n3EroG2+LM2iOfV+h65ktQpFWSNvBU8FKiyErcCJWwWl+jAiwCuKzDLlxxTTXYSQ5A4VQWyPKfggRo5/yV9J34NH5BhKLmghA/chelnRdmwnXKlwCiqtfmTfNrZificHiKk8VbdVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZcRAMTX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZcRAMTX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79970C116D0;
	Wed, 25 Feb 2026 01:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983871;
	bh=hZHGz/mZi+JWnIrh9QEhSD3DX/CYbZ5cW4djWR0GeRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcRAMTX2LPm0uiWd8rJ32qkcSBxuPrXSjyxS6JpLlGw+IRk48Aci/hrgE3fG8BDmS
	 6i37CPIoPBJc4VQUN0Z0UcqMWG/1FQ0KLAMg4HsQBPZEHyr03JspitXN6u2yXQIkC9
	 feCqr06nSqVh9/inMfydQXzPut+cS4qO//UFELII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 148/641] arm64: dts: mediatek: mt8183-jacuzzi-pico6: Fix typo in pinmux node
Date: Tue, 24 Feb 2026 17:17:54 -0800
Message-ID: <20260225012352.687732088@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit b1fc81a986c9b8089db31e21a372cc8b6514e900 ]

Rename "piins-bt-wakeup" to "pins-bt-wakeup" to fix a dtbs_check
warning happening due to this typo.

Fixes: 055ef10ccdd4 ("arm64: dts: mt8183: Add jacuzzi pico/pico6 board")
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts
index cce326aec1aa5..40af5656d6f15 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts
@@ -91,7 +91,7 @@ bluetooth@2 {
 
 &pio {
 	bt_pins_wakeup: bt-pins-wakeup {
-		piins-bt-wakeup {
+		pins-bt-wakeup {
 			pinmux = <PINMUX_GPIO42__FUNC_GPIO42>;
 			input-enable;
 		};
-- 
2.51.0



