Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF0E146A7A;
	Wed,  5 Feb 2025 14:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766966; cv=none; b=fycJLQy5Hp+T9tYJnZ2X19z0xrw/qCmW8PSs55/EurEX7emkZv2EMoFDmMTAawyB8G0UNp0CPAzLArHlShIs6v46gD1Yh2U5Uq0YZkjyOvHx+fnBe6ySbCfx3X4rZgbXWOiWwm8RDiGg2zWMsCmT5BpeskSlFZpsg7+6MUQCHsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766966; c=relaxed/simple;
	bh=ZBuZJSCJiZiGFqAuCyxIv3GN6mzeFijBDhmjRRZkcwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obUwfVS0GBmjz+1lQzQgk9L9fuhpG5DanYVNanLgJz1PBrdqeuDLV9oFt5hwT6INA9jNo+6SeYAvK/jfR9iBJEB2jPzrRG2MjqPG6kcsYlIeFo27oXUHhcEKyp+A2e+2DNge8wSYi/RYKuWxJ+kPFe7JSpx/YhIuNUSZ4nLGt7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+xqqzHu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+xqqzHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3256C4CED6;
	Wed,  5 Feb 2025 14:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766966;
	bh=ZBuZJSCJiZiGFqAuCyxIv3GN6mzeFijBDhmjRRZkcwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+xqqzHubAR5eqdmf+bt/oZn0i+2zd7k5gIFQe8xiomQ971fMYzhd3xQSyL5oLfHA
	 yqc/BeNFclCE1ux5S8GuWhvDK5+bm29Dn2FCLhgq6/SPIR1yvSOQXgHwMcZ4pvzPoU
	 Vs57BUqwV175JTDcufmTHskPvARv5I2OYn5197V8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 335/623] arm64: dts: mediatek: mt8516: fix GICv2 range
Date: Wed,  5 Feb 2025 14:41:17 +0100
Message-ID: <20250205134509.042680605@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



