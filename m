Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C21463DA
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 12:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792CDC433D2;
	Thu,  5 Jan 2023 12:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672923428;
	bh=rtPj+GPKiZJWhvbP4CVKRxRLABBg5HmAL75+OOgIEOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ob8yLF1CY1B6msJVmawRaIpCGVjsn1GFmI/Kdak50s25gja3H5Be2NvyxgMYfCwB3
	 IVG9f3kGm8B6wjVZcKA50AiRLzeC/jPsoc08FYxciOco/UCHlaeEyLguGYVQNHsm7V
	 okHCVzPgMTqewK+2v+IuWDs+0I/9yPItWVgE9Vzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kory Maincent <kory.maincent@bootlin.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 017/251] arm: dts: spear600: Fix clcd interrupt
Date: Thu,  5 Jan 2023 13:52:34 +0100
Message-Id: <20230105125335.524543381@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit 0336e2ce34e7a89832b6c214f924eb7bc58940be ]

Interrupt 12 of the Interrupt controller belongs to the SMI controller,
the right one for the display controller is the interrupt 13.

Fixes: 8113ba917dfa ("ARM: SPEAr: DT: Update device nodes")
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/spear600.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/spear600.dtsi b/arch/arm/boot/dts/spear600.dtsi
index bd379034993c..89318273d787 100644
--- a/arch/arm/boot/dts/spear600.dtsi
+++ b/arch/arm/boot/dts/spear600.dtsi
@@ -53,7 +53,7 @@ clcd@fc200000 {
 			compatible = "arm,pl110", "arm,primecell";
 			reg = <0xfc200000 0x1000>;
 			interrupt-parent = <&vic1>;
-			interrupts = <12>;
+			interrupts = <13>;
 			status = "disabled";
 		};
 
-- 
2.35.1



