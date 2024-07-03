Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995601836EE;
	Wed,  3 Jul 2024 11:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006264; cv=none; b=mJ+AXGEaa6pFllSBbIwucGqMB6EjbFUEIhKa3Iekffc8yWeav93q+vL3XGwBZXbKfnUXrvvQfMe1/zi3g4Suf5jJYD40LjuKDOs4u1i6rcdWk8G1+UdcgbxDhzVCSpDM8COnmoJQDOboSx8rGoe6WvvxN+6bNX1t7vf1T9EncRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006264; c=relaxed/simple;
	bh=XQF79araROjPDjz+6Fk+f2rjIpoaXzbpPggbuAoHJng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4YOYcfOwZCqF2mb386EunYB8cTkxz7JgDvGQ+bxCcatrItpB7FFS+nHXASdV7r2ISxkkQYTjcDujEVg2jCqQTEAzoEaXU5w8iNJpGNAopoYtIsx/7Cwyez5v5JEPhGROaPpgO8bvqn8ycEixp22YKR9E3WCk7ZzeL4j/GF9NFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X5by1FSH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X5by1FSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2BCC2BD10;
	Wed,  3 Jul 2024 11:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006264;
	bh=XQF79araROjPDjz+6Fk+f2rjIpoaXzbpPggbuAoHJng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X5by1FSHGb3DzwKIsWKdTWVO0c+aPcmP3N9BQek9KbWl9eeLRXEAsy1Lv1UU5zBAC
	 kdXMQ26VSTR47jjomqIdiiY0nBVOSO26cqXBb7JFJsV79uKOXl0FMwOs19nZUuZ/sK
	 JCU6rXmu5VxlNQFS9riPhIJRTq4QpRvb5BtVlL2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bee <knaerzche@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 356/356] arm64: dts: rockchip: Add sound-dai-cells for RK3368
Date: Wed,  3 Jul 2024 12:41:32 +0200
Message-ID: <20240703102926.576064417@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Bee <knaerzche@gmail.com>

[ Upstream commit 8d7ec44aa5d1eb94a30319074762a1740440cdc8 ]

Add the missing #sound-dai-cells for RK3368's I2S and S/PDIF controllers.

Fixes: f7d89dfe1e31 ("arm64: dts: rockchip: add i2s nodes support for RK3368 SoCs")
Fixes: 0328d68ea76d ("arm64: dts: rockchip: add rk3368 spdif node")
Signed-off-by: Alex Bee <knaerzche@gmail.com>
Link: https://lore.kernel.org/r/20240623090116.670607-4-knaerzche@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3368.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3368.dtsi b/arch/arm64/boot/dts/rockchip/rk3368.dtsi
index 4c64fbefb4834..ad58930d5ccec 100644
--- a/arch/arm64/boot/dts/rockchip/rk3368.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3368.dtsi
@@ -678,6 +678,7 @@
 		dma-names = "tx";
 		pinctrl-names = "default";
 		pinctrl-0 = <&spdif_tx>;
+		#sound-dai-cells = <0>;
 		status = "disabled";
 	};
 
@@ -689,6 +690,7 @@
 		clocks = <&cru SCLK_I2S_2CH>, <&cru HCLK_I2S_2CH>;
 		dmas = <&dmac_bus 6>, <&dmac_bus 7>;
 		dma-names = "tx", "rx";
+		#sound-dai-cells = <0>;
 		status = "disabled";
 	};
 
@@ -702,6 +704,7 @@
 		dma-names = "tx", "rx";
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2s_8ch_bus>;
+		#sound-dai-cells = <0>;
 		status = "disabled";
 	};
 
-- 
2.43.0



