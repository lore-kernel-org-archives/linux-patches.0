Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036001;
	b=ilHGkt/tRw0veCO8uRFTurHmeE3ToThffW+BQpqZLv8j9EFveRNI+lMeD60Qtanro0iv
	 xkbFmivA16bZm9SpGfu7j/phQQkpQ6B9dwPZIkFx+FCINaEN8pTlwPuVt1+eF6cFfbGdz
	 udOkRxVJpgp33ePWIlOPARoLoaHvcN8/alioemUmFqnwQs8ARKJT/u8V1eiUyHrJlKR9j
	 /U/Gx1JtQtLE1z5JpvSrgxCr2bIwzacmHcA7hCt8p+dRUY2JX3ts8tFTPRcVY3eulVvH5
	 qG9Bm3LXuPtAAgzM9ehvIob/Q08VmUfa87GWvwTZ1dyqrFT2fC3BlvmzVzSkmVGXWnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nMPujMGFc+gBOHXevQdkJ/4v8KDXG0SQx4CjuvmkZCI=;
	b=SkCf6YTM1ys2ZdjqxIgwgRF05x0I93Ic9AA62Fdwm/PHsZNHbDkJT15gjqaw+yNqwZPn
	 mDD7HniNR2IOROOXDpIfH1cqDvJVQrdRqlZ6g+g9mPeB6tqfNfwOd/2us2dZV/X6m0PhK
	 vYRpiNdtX3TUuXQetyqALtLUSIShvGXyemwG0ATKXR0v36j56sMyLACPzm/VKxQHnx6oF
	 Izv/+NTCOzDnFPyUIlhR/IyrHEmlN9Edr+Jma5Itwkmv29/IZTE2h9/V4ZocyxRH9llxA
	 QW9CBPyvoBtzFgCNMo5zCCRmAfUfimptumpG/CZTZx+CiQn+cKJcW6jhMQOeI5vQJAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MiflS0CT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018E4606A31C;
	Wed, 18 Nov 2026 21:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MiflS0CT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDF31F000C4;
	Wed, 18 Nov 2026 21:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036000;
	bh=nMPujMGFc+gBOHXevQdkJ/4v8KDXG0SQx4CjuvmkZCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MiflS0CTKbN1qi+17OO+Pd4X+kTBb8LjLI08ol/Wn+gyUb398y0TKhEkWzTl847UE
	 mrKi+h/PEkVdkv/f7MR8fodJTP9VVimUXjsnSZyuqM6ThTFztzbdkdgf8RNahC0gzL
	 +wTA3V32gvBSbsBjcqg7ncVId3I1n7KyYQVpXfKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0903/3318] arm64: dts: ti: k3-am62a7-sk: Set SD clock pin as OUTPUT
Date: Wed, 18 Nov 2026 15:25:25 +0100
Message-ID: <20261118150346.581759430@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 12cbf253a8910..65d6a934a7c4d 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -175,7 +175,7 @@ AM62AX_IOPAD(0x0b4, PIN_INPUT_PULLUP, 1) /* (K24) GPMC0_CSn3.I2C2_SDA */
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



