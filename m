Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062451;
	b=wwCDVGWNZGRFcMu8Q3odkuX1IoC2uBI1sncEIaq0Q8WEuzj+0vOZTlSjoQNo+L9i58cz
	 c/voqyeVNL2Vih9325gjevcg7vtwL4b3By2R15m3kYmGaHWBG4XR40/P46TEfMLHKYEcm
	 VJrgA9WJdJk48yqEd0Qzouh3eQ/+ZvpA9gV/xxqSVZwj/BUn7R78zpjqrLCAKMWilZcGN
	 5u7xX+3a+mB8ok6kRVJy7Z/xOClDPKW9lKQmxcjwxJsONk77oS7XKnZ9cLwZtJOSLNj9M
	 ozZAGeDnmr6d8y6UY2ANZ6Jpo2onXsFIe+hLnz0KRKBSduZQxpO1PqshVrMhNzRw6tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZzQq02t7vGoSPw9kfQ2zBqgDRdIDSyjqONi8UacX150=;
	b=Pg3ThNUm4Trxx+R+PfQFqD5dwV1gwe32er2PNDvk6BG3p4s1+VPmK468iYYsRyYL5RGB
	 TDUXZ3iWzfY0PACBf+nq/d51lonTzmpfHcGbEx+QfXxNRtuQFVBYKDhEwl+N6m4bZoKBF
	 LEqYeYprbo4q4Y/cVjxZsDYtMUwxWNlo3iEb7hmHuoHHHE0/XHnLm3kde9Mv6W+M7ZsLb
	 eK9Bzc7MPmG1qk90/y/0/6PaexLqHaYzx8F4b3dtSdyrwQf+oJtJ1aQrnyRuiVECNPDoz
	 ELUszXRSyxu64P57Ots+OyPGNMkWrIJgz1idi1SEsS5MjZQoThAoYF6q0uTfMBVTgiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0OxEo4fJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35567606A642;
	Sat,  7 Nov 2026 14:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0OxEo4fJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88D11F0089F;
	Sat,  7 Nov 2026 14:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062451;
	bh=ZzQq02t7vGoSPw9kfQ2zBqgDRdIDSyjqONi8UacX150=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0OxEo4fJn5u4MfdhF4e/XLKP+4oAnlfnw2QEtg/nSI0Tv09tN1d5Zh3lryN8B00KA
	 KW2KP9bJitaryQO16rEmBQ8qxqcoEJRwv+HiquCKMP5gqXNZpb8XaXEgdrFQSqpJKp
	 sJ3fVE3wBONjlj/kWJ0VlI4ucimPag/btLt5bVpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1322/1536] spi: amd: fix len==0 underflow and FIFO overflow
Date: Sat,  7 Nov 2026 08:55:38 -0500
Message-ID: <20261107135034.942179851@linuxfoundation.org>
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
index 2245ad54b03aa..8f8d1ac4f722d 100644
--- a/drivers/spi/spi-amd.c
+++ b/drivers/spi/spi-amd.c
@@ -286,11 +286,22 @@ static inline int amd_spi_fifo_xfer(struct amd_spi *amd_spi,
 
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
@@ -333,6 +344,12 @@ static inline int amd_spi_fifo_xfer(struct amd_spi *amd_spi,
 
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



