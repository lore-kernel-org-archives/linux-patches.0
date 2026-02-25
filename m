Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFEA248886;
	Wed, 25 Feb 2026 01:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983047; cv=none; b=cUb0fT2Xx8Wa6niG0Vk0m0djnvazY+S5FqsgJxVvaiGMOOnLdUJnODTxrXI4x/DM8Rpi51qJ/naTsUZdy4+NyznbK47Qi0HdeGz7ci18MvbxAzWKZ3gH9/d4QqbnoTwD7iq6OjjapunMEAIhDHEomhBbvkJLdYeDaDvbqrxTEZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983047; c=relaxed/simple;
	bh=EeZiGCm9cLI1GW0Ayo/JLMTbykO9Sf0QKiqGK6jQaMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPUnrD4YhTvCe2oKCSPAjV76R+BVlwuSqEVJZ2oRYc+hge1RHIk9NPSCSEgcpvV8eMKJzWNBNdmi3YkKPmY+PNsoRgIHFvDm+KRYVBiEZ0BUxPrH2QCAZipU9qy8cSNrgUFMEB/lFP6dPzZsFGOqHN2YxUItSw/leU/XlniJso0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eS/yIbHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eS/yIbHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983ACC116D0;
	Wed, 25 Feb 2026 01:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983047;
	bh=EeZiGCm9cLI1GW0Ayo/JLMTbykO9Sf0QKiqGK6jQaMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eS/yIbHJ4F54npe49MFZoa3LWaJfBmgx8Udz1bxQ09uPm6BwvWi52m6THS3CcrW4K
	 b0MwESVe7qhJduqxGElGdCSyIZiFHiI5suR7W7BbRDYhMfUY5sVt8GFPWVnV9OIorW
	 qxdtvtu0l7KKU9EYPaoRtO/mnQZqLMyquTbfaDcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 168/781] arm64: dts: mediatek: mt8183-jacuzzi-pico6: Fix typo in pinmux node
Date: Tue, 24 Feb 2026 17:14:37 -0800
Message-ID: <20260225012403.771543993@linuxfoundation.org>
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



