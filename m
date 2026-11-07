Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062917;
	b=b9COzLbNxLVAldwHXFIE0q58tM7cSzFBtf6kgxBfqh27pGL2WuC2P8R3VZP7LP1C+ZuP
	 27DpL2bxH1Ok67KOnkGbx98DmHvqHnPbiNdh9UesPXWYdBv2L1jjcGyEZyBUKxU7VlEnv
	 VrP6rrF1ngMph/fV1cgE6yW8MMMgfEZiPb2aRxkw/N8POPzuplnQSbEYUKnzgQdCFoXvk
	 bpM4y7b+OSg4SlCPDXIs9dc7LxFgoMSmAEt/YNPH7Vp/8MupXVwGMVujQHwY+68mwIIjy
	 RxZNFuwfnYuDK0j2fWczadr16ayahtVnV96czbLnUts/9bhP0La2kU7wxICurpPrbww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c/nEwTD2ULqBLBH+88AKRR9rRdQH8ssQwIxgAKrpX3w=;
	b=Hf9B6wjC1f67ZR9PVkWQUhqLF8EQNgOX3eO/sFb1roEEtSoy1yRwcXxWsAWP5+8L75k6
	 ROwb8gcmkRMgoEmV0dfWKV8rU7nf/Y8nxfdqkv654TmHZ0T8cHKJz7PofqZyXYKdZ4vGL
	 u0XyFu1GqjmDbas3VRDaMeznn01fX9mGpg9vI3i7UeL6Jo8k0M+DIIv2SkAbxNnVaNHRB
	 alxq1GVVL54aPrVyA14FLwRas4S0B9jScSMkX7lYNdmbbMUg+YbRcymjSti8dLJg/GIS0
	 cOyi03izHheASStSPsedw58oYQIMz9+UwsGLhl1x7JolYbHfEpqSCV3NlOAFrWdu+aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gd9qLObb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A194606A330;
	Sat,  7 Nov 2026 14:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gd9qLObb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B023C1F0089F;
	Sat,  7 Nov 2026 14:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062916;
	bh=c/nEwTD2ULqBLBH+88AKRR9rRdQH8ssQwIxgAKrpX3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gd9qLObbiJy+CEets5JMGhDg6cb3daB7V9XT/qWIQsi2nnTR9aQ72dJU3kpw7KQW6
	 aa6armokIO/aUkSy9uRkGmsclNsiALJbQdYeJGI31sjSyRzYl0dB8LMynozLKdNjaq
	 moaQ5Dqww6x6JeuiKfjcs3Ray5kgz0kMaC7j4j2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 192/869] arm64: dts: ti: k3-am62x-sk-common: Set SD clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:47:54 -0500
Message-ID: <20261107134858.586098002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 58f78c0de292d..3c5ef8fc9cdd6 100644
--- a/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
@@ -187,7 +187,7 @@ main_mmc1_pins_default: main-mmc1-default-pins {
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



