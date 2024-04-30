Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D811E50A;
	Tue, 30 Apr 2024 11:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475206; cv=none; b=d7tmqNvzxqGSLipem+EYnGJIBL/YgFdNM8i9MJK5As1K1ahT8Hy2JHiCr6+GuXMK5mdqcN8tXUHOgN6sN0Z2h/oli/FKmfRQepg5PfgW6WoozWksdGMRCbc7Sjbm8IJARnqA1s8Igwwmc/wquy5AYnTOZhuliUA7yr5dks0/qks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475206; c=relaxed/simple;
	bh=i1v9ST8zHdL4eBJUkOHSxiAud0m3Sm17+Sux0oOcXqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RdiX3pRPHzXi6BEem3ip8mbEMhWmf9zS829ZY6qihwPRcogV4LZjfh/2JEZqfIzP55lMOdOJnqNA2J24mB4lq4dYYbGQiPX0KFAZpZr5Oikp7L5ShvE12P6HEEfcNf7L3PTZJJZtaUSVTo9EmuWpZXiOj5y3T7q32gryKB1OQD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJ30uAQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJ30uAQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF59C2BBFC;
	Tue, 30 Apr 2024 11:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475206;
	bh=i1v9ST8zHdL4eBJUkOHSxiAud0m3Sm17+Sux0oOcXqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJ30uAQN30yHa8Qo6I1kXX9uPDIiQDWffrY3tYSmiZQVz2ThLnX1xtK217XM7QqcW
	 IipRbvfdYwvvvQv2Hve46IIqo94oKgOO/aB6aStxgHRL/nFCW6JEicmgJfOCbmaroE
	 f2cplDL1lCh7Roqqd/nAEXqYyJ+yFHugWoTLNZJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Shih <sam.shih@mediatek.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/186] arm64: dts: mediatek: mt7986: drop invalid properties from ethsys
Date: Tue, 30 Apr 2024 12:37:58 +0200
Message-ID: <20240430103058.787704535@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 3b449bfd2ff6c5d3ceecfcb18528ff8e1b4ac2fd ]

Mediatek ethsys controller / syscon binding doesn't allow any subnodes
so "#address-cells" and "#size-cells" are redundant (actually:
disallowed).

This fixes:
arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dtb: syscon@15000000: '#address-cells', '#size-cells' do not match any of the regexes: 'pinctrl-[0-9]+'
        from schema $id: http://devicetree.org/schemas/clock/mediatek,ethsys.yaml#

Fixes: 1f9986b258c2 ("arm64: dts: mediatek: add clock support for mt7986a")
Cc: Sam Shih <sam.shih@mediatek.com>
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240213053739.14387-1-zajec5@gmail.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index eba5e27a1bbea..850b664dfa13d 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -501,8 +501,6 @@
 			 compatible = "mediatek,mt7986-ethsys",
 				      "syscon";
 			 reg = <0 0x15000000 0 0x1000>;
-			 #address-cells = <1>;
-			 #size-cells = <1>;
 			 #clock-cells = <1>;
 			 #reset-cells = <1>;
 		};
-- 
2.43.0



