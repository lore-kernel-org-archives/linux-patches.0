Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1211A9B48;
	Tue, 17 Jun 2025 16:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176492; cv=none; b=s72k2OZFFK/ibW3fb6U/YOboWD2bdgyyrgORuIrLdF7tdrrhbxNcSR/RZ7oeyEy0Ic6N2qUYT2Q6QCW6m/SZM5Z+zS5flgwzDTFdIeKcWSzqiuaIOyA1D5asQenIeFTPB5ZlYiaoO16rV04tIQcqWGiACxaV5tdV+WV3wnLbhRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176492; c=relaxed/simple;
	bh=ZHKltGJONtJpRkmngJAjAeemB1UrAtGl5PH70cLFalI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zxufq80CnFHsCOHstC0ixfUSJ+zqSfNMd8zjk8OJvrb9MOW5cMGZwN9DCC/bXPljcJ8cU8683OlG62HsjlD9bcRsxYz8d8e/OHlf9OG4DZ4jd1DvpZqLlyEWj+SjqvrqjJ2VV4JG2ocy+k6Hv1AxMbka9/OwYMZHVq7t1kAikgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIv4vFxz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIv4vFxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF203C4CEE3;
	Tue, 17 Jun 2025 16:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176492;
	bh=ZHKltGJONtJpRkmngJAjAeemB1UrAtGl5PH70cLFalI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIv4vFxz9GXMxbDWxrjxwPUeIXiKREqB+tHrUHppZgGQM+Vh2GcDruP2lwl98uibc
	 NX3EQf1n3GiP3OzCEszqZu4emT8tiRLU2JpFcM/dUJ9A9OPFmoefM73sm14BBS+syQ
	 kgDKlAXexnTAEXNBhwbyW2QIbKz2/zPDQKnzZnCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 235/512] arm64: dts: mt8183: Add port node to mt8183.dtsi
Date: Tue, 17 Jun 2025 17:23:21 +0200
Message-ID: <20250617152429.147532045@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
index 22924f61ec9ed..c4fafd51b1225 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
@@ -280,14 +280,10 @@
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
index 92c41463d10e3..65be2c2c26d40 100644
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



