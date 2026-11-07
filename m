Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062039;
	b=SK8e+Rd7kBBnw29gZgOpJI35CoBo2sAhfnLygfsgmqWFvQr7LI532Kqytl5DVSr8BdoT
	 YyMjZY81KC16Ez39ArMRQ1Zj9DTkXic9dY9eOIH4tCUXmbu7TSHKpFfk9mehkubJCgO+y
	 vPUu1aB8C7mKz1TrIhvVTQkw5NJQfXulzT7aovX0L9H8XzRpL7OIXq88SphK2iawKqngb
	 XkR/uHIQhK2sMUQwIYm7bvn4D2dagSHwfmFf01JUiGtUnEsLMDQZJUKLduf8psP1G31dw
	 BM8Au/RqcdMbZECKSznkaR92eKhG+pM7UEXOkgsXpoWW8QKA+edP3YwITBBQEJvGDJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BlAX0yWWph6wDXX52ULeEgXfqIq50jQuIdCrcippL80=;
	b=09smp/Y+hnFJXLpVctms/YbMUkQH9PBWgcO6CKuEfANVLUqotW+J0Uy7Ig4lcdpRQT4n
	 iNWiV/dmb848aBUvVWVEEkRAVYMWbH1wrq364ca8IG26W/X+db/Kl7ws5Jj6kO/kHR4s1
	 KU00672DAmD/6XTebBiTMq0EOy8gzUP0T7lwEJ29rWcd1AVglZAxjMdpgsD48qABKm9uH
	 bDzRYzyLRTe5syov2fzFtSTRMUNhz36O4Ne1igT55XdWCFtJHSC1JhBHhh6/NZHStJzmp
	 ov4f1GFye65dpHN+BeoB61mZdRmQ6PR6rXPNlyw//Otkcm5WEcxlIWskZ3TW+NC8pZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1S+BowC9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5989606A332;
	Sat,  7 Nov 2026 14:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1S+BowC9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3451F0089F;
	Sat,  7 Nov 2026 14:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062038;
	bh=BlAX0yWWph6wDXX52ULeEgXfqIq50jQuIdCrcippL80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1S+BowC9LwdlhsLW30wO7K+XFzVhkkEoWZIoKonQXSnxdSzzbqZKKNF0lQHlwbHVC
	 gK1DBz7ujkRL7Q53LhJBRT+Ss7s/Bb6ztJC3mLckCGvBznsefMWQAd1ZyvxjyAntuT
	 ihsvmaVt046bL73jjmaiWpZ86tgHWo8i91v96bz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1021/1536] arm64: dts: ti: k3-am62a7-sk: Set eMMC clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:50:37 -0500
Message-ID: <20261107135026.356179937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Judith Mendez <jm@ti.com>

[ Upstream commit aa7d5b1efa75e58c9d440dfd720205045fe6a806 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruj16 Rev. C: Table 12-257. MMCSDi I/O Signals

Fixes: e041ec6e86e7 ("arm64: dts: ti: k3-am62a7-sk: Enable eMMC support")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-4-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
index dd406609ee22c..59971c46d80c1 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -290,7 +290,7 @@ AM62AX_IOPAD(0x0b4, PIN_INPUT_PULLUP, 1) /* (K24) GPMC0_CSn3.I2C2_SDA */
 	main_mmc0_pins_default: main-mmc0-default-pins {
 		pinctrl-single,pins = <
 			AM62AX_IOPAD(0x220, PIN_INPUT, 0) /* (Y3) MMC0_CMD */
-			AM62AX_IOPAD(0x218, PIN_INPUT, 0) /* (AB1) MMC0_CLK */
+			AM62AX_IOPAD(0x218, PIN_OUTPUT, 0) /* (AB1) MMC0_CLK */
 			AM62AX_IOPAD(0x214, PIN_INPUT, 0) /* (AA2) MMC0_DAT0 */
 			AM62AX_IOPAD(0x210, PIN_INPUT_PULLUP, 0) /* (AA1) MMC0_DAT1 */
 			AM62AX_IOPAD(0x20c, PIN_INPUT_PULLUP, 0) /* (AA3) MMC0_DAT2 */
-- 
2.53.0



