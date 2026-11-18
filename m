Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054105;
	b=kUCloeum4Nio0fKa0RIRRRMfZDQh8JB/4L+62yeaKuvGjSd37Q+6iCXjr5j3x6kh62qQ
	 HKk4x1WdRdM6xFSnC182Veb59ikQE/rAIS9ZAWVYSjFdwKpVZ3/0caLcczdiGopNE0nPz
	 rWSWR5J4Clu2BqXDJ0Ful5S25UieFSqnzR/Wz2AbuLOoKGmOJewbj8QeSFbfsIJ7jnjfa
	 vUD8FuVIM/Ni4Y7i9Xs76hjDVCYyL4byjboXNTMRoSAXoBosAz4ZUW9ySlTHzkpwbggjN
	 +7puyQBthjtVgBWGA62qgIgyYPWbLxTFtavU7Mbe39/MeqsCkElm1UATEmdE6F/2ccQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t3BU1IyHyTzIQ47QrC01AEfdZzN1fivPt8tZ28DB3WM=;
	b=oSAb8eq/wOGebDXw0CL3XIyTjm6/0bK6qB2BiG8SaXvecK8JaqhKyGmeldktV9ZmYx2C
	 UUnrD48DxqaCVB23NEK4z6KKd6+rVmdovdZ5fI0srs7Dgja7m6BhKKSF+M2nMKDYZowm9
	 RYn17IuFKc0FWlKn9rR2PTGATsyCXNf1tCgdlIgj0gmfijuVdnXN9Q8dt8G3XBlCF0+6T
	 2GNdpspLpZto5Vl5kb8zQvhbPFTgB86rP8jfZkU7faAiljsvjdlu7bmzmyyerptujp1zC
	 2iyV4VfFJso5VY2KSelZ1zb54GpbgO5GyTFap5kZ4ZWMjy6Tj56WNI7xnzvbtk+dOGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EOsMe0CR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50162606A31C;
	Thu, 19 Nov 2026 02:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EOsMe0CR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20D41F000C4;
	Thu, 19 Nov 2026 02:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054105;
	bh=t3BU1IyHyTzIQ47QrC01AEfdZzN1fivPt8tZ28DB3WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EOsMe0CR2dwasU0i+mleYOqzX5bdyB5C71+aezoiPIF3752WERpCw3MIlbCeCaow0
	 t6Iwdu9KdABpD9XcJwyOGUY6kaaFuQ1/ADpK4SsWSs1p3H/nzZoq7Gx0m8TtZVmd0f
	 H8mLKL1Y8fi3VSULwQvm10rJLmdYVAcunyo3jcak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lino Sanfilippo <LinoSanfilippo@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1154/2214] serial: amba-pl011: remove redundant code in rs485_config
Date: Wed, 18 Nov 2026 15:47:10 +0100
Message-ID: <20261118150058.145764532@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lino Sanfilippo <LinoSanfilippo@gmx.de>

[ Upstream commit a9efa452486ed59b38f15c2287d3e7e129f6e7fc ]

In uart_set_rs485_config() the serial core already

- ensures that only one of both options RTS on send or RTS after send is
  set

- nullifies the padding field of the passed serial_rs485 struct

- clamps the RTS delays

- assigns the passed serial_rs485 struct to the uart port

So remove these tasks from the code of the drivers rs485_config() function
to avoid redundancy.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Link: https://lore.kernel.org/r/20220410104642.32195-3-LinoSanfilippo@gmx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 97f85204275a ("serial: amba-pl011: keep transmitter enabled when disabling RS485")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/amba-pl011.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index a5340c5e11b10..7b21907cd14dd 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2241,25 +2241,11 @@ static int pl011_rs485_config(struct uart_port *port,
 	struct uart_amba_port *uap =
 		container_of(port, struct uart_amba_port, port);
 
-	/* pick sane settings if the user hasn't */
-	if (!(rs485->flags & SER_RS485_RTS_ON_SEND) ==
-	    !(rs485->flags & SER_RS485_RTS_AFTER_SEND)) {
-		rs485->flags |= SER_RS485_RTS_ON_SEND;
-		rs485->flags &= ~SER_RS485_RTS_AFTER_SEND;
-	}
-	/* clamp the delays to [0, 100ms] */
-	rs485->delay_rts_before_send = min(rs485->delay_rts_before_send, 100U);
-	rs485->delay_rts_after_send = min(rs485->delay_rts_after_send, 100U);
-	memset(rs485->padding, 0, sizeof(rs485->padding));
-
 	if (port->rs485.flags & SER_RS485_ENABLED)
 		pl011_rs485_tx_stop(uap);
 
-	/* Set new configuration */
-	port->rs485 = *rs485;
-
 	/* Make sure auto RTS is disabled */
-	if (port->rs485.flags & SER_RS485_ENABLED) {
+	if (rs485->flags & SER_RS485_ENABLED) {
 		u32 cr = pl011_read(uap, REG_CR);
 
 		cr &= ~UART011_CR_RTSEN;
-- 
2.53.0



