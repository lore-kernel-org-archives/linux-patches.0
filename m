Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045561;
	b=t1hItqceNZnPPakHK9TveqB+Uq7hG+hRY2AHeUMULyfb0LrTkEyqydZqi7F3lSK7YOm2
	 BseShOiRClpLdHBR8qcw9CBmvEZkUKxYQdYFf3+UG/Jswwc+AO2HIRf5UYpCXWrgGLS9A
	 BiSEieYAS9qK0PJIkefA1O8M6UUD+5rh3/0eipulWgg6akBta3qlXpYFWo7i3pn9yqQck
	 sCBbvtFWQAyz/cIERWOxfWIALNPX/Uz3pf6MlYv5mHHsfZ6kllxt80oFW6dxWMlm96Gew
	 isEf6jXbWP8OAHNWA6idC0aurS3MqEeNLraJY2wQzgWS+6HwNlSBaG31KCUfrv/qfzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cGYLdjDLHdHmJXrxMSvl4CQt3Oop5SKn4y41lzGwCZA=;
	b=X4Wz7ARmI4NHCd2jSWpaHg+lnsA7EOx998h/gWYLdqAE67J56gv5pY9B3RZbw+OZCBSc
	 sayzFY6Ij2kv01eEdMnY5rnuVwpQ94vqYXH3L87QuCr+Od6zeRCG9xb3okFFSBQyP0coU
	 JYTp/G41NrmEo6R/MMnCd1NBEhDOuvxy9/SKXS6fPjjfs5Ms2YTajD82i6BUgY0V9VZ8m
	 iZbSmzbzf74I321lDsKnQNHEfyTEQlWHfTcJAfesbA8nsk7TVde7jXom42qkVLCdUEQHq
	 LlnB/Ir/gs9atLu8EmL5VsGFuTZMaVJ3XNnCYHRdv9nIJWyLrQZmxP1k9NSZk6ueVLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bho2fdFn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB1D606A320;
	Wed, 18 Nov 2026 23:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bho2fdFn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF051F000C4;
	Wed, 18 Nov 2026 23:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045561;
	bh=cGYLdjDLHdHmJXrxMSvl4CQt3Oop5SKn4y41lzGwCZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bho2fdFn8WlMYL67WUM3WAmpbuzejF0+kry+0lE3d7o+gMjUXSgwrCHahm1fq/NOr
	 gO3Ss8nDp/KY/bY4Sefcy+jwLaENLCqbu03x+Eo6wtc1PRdj8eKyeIhlPdQKT4Bbyt
	 7HLQYAaObJgNmc7RVc8joUUOfhuDti7jssDWbvw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0967/2857] spi: amd: fix len==0 underflow and FIFO overflow
Date: Wed, 18 Nov 2026 15:33:21 +0100
Message-ID: <20261118150236.423436793@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weibin Liu <liuwb@xiaopeng.com>

[ Upstream commit e2f4edfc061e493fddde16c4bbe1c4f230f41e4a ]

amd_spi_fifo_xfer() unconditionally decrements xfer->len when a tx_buf
is present. The SPI core does not reject zero-length transfers, so a
transfer submitted through the SPI_IOC_MESSAGE ioctl with len == 0 and
a tx_buf makes the u32 len wrap to 0xFFFFFFFF, and the following
per-byte loop writes far past the FIFO window.

The driver also never checks the cumulative FIFO offset against
AMD_SPI_FIFO_SIZE. The core splits each transfer down to the
controller's max transfer size but does not bound the total message
length, so a message of several transfers whose total exceeds the FIFO
overflows it with out-of-bounds MMIO writes (tx) and reads (rx).

Skip zero-length transfers and reject any transfer that would run past
the end of the FIFO window.

Tested with a user-space replica of the fifo_xfer length arithmetic
(ASAN build): a zero-length transfer with tx_buf makes len-- wrap to
0xffffffff, and skipping zero-length transfers avoids the wrap. No AMD
SPI hardware was available, so the FIFO bound check was verified by
inspection against AMD_SPI_FIFO_SIZE.

Fixes: bbb336f39efc ("spi: spi-amd: Add AMD SPI controller driver support")
Cc: stable@vger.kernel.org # 5.8+
Reviewed-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Link: https://patch.msgid.link/20261014-spi-amd-fifo-fix-v1-1-9fec9ab753e8@xiaopeng.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-amd.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/spi/spi-amd.c b/drivers/spi/spi-amd.c
index 357d46651f609..bdb4c486d53a9 100644
--- a/drivers/spi/spi-amd.c
+++ b/drivers/spi/spi-amd.c
@@ -284,11 +284,22 @@ static inline int amd_spi_fifo_xfer(struct amd_spi *amd_spi,
 
 	list_for_each_entry(xfer, &message->transfers,
 			    transfer_list) {
+		/* Skip zero-length transfers to avoid len underflow below */
+		if (!xfer->len)
+			continue;
+
 		if (xfer->speed_hz)
 			amd_set_spi_freq(amd_spi, xfer->speed_hz);
 		else
 			amd_set_spi_freq(amd_spi, spi->max_speed_hz);
 
+		/* Reject transfers that would overflow the FIFO window */
+		if (fifo_pos + xfer->len >
+		    AMD_SPI_FIFO_BASE + AMD_SPI_FIFO_SIZE) {
+			message->status = -EMSGSIZE;
+			goto fin_msg;
+		}
+
 		if (xfer->tx_buf) {
 			buf = (u8 *)xfer->tx_buf;
 			if (!tx_len) {
@@ -331,6 +342,12 @@ static inline int amd_spi_fifo_xfer(struct amd_spi *amd_spi,
 
 		list_for_each_entry(xfer, &message->transfers, transfer_list)
 			if (xfer->rx_buf) {
+				/* Reject transfers that would overflow the FIFO window */
+				if (fifo_pos + xfer->len >
+				    AMD_SPI_FIFO_BASE + AMD_SPI_FIFO_SIZE) {
+					message->status = -EMSGSIZE;
+					goto fin_msg;
+				}
 				buf = (u8 *)xfer->rx_buf;
 				/* Read data from FIFO to receive buffer */
 				for (i = 0; i < xfer->len; i++)
-- 
2.53.0



