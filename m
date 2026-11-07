Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064064;
	b=guO3OeotogTj/cgNUqO6oLG/VpdsGwCD/VUdIHBDHnAK5+phegdrRKW6vmftKQhrAeqd
	 Yu42Ia+7deJjs4PZm7cr+TOUKz6lf9yNmAGhHkBjO6VaNH535yTBrP3TOrV7OkrZnPmC6
	 +xJgK8wmNcc4yao+vU0jArLEoIPoVNfylqzQ3JjAp6fzLQVVxTNdKd0GmBUXJN0+tiihj
	 LmHurB43+aSxYyTxjH7aqX9a0VjXpXyNr4AKIKpcsWBmeD7hqvmJqUoFsX7oV2Kn7y1k9
	 kwDq3eQvRl6NL7E7DTyReMUuGHbSpVJ+tMf0F2u5DgxNtQTdnDP6FzYLj3m5cwEivwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1jcPUwikRtBChhAXt0UvAq6rii9MDxZoaVZwRip4DNU=;
	b=u1y79aYxi0/+MbTja+ccpjBgc01AlVTQtrxdlr7gG5sljjgNrQAnQeqLuXQ8dwbY2+U9
	 3i1ZihN8gs8WrVMwSrBmrnIl0myybv1pQ/ZTanqaddGrv5aej+baEW7FnY5FleKexdawC
	 K7IECR2gDRmlkPw60dkrJ+1271/gC5yryTvrjjwWapD37NFEPmYgUze8uesUU9Upft3bT
	 ycel79f6k3E5OJxxxfmOwSfkEXO48zXinX6kwyIW8AAeHleImJ3VYWe01wgYP7KPH7mBE
	 +Y0fg0ykdzAlefjBKNZ0xVwxppU0+k6zPIehXRDXXhNcYtOX3qifT8SMhC8w7soDaIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tVti8VWO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CC5606C023;
	Sat,  7 Nov 2026 15:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tVti8VWO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765D81F0089F;
	Sat,  7 Nov 2026 15:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064063;
	bh=1jcPUwikRtBChhAXt0UvAq6rii9MDxZoaVZwRip4DNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tVti8VWOx1IHkvBrChz7s1vphVyy+7ahFkOXfxoc9PVKIdSLBhPLdZAHtqPKRhn8i
	 HpNe8psWmUZCwWn2kIlLCG9eWbpY95iuSejHuicWDOJxYaYqtYGo4oACmkFKZqy92z
	 BZkcycOGDWdbVezNyOkxHxpC/z5+ry55LagZsvOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0233/1257] arm64: dts: ti: k3-am62a7-sk: Set SD clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:42:09 -0500
Message-ID: <20261107134945.958266634@linuxfoundation.org>
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

[ Upstream commit cfad4f39124b218c2cbbbe17e742971abc9ac8b4 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruj16 Rev. C: Table 12-257. MMCSDi I/O Signals

Fixes: 38c4a08c820c ("arm64: dts: ti: Add support for AM62A7-SK")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-5-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
index f6778f9798d40..e63c5200a2370 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -344,7 +344,7 @@ AM62AX_IOPAD(0x1f8, PIN_INPUT_PULLUP, 0) /* (AC2) MMC0_DAT7 */
 	main_mmc1_pins_default: main-mmc1-default-pins {
 		pinctrl-single,pins = <
 			AM62AX_IOPAD(0x23c, PIN_INPUT, 0) /* (A21) MMC1_CMD */
-			AM62AX_IOPAD(0x234, PIN_INPUT, 0) /* (B22) MMC1_CLK */
+			AM62AX_IOPAD(0x234, PIN_OUTPUT, 0) /* (B22) MMC1_CLK */
 			AM62AX_IOPAD(0x230, PIN_INPUT, 0) /* (A22) MMC1_DAT0 */
 			AM62AX_IOPAD(0x22c, PIN_INPUT, 0) /* (B21) MMC1_DAT1 */
 			AM62AX_IOPAD(0x228, PIN_INPUT, 0) /* (C21) MMC1_DAT2 */
-- 
2.53.0



