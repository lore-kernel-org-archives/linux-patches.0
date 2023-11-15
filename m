Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F106D364CB
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8eMmEnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7AAC433C7;
	Wed, 15 Nov 2023 19:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077510;
	bh=SQzcb9GVcFryOZEsCP6XpG8aqXyzXhMqzsmzk0MdnH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j8eMmEncx7fLL1JFaEKdO3uq4MIXpsf0wz7KosvWM/3UZMJj0QWxeW3KpFTJHlhIA
	 vyPXs6Y/1ezw//zm6jGBPx+jFUZlS2vY6wPlW9IC7uZhkREfIFYpz1hf5R8pCPBYoL
	 oVf8J4HVZ4RFL+d++6owFUF4hY9yA5Ws5NlZ/TiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubhi Garg <shgarg@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 322/603] arm64: tegra: Use correct interrupts for Tegra234 TKE
Date: Wed, 15 Nov 2023 14:14:27 -0500
Message-ID: <20231115191635.783799118@linuxfoundation.org>
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

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit c0b80988eb78d6423249ab530bfbc6b238790a26 ]

The shared interrupts 0-9 of the TKE are mapped to interrupts 0-9, but
shared interrupts 10-15 are mapped to 256-261. Correct the mapping for
the final 6 interrupts. This prevents the TKE from requesting the RTC
interrupt (along with several GTE and watchdog interrupts).

Reported-by: Shubhi Garg <shgarg@nvidia.com>
Fixes: 28d860ed02c2 ("arm64: tegra: Enable native timers on Tegra234")
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 95524e5bce826..ac69eacf8a6ba 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -43,12 +43,12 @@ timer@2080000 {
 				     <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 256 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 257 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 258 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 259 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 260 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 261 IRQ_TYPE_LEVEL_HIGH>;
 			status = "okay";
 		};
 
-- 
2.42.0



