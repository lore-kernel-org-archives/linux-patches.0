Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064915;
	b=TTYVppppukCz6FNoYzlTvabALp1wBBSMUH+oEYHdM1IComMdoRE17edIBZBMQLdJjfZa
	 XWYtSQqzWpTJV4Y4ZlM7zRc8Nkw7L4jimhxIgoQ+rkH/KeSAoOsn0zQTf6J6EAJR7E2aQ
	 m7aedbNZAMCnYgtsg31Qx9Sk4rW5LzPfsQyd+Co+s+fItf78QziDFF+mY4w8cbtPzaVec
	 zh7xHVkuJKb982ydkCny/MVsz3hUYwx1YxTsDGN41HcTVhXoNhsPyj+vlr6uB44C5NpM2
	 q/h6/ioyBr1LBMw86eoHEPebFKY8FwYgLZqNf+QTGxnbe8yHn3ABJTUPWxdofy9nyYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0r6/+Wij0hvNlWQmulIQbNhap6m+17ys30shRdmKNgw=;
	b=LPPvCk7LdK7R1gVK0dqVf4R0OKm70qjFMr0fEEaP2bG+20rJ2cD5n4UONJ3EOmu/ROSc
	 E79OVgJ5K4/v/llOiHXMFVGZWQblEUrcROfb7he5AprcrcpjujYIZB9UH/VlQaZy/m+il
	 jyvOgrgKgGqi1upeOUQ93SkPSN/9DlC9ggwicakqM785hQCom8iQtcVA8el35wyphVcku
	 21LgPGZBXJXBpZxlrhsI+wmqQz/19WOzztXcd+BUNXRnjD1sbxkGBvg1YEhrXS3ikcQB6
	 ZjC/08LK1AClXCbVS3sO26mXI9bD8LjLHVtwsZHWn3UgpPddNHnN1deU1jiFDQsGxRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BlNfNhoA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596B6606A9FE;
	Sat,  7 Nov 2026 15:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BlNfNhoA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57E01F0089F;
	Sat,  7 Nov 2026 15:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064914;
	bh=0r6/+Wij0hvNlWQmulIQbNhap6m+17ys30shRdmKNgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BlNfNhoAfgxcRtIlogbigk1tNJuP7WA0tycQZHSopdMrh6J1kk/SdH9Um4YpuqcOh
	 ECqjVCq6nt5Fp0V9x6nJcybSd3KjEfFkOVhp7jY+u8Sus7Txetfi/7Md8M1fYp7+ZG
	 cCYFOSHyOKAq9ZzD4Q49W+rFoWsylshsDL0uM18o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0814/1257] spi: amd: fix len==0 underflow and FIFO overflow
Date: Sat,  7 Nov 2026 08:51:50 -0500
Message-ID: <20261107135001.828461577@linuxfoundation.org>
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
index 71a6e5c475b03..ddf89e5353c55 100644
--- a/drivers/spi/spi-amd.c
+++ b/drivers/spi/spi-amd.c
@@ -322,11 +322,22 @@ static inline int amd_spi_fifo_xfer(struct amd_spi *amd_spi,
 
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
@@ -369,6 +380,12 @@ static inline int amd_spi_fifo_xfer(struct amd_spi *amd_spi,
 
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



