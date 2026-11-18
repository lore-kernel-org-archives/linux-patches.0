Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060944;
	b=OyiIsgoQel4AeBcceuhsk5WwmVVeVkWUmHuIWbwjPHvLe2zIuTgPBZRDtWnyIgwBW1B0
	 DqGI8noY1axrUqmjjTKZiD6QpKNV+EGkDqndoNGu6/fHYIwXYcm2ydSSKgnVNvFtZJP3m
	 rk2m5UYQm64IAexd/NQzvsrC+hWxhb4Ghj4krqEN2O//4x6pKNhebRw8HjQss7wjE62dn
	 +9Pbb7oGBFP46RtIu4p5ZlYVErSRVP82d5cSg6R7REtkgMSAoKc2erRVKP6vQznoOjkaP
	 peKv5MY/8D+bzRFJrQwxM2D7xmi5Qib/zsBlRRwlNigHpv/rtE4j57oJ8L9RaDmGRUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iRl54b8YZhoMj2Wi1ddNq8AbJNAji+Mzdn+95NlyWDE=;
	b=i3ipQVAE+de7PAkvoC8VycWcmx2WvfferB4q1lnxs0XCUgu7d+uYoVDEXYyNNK7s2Vqd
	 /6VFddrPSEPH17o7SvePHMrJc+ciwldjpQdZht0kS9E5URR2rAVF0XLNYq+7t+gKflbDe
	 lcSzVVMnzlGOXulGvXpxZKbAl3Rf+4uWMlE1mqR0KYlWSN6q63/3UYn6k3lUtCGh8Q3Fj
	 BNU24ILoiMKiQn9u2A3Wwv4o1Kvj/HsIT0ukBI7sH4+vvMTecCIq+MGaA1dNhjV0AQhjH
	 uw0TyuMCy50QvofLUcwhtXfYnUKKOfdwKnsDe6P4nKR/TTpL+TvF5j+JJeimtF9svSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZGmMn+5D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9A3606A326;
	Thu, 19 Nov 2026 04:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZGmMn+5D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC531F000C4;
	Thu, 19 Nov 2026 04:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060943;
	bh=iRl54b8YZhoMj2Wi1ddNq8AbJNAji+Mzdn+95NlyWDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZGmMn+5Dt/iyfeJPhgjmlltBGoLbUHYvkocgQePKHsltck8Bih0R++T3vG1we/y3H
	 NbFmdumNtabgb7S/uidXAlgEhYKHhYi2GYa20WXjOab3vVxfdFCURqgmP9eoqJu1YV
	 bY/U34g35yG+5R0ig0T4UzkOFBmPSwtAb06h9R18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1373/1848] ARM: dts: gemini: Use a level-high interrupt for TVE200
Date: Wed, 18 Nov 2026 15:56:51 +0100
Message-ID: <20261118150017.013079427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 5bf1bb010712bba28eda926ed453db3cab91381a ]

TVE200's interrupt is configured as rising-edge. On the D-Link DIR-685,
this can stop interrupt delivery after the first vertical interrupt,
causing vblank and page-flip timeouts and delaying framebuffer console
startup.

The vertical interrupt can remain pending after acknowledgment. Use
level-high triggering so the pending condition is delivered again
without requiring another edge.

Fixes: d2b85241a9f5 ("ARM: dts: Add TVE200 to the Gemini SoC DTSI")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Message-ID: <20260921-gemini-tve200-fix-v1-2-8be03ac2a8f7@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/gemini.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/gemini.dtsi b/arch/arm/boot/dts/gemini.dtsi
index 07448c03dac9e..665610531f47a 100644
--- a/arch/arm/boot/dts/gemini.dtsi
+++ b/arch/arm/boot/dts/gemini.dtsi
@@ -403,7 +403,7 @@ dma-controller@67000000 {
 		display-controller@6a000000 {
 			compatible = "cortina,gemini-tvc", "faraday,tve200";
 			reg = <0x6a000000 0x1000>;
-			interrupts = <13 IRQ_TYPE_EDGE_RISING>;
+			interrupts = <13 IRQ_TYPE_LEVEL_HIGH>;
 			resets = <&syscon GEMINI_RESET_TVC>;
 			clocks = <&syscon GEMINI_CLK_GATE_TVC>,
 				 <&syscon GEMINI_CLK_TVC>;
-- 
2.53.0



