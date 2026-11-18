Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030541;
	b=KrpsgjnSm+DUWJyISHXF4Tiz0x0GhJFPJtoC3iwz1vs5w3vUnGYh685lqpOT4bzwSFON
	 jCADSEkvwS+sEhspPpiGfFqUKny7Zo0CqKnT/xYi+fc0lTte4irDDsYy78DY0kWn2zEH4
	 +epj8PznftX5e7YZwbls7EAL5RQNNa3KRmYDtbRpDvP5Fnk4WhkMxMj9SzSGN88xpSTWg
	 X/O9tRUcbvvNyZi64uHd68svTtjxqGIgalkmlc7Px4xac+XDzM7AkmP+VehTom+Y+j5Zh
	 uIJegJA2b+di4TyxkkL7EyzFj1Y3F++3fEWAdeXHLsgbY35pTyvZf8/mD3A4N1lmchA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SZ66E6sOSONCnDlCtkj4RumHhgZD3+mH66X/bljEAqY=;
	b=K4KpAAnUyYLRFIYrnRMYbf0vVnFqOrghGLWlaZcweW8IQ5HmuCNnOj6oxvl6pW+Kmek0
	 MnMMM3TkP9kmWmeDpEkbB/K9Z9X96m+/vVfdNwWmEVetROEvOnaCcGvvxibGf9iTJDofQ
	 JA7rnRuBqvF7TFb1OLPqrGY8CfBRF63GNyiHmiIXd2+Abnrb/Xv/V+W+CDXBc+l8cfNG6
	 xDA5mABe5VYfA2X8qX2oo/EbguNmGfzrFH8GQluo9NmirmIr03M2OBGmSRMFCzSnBZkGr
	 1a3e6DzInY1odeJlWUntHO73XQxaK0VrhdgyDmOp2/dAvVUrTjHrBnGhZcr2kZoQaiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gl0zrPgG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA7C606B103;
	Wed, 18 Nov 2026 19:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gl0zrPgG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8811F000C7;
	Wed, 18 Nov 2026 19:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030540;
	bh=SZ66E6sOSONCnDlCtkj4RumHhgZD3+mH66X/bljEAqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gl0zrPgGJKD25SIOMifTj3qiiKDGe7pdlTo5b786r7c2gkEKMfs0dG/cGBvSyRuzs
	 slZbx1U7ijCO2s8XGEM1clMkvnjjMS9zsiclI5gk1ymmP/HTz46bzEammRMQyxVpnX
	 4zmv32gHseUFQNhALEf8ptxMPi62F1D0HfaY6Gbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Nowicki <mateusz.nowicki@posteo.net>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0734/1756] arm64: dts: st: fix sai3b unit address on stm32mp231
Date: Wed, 18 Nov 2026 15:47:41 +0100
Message-ID: <20261118150038.871049576@linuxfoundation.org>
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
index 39f67d80c3645..ec03993c4135d 100644
--- a/arch/arm64/boot/dts/st/stm32mp231.dtsi
+++ b/arch/arm64/boot/dts/st/stm32mp231.dtsi
@@ -557,7 +557,7 @@ sai3a: audio-controller@402b0004 {
 					status = "disabled";
 				};
 
-				sai3b: audio-controller@502b0024 {
+				sai3b: audio-controller@402b0024 {
 					compatible = "st,stm32-sai-sub-b";
 					reg = <0x24 0x20>;
 					#sound-dai-cells = <0>;
-- 
2.53.0



