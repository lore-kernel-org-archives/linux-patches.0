Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F15412C490;
	Tue, 30 Apr 2024 11:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475155; cv=none; b=L+x9c66y1pYcYrvUFB0+0adHCEh2BADBlkEWXXWWYaLvTaGC/lIGadwF/zFiey+3WU5Rjklw8y0OxcHRqT3hdRn6hv0TtYozZ8009g9dckcbQwjNOFimZwcr0z2/1u0Q6diXAVzSYwf7He66TgSAwm5UHJt4B3/jnjza9u9gWp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475155; c=relaxed/simple;
	bh=V0mIK2COzCpDHEJIpA2GZql7TkbxZIEU2zk35+jRzTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvfYVN4BupK1ivJglCMhndg9EEeY6KXTYdwRVTJybqUKvitXiiLPOn4/mICNPfdGoe1mkRA9wVosXC8POxVemA3T8BpyxJe7tYHhWRL/FYHMIjwzp6Oxyac4/u9XSXnhMJPGTSWD5Gba/Zs90lacL+MNMkJAtB/BMY+E3K3MYrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDuCtFTn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDuCtFTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245D9C2BBFC;
	Tue, 30 Apr 2024 11:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475155;
	bh=V0mIK2COzCpDHEJIpA2GZql7TkbxZIEU2zk35+jRzTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDuCtFTnmd8X9TwFG0tzzKvXbyDo7ppR33sui43EkX6kxf703B/TRbujFtVXUshVQ
	 z/wFP+Mbk+6fqOIYSaVJiH69Qd0i90hzRRzXa+zvXX2On3qpEkeMWZ5lzSkM2hlPJc
	 CxZopt4NNW8Fi5c97McTV9C4klEBn45CefASt+l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiyi Lu <weiyi.lu@mediatek.com>,
	Ikjoon Jang <ikjn@chromium.org>,
	Enric Balletbo i Serra <enric.balletbo@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/186] arm64: dts: mediatek: mt8183: Add power-domains properity to mfgcfg
Date: Tue, 30 Apr 2024 12:37:43 +0200
Message-ID: <20240430103058.347996107@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ikjoon Jang <ikjn@chromium.org>

[ Upstream commit 1781f2c461804c0123f59afc7350e520a88edffb ]

mfgcfg clock is under MFG_ASYNC power domain.

Fixes: e526c9bc11f8 ("arm64: dts: Add Mediatek SoC MT8183 and evaluation board dts and Makefile")
Fixes: 37fb78b9aeb7 ("arm64: dts: mediatek: Add mt8183 power domains controller")
Signed-off-by: Weiyi Lu <weiyi.lu@mediatek.com>
Signed-off-by: Ikjoon Jang <ikjn@chromium.org>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20240223091122.2430037-1-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183.dtsi b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
index df6e9990cd5fa..8721a5ffca30a 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -1628,6 +1628,7 @@
 			compatible = "mediatek,mt8183-mfgcfg", "syscon";
 			reg = <0 0x13000000 0 0x1000>;
 			#clock-cells = <1>;
+			power-domains = <&spm MT8183_POWER_DOMAIN_MFG_ASYNC>;
 		};
 
 		gpu: gpu@13040000 {
-- 
2.43.0



