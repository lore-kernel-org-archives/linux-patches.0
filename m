Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018065;
	b=BdFrads5DOFWe9Zr3YUaEY+QYYcmMPeX8h1Q6FjGNvy1c0vgAOYbSiLm3Ro7/p1pKseH
	 67WWPjtMIaivEmlnV27gpN1ycuQVZ1JFJAkV1IjgHRiWF4zoBF62SRSC05A/7HPsUZRtD
	 4F5I0LO8Ran/0KKY9bA6AdYEO79gVRNxNVx02MpKFhaSWLP9esXr9lUuiN8JrBinL3FU0
	 z8lQlXmrEn9xeMEMgI6u0OjqRKYISKr8XEjTwG7D0dYHIbUY0ldHacfigKDwQAiPUE1NU
	 DQfiBu4tiAqucbtM/Yp8eFywmnnqtisaGVYtIhxNzWnLeC596eXqRtk9f95u5RqZnzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AzbcM2jJncZD6jNEWH254LA5v3ibfEJq4vfy3t96uGo=;
	b=ar+vF4Omr8LJAUeHXkFE1GdIymEP3dvxpl0NgY452pdDeR1yAAVjasGAZ8SKbi31fgRm
	 pgb70ZvZZtegU/nQngj4z4ITDbCZGvjYSPs1iMgz1UNxi/ynsKqeMgSYTv3tJ/JNLj0KA
	 HLTpe2/qCmo3AeQuF9IHSoS7sYk1+idLP4GaY8C0jZeGlaynVBRrhbjfmhzv0EtxwCyiW
	 Rs7Z1Wc8bTb3J81smgrG9oKyfoSFdIB0zpf9AYJ+17zKcYrVe44wP3AQUj8F2yaTstTxx
	 s5YicFBJW61W+6vX8K36amH5dy30o93fuk5uLS2cLoCBLsgeGCg8espmmHRvav6/vVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DaWRCFKe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086CA60A262A;
	Wed, 18 Nov 2026 16:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DaWRCFKe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092A71F000C5;
	Wed, 18 Nov 2026 16:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018064;
	bh=AzbcM2jJncZD6jNEWH254LA5v3ibfEJq4vfy3t96uGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DaWRCFKeRFCxn8rRku7k0Gb4UF1JxShGYLxhqhXJ1n2zxHGLsq09Bg96lIqg+lumz
	 /iemxuD6XW4k+VHOERUoPiwm5+uaWyqqXCeHSDhE93yOvtpUvgo/eHEdrOLRkVVe3/
	 +5niQ9rl7yMSPh47aOqdN6IH9dn8nedMgQtcNuK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Nowicki <mateusz.nowicki@posteo.net>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1107/2651] arm64: dts: st: fix sai3b unit address on stm32mp231
Date: Wed, 18 Nov 2026 15:39:07 +0100
Message-ID: <20261118150327.846261732@linuxfoundation.org>
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

From: Mateusz Nowicki <mateusz.nowicki@posteo.net>

[ Upstream commit 4b14dbc4c636e760f5db5a2e4e1b4589d484a7d2 ]

The unit address of the sai3b node, 502b0024, is the address of the
SAI_BCR1 register in the secure alias of SAI3. The reg property of the
node translates to the non-secure address 0x402b0024, which all other
SAI nodes use. Fix the unit address to match.

Fixes: e9b03ef21386 ("arm64: dts: st: introduce stm32mp23 SoCs family")
Signed-off-by: Mateusz Nowicki <mateusz.nowicki@posteo.net>
Link: https://lore.kernel.org/r/20260924193759.27881-3-mateusz.nowicki@posteo.net
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/st/stm32mp231.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/st/stm32mp231.dtsi b/arch/arm64/boot/dts/st/stm32mp231.dtsi
index 35e247af957cb..0eca3ca6a781a 100644
--- a/arch/arm64/boot/dts/st/stm32mp231.dtsi
+++ b/arch/arm64/boot/dts/st/stm32mp231.dtsi
@@ -577,7 +577,7 @@ sai3a: audio-controller@402b0004 {
 					status = "disabled";
 				};
 
-				sai3b: audio-controller@502b0024 {
+				sai3b: audio-controller@402b0024 {
 					compatible = "st,stm32-sai-sub-b";
 					reg = <0x24 0x20>;
 					#sound-dai-cells = <0>;
-- 
2.53.0



