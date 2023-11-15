Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7043A8F4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJ/r8CLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F117C433CA;
	Wed, 15 Nov 2023 19:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077521;
	bh=VAoR1kfyuaEhhh3cW++PQn9OIWTWARta4gGhMANyawY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJ/r8CLW5cSKXnup/IW+NLsRm3SPFodzZfY5xx7o4kusa+9ge7Pa1JOCkicDJGBNA
	 VVJQzaUdyj2THvQlzYjK8e0tD89OFah84jzOJKjgpAPdKMTSMvB0vso1xYupvj9hvC
	 tGlE9gN75GLFK87f545KeyDDgq4z6srmDAuaQcxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brad Griffis <bgriffis@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 318/603] arm64: tegra: Fix P3767 card detect polarity
Date: Wed, 15 Nov 2023 14:14:23 -0500
Message-ID: <20231115191635.495566207@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brad Griffis <bgriffis@nvidia.com>

[ Upstream commit c6b7a1d11d0fa6333078141251908f48042016e1 ]

The SD card detect pin is active-low on all Orin Nano and NX SKUs that
have an SD card slot.

Fixes: 13b0aca303e9 ("arm64: tegra: Support Jetson Orin NX")
Signed-off-by: Brad Griffis <bgriffis@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra234-p3767.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234-p3767.dtsi b/arch/arm64/boot/dts/nvidia/tegra234-p3767.dtsi
index 5f592f1d81e2e..99dd648038ecb 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234-p3767.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234-p3767.dtsi
@@ -42,7 +42,7 @@ flash@0 {
 		mmc@3400000 {
 			status = "okay";
 			bus-width = <4>;
-			cd-gpios = <&gpio TEGRA234_MAIN_GPIO(G, 7) GPIO_ACTIVE_HIGH>;
+			cd-gpios = <&gpio TEGRA234_MAIN_GPIO(G, 7) GPIO_ACTIVE_LOW>;
 			disable-wp;
 		};
 
-- 
2.42.0



