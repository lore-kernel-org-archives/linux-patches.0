Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1081C9B91;
	Wed,  2 Oct 2024 13:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876845; cv=none; b=qX0/fKnpYntSeIF+PbseRcUZzqzh2f4DXgRMqNYPK1v5EouOxsD4+QP1qsUAtO3sVlVWLDvGrmCKJffJMhl4ydeY1i9UW3ltFAjUy29i2m5oTdMcq/MzSI5xQVjfl8DsUnNPhZsM4m4R6WORyT4UQKjDr0oTvV2OPtfb1UdQuNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876845; c=relaxed/simple;
	bh=42G1Luy09lizKY1SjuKU3zyFeFFceSTo6Q/iQLG0O+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U5my/cdNNfbwnNU6VCTv/vhYxS+lwPJ5aLA+++XB1p/U+fwms+pG/eNm6u7yX5OnuEETNUNnmTt0FYB8MklpD0Qel/JRtGltQboApArC19VfWAn/1Iw6bdwZstorxwgkrAgRmTYOQIcIk7f7o47UAfpXx1j2XtwPq+8oK/dMS14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQ7PuFhA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQ7PuFhA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FE0C4CEC2;
	Wed,  2 Oct 2024 13:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876845;
	bh=42G1Luy09lizKY1SjuKU3zyFeFFceSTo6Q/iQLG0O+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQ7PuFhA5vEBsLn5umZjlG+QBkiMtES3GBOe5J7fkhQSiCHsR5I0ffdZclRRxCU1z
	 CySD4IYCJo1kuZUdSJB52+3MQo8WJxkGB149bZQdMEWQ850hRUCY5HG4b0riUItRkZ
	 ylk67ML5gSNHDjTYtcu59+X0ymglnj8y+wxdNA1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	=?UTF-8?q?N=C3=ADcolas=20F=2E=20R=2E=20A=2E=20Prado?= <nfraprado@collabora.com>
Subject: [PATCH 6.11 579/695] arm64: dts: mediatek: mt8195-cherry: Mark USB 3.0 on xhci1 as disabled
Date: Wed,  2 Oct 2024 14:59:37 +0200
Message-ID: <20241002125845.623636405@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1404,6 +1404,7 @@
 	rx-fifo-depth = <3072>;
 	vusb33-supply = <&mt6359_vusb_ldo_reg>;
 	vbus-supply = <&usb_vbus>;
+	mediatek,u3p-dis-msk = <1>;
 };
 
 &xhci2 {


