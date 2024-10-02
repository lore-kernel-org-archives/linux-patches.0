Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD47B1D1752;
	Wed,  2 Oct 2024 14:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878740; cv=none; b=eS2SiPhcQwoDhRrrzX3i4LuM1cfzjY6mwkpOboZWo4xaaFx1shp0q+uOaxeiF+tegk8jkHWW0h0FjF0zVEQu8FmXpzVu14DIJOwqCArbdOw+BGDwZkQZ3TwrPoS7yJqGeK6D+HAVIZWVPjLZi7FINouXTQ7IHN8FlopmPUy0R4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878740; c=relaxed/simple;
	bh=Oy69riVdUbQltVhI7hoejnLjRIsARA5mC6nLiv2QiQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HMyMGPy1yTj9OzvcL76zZYcIy6IC2aAdr+aAd3E6LNmxnFTWmAYvNspc/hh2/PWrxkzFd3auGmi1C9sS6zjA87Ljs0v3WNn5/jxlOmXMUcwjgBCGCHDcRqgfPXZ5zh60nnGcSo//doyp4J1b3/cA5ZMVpoj8FXjwk7JLgAWikpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mz+hfQtJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mz+hfQtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5462EC4CEC2;
	Wed,  2 Oct 2024 14:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878740;
	bh=Oy69riVdUbQltVhI7hoejnLjRIsARA5mC6nLiv2QiQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mz+hfQtJjWv58MubSBLfMRwwMmxpxdeJBxrNQaa+dk4SPyZq+6ACZcHlMmeMHGNb9
	 led2XpwibIozUoT7nf4uBI2jlY6VA+I7vJ4/UK0g8hHgbJc1RHGEkJeVaeqIVZuS/5
	 euhB5vmOlvvTte+rhNLw/72p/xfZKHKnew7Yqbz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	=?UTF-8?q?N=C3=ADcolas=20F=2E=20R=2E=20A=2E=20Prado?= <nfraprado@collabora.com>
Subject: [PATCH 6.10 517/634] arm64: dts: mediatek: mt8195-cherry: Mark USB 3.0 on xhci1 as disabled
Date: Wed,  2 Oct 2024 15:00:17 +0200
Message-ID: <20241002125831.516319313@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

commit 09d385679487c58f0859c1ad4f404ba3df2f8830 upstream.

USB 3.0 on xhci1 is not used, as the controller shares the same PHY as
pcie1. The latter is enabled to support the M.2 PCIe WLAN card on this
design.

Mark USB 3.0 as disabled on this controller using the
"mediatek,u3p-dis-msk" property.

Reported-by: Nícolas F. R. A. Prado <nfraprado@collabora.com> #KernelCI
Closes: https://lore.kernel.org/all/9fce9838-ef87-4d1b-b3df-63e1ddb0ec51@notapiano/
Fixes: b6267a396e1c ("arm64: dts: mediatek: cherry: Enable T-PHYs and USB XHCI controllers")
Cc: stable@vger.kernel.org
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20240731034411.371178-2-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
@@ -1359,6 +1359,7 @@
 	rx-fifo-depth = <3072>;
 	vusb33-supply = <&mt6359_vusb_ldo_reg>;
 	vbus-supply = <&usb_vbus>;
+	mediatek,u3p-dis-msk = <1>;
 };
 
 &xhci2 {


