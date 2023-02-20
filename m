Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB3363B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5260BC433D2;
	Mon, 20 Feb 2023 13:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900832;
	bh=q7MiPIYr6Udv/qiMWM1eAoMRJS+aEqwMSN5KnWOWvbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQF1aa/+NjB+uTZwTxIg21r9PcYsr7yLBDL2JX1w6p3AMWo0hUW30crZsk+aE/Qqh
	 1vwVH4l9mvYfTcQPXs/VkgYC6wStDrkvfOiSyqJq1VpnRrpE/SFL15Z7OhqYmxSBhn
	 aH8xIHnuMLxJ6VVSQraB2rpHOZjcmRUtEZnSxQXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 5.4 085/156] arm64: dts: meson-gx: Make mmc host controller interrupts level-sensitive
Date: Mon, 20 Feb 2023 14:35:29 +0100
Message-Id: <20230220133605.974274199@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heiner Kallweit <hkallweit1@gmail.com>

commit 66e45351f7d6798751f98001d1fcd572024d87f0 upstream.

The usage of edge-triggered interrupts lead to lost interrupts under load,
see [0]. This was confirmed to be fixed by using level-triggered
interrupts.
The report was about SDIO. However, as the host controller is the same
for SD and MMC, apply the change to all mmc controller instances.

[0] https://www.spinics.net/lists/linux-mmc/msg73991.html

Fixes: ef8d2ffedf18 ("ARM64: dts: meson-gxbb: add MMC support")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Acked-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/76e042e0-a610-5ed5-209f-c4d7f879df44@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
@@ -528,21 +528,21 @@
 			sd_emmc_a: mmc@70000 {
 				compatible = "amlogic,meson-gx-mmc", "amlogic,meson-gxbb-mmc";
 				reg = <0x0 0x70000 0x0 0x800>;
-				interrupts = <GIC_SPI 216 IRQ_TYPE_EDGE_RISING>;
+				interrupts = <GIC_SPI 216 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
 
 			sd_emmc_b: mmc@72000 {
 				compatible = "amlogic,meson-gx-mmc", "amlogic,meson-gxbb-mmc";
 				reg = <0x0 0x72000 0x0 0x800>;
-				interrupts = <GIC_SPI 217 IRQ_TYPE_EDGE_RISING>;
+				interrupts = <GIC_SPI 217 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
 
 			sd_emmc_c: mmc@74000 {
 				compatible = "amlogic,meson-gx-mmc", "amlogic,meson-gxbb-mmc";
 				reg = <0x0 0x74000 0x0 0x800>;
-				interrupts = <GIC_SPI 218 IRQ_TYPE_EDGE_RISING>;
+				interrupts = <GIC_SPI 218 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
 		};


