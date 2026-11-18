Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048789;
	b=f0yFBXEvM+twLIALyXNFG44/ljTxfSB4giw5pCaNoLA1oYrpF4WfT+XkdjejnsjH3dl2
	 npTYlJ2xh7X+9fftC6Qgxr85NM5hg5nmM7/gYdH8JEV4sj+QoE1s6PplBihfW1yECNPpp
	 XptvrpbtxlLJEpvKXI72LkOGZANITo8XFCx8iXAEJrRWetYVBGpc9riC7vS0/x409VVdk
	 Sey+UNz0/yIQ7X4kaCASbNSs+Wib3CG8aAJ3u6NWnugNlR3YMmQevv9jBoe0aJgjT1pMj
	 kPnBUh9WzkaM94XO26MsO7AT71sWZSZwJ79mFummPt3Mh9LkyymWC87OP64dZmjCoeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lmCIto2wzZ5YqAkDIHY6E2drjLdnliq1/gHGTxz4SDU=;
	b=QsvTWruvFQ/wReeAcuW68doAglbMoDxsEAV/y4PfeMJnVnkkOu/tpHTc0r3uBa8RmL3V
	 iXzPJs9txVmX6oNWKeXPKIAMBe3/YSmhnWZkVcNQCd8P3T+Wy3fAV9mHCwyThJ5kzU4QR
	 T2e7L3mfMKV86zVpgHsyLen09bRM4ukQY9PlRLMLK+BUh38trer9V4ag6xSP6ylFLe06c
	 nuNXVIbbLjjTUE2LF6NQu/3WF2O+CCYSzT1K+sYk2KXZbO6ox53KE+2AbXfTru4zOZEjT
	 Z0M3Gt+9ZIlH/dPpL/sE1UhuE7dPlfa0poXlA9vwpL2qir4Kw88at6d1kcoTQZmGRLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zyvKsSSD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367B4606A325;
	Thu, 19 Nov 2026 00:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zyvKsSSD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1201F000C4;
	Thu, 19 Nov 2026 00:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048789;
	bh=lmCIto2wzZ5YqAkDIHY6E2drjLdnliq1/gHGTxz4SDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zyvKsSSDu8deRoo2gD7sy1gfjUOHlOmKpzYlCmjhUfyTnpjsFkos7NZ83ucXk+jBN
	 ozkKzk0ELM4zC8OmeE1jLE1sp+L4g5LlrYxl9LS7HIQrnrifesSpdcy0t8n4HkPs+A
	 DbpVezHmNW5n6ZSaycYr0BuY/7L9mnxyOAF6lCSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2079/2857] ARM: dts: gemini: Use a level-high interrupt for TVE200
Date: Wed, 18 Nov 2026 15:51:53 +0100
Message-ID: <20261118150316.265115193@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e836bd0818d42..86d7f1b683dc0 100644
--- a/arch/arm/boot/dts/gemini.dtsi
+++ b/arch/arm/boot/dts/gemini.dtsi
@@ -430,7 +430,7 @@ dma-controller@67000000 {
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



