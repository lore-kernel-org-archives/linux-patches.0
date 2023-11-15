Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6E3364C8
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUOfnS7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2D7C433C8;
	Wed, 15 Nov 2023 19:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077447;
	bh=Sk/Em0X5f2Cdemd/y51A9iz/OnUqSOTxaKz4f1VGA8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUOfnS7YPq387dIdbNixIfnAb+k5yOarfDr76mxe3O9Qu8wTS18V0gdW2ivVl3pRe
	 Bbt+ab2E2h9Q7n60jblVqnEYhCUcmRWU2/I42ef9fXfH750iDMcqQSRKPBwTxLwq24
	 KELdIXa0u6Xg8V0PdW1bMgLGfABD/yxVB61v7wVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 309/603] arm64: dts: ti: Fix HDMI Audio overlay in Makefile
Date: Wed, 15 Nov 2023 14:14:14 -0500
Message-ID: <20231115191634.806312173@linuxfoundation.org>
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

From: Aradhya Bhatia <a-bhatia1@ti.com>

[ Upstream commit 69c570ebc3964534c19dc4438d3b96f55d489fc3 ]

Apply HDMI audio overlay to AM625 and AM62-LP SK-EVMs DT binaries,
instead of leaving it in a floating state.

Fixes: b50ccab9e07c ("arm64: dts: ti: am62x-sk: Add overlay for HDMI audio")
Reported-by: Rob Herring <robh@kernel.org>
Signed-off-by: Aradhya Bhatia <a-bhatia1@ti.com>
Link: https://lore.kernel.org/r/20231003092259.28103-1-a-bhatia1@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/Makefile b/arch/arm64/boot/dts/ti/Makefile
index 51dab9499cd0b..8bd5acc6d6835 100644
--- a/arch/arm64/boot/dts/ti/Makefile
+++ b/arch/arm64/boot/dts/ti/Makefile
@@ -9,6 +9,8 @@
 # alphabetically.
 
 # Boards with AM62x SoC
+k3-am625-sk-hdmi-audio-dtbs := k3-am625-sk.dtb k3-am62x-sk-hdmi-audio.dtbo
+k3-am62-lp-sk-hdmi-audio-dtbs := k3-am62-lp-sk.dtb k3-am62x-sk-hdmi-audio.dtbo
 dtb-$(CONFIG_ARCH_K3) += k3-am625-beagleplay.dtb
 dtb-$(CONFIG_ARCH_K3) += k3-am625-phyboard-lyra-rdk.dtb
 dtb-$(CONFIG_ARCH_K3) += k3-am625-sk.dtb
@@ -19,7 +21,8 @@ dtb-$(CONFIG_ARCH_K3) += k3-am625-verdin-wifi-dahlia.dtb
 dtb-$(CONFIG_ARCH_K3) += k3-am625-verdin-wifi-dev.dtb
 dtb-$(CONFIG_ARCH_K3) += k3-am625-verdin-wifi-yavia.dtb
 dtb-$(CONFIG_ARCH_K3) += k3-am62-lp-sk.dtb
-dtb-$(CONFIG_ARCH_K3) += k3-am62x-sk-hdmi-audio.dtbo
+dtb-$(CONFIG_ARCH_K3) += k3-am625-sk-hdmi-audio.dtb
+dtb-$(CONFIG_ARCH_K3) += k3-am62-lp-sk-hdmi-audio.dtb
 
 # Boards with AM62Ax SoC
 dtb-$(CONFIG_ARCH_K3) += k3-am62a7-sk.dtb
-- 
2.42.0



