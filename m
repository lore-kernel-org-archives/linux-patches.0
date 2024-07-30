Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746F0183CBF;
	Tue, 30 Jul 2024 16:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355984; cv=none; b=Y/LLa4hKCCAM5Bm3D/bFCoBEitDBwbcttb4ubUBMs3+4aSuIqM7kkgbz4h9zEGqWZRN2YHGZ/WFHN8UqJm8f4dD3G0P2xITD+IcaG7UAIlk5n+j1X4zjOzUeSF3B9MUa3FGoUzIp1ZAsdIVLtlDI9A1Gr3HwSDIKDZZJGDI0yOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355984; c=relaxed/simple;
	bh=AjKvbBYMun4bwxbkTndk2MfCCxskbi61/pWhZ8a07DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBkovfwtgr5F2ycZompHzYcGJs/x06Z384QKONCFIRMLQs/BbCEzHpzRD7UyfCyhl9kFOL3OkfEPvVWoq0gd54+8/786Zi1Jle0vr9uibNHQNNeRgIsNFVN6+LJzZmVk1zCqIbXWtZlGqW+DoN3SMzD1RWpwNZjpjXcMaxbReqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qg45aw6V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qg45aw6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB55C4AF0C;
	Tue, 30 Jul 2024 16:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355984;
	bh=AjKvbBYMun4bwxbkTndk2MfCCxskbi61/pWhZ8a07DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qg45aw6VdPyUu6V5QiM2WFQ0o8/MVFdZ3j8VYoumrrsY7OapQnmKj5OBZEz8Ns8O1
	 EUbltdscq5xPyo+K2w1OH1WJCn1b9bTNDhf/eyOsbgUZ6k1CSgSdOziwQArxqrrwxy
	 /2W+km5GazJggY7ukSdMaehaeWEmfZM3vBpOcg6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 106/809] arm64: dts: mediatek: mt8183-kukui: Fix the value of `dlg,jack-det-rate` mismatch
Date: Tue, 30 Jul 2024 17:39:42 +0200
Message-ID: <20240730151728.813220044@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Te Yuan <yuanhsinte@chromium.org>

[ Upstream commit 95173af725e6f41eb470466a52ddf2054439409c ]

According to Documentation/devicetree/bindings/sound/dialog,da7219.yaml,
the value of `dlg,jack-det-rate` property should be "32_64" instead of
"32ms_64ms".

Fixes: dc0ff0fa3a9b ("ASoC: da7219: Add Jack insertion detection polarity")
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Link: https://lore.kernel.org/r/20240613-jack-rate-v2-1-ebc5f9f37931@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-audio-da7219.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-audio-da7219.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui-audio-da7219.dtsi
index 8b57706ac8140..586eee79c73cf 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-audio-da7219.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-audio-da7219.dtsi
@@ -27,7 +27,7 @@ da7219_aad {
 			dlg,btn-cfg = <50>;
 			dlg,mic-det-thr = <500>;
 			dlg,jack-ins-deb = <20>;
-			dlg,jack-det-rate = "32ms_64ms";
+			dlg,jack-det-rate = "32_64";
 			dlg,jack-rem-deb = <1>;
 
 			dlg,a-d-btn-thr = <0xa>;
-- 
2.43.0



