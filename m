Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024999;
	b=yf6/trEfCWdNEgCnay0I0pNPJXPaFJpCbR3JNG0HajvgVgZBEmzodEM7CBfg/qZdfYho
	 cK3IRq6l6Y86TOEBg5PPgK/5lI8x9HecphnWP0EoX18WEAzYJM95AEkxBkswL3X3qCSpF
	 DcTSAsqe78dEN8el8SsT6lHDsn+K8k27jcAnhZ0GsnZJPU0TEY65XvkPgukcHrlWM8pIp
	 AQBMTYdQs8aMoW75/FhTJE7QyssEsQLgxq4oX6AcrjmndGtY3VUnSjfzt9E8soJoiixf1
	 /O0YhQntlRF9Xza2GXx+t1qu8TM5Tk0TAZB7shvfkNZgka/TxN6rtDWiXZjM4PVjgFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DLO4mhlG2IDZipr7f9bFgUMNOMRu0mtnISjoZWwaO5U=;
	b=WR5nPcnTyM7pv0YOtKbF1Z/XiZ8E2ZFxrzPjtNyGVUPHdxpRkpa5LGAaeChR/SEhTMtc
	 +9903PqUlVobVnoRPluasgWbnkbQW88TXrGd+EASLbIZlF/utv9K2K9edpCBqwbSRyGad
	 EHXXxuE7NoSLA9oS8HM1en/KvYO24/1xWzeIxbeaA8QKMMMrtalqzXWv2RQQPjBg/9A2P
	 6PqoKtsslT4gVPwJocs5Ie3aNqOMSXLse/i8w8Lknq9IpeB8OkSeWYna+NwwGu7FZK8MD
	 rLHs6imtFwh5CWuaAWjJqFqJJfU3VHF9ElCDpTrXw2Mv8LI7fUSdS93WMn+W0eB8Fxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sVFv00VH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6A5606A31C;
	Wed, 18 Nov 2026 18:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sVFv00VH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0E41F000C4;
	Wed, 18 Nov 2026 18:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024999;
	bh=DLO4mhlG2IDZipr7f9bFgUMNOMRu0mtnISjoZWwaO5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sVFv00VHHwmQTbzr4yqRDX0CwEhVcjpPQi4ISt/DbIgyJsLFXQYseNxkr52TFebcp
	 X2J59xJYgCdvSijA+m5CTaisOaH9xtMfp2rl+B8ANM6WpvDqWVG2l5kpO+mQwgqSvW
	 OkvoPmTW4BAxGfa/OcEgAtDMMxcb32BMfxf0dhKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Nowicki <mateusz.nowicki@posteo.net>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0925/2151] arm64: dts: st: fix sai3b unit address on stm32mp251
Date: Wed, 18 Nov 2026 15:44:20 +0100
Message-ID: <20261118150156.154059436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Nowicki <mateusz.nowicki@posteo.net>

[ Upstream commit 64a74189380955bd2d45e5e38a90947b0f63efd3 ]

The unit address of the sai3b node, 502b0024, is the address of the
SAI_BCR1 register in the secure alias of SAI3. The reg property of the
node translates to the non-secure address 0x402b0024, which all other
SAI nodes use. Fix the unit address to match.

Fixes: bf26d75a95f1 ("arm64: dts: st: add sai support on stm32mp251")
Signed-off-by: Mateusz Nowicki <mateusz.nowicki@posteo.net>
Link: https://lore.kernel.org/r/20260924193759.27881-2-mateusz.nowicki@posteo.net
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/st/stm32mp251.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/st/stm32mp251.dtsi b/arch/arm64/boot/dts/st/stm32mp251.dtsi
index 371bfa26bdd57..323ac04b550a6 100644
--- a/arch/arm64/boot/dts/st/stm32mp251.dtsi
+++ b/arch/arm64/boot/dts/st/stm32mp251.dtsi
@@ -1265,7 +1265,7 @@ sai3a: audio-controller@402b0004 {
 					status = "disabled";
 				};
 
-				sai3b: audio-controller@502b0024 {
+				sai3b: audio-controller@402b0024 {
 					compatible = "st,stm32-sai-sub-b";
 					reg = <0x24 0x20>;
 					#sound-dai-cells = <0>;
-- 
2.53.0



