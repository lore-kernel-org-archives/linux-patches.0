Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055429;
	b=o5zs3baJqSpkiKszknRl/diZAPreXDdYn7p1GLe1hclO/8pOh9yLwIUYzzY3ZtCRPfN+
	 XSSZpS8iUD/OPismV8UWZcKSw8UNlXn4p+ik+mM0gl3xLPbx+jxEiTpNEboXbuCxIUT8C
	 hgv8D9M6lHiBGFx5YWNcHl4OUh8CHTIpuiXzIRA8IIgXoQQKQF2ETbNdSv2B/3QOJH1Oo
	 FgivdPwxadjibI/vSWRmgJOXGwp62rShW8LoP6esJOrZ26bSwrYTF784RK//PWE9bDzf/
	 DVqBOGw9Pb6J+TrWtYEmCBwCiGPpurG5347e+c43MINCKt9a0eKZvkCZqocWDpVnLpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hWFicvdSIUHZnBU97HcBiqQ4nwXqQ5gfFuSU0G73eE0=;
	b=A8U7gtJ5rrTnjkJkbCLftVHkBvSqmsQLLcrZEXn0dAmxP8G7Nckd1luriPbSmQar//gp
	 5eQza1xl5+3TjxWZN8C+mWlGfmyHAZh51aOJMeOqNZ0tCVo9ervvDv1qChaKUUSKE+cIK
	 Nlvq2Em9+xa2nvHw9j2C/VdN91GrRJWqqMN5oTFQmOcifo9slx5wdqMKG7iWVKV4u0+Qs
	 95bg0z0TXnX4qaA80TEoTHRHk2tCTwQjjlQF96rnMYJId9nWOv4tafd8gF3Whd9SI261P
	 +qlxHVJfEbFvOEQt5Olx8zCUUkl98b/AFxcteLAPtASY3/U4TCiPKQKUzjq3inNDMFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AAphXX/K";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E30606A31C;
	Thu, 19 Nov 2026 02:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AAphXX/K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07F61F000C5;
	Thu, 19 Nov 2026 02:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055429;
	bh=hWFicvdSIUHZnBU97HcBiqQ4nwXqQ5gfFuSU0G73eE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AAphXX/KqcymxKPPCs+dkcpkNnbH+xZZJFKLmAnHQsrtGp0rPdUL43I5Y5taFcG+J
	 WhJLt8rLJ+37rDTS5TVtLi7gA/2G64NdCsfmjE30UdDzWLQeyVMft3OAN2dkM/2RoS
	 2WuIsiHnLFpQrOMFDjdypAx8Jnixgf+4dCNIwP3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1627/2214] ARM: dts: gemini: Use a level-high interrupt for TVE200
Date: Wed, 18 Nov 2026 15:55:03 +0100
Message-ID: <20261118150117.051216930@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cc053af3c3472..8fe76b520b03f 100644
--- a/arch/arm/boot/dts/gemini.dtsi
+++ b/arch/arm/boot/dts/gemini.dtsi
@@ -411,7 +411,7 @@ dma-controller@67000000 {
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



