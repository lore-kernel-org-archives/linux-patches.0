Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036647;
	b=GTTAJ9LxneFQiWlmUisWjs+3Bj9Nytt+BzDvcOdQX7Sx/JbdpiOG4EAGfKIs8SYbFFlP
	 PUxzTmqn1hBmuR9VBDQfPeEp0ExC0DgFFl2yaCzdlP0T6NFhYSu+rN8ELRwTOnjsv5GfR
	 Zvlx7NuAvW3vpzXR8uPF2lZ44KDORCQhI18Y9XCTtzmULzY2Rq2IZAKBvMNwkLPDHrZjy
	 Pmo7UNEP13XTjPNTaOCRNnEgs2gJSCU/TrLMTPnP2+vCGB0OTzzfPJhln5JPQKaLXnpv+
	 N+Xbwcjd2xW4gAXAvCWEfoWBzI43nuAuUOWJ12PM35G0F91uoCmWCynlisjhHORd20Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036647;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hXCrrOB7kOiSkNDn781QyA4wpaddeY5vMfno4xibA7s=;
	b=WRnQLdFJ2qNYmD+tn3J4w4oga2+j7sTVYH0XqqIdm6I9lalfI+SSdrNJuHKwKnMlC6Zb
	 x7zLX9uUFQ9REM3CRmk1+ysB8RoDiPvCe/jSCokIW44fsifbHOqr7jYZpzpOYP1UcasS+
	 EfbWzGLiQFePwR+potdK/d+AWjLq1vp1CErcBn6q5mOrtPtsvdETRoG5YnIjk1PtgmDsD
	 yuvUyUeUKEB/Usj/e7DoEehppVa8ag2Yi9ZoKUBNfKS9VYSb9aoBN2Ufl0k1TNAS4Vonq
	 esTluktnvumAPyKlYxMRNJHD91FCwmFiUGLp2K5j8CPPk3D1gV8Ey94VeU9dJxUX5ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ngs9BJ7I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36FA606A32F;
	Wed, 18 Nov 2026 21:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ngs9BJ7I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF231F000C4;
	Wed, 18 Nov 2026 21:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036646;
	bh=hXCrrOB7kOiSkNDn781QyA4wpaddeY5vMfno4xibA7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ngs9BJ7IejzY8frFOFTSv1ZDPD2iUVL86quSp5ta+vFBhhZ7+cXFIokr6qEOhsmv3
	 isQFXPz/Z9hqs3FF7Xm6pJFPZ3W3wI101wlJZvotlASR4yuOg9itNfAova7fMMgvvt
	 kZd/gNuadgb8HACoFqvbDzozqNHrBvIIaWH8kysw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishnamoorthi M <krishnamoorthi.m@amd.com>,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1134/3318] spi: amd: validate FIFO usage before executing message
Date: Wed, 18 Nov 2026 15:29:16 +0100
Message-ID: <20261118150354.068417207@linuxfoundation.org>
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

From: Weibin Liu <liuwb@xiaopeng.com>

[ Upstream commit aed0c7475d6af333fb9b37848ed5e4f92a808ffa ]

The RX FIFO bound is checked in the drain loop, after
amd_spi_execute_opcode(). A message whose cumulative RX length exceeds
AMD_SPI_FIFO_SIZE can therefore issue an SPI transaction before being
rejected.

Check tx_len + rx_len while walking the message and drop the drain-loop
check. This validates the complete message before executing the command.

Tested with a user-space replica covering TX, RX and mixed messages at
the 70/71-byte boundary. Oversized split-RX messages are now rejected
without executing the command. No AMD SPI hardware was available.

Assisted-by: LLM
Suggested-by: Krishnamoorthi M <krishnamoorthi.m@amd.com>
Fixes: e2f4edfc061e ("spi: amd: fix len==0 underflow and FIFO overflow")
Reviewed-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Link: https://patch.msgid.link/20261027021340.914399-1-liuwb@xiaopeng.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-amd.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/spi/spi-amd.c b/drivers/spi/spi-amd.c
index eb0f38d1522c8..689511c6babc5 100644
--- a/drivers/spi/spi-amd.c
+++ b/drivers/spi/spi-amd.c
@@ -293,13 +293,6 @@ static inline int amd_spi_fifo_xfer(struct amd_spi *amd_spi,
 		else
 			amd_set_spi_freq(amd_spi, spi->max_speed_hz);
 
-		/* Reject transfers that would overflow the FIFO window */
-		if (fifo_pos + xfer->len >
-		    AMD_SPI_FIFO_BASE + AMD_SPI_FIFO_SIZE) {
-			message->status = -EMSGSIZE;
-			goto fin_msg;
-		}
-
 		if (xfer->tx_buf) {
 			buf = (u8 *)xfer->tx_buf;
 			if (!tx_len) {
@@ -308,6 +301,10 @@ static inline int amd_spi_fifo_xfer(struct amd_spi *amd_spi,
 				xfer->len--;
 			}
 			tx_len += xfer->len;
+			if (tx_len + rx_len > AMD_SPI_FIFO_SIZE) {
+				message->status = -EMSGSIZE;
+				goto fin_msg;
+			}
 
 			/* Write data into the FIFO. */
 			for (i = 0; i < xfer->len; i++)
@@ -317,8 +314,13 @@ static inline int amd_spi_fifo_xfer(struct amd_spi *amd_spi,
 		}
 
 		/* Store no. of bytes to be received from FIFO */
-		if (xfer->rx_buf)
+		if (xfer->rx_buf) {
 			rx_len += xfer->len;
+			if (tx_len + rx_len > AMD_SPI_FIFO_SIZE) {
+				message->status = -EMSGSIZE;
+				goto fin_msg;
+			}
+		}
 	}
 
 	if (!buf) {
@@ -342,12 +344,6 @@ static inline int amd_spi_fifo_xfer(struct amd_spi *amd_spi,
 
 		list_for_each_entry(xfer, &message->transfers, transfer_list)
 			if (xfer->rx_buf) {
-				/* Reject transfers that would overflow the FIFO window */
-				if (fifo_pos + xfer->len >
-				    AMD_SPI_FIFO_BASE + AMD_SPI_FIFO_SIZE) {
-					message->status = -EMSGSIZE;
-					goto fin_msg;
-				}
 				buf = (u8 *)xfer->rx_buf;
 				/* Read data from FIFO to receive buffer */
 				for (i = 0; i < xfer->len; i++)
-- 
2.53.0



