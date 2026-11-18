Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030191;
	b=eNIQv3dD6Fb0ERvjccT92Y9nnINMl7lqGd2iYYCVLEW8wsX8RAFXh95QihvNrDeHnJgZ
	 Uv44Cu1RuDufm10cfiKJvcDZpCZsHoURZI8QJ5dUv3Y9YcyImoDKQpE9KQFTp/S+CTaL0
	 6ubu2FAkVeHY7KhvB1SyJomU+wO5nuwTvjvwzTQALFeH9yKuupOuu2Hw8QnPueqY5VmU/
	 rUAhM03ULoSQKp0Pnz4PC8KZrIhPxWuoN1kuquZ0ILdyeKN2HwXpKyn0Vkt0GNTOnbNeL
	 LLzThGcoBBO7US08HSVyfwFSb3A8+JhQsNfq7eAq0OhGRbSYzzB6m7b0if/mfsZxuJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WIl/+spZ58RQkDpnyMvGHZCbn7n9tlnNaq5zTHZUtKk=;
	b=0DwMN3Js6WYTAw21UjMOYbGTOfGMZhBC8ep7ylJxbeI0UJFKeHhMDiP+OEaTJvZZyj2j
	 2njPG1obuBWqLmMusYSYzaKUEZg5KTTbYQ9Qd+jQWfodbQp+t4mMoTf7sQeJ53wUvlAI4
	 t0ZS8mw19l6XlXOdj+4M+aEODZplQEHBroeHDrU1BS1rPCWdu90O09Bn/ohQZThQMT3Z+
	 gkID6iki/7HwfiZ8LgzB9u623Yay8vLyCm0c5OZFhqGEQ5PVAcXFZmLxaQ/Pq4mcZqz7+
	 fT+R3KGlasMKQ8r5v1LYBVMK65ILHPHrF5qF+3WKPw0SH9f0C7kVPbrlld8yRD0JSgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=loo9U3iI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A1C606A32C;
	Wed, 18 Nov 2026 19:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=loo9U3iI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691211F000C4;
	Wed, 18 Nov 2026 19:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030191;
	bh=WIl/+spZ58RQkDpnyMvGHZCbn7n9tlnNaq5zTHZUtKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=loo9U3iIKhtvxTy3fMj0JU0D97dn+ZWjd+isQvT02JITAltlF1Fvcd6FVOSIvLf7s
	 fH93afSL85CnzCSgY0vcVAVtqcOY+gh1W9KXIAtWi9PLSro++ERf+ziXbrSCgbBbHV
	 ZHf2Jyn1v+UhwXqDA17sOW38Fs/Uva79c2FE7tYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0618/1756] ARM: dts: gemini: Use a level-high interrupt for TVE200
Date: Wed, 18 Nov 2026 15:45:45 +0100
Message-ID: <20261118150033.517983715@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



