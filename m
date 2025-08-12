Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447EB6BB5B;
	Tue, 12 Aug 2025 18:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023466; cv=none; b=bnqR0dS4keAfjDHKzA29IltVY/nH1GUAw2fFlc56nbff1geVVsFIFUqpvYvjnJxqUM+QPvbJ23lPdYjZyahe25YSdbmp0VE3Ets2dqeVLmr8jOReIarN5BVnXrhUunvCZftdQZdIJXt3K3+S97yq/fhq/CjYofJfH//e65vqABM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023466; c=relaxed/simple;
	bh=2F7z+cdaTGx/oIBzd7VpHz3pZQpC3MjDjtxOuBoSPtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJByDAeAFowtA1GE8Ns9Yyf8nuZkGsLyV8spHshPTphOVvWX/YePdGRqN4JnDpvSIdhdXcI/MSVmKKcoHT0IR/sMY4QeOfMbH/zxUp8AyIzO2Xo1BN/D0gNqyTnMnFTqUitSR+GJQBojuB/0ugyrOM0hMNSm59NKRnYf1tRuUmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPjljlK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPjljlK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1473C4CEF0;
	Tue, 12 Aug 2025 18:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023466;
	bh=2F7z+cdaTGx/oIBzd7VpHz3pZQpC3MjDjtxOuBoSPtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPjljlK590lJl89fN5JRrS2hXWldcb5s7JLNKe+AuTwc1lhQO1QM6jjxOO4Plg3m6
	 j8cLxhmlgt5kx4yhwQ7666KuBNud7bnD1eEQslFgoYpEDFQLViILyz21ftJX/0JyWa
	 22JP+dTIvgVHd0wmOAEpwnZFPnrcECgPjAn7Srqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 088/627] arm64: dts: ti: k3-am62p-verdin: add SD_1 CD pull-up
Date: Tue, 12 Aug 2025 19:26:23 +0200
Message-ID: <20250812173422.651602225@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit fefaa8d7f8012249729a987d3abce747ffab0ca7 ]

Add internal pull-up to the SD_1 card detect signal, without this the CD
signal is floating and spurious detects events can happen.

Fixes: 87f95ea316ac ("arm64: dts: ti: Add Toradex Verdin AM62P")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://lore.kernel.org/r/20250701081643.71406-1-francesco@dolcini.it
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi b/arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi
index d90d13287076..85c001aef7e3 100644
--- a/arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi
@@ -433,7 +433,7 @@ AM62PX_IOPAD(0x01b8, PIN_OUTPUT, 7) /* (E20) SPI0_CS1.GPIO1_16 */ /* SODIMM 19 *
 	/* Verdin SD_1_CD# */
 	pinctrl_sd1_cd: main-gpio1-48-default-pins {
 		pinctrl-single,pins = <
-			AM62PX_IOPAD(0x0240, PIN_INPUT, 7) /* (D23) MMC1_SDCD.GPIO1_48 */ /* SODIMM 84 */
+			AM62PX_IOPAD(0x0240, PIN_INPUT_PULLUP, 7) /* (D23) MMC1_SDCD.GPIO1_48 */ /* SODIMM 84 */
 		>;
 	};
 
-- 
2.39.5



