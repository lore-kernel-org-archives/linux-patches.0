Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A90A222D4B;
	Thu, 12 Dec 2024 16:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020139; cv=none; b=YAcOa+iR+2Z0CYibGd2qJ7C7vXUGanS/AejAJmIZw6tZ4SQ/NG/rtsaqHnqiIuMGqb/5WU4WN8J/SJVA8u0U/bMiVSvu5o7iRnf7KHi09x3kdP5dNX2UVWRvo68OyZpLD0lUaf1fXz9NRe2iUB8wyvOIbwdrt8Zp7aDbipj+dNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020139; c=relaxed/simple;
	bh=qCx1ZGGG7QFtQqDTdICvifTGFUu17ZEC78LlzQMM2MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FPejKzWs9wiaQGYvQXIYpGejpNBispjtMELvlhRvuVdspKOtRS1/qX8zxN6vuqG7q7KFnbiWjf0tLMzJ7plg1JrMaLBKKL1EAUSA26vOaZuEVd7PywX/YdL5OdczURlQFCSzYro8gslLdmqkkmXuQ4faT1a9joQrq1NUrOw44kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDkz0a49; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDkz0a49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49E8C4CED4;
	Thu, 12 Dec 2024 16:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020139;
	bh=qCx1ZGGG7QFtQqDTdICvifTGFUu17ZEC78LlzQMM2MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDkz0a49GF25rIUYT2Sv6y8fu6ppKg6eAsrF6zNssl9VtfQ/zPdU5wzad76d1Lrx3
	 9HAXevLdVO+kryEGt270J7v0KPTzljViNxNwrbdOFr27ZLIokzuqZwM8QltyVyuRtr
	 u7vynaoEaozGtIL7JeHogHk5pV+QtrBIGGR6qAUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	=?UTF-8?q?N=C3=ADcolas=20F=2E=20R=2E=20A=2E=20Prado?= <nfraprado@collabora.com>
Subject: [PATCH 6.1 357/772] arm64: dts: mediatek: mt8195-cherry: Mark USB 3.0 on xhci1 as disabled
Date: Thu, 12 Dec 2024 15:55:02 +0100
Message-ID: <20241212144404.663757090@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 09d385679487c58f0859c1ad4f404ba3df2f8830 ]

USB 3.0 on xhci1 is not used, as the controller shares the same PHY as
pcie1. The latter is enabled to support the M.2 PCIe WLAN card on this
design.

Mark USB 3.0 as disabled on this controller using the
"mediatek,u3p-dis-msk" property.

Reported-by: Nícolas F. R. A. Prado <nfraprado@collabora.com> #KernelCI
Closes: https://lore.kernel.org/all/9fce9838-ef87-4d1b-b3df-63e1ddb0ec51@notapiano/
Fixes: b6267a396e1c ("arm64: dts: mediatek: cherry: Enable T-PHYs and USB XHCI controllers")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240731034411.371178-2-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
@@ -906,6 +906,7 @@
 
 	vusb33-supply = <&mt6359_vusb_ldo_reg>;
 	vbus-supply = <&usb_vbus>;
+	mediatek,u3p-dis-msk = <1>;
 };
 
 &xhci2 {


