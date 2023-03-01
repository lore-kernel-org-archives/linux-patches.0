Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44916847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE701C433D2;
	Wed,  1 Mar 2023 18:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694141;
	bh=RaZaytxB3/oi0P1WcP0Mo2lpdwiIdjxmV0Ul3ysEd78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2EeWD7/FhN8DaDqpWx1xkULBvrwVvNtCERiA8ZIZcwp74STFwrrlgKIXFqShvV93J
	 ctq1TTSDhIzuOO+H9xW9Xo4XqnpkS4xGDVSrNNL95dazKNXSsSGn9TQrbVbzkqvu7K
	 grk30csEMecFAPgvwJxAVdLlgiBaFCblEc2cwids=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.2 14/16] arm64: dts: uniphier: Fix property name in PXs3 USB node
Date: Wed,  1 Mar 2023 19:07:50 +0100
Message-Id: <20230301180653.830035042@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>
References: <20230301180653.263532453@linuxfoundation.org>
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
 arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts |    2 +-
 arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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


