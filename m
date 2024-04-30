Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7C912B176;
	Tue, 30 Apr 2024 11:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474937; cv=none; b=JBO8kTtaI3wpnHDdDp/qd3VdRZwBda8gBg1gIZcn1JsvMANmFuYe6/uGmRsoPN1tsY33BfblHTR9uQv4kVZlcG8uKEYEPojtuajtA+aG7GhIwwCJ7U5vIeQKRVe/fvDsD55T8XomJOp+V7ujd0EVvG9LTdG9AwT4XAEQqXF4d0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474937; c=relaxed/simple;
	bh=iD47SEU/2V2TrWZXX4MXalvpz9OGqsAKJbw2/FzWuu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r2ykIag0vDUxgb19qqpWpVLwvH672Ad4SxphRbRovI5kFvkw1jv8Un9xbNcKpTUsw5B0KeIlDkdXKkbVVgGnmg4p2JENUhzmcz7uxpvI4KvhXBg1tKq8MwNim36i3O7Y/66eV8oKLc6fY7LBTEbGJeASc92SeYcl1QTI218HuVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aAPIDLXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aAPIDLXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70171C2BBFC;
	Tue, 30 Apr 2024 11:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474936;
	bh=iD47SEU/2V2TrWZXX4MXalvpz9OGqsAKJbw2/FzWuu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aAPIDLXp7lRR1kRP2T0ABrgqVsI+JT9kmvTt3rh4M/upA2Embrakezdgni9gE59lZ
	 8spFv6boH2mknK1e1H+nYyiAbIIaHSD9tlMR03pokK0GWo2w0vDKgCwdHdcuW/B2zN
	 PJm9x7V99Mr7XLE+LliGWTLcRNOwNGsc8E6yu4lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/138] arm64: dts: mediatek: mt7622: fix IR nodename
Date: Tue, 30 Apr 2024 12:39:24 +0200
Message-ID: <20240430103051.749548547@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 800dc93c3941e372c94278bf4059e6e82f60bd66 ]

Fix following validation error:
arch/arm64/boot/dts/mediatek/mt7622-rfb1.dtb: cir@10009000: $nodename:0: 'cir@10009000' does not match '^ir(-receiver)?(@[a-f0-9]+)?$'
        from schema $id: http://devicetree.org/schemas/media/mediatek,mt7622-cir.yaml#

Fixes: ae457b7679c4 ("arm64: dts: mt7622: add SoC and peripheral related device nodes")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240317221050.18595-3-zajec5@gmail.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7622.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index b590c2d3bc86f..bf0856d37eda8 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -244,7 +244,7 @@
 		clock-names = "hif_sel";
 	};
 
-	cir: cir@10009000 {
+	cir: ir-receiver@10009000 {
 		compatible = "mediatek,mt7622-cir";
 		reg = <0 0x10009000 0 0x1000>;
 		interrupts = <GIC_SPI 175 IRQ_TYPE_LEVEL_LOW>;
-- 
2.43.0



