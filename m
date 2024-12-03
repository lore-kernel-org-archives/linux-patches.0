Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11ECC1FA174;
	Tue,  3 Dec 2024 15:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240448; cv=none; b=IfA2KLBAqpNoa7fFErI7/fJklBkbwH3Qnfg2pJHWjjybp1OBVpvg18AOPxAxNQdYEPEHHXXSq7Xi2spOmUE1XwuRUdK2TNv+2XNN7TFJZpQE79cqMHJBgmIo4bVkyb8ErBcy0u2xwtQLLCYffNWg10k7nazIhfCKmU7UpR1wNgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240448; c=relaxed/simple;
	bh=V9LNO3aP6tG2GC1d66w09nkLRnuF5t6i0on+wddUyuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UW5Cvy5x8GuMCn4NvTv05gCCKwvJxwo5KpFomOrXNICJvlXymSsGEShf8ylltRbVkYNKxDwdqP3hr7Yq5JZpNBFf+oq6yMXsvYrTIeaEbYgnhPGTN9jqOHM1D7WAeeuyfwy51ku4OUueVKQQDU5e5YizamEU9b1FFuj+QSA81y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9BlpD/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9BlpD/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695EDC4CEDE;
	Tue,  3 Dec 2024 15:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240447;
	bh=V9LNO3aP6tG2GC1d66w09nkLRnuF5t6i0on+wddUyuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9BlpD/8AmpC8khFSKyGb8yZr0g7NpVt5cLbgq5vfAOO0QjrMp+w/MEcy2/DBdGG8
	 7Zwqo2J0aq8grzn7+cXpFInD68CSE4ThPO3jHogoR9Ie3GLQ8ghxc4YL4vN0+iVlbw
	 y+BhqqgxXCyD3F8tQqN+4VH+RezGqSGGz7TyTLlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/826] arm64: dts: mediatek: mt8395-genio-1200-evk: Fix dtbs_check error for phy
Date: Tue,  3 Dec 2024 15:37:13 +0100
Message-ID: <20241203144747.878894127@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Macpaul Lin <macpaul.lin@mediatek.com>

[ Upstream commit 752804acea010959bb3a00c65acdf78086a8474c ]

The ethernet-phy node in mt8395-genio-1200-evk.dts was triggering a
dtbs_check error. The error message was:
  eth-phy0@1: $nodename:0: 'eth-phy0@1' does not match
              '^ethernet-phy(@[a-f0-9]+)?$'
Fix this issue by replacing 'eth-phy' node to generic 'ethernet-phy'.

Fixes: f2b543a191b6 ("arm64: dts: mediatek: add device-tree for Genio 1200 EVK board")
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241002051620.2050-3-macpaul.lin@mediatek.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk.dts b/arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk.dts
index 1ef6262b65c9a..b4b48eb93f3c5 100644
--- a/arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk.dts
@@ -187,7 +187,7 @@ mdio {
 		compatible = "snps,dwmac-mdio";
 		#address-cells = <1>;
 		#size-cells = <0>;
-		eth_phy0: eth-phy0@1 {
+		eth_phy0: ethernet-phy@1 {
 			compatible = "ethernet-phy-id001c.c916";
 			reg = <0x1>;
 		};
-- 
2.43.0



