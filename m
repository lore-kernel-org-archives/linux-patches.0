Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91878156F39;
	Wed,  5 Feb 2025 14:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766275; cv=none; b=G9jieaceIdY5RznK43xJC/ibEPUn2+gHE1vHzOz7A1dv7y8RJJ+cs8IdYtPY7eV1KAVPQCRR92AF8PR/2Hwzw0oVuaebk7jXOXnNFGU8I7y3wl2Qoa/XwcNi/+ffDl8iu+nCoNr6tc7QaliB2mVdlMiE0TWNsrO0vyOpSlKZxEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766275; c=relaxed/simple;
	bh=ByqjAqvZ0PR8kF5DtjYArFdikaeP+2t7REjH3a2lFlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKQYAHHlYU+ncAFDcdrBghZBM9U7FG0du3I1PVB51/yPmMGB4+3jggagJnmFDWYkkH4BCa1gV/2tehNSZhClnq0GgIoUeVhMYx74kl/fLh0fSFWKU0r1OsMjCJvQvUb2lUWlKts0apvKPlpHx+f6/NtktYbk4nw44FzULqmisrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gD76B3Up; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gD76B3Up"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DADC4CED1;
	Wed,  5 Feb 2025 14:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766275;
	bh=ByqjAqvZ0PR8kF5DtjYArFdikaeP+2t7REjH3a2lFlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gD76B3UprvCzdKD5foeU4peqzhRKnvJXZ05pvtqwsKHCDH+1l9ZS2JMw5LtUcthy5
	 sptt8b7RwD5P2L8MKOaauOtWrfwW3OZIIRkEQ03PuKH6HkJHvjyL3p+gHrakTjAbZ4
	 7yq+nqf/IYrIUrTr4QxhwbrfNUurIUWMMT5IgmZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 306/590] arm64: dts: mediatek: mt8516: fix GICv2 range
Date: Wed,  5 Feb 2025 14:41:01 +0100
Message-ID: <20250205134506.983828764@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d0b03dc4d3f43..4444293413023 100644
--- a/arch/arm64/boot/dts/mediatek/mt8516.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
@@ -268,7 +268,7 @@
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



