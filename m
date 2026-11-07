Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064072;
	b=eijuXuLBjJrYHN4yDCJcNcKl39dYVnMfC5j3DQBWGKZGObilnqjeAV2t5U1Lxvv8ZDxv
	 xe//60WgeoVrCfrXJ7KDlrqVvca8jdiM6r+dErXqXw3Iunt8aafxAVbAAXrhUUbZjwlUB
	 DzQNQjVIeASHcpUbT2Y/eOwcXqTErygef3FzfeygvfQsVqaxANXT1YljoUv/SW3AGKbTq
	 rg78BIFrHSAl0lZdrqtzdOGDLZQ3dDIdRg40wBHYyA9AzeMaF7FIAl5WV84kwVzqA+3wi
	 8Q/MJhIdUEIvA+BX2vc7xI95XydirK7Vw5Dzh5ums2/j0ooHmN29iWc9jb6YjfSTNXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064072;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=npwG8eIUoQKseW9ufawtZlB4SpVjLqPbJjWDshuaf8c=;
	b=3OhH0PODYfcqCHooCtbwUvttDDpexqxMuGe/sT7cXjD58Uolj7Udb2HIJCav2d6FVEv9
	 RqK6VF1v8Hf1g8KkxM3/z5q9o358hwCm7sGyWUtc0AwAEjxX5lrn9NUGcHABf1bg3fMuU
	 2Jr37+l3BW1yWvAv+A7ugn4DrrXPmSDP0yxGxiYF2/pi0HL8fkSyVUImfISX1ezlZ6EBW
	 Vjwfvu8w2JVXBcnScjL3Sj6igt8/nF8ASNftybtAJSP8xTvIpzdxW1e42cjZybZTiasWW
	 xjgb7liOon51oKlQHbXayadr3uCo1ypcNu4/C4ykMIzc4LrmdMZfOQxVRsSnJKGaC6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lDi+b55E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E4D606A9DA;
	Sat,  7 Nov 2026 15:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lDi+b55E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1621F008A1;
	Sat,  7 Nov 2026 15:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064071;
	bh=npwG8eIUoQKseW9ufawtZlB4SpVjLqPbJjWDshuaf8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lDi+b55EpQMJ8aWs8KuHe7rOn5XqAXt63HUZuA+12o9nEe4iUrdBAnmeZh+pPY7YC
	 pp/3+tfbgqLTzBrwjP9Sdg6P1/O1oHyQahLdWl8l2PId5rNvfso6FlnIgcVZTtjFZG
	 UpJi9Wm0l+jmPDXfy8Gh31zCMShPH0KwgfQ4iALs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0238/1257] arm64: dts: ti: k3-am62x-sk-common: Set SD clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:42:14 -0500
Message-ID: <20261107134946.092164101@linuxfoundation.org>
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

[ Upstream commit 1e2e5016bda94b2bcd86258b5eb77fe3006639a0 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruiv7 Rev. C: Table 12-246. MMCSDi I/O Signals

Fixes: d19a66ae488a ("arm64: dts: ti: k3-am625-sk: Enable on board peripherals")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-10-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi b/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
index ab9e58c2d225e..d2f41e2ed6239 100644
--- a/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
@@ -194,7 +194,7 @@ main_mmc1_pins_default: main-mmc1-default-pins {
 		bootph-all;
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x23c, PIN_INPUT, 0) /* (A21/C18) MMC1_CMD */
-			AM62X_IOPAD(0x234, PIN_INPUT, 0) /* (B22/A20) MMC1_CLK */
+			AM62X_IOPAD(0x234, PIN_OUTPUT, 0) /* (B22/A20) MMC1_CLK */
 			AM62X_IOPAD(0x230, PIN_INPUT, 0) /* (A22/A19) MMC1_DAT0 */
 			AM62X_IOPAD(0x22c, PIN_INPUT, 0) /* (B21/B19) MMC1_DAT1 */
 			AM62X_IOPAD(0x228, PIN_INPUT, 0) /* (C21/B20) MMC1_DAT2 */
-- 
2.53.0



