Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17731E0DCA;
	Wed, 19 Feb 2025 09:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956306; cv=none; b=tuqBEygRR4tz4FwrCmfY4V9wdzCaDP2MEm801r+JiLv4IHDWSa2+aBIeYU/RtcIraLR0m7hJyORL5lptoRnrcTexUKUBSnXbJXNFFt1fAKu7dZ3iNo3PIsv60+h9QmI0+Fw86r9H2M3lW5/c8t/PD+rUkxf9tNiVitFEMiAn7dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956306; c=relaxed/simple;
	bh=vItoEDLTYwFP8uo4OQ47MbhXo9B6iZ2mQzDsX8T+mnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEGbhkJKrTZ3+cR+IPKjrGyket2JJnvrWmHpQdkzmobOXTGwrPxLY7Z4ki6oLX8VGzlsO6gvUpoVoUiAt48CDrFE8shvATPRsHxYsBmi7Hq05XoOjWu1BZbKg/K74o6w51aW9Xr04R+1JgBHK6hXE7Eli83N8QHbgwZHUY23Zks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0md0mxa+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0md0mxa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26ED6C4CED1;
	Wed, 19 Feb 2025 09:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956306;
	bh=vItoEDLTYwFP8uo4OQ47MbhXo9B6iZ2mQzDsX8T+mnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0md0mxa+TlBYXF4GJpPqrOUHklMaj7+OGXAOEqUKnyZUoChqWYc6ZaqhaZ5IZx5uT
	 XHMKZVpHPGjX0r+pCLxRC+AqZeHk4ZhmMa69LdCVy0alkVYnG0s6BRpHmopG58G2Wj
	 NpDxlAkEaE8LvruALMYm9ubfxNeOGygfP8DtHHK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/578] arm64: dts: mediatek: mt8516: fix GICv2 range
Date: Wed, 19 Feb 2025 09:22:19 +0100
Message-ID: <20250219082658.298922959@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d1b67c82d7617..81ac7f2f710b4 100644
--- a/arch/arm64/boot/dts/mediatek/mt8516.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
@@ -269,7 +269,7 @@
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



