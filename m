Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064066;
	b=Vnx0Ws9/vxtNo4Vqc47mWZJaWUGnlu/AX9lYT9qSuGtlmBYrvCyzCaiGdTjaGzm9slQA
	 9+BUU8ezvggbc4Oks5vH8R4B5RCWmDGLuRZ8zzs9leVwroaeLjFTeTkxAFHxrBN36ciGm
	 2RekJ2w8Yg50nmtTF/McN7gBeGxEwi/NdSSEwvzZpytpiiqhSz6nkSrTAlYgWoZuGr/J6
	 dm+1GnvwJHR5b9rBeiIxVDb4eI8PsFfTEy/m2M7KrLwufmjXK45rGD3OlptReNFWNJRXv
	 ItO95txmvCDCcfS6AB21KOUaCkDxX988zsQ+SGTWRX5JyWJiJGrRqCP0Vz95yVwiGLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d1DQsuI3temPhyeJHB8hSb5QOQNkkSFEo9zlflyeBRU=;
	b=VRSTCXdUXqEVttX0eC8tKLkUjR3tEWb7EJYcbsbq8gaIaUZE91XcPzTnw1Q1iJVNvuYh
	 Fe/v2C8N5jv4h/jw3ikibOFM8jlKg4SCqwN/LI/GKQ8TAxI/6pSMR7X0lwuSfoUdm0ATA
	 94ZqntR9O1pHd9c5hMv0l9RLlVGtZSPy46k1Nzq/7CmpuIc7WEBNfRf/0R0ewPAchP1+U
	 5MyvNRta+ggVeDNVdb2KY13qwHaSP+yypMHSCQkNqmdkFlf2xEKIdGivz+PlNSuGeGUum
	 QWF5de1PPe/Jo8E+XsmY+XQvzfJlrOz5jHWER2RsCpxckzjYGnJCE4b2/EpW1qWdgxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PnklOTLX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569EB606A9EB;
	Sat,  7 Nov 2026 15:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PnklOTLX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56CB1F0089F;
	Sat,  7 Nov 2026 15:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064064;
	bh=d1DQsuI3temPhyeJHB8hSb5QOQNkkSFEo9zlflyeBRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PnklOTLX7/Rp1K3S4GFeENxtnERZKuCfbCsSQ0UkDy8UUM7h4+gaI2CIm67d9+Eb5
	 JxI7TUyWx24+ooEunDjyhzvnp4epbus+tDvwOaSuBaA+GRTu7rEIQ+OSJoFVwl9e3Y
	 8DnxBzorRh1A2Y7Xzuen+UQXgWpOA8E0HNeHE9Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Wadim Egorov <w.egorov@phytec.de>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0234/1257] arm64: dts: ti: k3-am62a-phycore-som: Set eMMC clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:42:10 -0500
Message-ID: <20261107134945.983165363@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Judith Mendez <jm@ti.com>

[ Upstream commit 4834050197f205a649e36661ca150e6ac8295008 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruj16 Rev. C: Table 12-257. MMCSDi I/O Signals

Fixes: d69383885576 ("arm64: dts: ti: Add basic support for phyBOARD-Lyra-AM62Ax")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Acked-by: Wadim Egorov <w.egorov@phytec.de>
Link: https://patch.msgid.link/20260909214743.899477-6-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi b/arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi
index de4048a3564bc..5ad93be3d3363 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi
@@ -120,7 +120,7 @@ AM62AX_IOPAD(0x15c, PIN_INPUT, 0) /* (V13) MDIO0_MDIO */
 	main_mmc0_pins_default: main-mmc0-default-pins {
 		pinctrl-single,pins = <
 			AM62AX_IOPAD(0x220, PIN_INPUT_PULLUP, 0) /* (Y6) MMC0_CMD */
-			AM62AX_IOPAD(0x218, PIN_INPUT_PULLDOWN, 0) /* (AB7) MMC0_CLK */
+			AM62AX_IOPAD(0x218, PIN_OUTPUT_PULLDOWN, 0) /* (AB7) MMC0_CLK */
 			AM62AX_IOPAD(0x214, PIN_INPUT_PULLUP, 0) /* (AA6) MMC0_DAT0 */
 			AM62AX_IOPAD(0x210, PIN_INPUT_PULLUP, 0) /* (AB6) MMC0_DAT1 */
 			AM62AX_IOPAD(0x20c, PIN_INPUT_PULLUP, 0) /* (Y7) MMC0_DAT2 */
-- 
2.53.0



