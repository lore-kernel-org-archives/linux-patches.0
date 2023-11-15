Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618B8364A8
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LR5I/GnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1285CC433C8;
	Wed, 15 Nov 2023 19:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076449;
	bh=jf4G5SclBGX5ToFvzM6IjabetLrIeyZWjA3IhRKjsSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LR5I/GnGDWbWS6WziX+bwMl2aQoUsLEZ4gUiVt6mjWyL5IMdQ7dCacVpndNERhSMG
	 MIKqh+RjOBDEEU66x8LrpnVoPhFw6tgisQeY5llQrmTBPWmPAhhcv+bFURqifNf0AA
	 fVL+jZXOrDEtAr7RDMGrU/zEhATB1TtL4DZXt6VU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brad Griffis <bgriffis@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 295/550] arm64: tegra: Fix P3767 QSPI speed
Date: Wed, 15 Nov 2023 14:14:39 -0500
Message-ID: <20231115191621.266036773@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brad Griffis <bgriffis@nvidia.com>

[ Upstream commit 57ea99ba176913c325fc8324a24a1b5e8a6cf520 ]

The QSPI device used on Jetson Orin NX and Nano modules (p3767) is
the same as Jetson AGX Orin (p3701) and should have a maximum speed of
102 MHz.

Fixes: 13b0aca303e9 ("arm64: tegra: Support Jetson Orin NX")
Signed-off-by: Brad Griffis <bgriffis@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra234-p3767.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234-p3767.dtsi b/arch/arm64/boot/dts/nvidia/tegra234-p3767.dtsi
index 2ea102b3a7f40..2e0fb61a1167f 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234-p3767.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234-p3767.dtsi
@@ -28,7 +28,7 @@ spi@3270000 {
 			flash@0 {
 				compatible = "jedec,spi-nor";
 				reg = <0>;
-				spi-max-frequency = <136000000>;
+				spi-max-frequency = <102000000>;
 				spi-tx-bus-width = <4>;
 				spi-rx-bus-width = <4>;
 			};
-- 
2.42.0



