Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040268;
	b=DBoFASEyeHoDmcffY+v/dTSkKiE4RwLqq8YsiJ9o6FAl8J8c6huDQsVWZKgJao3AGRqn
	 JQHioNL5swN9y3HXNiLtdH0rZF50kpeAjrhpPXaY+XLryTNrqNjif3EmdGBLTaYZDJePm
	 mb/8iJtfEkzAuvbiPiLULA9CVK7GwrbCLfKp/w+SvKvgQz2uwKwVGfy7BKzxObrnbn39e
	 X/A9a9dL/Bjde4r9fgXD8wOHFb9dWU8fkxMVM4a6PBXE2TOkc7iHeNwkv1xNVTPTKdFoY
	 5P1BfyEbUpG1mZGZ+kbxRj4FsCSuHMxPufL19WfDsZ6A1hMNAX18WijpMrG8OgRG1nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040268;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RqeEpEtOWP3qX8vpOhCu4gWFsk8UUvc3wDyrBQ4PG70=;
	b=DHrYtBjlVtKtIzcTkdQfsQUf5CR5jDAMF6EU9mLHNl2v9t+/hvRSyI5i0cIP0OPCabaS
	 zdwMXkQlK+p6J8VvP8sjY178eow+ssyTfNGzuZGnpStikJDSeadwUvs85HH/0MC6fpR6L
	 BprLiRF2clkuebvAHfGSyrtsdjnK7tvbeTJC77VhcRxZeVre1AjQ+u7r7z0daBC3R6JJ4
	 8fNMYEbQsvAZSP/8TQpPg2h7Tlu5mtoBvC0bu9JiFWjZDdT9vdjnKDQAFxGtyaQzAsV8S
	 EfRXqXry0vGbxPRr+Pfg3Qwb3wvlvaxIcM2ppNFo4S9ZNQh5Vw+oxOAsubrm4v4bjnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lPizxnxN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AFE606A32A;
	Wed, 18 Nov 2026 22:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lPizxnxN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DC81F000C4;
	Wed, 18 Nov 2026 22:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040268;
	bh=RqeEpEtOWP3qX8vpOhCu4gWFsk8UUvc3wDyrBQ4PG70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lPizxnxNkDTdzdTDqbOYhrtvD7QvqNJFwJy+8XPKogPfW6xoBagHX0DMu0nJTIZfw
	 hmQRpbpAUwrtaFVmvZmrsF+3Gl5q4iTKrSZUoovA1h6ts+xT/wh6MB7s4POBqYdeJm
	 evGrAuSkLn74TlFge0zqpFImeSo6ar26af44YR2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2395/3318] ARM: dts: gemini: Use a level-high interrupt for TVE200
Date: Wed, 18 Nov 2026 15:50:17 +0100
Message-ID: <20261118150433.361223263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/gemini/gemini.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/gemini/gemini.dtsi b/arch/arm/boot/dts/gemini/gemini.dtsi
index befe322bd7de9..c95faa197bcf1 100644
--- a/arch/arm/boot/dts/gemini/gemini.dtsi
+++ b/arch/arm/boot/dts/gemini/gemini.dtsi
@@ -428,7 +428,7 @@ dma-controller@67000000 {
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



