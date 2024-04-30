Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF4C211C;
	Tue, 30 Apr 2024 11:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475771; cv=none; b=RU1aZ8eCqsN4UgqFQe9e7YJsb4G6Q2l7F2RSq4zMjs89aiAQRY0lMgpIoZaVr61yWjdbk3zMu7duZ1WBy5MjOl3TwUfFRM4D+P8Rpm592copNcvnB9BQU1K3icL3+onF+UfZe3NNb+Id3q2XZWt5vrYRKvY+H69jiCxOw6foU7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475771; c=relaxed/simple;
	bh=gzfBHz60bbBDBr1Ch+ZM3uSJQWXPNaxIp9urXb8INEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X3PJGhaydrEaC2/hf3kwDR4FKAHp9toQMyx3X+aiJf5rXXL2F3ZSSmpzmUoqszk0ibTogrGPS571uA10ANL+d3AAsMCEkljtzKkeyItU79A45LwGhSCbr9Qc93wLCCOKeIocxthbx2Ja1beb7MKmVVE8XaZIVDxMCasyJj5fjbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWzB4cMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWzB4cMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA65DC2BBFC;
	Tue, 30 Apr 2024 11:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475771;
	bh=gzfBHz60bbBDBr1Ch+ZM3uSJQWXPNaxIp9urXb8INEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWzB4cMzqZwBmvMJaO2uCO2E+nSqpBWa/DOEsnXr6Sfub7vDQjuzjj5VkpR/DbP8s
	 XAFpg9f2pdtVOzbIXSzgc86DTHzQvfLMuWg1smycXwD4yhUD2HLemP/EJ5hhdiGkdF
	 /JWQuF6V55bcoDQNfwg9VZ9epQPtsuGxkqkGFfJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 13/80] arm64: dts: mediatek: mt7622: fix IR nodename
Date: Tue, 30 Apr 2024 12:39:45 +0200
Message-ID: <20240430103043.804055449@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a5395d1d098c0..f3bc89ac0bef4 100644
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



