Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B617525F79E;
	Tue, 11 Mar 2025 15:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706482; cv=none; b=GEex+F5nuhj/c8Jp+Oo0n5d/e3tmI/v77iI/ujsk7FzyquZphQ75sNOwHRP3HAs+9KSZ+fXTAkdJ6YlofVWBpC//3vlWQVhRBfVJquCiEvU+tN3NRIesp9vdJOzh+6T+rd56YbiB4KidMca5GIf4wAKtsPPRgot2yzOw9QoKcLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706482; c=relaxed/simple;
	bh=LqvBZuGxTB0Y3UL1hpdHeAIbjgXlf5bKoO0Iw/TRmfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rsryj+GRmsrCrI/HDaQA2ny0qhTCsiBa4/zHDZNZl/cHUTCz51TKZ4EnPVhhE9YRBy24e4y+AIqLhCe9DiXAaLlNY5SooXv9II2Mg7AoK2JOBkutK1KSFxwWcylw2N7Z8YXRetwGYgPVxYjISspiL6GCvcwPxvGh/mHMSK6dh7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmVhuFu6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmVhuFu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317ACC4CEE9;
	Tue, 11 Mar 2025 15:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706482;
	bh=LqvBZuGxTB0Y3UL1hpdHeAIbjgXlf5bKoO0Iw/TRmfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmVhuFu6dAYDYAtTU2IVpVHl6vzcbKJErSU3MnQDB1QeMkYWN+lJYEyuhDBnaXSCV
	 QvkJx7cJqioA3Pfd5dcHqmU7ztv6DVtmSoF3SvnVb5/h4uhVYU3/4AZn1+Pb62/FBg
	 samAnOSqc28SZBq3KP6S8J8BFyE26a3X+i8V51fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/462] arm64: dts: mediatek: mt8516: fix GICv2 range
Date: Tue, 11 Mar 2025 15:55:29 +0100
Message-ID: <20250311145800.841393976@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

[ Upstream commit e3ee31e4409f051c021a30122f3c470f093a7386 ]

On the MT8167 which is based on the MT8516 DTS, the following error
was appearing on boot, breaking interrupt operation:

GICv2 detected, but range too small and irqchip.gicv2_force_probe not set

Similar to what's been proposed for MT7622 which has the same issue,
fix by using the range reported by force_probe.

Link: https://lore.kernel.org/all/YmhNSLgp%2Fyg8Vr1F@makrotopia.org/
Fixes: 5236347bde42 ("arm64: dts: mediatek: add dtsi for MT8516")
Signed-off-by: Val Packett <val@packett.cool>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241204190524.21862-2-val@packett.cool
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8516.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8516.dtsi b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
index 89af661e7f631..6d2804065ca89 100644
--- a/arch/arm64/boot/dts/mediatek/mt8516.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
@@ -262,7 +262,7 @@
 			interrupt-parent = <&gic>;
 			interrupt-controller;
 			reg = <0 0x10310000 0 0x1000>,
-			      <0 0x10320000 0 0x1000>,
+			      <0 0x1032f000 0 0x2000>,
 			      <0 0x10340000 0 0x2000>,
 			      <0 0x10360000 0 0x2000>;
 			interrupts = <GIC_PPI 9
-- 
2.39.5



