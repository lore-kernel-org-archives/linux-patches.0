Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C404C28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2622DC433EF;
	Mon, 30 Jan 2023 13:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087080;
	bh=ISKq4zoKlXMms6LyLvHrc9dp4pM+MVB0HUonyq7Qb7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rXLT3s7bWFZ6rvPiscsb8Vr3ZyhnDFrg9Cj06OGb/Z329WzCuk+miK9a93MFQHzo4
	 v4UuGvPKGIDXjQca+NbCBQcezbm3UXFNH/YTOnkvvwM4ShT8Ig3XVjdOh4BmoQ73GB
	 KHb+kCUKRENZiNpQBaH+hfRRphmodCSK+bDxTA4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Reinhold Mueller <reinhold.mueller@emtrion.com>,
	Alexandre Torgue <alexandre.torgue@st.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/313] ARM: dts: stm32: Fix qspi pinctrl phandle for stm32mp157c-emstamp-argon
Date: Mon, 30 Jan 2023 14:48:45 +0100
Message-Id: <20230130134340.839279229@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Patrice Chotard <patrice.chotard@foss.st.com>

[ Upstream commit 732dbcf52f74b254a7ddd4226e0b9638e1e7aeff ]

Chip select pinctrl phandle was missing in several stm32mp15x based boards.

Fixes: ea99a5a02ebc ("ARM: dts: stm32: Create separate pinmux for qspi cs pin in stm32mp15-pinctrl.dtsi")

Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
Cc: Reinhold Mueller <reinhold.mueller@emtrion.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp157c-emstamp-argon.dtsi | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp157c-emstamp-argon.dtsi b/arch/arm/boot/dts/stm32mp157c-emstamp-argon.dtsi
index 30156b7546ed..d540550f7da2 100644
--- a/arch/arm/boot/dts/stm32mp157c-emstamp-argon.dtsi
+++ b/arch/arm/boot/dts/stm32mp157c-emstamp-argon.dtsi
@@ -391,8 +391,12 @@ &pwr_regulators {
 
 &qspi {
 	pinctrl-names = "default", "sleep";
-	pinctrl-0 = <&qspi_clk_pins_a &qspi_bk1_pins_a>;
-	pinctrl-1 = <&qspi_clk_sleep_pins_a &qspi_bk1_sleep_pins_a>;
+	pinctrl-0 = <&qspi_clk_pins_a
+		     &qspi_bk1_pins_a
+		     &qspi_cs1_pins_a>;
+	pinctrl-1 = <&qspi_clk_sleep_pins_a
+		     &qspi_bk1_sleep_pins_a
+		     &qspi_cs1_sleep_pins_a>;
 	reg = <0x58003000 0x1000>, <0x70000000 0x4000000>;
 	#address-cells = <1>;
 	#size-cells = <0>;
-- 
2.39.0



