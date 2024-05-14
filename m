Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED51313D2B7;
	Tue, 14 May 2024 10:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683345; cv=none; b=MU/yHlhefTorV93EGOctVaR1ztk3v7VTXMdJBNjP6qUdUG7JJvKXrj9fMNEvKl5I9lX2mspXD3kotDqp5MsiBICE8HUgkunOyoCTXyNOGFHF9CLMnxHqkGSMLTf8r7LIldE/0A4FbtZuxKf/3U9OKkrKPZPZFK2/9O+YPVNVtCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683345; c=relaxed/simple;
	bh=3X9hGJ/CoyUyGZKtnrWrpiobyEVAN+5gKKQ9gmVoVEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7Ah1mrCxk/Dr4aO+PjhXhtL5PqaUN0v8+sUvLyEm+9XA+ygiPySBkYoOsBrDEd/OFNtz7uoWNhXNhkXxdoRn53ULqLCdn84hPB8vJTjNvH9cG2m87cvjyzhbOPjV3qWnv2uc5NVWDL/VKng8u5rlWD4coXZUULg9qdGF9WUHUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OrcAhAX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OrcAhAX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23215C2BD10;
	Tue, 14 May 2024 10:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683344;
	bh=3X9hGJ/CoyUyGZKtnrWrpiobyEVAN+5gKKQ9gmVoVEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OrcAhAX1BULShPsGqYd3S7zM9+99EgVbTVhCb2RvKMTPOh+7puDEc4xGT2GLE+xLo
	 iIeGgWK/CLa6KJ1asjG2ItG6pPAnpL9Dgwl5HzEKz2CMjPWOVZPIrrSnUHipblmSW1
	 yepJJYnj8mqI6lRcvJkFTTtDi7vFdCxHVAd9+ciQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 202/336] arm64: dts: mediatek: mt8183-pico6: Fix bluetooth node
Date: Tue, 14 May 2024 12:16:46 +0200
Message-ID: <20240514101046.229771729@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit cd17bcbd2b33d7c816b80640ae2fef2507576278 ]

Bluetooth is not a random device connected to the MMC/SD controller. It
is function 2 of the SDIO device.

Fix the address of the bluetooth node. Also fix the node name and drop
the label.

Fixes: 055ef10ccdd4 ("arm64: dts: mt8183: Add jacuzzi pico/pico6 board")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts
index a2e74b8293206..6a7ae616512d6 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts
@@ -82,7 +82,8 @@
 };
 
 &mmc1 {
-	bt_reset: bt-reset {
+	bluetooth@2 {
+		reg = <2>;
 		compatible = "mediatek,mt7921s-bluetooth";
 		pinctrl-names = "default";
 		pinctrl-0 = <&bt_pins_reset>;
-- 
2.43.0



