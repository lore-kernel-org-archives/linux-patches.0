Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA75A1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AB6C433D2;
	Wed, 28 Dec 2022 14:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672238693;
	bh=OvoPftLgNCIVWyumvRT5AIgLunjqxeCqOuMRWjthq48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HpPVom9g1J5CpWJEjUc82tthK3sO7IhLU6VddKB2Qy84S38ZJihowXMKtrmqmIHO8
	 QmvsG69/W/rMxNBpkqiifByoPaqWKgOLq+BD6XVzFKgbTQ08OvTleWzwvhz+9a5Zl9
	 Ki4bvo+A5o8M/zXP9+ha3FCvOsvm8vVJGXcIsHOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 6.1 0001/1146] MIPS: DTS: CI20: fix reset line polarity of the ethernet controller
Date: Wed, 28 Dec 2022 15:25:40 +0100
Message-Id: <20221228144330.227642259@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit ca637c0ece144ce62ec8ef75dc127bcccd4f442a upstream.

The reset line is called PWRST#, annotated as "active low" in the
binding documentation, and is driven low and then high by the driver to
reset the chip. However in device tree for CI20 board it was incorrectly
marked as "active high". Fix it.

Because (as far as I know) the ci20.dts is always built in the kernel I
elected not to also add a quirk to gpiolib to force the polarity there.

Fixes: db49ca38579d ("net: davicom: dm9000: switch to using gpiod API")
Reported-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Acked-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/boot/dts/ingenic/ci20.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/boot/dts/ingenic/ci20.dts
+++ b/arch/mips/boot/dts/ingenic/ci20.dts
@@ -438,7 +438,7 @@
 		ingenic,nemc-tAW = <50>;
 		ingenic,nemc-tSTRV = <100>;
 
-		reset-gpios = <&gpf 12 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpf 12 GPIO_ACTIVE_LOW>;
 		vcc-supply = <&eth0_power>;
 
 		interrupt-parent = <&gpe>;


