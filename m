Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064832;
	b=xryJsK56EkKNszIQ9aUWe0s57zvg2pAaZ4U+4bR7w7LxnLRPQyWlIud2xoQJ2Wqi0zEX
	 5wl2mLkY52Pl+J1kl/lJotziMkr9zT/6Gc4lBTMsz93KLTUneQq6vWs30b3pkShlHMO0j
	 C4vjPkjYTu0I+6nh3M5rA3lsA1jNAyz5zeZQb0lhMHfNKkTzdGkTcHUVohcjhEUnGHDNY
	 DW8nYzXQ/4T9+HevbxNIVKez630hjulgMXZ9s0RxTIGmNwpFe8sgMyQKhRfMsHKsWyQt1
	 u2LOsZUON+aFpaidgKz7bSyPVooKSrdE/pwdNvKeOdqmDj3dw2C+U3fsAV5QVe3IHkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064832;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mOUYN5SZT0x8eX0Ku0FXVGcSZP/weX4rL+B/uduWfHs=;
	b=oQCOpf+PYIO3PmuOCFdirivm3osWLFSA7tVkqzBQCboU2v0NMU2Ayi8OVRGJ3uqp8ej3
	 FbaBxJTJp+kSWnK+YRpor2DbUDOVnu0/mE6e0EHplY762UB4TD7Rqs4SnZYF/Q38B1dPx
	 cwGzlKzuECAbfh4kdngdA1eFY11aReXizy47BLjBvY57fjhfSvH7n29VSwldBDNvrXAOs
	 LbeW4noC3mDrhxFXcJqXs+dLIp2DhIFQmS+jHul2cbr/2zfYTF38dYDbgvO7HO1b5w+7g
	 x6uTK2MQerKPm0GIofEsWqsArGaiL48gq/Vyf6we6QbIJsAyXCVXbPtIFcXvBMDNz+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnp7HShq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4900606A338;
	Sat,  7 Nov 2026 15:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnp7HShq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D4F1F008A1;
	Sat,  7 Nov 2026 15:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064831;
	bh=mOUYN5SZT0x8eX0Ku0FXVGcSZP/weX4rL+B/uduWfHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tnp7HShqHL0VEuoWo67MQa3C05E+/kgI8+UxAHHtOPglhgChW6CSNHyVW5d/+2r9s
	 /6rwj31U8/8cdbyUy+bABUUA5UqJqZu3TQIcd0lAoEzTfQpd1E2H1SERHbVvLFPxCn
	 004aeLCAbr6p/iOhxvDe4i7o6To1ejgBsN6K3xQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0763/1257] spi: cadence-xspi: fix stack buffer overflow in the Marvell b0 path
Date: Sat,  7 Nov 2026 08:50:59 -0500
Message-ID: <20261107135000.360794385@linuxfoundation.org>
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

[ Upstream commit ef9690269999ddf9b204731baca1bd6b7aea1aa7 ]

transfer_one_message_b0() falls back to a 10-byte stack buffer for
transfers which carry no TX data and points both in_buffer and
out_buffer into it.

With a transfer longer than 10 bytes the SDMA branch of the loop moves
up to MRVL_XFER_QWORD_COUNT * MRVL_XFER_QWORD_BYTECOUNT (256) bytes
through those pointers and then advances them by the same amount, so
both directions overflow the scratch buffer: a read transaction copies
SDMA data past the end of the buffer, a write transaction sends stack
contents from beyond it to the SPI bus.

Size the scratch buffer for the largest chunk the loop can request,
keep the buffer pointers pinned to it when the message does not carry
the corresponding TX or RX data, and only advance the pointers which
reference real transfer buffers. Also zero-initialize the scratch
buffer so that padding bytes sent for TX-less transfers no longer leak
uninitialized stack contents.

Fixes: 5cb7651f78e1 ("Marvell HW overlay support for Cadence xSPI")
Cc: stable@vger.kernel.org # 6.11+
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Link: https://patch.msgid.link/20260929081146.41041-3-liuwb@xiaopeng.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-xspi.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-cadence-xspi.c b/drivers/spi/spi-cadence-xspi.c
index 1f1cd45359d34..3687853e4ce4e 100644
--- a/drivers/spi/spi-cadence-xspi.c
+++ b/drivers/spi/spi-cadence-xspi.c
@@ -268,6 +268,7 @@
 #define MRVL_XFER_FUNC_START		 BIT(0)
 #define MRVL_XFER_QWORD_COUNT		 32
 #define MRVL_XFER_QWORD_BYTECOUNT	 8
+#define MRVL_XFER_MAX_LEN (MRVL_XFER_QWORD_COUNT * MRVL_XFER_QWORD_BYTECOUNT)
 
 #define MRVL_XSPI_POLL_TIMEOUT_US	1000
 #define MRVL_XSPI_POLL_DELAY_US		10
@@ -1107,7 +1108,7 @@ static int cdns_xspi_transfer_one_message_b0(struct spi_controller *controller,
 	struct spi_device *spi = m->spi;
 	struct spi_transfer *t = NULL;
 
-	const unsigned int max_len = MRVL_XFER_QWORD_BYTECOUNT * MRVL_XFER_QWORD_COUNT;
+	const unsigned int max_len = MRVL_XFER_MAX_LEN;
 	int current_transfer_len;
 	int cs = spi_get_chipselect(spi, 0);
 	int cs_change = 0;
@@ -1130,13 +1131,16 @@ static int cdns_xspi_transfer_one_message_b0(struct spi_controller *controller,
 	list_for_each_entry(t, &m->transfers, transfer_list) {
 		u8 *txd = (u8 *) t->tx_buf;
 		u8 *rxd = (u8 *) t->rx_buf;
-		u8 data[10];
+		u8 data[MRVL_XFER_MAX_LEN] = {0};
 		u32 cmd_regs[6];
 
 		if (!txd)
 			txd = data;
 
-		cdns_xspi->in_buffer = txd + 1;
+		if (rxd)
+			cdns_xspi->in_buffer = rxd;
+		else
+			cdns_xspi->in_buffer = data;
 		cdns_xspi->out_buffer = txd + 1;
 
 		while (t->len) {
@@ -1163,8 +1167,10 @@ static int cdns_xspi_transfer_one_message_b0(struct spi_controller *controller,
 				if (!cdns_xspi_is_stig_ready(cdns_xspi, true))
 					return -EIO;
 
-				cdns_xspi->in_buffer += current_transfer_len;
-				cdns_xspi->out_buffer += current_transfer_len;
+				if (rxd)
+					cdns_xspi->in_buffer += current_transfer_len;
+				if (t->tx_buf)
+					cdns_xspi->out_buffer += current_transfer_len;
 			}
 
 			if (rxd) {
-- 
2.53.0



