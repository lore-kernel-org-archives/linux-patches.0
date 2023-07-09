Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA40522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6BFC433C8;
	Sun,  9 Jul 2023 11:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901886;
	bh=OEmjrOiVakU59k2XjO4Xk5TFA5tM34Om+iY7A+QtpqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMXxmNS81wf6H1EDeLJv45FFUgGbK0hWzs7S+YRcViH+UG83IWY4lwXAt5u9kKG06
	 hlKODDNS2r10mbs0dMfcYJBsF6oOAsURRNmTSnRzHQAZ2tPSwwa21ubb2ffsL6jr7T
	 L3J+vURQghOPHJtZ4/AZZZbSQLkU3QGM6f3n5lZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans-Frieder Vogt <hfdevel@gmx.net>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 179/431] ARM: dts: meson8b: correct uart_B and uart_C clock references
Date: Sun,  9 Jul 2023 13:12:07 +0200
Message-ID: <20230709111455.378000793@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: hfdevel@gmx.net <hfdevel@gmx.net>

[ Upstream commit d542ce8d4769cdef6a7bc3437e59cfed9c68f0e4 ]

With the current device tree for meson8b, uarts B (e.g. available on pins
8/10 on Odroid-C1) and C (pins 3/5 on Odroid-C1) do not work, because they
are relying on incorrect clocks. Change the references of pclk to the
correct CLKID, to allow use of the two uarts.

Fixes: 3375aa77135f ("ARM: dts: meson8b: Fix the UART device-tree schema validation")
Signed-off-by: Hans-Frieder Vogt <hfdevel@gmx.net>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/trinity-bf20bcb9-790b-4ab9-99e3-0831ef8257f4-1680878185420@3c-app-gmx-bap55
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/meson8b.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/meson8b.dtsi b/arch/arm/boot/dts/meson8b.dtsi
index d5a3fe21e8e7e..25f7c985f9ea1 100644
--- a/arch/arm/boot/dts/meson8b.dtsi
+++ b/arch/arm/boot/dts/meson8b.dtsi
@@ -740,13 +740,13 @@ &uart_A {
 
 &uart_B {
 	compatible = "amlogic,meson8b-uart";
-	clocks = <&xtal>, <&clkc CLKID_UART0>, <&clkc CLKID_CLK81>;
+	clocks = <&xtal>, <&clkc CLKID_UART1>, <&clkc CLKID_CLK81>;
 	clock-names = "xtal", "pclk", "baud";
 };
 
 &uart_C {
 	compatible = "amlogic,meson8b-uart";
-	clocks = <&xtal>, <&clkc CLKID_UART0>, <&clkc CLKID_CLK81>;
+	clocks = <&xtal>, <&clkc CLKID_UART2>, <&clkc CLKID_CLK81>;
 	clock-names = "xtal", "pclk", "baud";
 };
 
-- 
2.39.2



