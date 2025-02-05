Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E736D190052;
	Wed,  5 Feb 2025 14:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767076; cv=none; b=Q/sJsnU6vx8UE2AUfmimapPHADPifMl1z7wZRam0ahLCKFiKSNnhJFPErRliryOyV3KPA/KKs8j+9mNyXTEjzdXCXXTEn7ofcXgubWaWnmYgzaJrBSUpY0C2pnGl5MTqcsr2n3OvRGQk+1oPW4nm7azcLxrPDi9tmiE2qlsGTMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767076; c=relaxed/simple;
	bh=1QQOHY1lPuGbRQ5ekTbj6qtJc9enw61hq6qPcUdcXRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgmMnaHsIdMH/0bd+Q/enyytGROC7USOwcYHq5rfg69tdck24nKl6RCbItc5C1hQ95E0QaKplYghgDPo0gGKANvh8f4Srin/YPjQdzUo8CJegPyXTx+hk69psU7J0WRjjEdIUp1IeC+RULddAwgQHEQdYRDReSmECwC1OtHHXl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXYI5k1g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXYI5k1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630B1C4CED6;
	Wed,  5 Feb 2025 14:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767075;
	bh=1QQOHY1lPuGbRQ5ekTbj6qtJc9enw61hq6qPcUdcXRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXYI5k1g0UX1Ba5XKDKGryzArOC+4BrsCoGpkxY5/ezH/6j7DOETvvfHQPb8YaZ4X
	 55tpqgdrdEoEf8BTgvtM79JldH6xHbRO4TquoXg0ZhyLbQEAYocIFrEtX6WcH9bY12
	 tV4MH42RAWjMwtZ7imrHOFyK7L2FcphnQN+8a96Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 353/623] arm64: dts: mediatek: mt8173-evb: Fix MT6397 PMIC sub-node names
Date: Wed,  5 Feb 2025 14:41:35 +0100
Message-ID: <20250205134509.729363713@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 9545ba142865b9099d43c972b9ebcf463606499a ]

The MT6397 PMIC bindings specify exact names for its sub-nodes. The
names used in the current dts don't match, causing a validation error.

Fix up the names. Also drop the label for the regulators node, since
any reference should be against the individual regulator sub-nodes.

Fixes: 16ea61fc5614 ("arm64: dts: mt8173-evb: Add PMIC support")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20241210092614.3951748-2-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8173-evb.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173-evb.dts b/arch/arm64/boot/dts/mediatek/mt8173-evb.dts
index 511c16cb1d59c..9fffed0ef4bff 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173-evb.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8173-evb.dts
@@ -307,7 +307,7 @@
 		interrupt-controller;
 		#interrupt-cells = <2>;
 
-		mt6397regulator: mt6397regulator {
+		regulators {
 			compatible = "mediatek,mt6397-regulator";
 
 			mt6397_vpca15_reg: buck_vpca15 {
-- 
2.39.5



