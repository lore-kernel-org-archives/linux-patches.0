Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017638;
	b=1JA465zDqkyv3ixcFEV9XKDNR4aIDVArWXc7XpLRh4uWZvK7bOH2sJ316IGiYfm7+4+/
	 jDU+IO7T2bc2gK+mtZl4RF49OKprhGSEauyl+vTjt11uMYIfmFbihM1nd4HODZGzm8gdC
	 iabX+V/vT/QlBmVVqloRxpxvKgs0w2I5l6U+NTiwHBhwwC5Jv8maXrDFtEtvwYvMnRdVo
	 8VZ86uaPQPtcIIdKDy6LnQJwUqstYcA0jO49dnxSKukqUvlHHPLtECVeQY6zZ25F//7np
	 EFEbYqIG7FgGnDvgAc/r3EeppngEtLO21EiPiopgvCswPgFZoDMaiCthppoMenTG35w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UaVHWYwMUgG5QSWRdnbChW7hTw/wrhh7xI6BL37bz/4=;
	b=tFh0rANaUEzNwpydqyDIzpxjFGltOjwvfupQKF1qhbG/uNttjmYVF+RjolWOipVgQvOq
	 LontCr9dZST2hSl/ZIfn0+ybCvc5NEyabxmpAJYPcVSASaupkEagOBttprbCHlTRLvyrY
	 nmcAUtT7nITAV1TIVQSfY5ismsV0tlegPmGue/7APvM5qQISTsnvjNCrTr7fzYAoPK+oY
	 u2xqigMvXczfdx4EN8FQz7Q95yl9lXqCeISQllwQf/KJsvB1mMsOqXpjaLjRh7bUTBP8G
	 ZDCc5WZdXHMxbelayZNQOUI87ry2tLhgba5HkuJQKVnoSgkCxcpSNjIFB+eg8WPytog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j2RsGLIi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD68E606A32F;
	Wed, 18 Nov 2026 16:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j2RsGLIi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4C21F000C4;
	Wed, 18 Nov 2026 16:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017638;
	bh=UaVHWYwMUgG5QSWRdnbChW7hTw/wrhh7xI6BL37bz/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j2RsGLIiwv0EUWD7P19NBOc7tRzaIJMBzN7EK6eXVpf6uk0gtkNrvLhb0/nWx+OKo
	 W7STXg+OUXLx6QuDiuygQeQF62mYmR+dG409dm6Gvwxz8PVDTUsRhcWrhzy8fq0p+P
	 11kFtC8CCh1w+sGyzsKKSgfItgODFZ+vYZeiSFkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0915/2651] ARM: dts: gemini: Use a level-high interrupt for TVE200
Date: Wed, 18 Nov 2026 15:35:55 +0100
Message-ID: <20261118150320.834519057@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 23e68e17ffbbd..d8f64fea0a79d 100644
--- a/arch/arm/boot/dts/gemini/gemini.dtsi
+++ b/arch/arm/boot/dts/gemini/gemini.dtsi
@@ -445,7 +445,7 @@ dma-controller@67000000 {
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



