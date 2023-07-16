Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F06B8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1609DC433C8;
	Sun, 16 Jul 2023 20:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689541086;
	bh=qcvlOthX8qy3LD+hFK8fjAUzkUWSHTw8O7x7v0oWVEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tgpVnsxGBwz5aEGYZ4ZerRQrx0ppTsXM/tReghMTtzxgj2codn9T8pROtIQQiDJT9
	 5krdSujmT9r7agYEka0uNmqzHgpFAkxb+RIUJv6+M2tSXGZRYz5VVJomLLyRuGQYck
	 k9NKbNR3CkmOsQsX4lp2kkynF1q0fOxX1QNGC8I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 584/591] MIPS: DTS: CI20: Raise VDDCORE voltage to 1.125 volts
Date: Sun, 16 Jul 2023 21:52:03 +0200
Message-ID: <20230716194938.962866072@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul Cercueil <paul@crapouillou.net>

commit 944520f85d5b1fb2f9ea243be41f9c9af3d4cef3 upstream.

Commit 08384e80a70f ("MIPS: DTS: CI20: Fix ACT8600 regulator node
names") caused the VDDCORE power supply (regulated by the ACT8600's
DCDC1 output) to drop from a voltage of 1.2V configured by the
bootloader, to the 1.1V set in the Device Tree.

According to the documentation, the VDDCORE supply should be between
0.99V and 1.21V; both values are therefore within the supported range.

However, VDDCORE being 1.1V results in the CI20 being very unstable,
with corrupted memory, failures to boot, or reboots at random. The
reason might be succint drops of the voltage below the minimum required.

Raising the minimum voltage to 1.125 volts seems to be enough to address
this issue, while still keeping a relatively low core voltage which
helps for power consumption and thermals.

Fixes: 08384e80a70f ("MIPS: DTS: CI20: Fix ACT8600 regulator node names")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/boot/dts/ingenic/ci20.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/mips/boot/dts/ingenic/ci20.dts
+++ b/arch/mips/boot/dts/ingenic/ci20.dts
@@ -240,8 +240,8 @@
 
 		regulators {
 			vddcore: DCDC1 {
-				regulator-min-microvolt = <1100000>;
-				regulator-max-microvolt = <1100000>;
+				regulator-min-microvolt = <1125000>;
+				regulator-max-microvolt = <1125000>;
 				regulator-always-on;
 			};
 			vddmem: DCDC2 {


