Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8871D07AC;
	Wed,  2 Oct 2024 14:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878743; cv=none; b=gXt6TuNmQhi1oGeb5AtRkU5h5a4BWwHTKs1AwWHgRbfat71EJ5hNsFs0I9+jO0AOxN8jm72fqicifxC3gX4fQD7uFFb3Toj7CwrSweB7LvzPhqLNAXXaepspuEpB3kHHrM4x9JQpE7h1le5eth6rZ7BWE10aI5qCcTWdZJobDaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878743; c=relaxed/simple;
	bh=NY1Y9yiGB73o3Bf9NUP0IDRvKkNgevbLSs4H1eyxFsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoougkdMkKXTo3B09V0rXZiTgQfqSqsQTMirBoJ/r3DX3in+yY4l35DRa0h5IYxIQfZrRHxQNcZp1mYfKRf2C9+uZ+92Uv/XoI5S1Iu4ktIeAmmHUBng9UMn2zm/XznabCaaZ5SOzpe/WH/hcD6XecbafZaKsPS3HvG+mI4vMms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lw2eD4o6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lw2eD4o6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E069C4CEC2;
	Wed,  2 Oct 2024 14:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878743;
	bh=NY1Y9yiGB73o3Bf9NUP0IDRvKkNgevbLSs4H1eyxFsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lw2eD4o6My1TFkj5q87aC4tLHL1WxXUXgSCl+gZvvUdzEkUzH872jybmmZdKzXpkO
	 gR5xsJmCSzRDJ8/gfJIlVQSzacd1sZ1bO7FmPX38EKGGmAgkQ1mIT7Gq1aWVJ3IBod
	 WdXUnaHQjSyR5Ldj0rDG4EkJUAFDBwxADju/KMJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.10 518/634] arm64: dts: mediatek: mt8395-nio-12l: Mark USB 3.0 on xhci1 as disabled
Date: Wed,  2 Oct 2024 15:00:18 +0200
Message-ID: <20241002125831.556240537@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

commit be985531a5dd9ca50fc9f3f85b8adeb2a4a75a58 upstream.

USB 3.0 on xhci1 is not used, as the controller shares the same PHY as
pcie1. The latter is enabled to support the M.2 PCIe WLAN card on this
design.

Mark USB 3.0 as disabled on this controller using the
"mediatek,u3p-dis-msk" property.

Fixes: 96564b1e2ea4 ("arm64: dts: mediatek: Introduce the MT8395 Radxa NIO 12L board")
Cc: stable@vger.kernel.org
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20240731034411.371178-3-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8395-radxa-nio-12l.dts |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/mediatek/mt8395-radxa-nio-12l.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8395-radxa-nio-12l.dts
@@ -816,6 +816,7 @@
 	usb2-lpm-disable;
 	vusb33-supply = <&mt6359_vusb_ldo_reg>;
 	vbus-supply = <&vsys>;
+	mediatek,u3p-dis-msk = <1>;
 	status = "okay";
 };
 


