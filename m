Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E213518C92B;
	Tue, 30 Jul 2024 16:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356075; cv=none; b=di1ridl+rcoErl0eoJ5uNFXZxKiX759FUH8rs6eFRAkC2f/OB2c+N5J6QvEgYymoWGn/h+yW8yv+7G+K6+Rz9xYNpoEOnonR/wFq9C/hc6DmYtAuLXfF7vM3SjfMYmYmHIBjs9YBgqv5QiEaxx76iDs7x2rYUhz3ceKFJ6r/4jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356075; c=relaxed/simple;
	bh=t98ykbOf77S5kGZIONNhPUiAfsPFFOWpFgifzzuxBpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfg94dbfZvbiMuWEEVnlodLzF4yJDMo29P8DaZl6mMwkUgC9Igfyh75r9/4vtW9kzvNvVM31Xyi+mVZZvtxOPU2NKA8ZRx7PedrZbiH/GsfH0btYRw8MOhzkDMnElzo+++Y5EV31svXPsXAYWVpPVdOvhSuh8PNVDmX9nQNrOWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IqWYapl6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IqWYapl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B74C4AF0C;
	Tue, 30 Jul 2024 16:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356074;
	bh=t98ykbOf77S5kGZIONNhPUiAfsPFFOWpFgifzzuxBpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IqWYapl6UNtg/4M5Ns1HUfe084+g8YJx8xl/AOtVhDvWT1i3jC92FgObkDBeURtu6
	 Ym5EQlreowQRxt57rQNG5OZcvrDAahIFPqo3dviVG3XPLZvqWDlgnbJAEWLhIxHnHZ
	 C72RqudgpHEdlsCaImGVB65ldxc6fkMaW0S41Aic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 114/809] arm64: dts: rockchip: Fix mic-in-differential usage on rk3566-roc-pc
Date: Tue, 30 Jul 2024 17:39:50 +0200
Message-ID: <20240730151729.125222160@linuxfoundation.org>
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit e643e4eb4bef6a2f95bf0c61a20c991bccecb212 ]

The 'mic-in-differential' DT property supported by the RK809/RK817 audio
codec driver is actually valid if prefixed with 'rockchip,':

  DTC_CHK arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dtb
  rk3566-roc-pc.dtb: pmic@20: codec: 'mic-in-differential' does not match any of the regexes: 'pinctrl-[0-9]+'
	from schema $id: http://devicetree.org/schemas/mfd/rockchip,rk809.yaml#

Make use of the correct property name.

Fixes: a8e35c4bebe4 ("arm64: dts: rockchip: add audio nodes to rk3566-roc-pc")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20240622-rk809-fixes-v2-4-c0db420d3639@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
index 63eea27293fe9..67e7801bd4896 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
@@ -269,7 +269,7 @@ rk809: pmic@20 {
 		vcc9-supply = <&vcc3v3_sys>;
 
 		codec {
-			mic-in-differential;
+			rockchip,mic-in-differential;
 		};
 
 		regulators {
-- 
2.43.0



