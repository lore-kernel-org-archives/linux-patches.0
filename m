Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1A818B484;
	Mon, 24 Feb 2025 14:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408122; cv=none; b=LMsg5bU7n4aSi1LbN11d9h8JOwIqxKuWtLLmZukIqwKIJrGJ1G1x3X+2S5GM8aUHt8e7Z+oRCCBoLSGowpev5h6TA6ZW1kmKaJKcUavbSNBel/4kuyV80EkCEdAGZ1xSvd/TnvYN+VHchmaRIkyns8P19E1sRMRmsBFEPfz0vjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408122; c=relaxed/simple;
	bh=Ndjd6P4NBkUixSkJkfRMSplOpdKQv/MHITqNh6eJvCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxN4tHEX4pTW2kYNjW313H82xftjC7LLE7ivRSmCJ7SU6hCf5WYoH6Wm4zBC4ZjdMILJvOjD9GJwawmNlijwAUU1HcCrkRA1+YQTWhLxNpMcLWjlVZPgJ8NPNXfKgRcMWF8XK0LWPY272VihHQOWYbMK2ElIbQ2UxhwPGSUU8tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Te0xB/mB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Te0xB/mB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B6EC4CED6;
	Mon, 24 Feb 2025 14:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408122;
	bh=Ndjd6P4NBkUixSkJkfRMSplOpdKQv/MHITqNh6eJvCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Te0xB/mBi9EwDbBFDLXnC0AR+OZSFNygu1sQa9j82dYRX3O+XDtju+F81UHfHyO31
	 qzI8h9haIW/OaFxggZoQboNqPqGxmqmiNWO+rP/nTp7eXT2q8hxp2PgeUbkDGG5PlY
	 RlkEDruKQH1S/6KzD6dESG0LWJ9qVXh/c+HGI+Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Fei Shao <fshao@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/140] arm64: dts: mediatek: mt8183: Disable DSI display output by default
Date: Mon, 24 Feb 2025 15:35:06 +0100
Message-ID: <20250224142607.218683604@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 26f6e91fa29a58fdc76b47f94f8f6027944a490c ]

Most SoC dtsi files have the display output interfaces disabled by
default, and only enabled on boards that utilize them. The MT8183
has it backwards: the display outputs are left enabled by default,
and only disabled at the board level.

Reverse the situation for the DSI output so that it follows the
normal scheme. For ease of backporting the DPI output is handled
in a separate patch.

Fixes: 88ec840270e6 ("arm64: dts: mt8183: Add dsi node")
Fixes: 19b6403f1e2a ("arm64: dts: mt8183: add mt8183 pumpkin board")
Cc: stable@vger.kernel.org
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Fei Shao <fshao@chromium.org>
Link: https://lore.kernel.org/r/20241025075630.3917458-2-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183.dtsi b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
index d1b6355148620..f3a1b96f1ee4d 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -1828,6 +1828,7 @@ dsi0: dsi@14014000 {
 			resets = <&mmsys MT8183_MMSYS_SW0_RST_B_DISP_DSI0>;
 			phys = <&mipi_tx0>;
 			phy-names = "dphy";
+			status = "disabled";
 		};
 
 		mutex: mutex@14016000 {
-- 
2.39.5



