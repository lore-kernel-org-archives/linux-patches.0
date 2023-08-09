Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56257171B3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC65FC433C7;
	Wed,  9 Aug 2023 11:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578993;
	bh=dYq8nxoIMX8PAo4+foTqb6nfE1TXHhdfhTmjgqBjN4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V05lnpGYineRK+fkWsu+y1XwJx4aF8Mp+peTIyB17HaEqPtHYDN0CDOV5cPkQv6aZ
	 v7O7ObzZXgogo5ALpUi4HlYRihYqZ3Jnavboajm9ptVbMaKlv8TLGtAH73mUwc7uI3
	 0R5vW2GGW0gl9NtN4+vWyDSBXVjXAeV2lftDKEwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 036/204] ARM: dts: BCM5301X: Drop "clock-names" from the SPI node
Date: Wed,  9 Aug 2023 12:39:34 +0200
Message-ID: <20230809103643.778680262@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit d3c8e2c5757153bbfad70019ec1decbca86f3def ]

There is no such property in the SPI controller binding documentation.
Also Linux driver doesn't look for it.

This fixes:
arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dtb: spi@18029200: Unevaluated properties are not allowed ('clock-names' was unexpected)
        From schema: Documentation/devicetree/bindings/spi/brcm,spi-bcm-qspi.yaml

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/r/20230503122830.3200-1-zajec5@gmail.com
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm5301x.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index c3b6ba4db8e3d..b48d8336b798e 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -449,7 +449,6 @@ spi@18029200 {
 				  "spi_lr_session_done",
 				  "spi_lr_overread";
 		clocks = <&iprocmed>;
-		clock-names = "iprocmed";
 		num-cs = <2>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
2.39.2



