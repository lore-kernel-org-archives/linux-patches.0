Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC342847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63346C4339B;
	Wed,  1 Mar 2023 18:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694394;
	bh=TTVb/FAA0tZrNRdTGBMrBBucjEXf/rsl3YeQsmLViO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7FIZkiV9+NjjJCJl38N/bs5EsvbSXjRgBjh+thfzyFPK2HvNkmYwXFqYT9p6BakP
	 Rq4I32HAD51pGVQ0IOD2HK7XcR7X+qM2DQ5FQpTdhi0ZldcHBrBvWKDU774+zlFgaW
	 /Yst+NowgAvtEeyWkF5nc5bYEb7Td2UjeMQmAJoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.1 33/42] arm64: dts: uniphier: Fix property name in PXs3 USB node
Date: Wed,  1 Mar 2023 19:08:54 +0100
Message-Id: <20230301180658.545313154@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

commit 2508d5efd7a588d07915a762e1731173854525f9 upstream.

The property "snps,usb2_gadget_lpm_disable" is wrong.
It should be fixed to "snps,usb2-gadget-lpm-disable".

Cc: stable@vger.kernel.org
Fixes: 19fee1a1096d ("arm64: dts: uniphier: Add USB-device support for PXs3 reference board")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://lore.kernel.org/r/20230207021429.28925-1-hayashi.kunihiko@socionext.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts | 2 +-
 arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts b/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts
index 7069f51bc120..99136adb1857 100644
--- a/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts
+++ b/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts
@@ -24,7 +24,7 @@
 	snps,dis_enblslpm_quirk;
 	snps,dis_u2_susphy_quirk;
 	snps,dis_u3_susphy_quirk;
-	snps,usb2_gadget_lpm_disable;
+	snps,usb2-gadget-lpm-disable;
 	phy-names = "usb2-phy", "usb3-phy";
 	phys = <&usb0_hsphy0>, <&usb0_ssphy0>;
 };
diff --git a/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts b/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts
index a3cfa8113ffb..4c960f455461 100644
--- a/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts
+++ b/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts
@@ -24,7 +24,7 @@
 	snps,dis_enblslpm_quirk;
 	snps,dis_u2_susphy_quirk;
 	snps,dis_u3_susphy_quirk;
-	snps,usb2_gadget_lpm_disable;
+	snps,usb2-gadget-lpm-disable;
 	phy-names = "usb2-phy", "usb3-phy";
 	phys = <&usb1_hsphy0>, <&usb1_ssphy0>;
 };
-- 
2.39.2



