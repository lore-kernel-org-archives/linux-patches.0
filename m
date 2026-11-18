Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026362;
	b=HgrhnIRkNyQk1pCL5fg4KxMn0TRbJdCPQROvQ8WC0JmsXpgNavshqnm8953R6ggGQh+M
	 SXBXhpyqarwue0os0K7fCTZ6JoECAppONnu7snJOIZk+NDkDqtTr1+9sb7jQcrTRKKQU6
	 o/I+kWV2KbvPhlX0xxe4H1N25PVR9OUINrdaHrbMvCafZUpaqRoLaVabzH5SoP9uvDXik
	 MLywH/5oS3u8vxagv2eOF5LWiTovddrIajqNT8mc6TuBaon79FSAyC8aVTe0FhxT0pZos
	 hT2JKzq9/sudy19JLsQJ4piFD8qCVvUJceSWm6IKOcQJ3VKIA1WH2N+aDpCyBzK940g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E59ZsW0vQ+ds+FHjioIL9B6mq1vKEfu+pNRBHrfTs5o=;
	b=FIsSD9KfOL6ZeU/G5mEGa9VIf1yObqB/v1NtCxQZsw2XOJsgzrvgebpNloHlVROBisQa
	 l/nNITNZ5odE940c4+MlMzc0g7jVr4MnAQW/pSfD9+98l2Of2WDF26RTwHDdXbCvwlwb6
	 7qde1k8X6xdz4v3epvaOj6ggq/bGH0leuauSdyRuceM8mCqGO109Ht+M9T8oJqcMhxH2b
	 oy9ZSy/xsJ1EvTHDQYgtoyTg8GZZqReSRUQJqfvgq946ZUghnwINcRIa8GBrRZ+Qq0/Uk
	 IgtsG58BX9lN/y/VeDTiSOGeH3FgZWtthuiDNIHDPFJHl9DUOg1gwJglGiyoPKg/zBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oo9Gp+7X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05C7606A325;
	Wed, 18 Nov 2026 18:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oo9Gp+7X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D2C1F000C4;
	Wed, 18 Nov 2026 18:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026362;
	bh=E59ZsW0vQ+ds+FHjioIL9B6mq1vKEfu+pNRBHrfTs5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oo9Gp+7XSwzoBeKRhXr7SIZEOtl9bxO9yB9HTO8wsWXLbD9NFTXJx7JgDpZtNztDY
	 +Cn3WfX4320vARXPgKF6iriwmAkczX6wtLOod/y2kubsqFOOLdWCR8rbYdWs1xzCvK
	 VQ75CENsQwhQ4scxPd2BUlt63g0MDxGBgf8WudSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1407/2151] serial: max310x: support active-low RTS on the hardware path
Date: Wed, 18 Nov 2026 15:52:22 +0100
Message-ID: <20261118150213.232658096@linuxfoundation.org>
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

From: Tapio Reijonen <tapio.reijonen@vaisala.com>

[ Upstream commit 7b07356e820e9543cb5b64d009c345303aad0c65 ]

The chip's auto-RTS engine asserts the RTS_ pin high while data is
shifting out, so a transceiver with an active-low driver-enable could
not use the hardware RS485 path at all: SER_RS485_RTS_AFTER_SEND is
not in the supported flags and the core normalizes it away with
"invalid RTS setting, using RTS_ON_SEND instead".

The output stage is invertible: program IRDA.RTSINVERT when the
requested polarity is active-low and advertise SER_RS485_RTS_AFTER_SEND
in rs485_supported. A break already drives break_state onto the RTS
bit unadjusted, which remains correct because RTSINVERT inverts the
output stage itself, not the register value.

Assisted-by: Claude:claude-fable-5
Signed-off-by: Tapio Reijonen <tapio.reijonen@vaisala.com>
Link: https://patch.msgid.link/20261008-max310x-rs485-sw-delay-v8-6-6ba881f81e1f@vaisala.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 33632215e1bb ("serial: max310x: drive RTS in software when hardware delays are too short")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -162,6 +162,7 @@
 /* IRDA register bits */
 #define MAX310X_IRDA_IRDAEN_BIT		(1 << 0) /* IRDA mode enable */
 #define MAX310X_IRDA_SIR_BIT		(1 << 1) /* SIR mode enable */
+#define MAX310X_IRDA_RTSINVERT_BIT	(1 << 2) /* Invert RTS output */
 
 /* HDPIXDELAY accessor macros */
 #define MAX310X_HDPIXDELAY_SETUP(val)	(((val) & 0x0f) << 4)
@@ -923,7 +924,7 @@ static void max310x_set_rts_ctl_params(s
 	const unsigned int max_bit_dly = 15;
 	struct uart_port *port = &one->port;
 	unsigned int setup = 0, hold = 0;
-	u8 mode1 = 0;
+	u8 mode1 = 0, irda = 0;
 
 	if (port->rs485.flags & SER_RS485_ENABLED) {
 		/* Convert milliseconds to bit-times, rounding up. */
@@ -935,6 +936,12 @@ static void max310x_set_rts_ctl_params(s
 		hold  = min(hold,  max_bit_dly);
 
 		mode1 = MAX310X_MODE1_TRNSCVCTRL_BIT;
+		/*
+		 * The auto-RTS engine asserts RTS high on send; for an
+		 * active-low RTS let IRDA.RTSINVERT invert the output stage.
+		 */
+		if (!(port->rs485.flags & SER_RS485_RTS_ON_SEND))
+			irda = MAX310X_IRDA_RTSINVERT_BIT;
 	}
 
 	max310x_port_write(port, MAX310X_HDPIXDELAY_REG,
@@ -952,6 +959,8 @@ static void max310x_set_rts_ctl_params(s
 
 	max310x_port_update(port, MAX310X_MODE1_REG,
 			    MAX310X_MODE1_TRNSCVCTRL_BIT, mode1);
+	max310x_port_update(port, MAX310X_IRDA_REG,
+			    MAX310X_IRDA_RTSINVERT_BIT, irda);
 }
 
 static void max310x_break_ctl(struct uart_port *port, int break_state)
@@ -968,7 +977,9 @@ static void max310x_break_ctl(struct uar
 	 * The chip's auto-RTS asserts the transceiver only while FIFO data is
 	 * shifting out, and a break is not FIFO data. Disable auto-RTS for the
 	 * break duration and drive RTS manually so the break reaches the wire;
-	 * restore auto-RTS when the break ends.
+	 * restore auto-RTS when the break ends. For an active-low RTS,
+	 * IRDA.RTSINVERT already inverts the RTS_ output stage, so break_state
+	 * is driven as it is.
 	 */
 	if (break_state) {
 		if (!(port->rs485.flags & SER_RS485_ENABLED))
@@ -1399,7 +1410,8 @@ static int max310x_gpio_set_config(struc
 #endif
 
 static const struct serial_rs485 max310x_rs485_supported = {
-	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND | SER_RS485_RX_DURING_TX,
+	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND |
+		 SER_RS485_RTS_AFTER_SEND | SER_RS485_RX_DURING_TX,
 	.delay_rts_before_send = 1,
 	.delay_rts_after_send = 1,
 };


