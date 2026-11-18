Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017111;
	b=OwJxekD0DNpttKTV+bOoHubLAUNnGCJixSQ/vimOVzheuRGOjkMgJyZRiAZjcCCMjV3N
	 bJyLQprYVBTNOw9DlPH/j/7clPZWgwayMmXPjufI81EatkdMAVXJ8gOcOH91FvM8KYK75
	 pgHdYj5AgjwBKiyldnb/WXNgxjmyM5wY5gb1bzgRnrLe0p4Owb2yoj2TZTjboDpFYli2d
	 PegRFznP2Hw8aFgqw7kgzxuIhaYXpB0Jd0JfiDl9Ah09EN3zU7l8nw705FHPFCGub+vbJ
	 6kFr0t+HXrba8LFrGnxRNDcqh45ZFPCegBU7/FfqIw1nWa83uWMQTt4RD/6KjP9najQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qw2X5wFPPkHAoKMgsX8E864Itf0bZSTt0AMQ0MMxliA=;
	b=hlkZrfFaHgJqbONjH5RWB9AJ6q9rx5OlTPCxSBNsK2J7txoErr8c95NnBh1UvaqJpmeD
	 XwJYr+y8jkbC5ont+n/Y+Fkjy46tsKqUROOEcaDEhLNzVc3fUFRgiHGim1Hs0gp9uRRSr
	 whugdDl7n/XBs5pTYCaLf2EZ5145sDFfLMH6N7fhOgWYY4MOww0y1EdFKy8BFLPWXhYT/
	 O4pWP24dXHVdV4B+cJGt20vJwTRGZZztBlQ1pLlOwZTF/S1KxUTJggqPEkm7CuyDo1A3S
	 k4J+VfB+BsAJ9sgv07Q96hfe3l73bo/Cqj9C5lrTGkaixkeSJru+G2ElOymyXvLABPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kIfseebz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15589606A31C;
	Wed, 18 Nov 2026 15:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kIfseebz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D54A1F000C8;
	Wed, 18 Nov 2026 15:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017110;
	bh=Qw2X5wFPPkHAoKMgsX8E864Itf0bZSTt0AMQ0MMxliA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kIfseebz5ZJMaC3jiYkAiY3LmIX3biO+ZuNdIy2ji5GyY0yH1nBnoVp8lKgtBxOfT
	 yTk+gLce17xS8+vFCVSMlCNXGE2oSm+SQTMhgmpa4pdKn5EudALjQNFiL4RdJPdvMF
	 6nwZv86ayyL8N8w4j/vUA3LnELWh129C7dj9uUn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0767/2651] arm64: dts: renesas: ironhide: Align inline ECC carveout sizes with bootloader settings
Date: Wed, 18 Nov 2026 15:33:27 +0100
Message-ID: <20261118150315.497381163@linuxfoundation.org>
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

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit 47ecb59d32cd4fd854aa64bf7e08a74fb97a744a ]

The DBSC5 DRAM controller protects DRAM content using inline ECC.  The
current set of carveouts follows SoC documentation, which describes the
three trailing carveouts as larger than the rest.

Both the downstream IPL and mainline U-Boot on RSIP configure the ECC
carveouts to the same size for all eight carveouts.  Align the carveout
sizes with the controller configuration set by the bootloader.

This makes 1638 MiB of DRAM available for each of the three carveouts,
which adds up to a total of 4915 MiB of newly accessible DRAM on this
platform with this fix.

Making this memory available does not pose a danger, since the current
set of carveouts were carefully set to a larger size to prevent any
possible issues until a confirmation from the hardware team become
available, that it is safe to apply these less restrictive settings.

Fixes: 6fa6ee724d8d ("arm64: dts: renesas: ironhide: Describe inline ECC carveouts")
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260916220801.240796-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a78000-ironhide.dts | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a78000-ironhide.dts b/arch/arm64/boot/dts/renesas/r8a78000-ironhide.dts
index 0ab303863155e..b2d6b06c63881 100644
--- a/arch/arm64/boot/dts/renesas/r8a78000-ironhide.dts
+++ b/arch/arm64/boot/dts/renesas/r8a78000-ironhide.dts
@@ -134,18 +134,18 @@ ecc@18cccc0000 {
 			no-map;
 		};
 
-		ecc@1a66660000 {
-			reg = <0x1a 0x66660000 0x0 0x999a0000>;
+		ecc@1acccc0000 {
+			reg = <0x1a 0xcccc0000 0x0 0x33340000>;
 			no-map;
 		};
 
-		ecc@1c66660000 {
-			reg = <0x1c 0x66660000 0x0 0x999a0000>;
+		ecc@1ccccc0000 {
+			reg = <0x1c 0xcccc0000 0x0 0x33340000>;
 			no-map;
 		};
 
-		ecc@1e66660000 {
-			reg = <0x1e 0x66660000 0x0 0x999a0000>;
+		ecc@1ecccc0000 {
+			reg = <0x1e 0xcccc0000 0x0 0x33340000>;
 			no-map;
 		};
 	};
-- 
2.53.0



