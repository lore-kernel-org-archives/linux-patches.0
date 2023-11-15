Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DECF3BB42
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUe+f/yW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF2AC433C7;
	Wed, 15 Nov 2023 19:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077476;
	bh=i9GewvoW1bDcvY8g09BAx0k8oYRenRCNefKAL2DA/pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUe+f/yWYP+1CTZKuabmTOwfYJZTQMOncai7y701Calfj36HFcppuSM7ds6bfFKQH
	 CHfipuwyP2o++FW3AZCAYsUQeSIUs1Ft0f+QiMoEScU5tb69wgo8+2ZIexAPscjR+y
	 oT7Lq9HO98LApqSrWNruwm2wNfYXdm2p48+uhWX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brad Griffis <bgriffis@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 319/603] arm64: tegra: Fix P3767 QSPI speed
Date: Wed, 15 Nov 2023 14:14:24 -0500
Message-ID: <20231115191635.572736910@linuxfoundation.org>
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
index 99dd648038ecb..fe08e131b7b9e 100644
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



