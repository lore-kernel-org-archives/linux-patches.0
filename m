Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978FE2ED84A;
	Tue, 17 Jun 2025 16:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177845; cv=none; b=PP85xv3YGnPYOSrx5H6dl1ah+OwhN+gjORnWCPmE9i28ELIDUB4XDSziyocg325CK1DXoQwjnIzYMFmvB9hDiePADaZ7BtHumhcTf+ZhsqHdXY0AVDzlyf6xF+FESHvj34w+Eq9f1BSdgxCUmgagSzs8gGX36Gp1GRNoFQ42YkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177845; c=relaxed/simple;
	bh=ZGoym5ssVRf2irud4bWiVbRy8+MB6aQBd1UYXES2Yf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nfg00gPBEH7q9CP0pxeiEm+83V8C5xJPR/zUpgKzJvPJN4rfEJaNDRDcNqPOuX8V1eSVmFiNhBWBGK1lQjTQfMg2dB1sgof/x6pEZhescV88btgwsam0AFqSgo07hNkflyPPvlGovbYxQWznyEj+CP2qBLq+E2FVLwg/vXfTFuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v1n+r6Ub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v1n+r6Ub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04078C4CEE3;
	Tue, 17 Jun 2025 16:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177845;
	bh=ZGoym5ssVRf2irud4bWiVbRy8+MB6aQBd1UYXES2Yf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v1n+r6UbUFm7tyNoyZyhRQW3PcWciZm+mbBYEvTvT2jz98ZhT4zld4W45o2nkUOR9
	 9Fg8z6Ut49Np/FD9VwA5DH9MDsLZTMZC79VRyj32fZxeVt8JdTdJwFZzRW9Xo8vH8p
	 4jDahsvvSxksRZl84NvdJwwh0gGwErq2Q2vgwy9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 371/780] arm64: dts: mt8183: Add port node to mt8183.dtsi
Date: Tue, 17 Jun 2025 17:21:19 +0200
Message-ID: <20250617152506.558626755@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit d15059f7be59f887c1a370037cc2337c2ff2ad56 ]

Add the port node to fix the binding schema check. Also update
mt8183-kukui to reference the new port node.

Fixes: 88ec840270e6 ("arm64: dts: mt8183: Add dsi node")
Fixes: 27eaf34df364 ("arm64: dts: mt8183: config dsi node")
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Link: https://lore.kernel.org/r/20250423040354.2847447-1-treapking@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi | 10 +++-------
 arch/arm64/boot/dts/mediatek/mt8183.dtsi       |  4 ++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
index e1495f1900a7b..f9ca6b3720e91 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
@@ -259,14 +259,10 @@
 			};
 		};
 	};
+};
 
-	ports {
-		port {
-			dsi_out: endpoint {
-				remote-endpoint = <&panel_in>;
-			};
-		};
-	};
+&dsi_out {
+	remote-endpoint = <&panel_in>;
 };
 
 &gic {
diff --git a/arch/arm64/boot/dts/mediatek/mt8183.dtsi b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
index 0aa34e5bbaaa8..3c1fe80e64b9c 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -1836,6 +1836,10 @@
 			phys = <&mipi_tx0>;
 			phy-names = "dphy";
 			status = "disabled";
+
+			port {
+				dsi_out: endpoint { };
+			};
 		};
 
 		dpi0: dpi@14015000 {
-- 
2.39.5



