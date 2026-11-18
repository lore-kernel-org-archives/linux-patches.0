Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053140;
	b=e7TavKjPg2Xk0jqHI6DWI6xlVSua8CQ1L0lo4uUcK5Ex6hZWHtgQYHjM67XRy+3hfaVt
	 +ikIzXtkh4UP/c6E4BBil2OhCfZBJYbO3XBnvy1sOvEeVAvooR6uDq2zTh3qOUE3r0yYd
	 enoY4QTX0p/nqN/zIm07V66L6WB758tchZzRuWtpI5fJyFr1fi1rodcWyNXynaNJ0veZp
	 KMAYH9l8Xd2THU9cek+88cIU482URIk7GUbpk0BHSsMdmjzn+crO6C4+GpDTxwiJKho13
	 S2HBxVcVSsalYrMr7LvxX6ms2xv7eoxPmNt5YwkF8fzJajGJAmccZqG85i8cLdBhIFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tlQ5LeHWTJMy4I0WRlXzaW6dOt/9K0RTuDAW5D2Yy9Q=;
	b=q8XMwmXOfo9MhknBrowoeZlfC43Uvi3IPfcqyny+GcAtQ3EjO3M3UxFEHJVn86u5Y67k
	 4XqbuwlTiJwHxTW4WYgULsEQs9NunvKXmjEtC/wUtxNcu8c74ktAi4kT1ttUsizWft8B5
	 fxhVnedsTrqlgv4CaAitlQCjXXW3MrB2cFJnAYKFGEbSJlwnyfo3G5P/jIia1mbR+coXA
	 VQOWxgkOXnAtu1vRChfJjq9GRUGQ328gJUWQuZr85SYgF0PemETb/FwS8hGEFUBNZTnxs
	 68lmTvjMLip2LcPx4vwKr1/bhy0w+dON0GCLa514X8t7tKryr9xIytB3LiPJJDlj5hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GCG3aO5O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCC8606A32C;
	Thu, 19 Nov 2026 01:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GCG3aO5O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDB71F000C5;
	Thu, 19 Nov 2026 01:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053139;
	bh=tlQ5LeHWTJMy4I0WRlXzaW6dOt/9K0RTuDAW5D2Yy9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GCG3aO5OXA/5ekEp6QQaFB7kr7HZczcZ68LnG96mpLhvtp/GX7rx1BNMeV65BoGOt
	 vhJb0zDMFkWtWh85Z7/UYicfgkvjzyPpCaRX0B8cr2Njxd/QSKHH4WiA304G5yJdLN
	 H+bfTunFCLTT3drHXzpoplR/MX9o34GMlATS5Me0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pufan Jin <cyan2254650260@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0813/2214] spi: zynq-qspi: fix address buffer corruption and support 4-byte address
Date: Wed, 18 Nov 2026 15:41:29 +0100
Message-ID: <20261118150044.026031248@linuxfoundation.org>
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

From: Pufan Jin <cyan2254650260@gmail.com>

[ Upstream commit dc5ca34f5e8dc10c566ef39aa3b1a201a17ca734 ]

In zynq_qspi_exec_mem_op(), when transmitting address bytes, the driver
iterates over op->addr.nbytes and populates xqspi->txbuf[i]. However,
xqspi->txbuf is never re-assigned before populating the address, meaning
it still points to (u8 *)&op->cmd.opcode from the command phase.

This causes two severe issues:
1. Memory corruption: Writing into xqspi->txbuf writes past the opcode
   buffer on the stack (which was passed as const struct spi_mem_op *).
   If opcode is zero, xqspi->txbuf is uninitialized.
2. In zynq_qspi_supports_op(), operations with op->addr.nbytes > 3 are
   rejected. When paired with SPI NOR flashes larger than 16MB (such as
   Winbond W25Q256), spi_nor_spimem_check_read_pp_op() tests 4-byte address
   support, which fails and causes spi_nor_select_read() to drop all read
   capabilities, failing probe with -EINVAL (-22).

The Zynq-7000 QSPI controller hardware in manual I/O mode natively supports
transmitting 1 to 4 address bytes via its TXD FIFO registers
(ZYNQ_QSPI_TXD_00_00_OFFSET).

Fix this by introducing a local opaddr[4] buffer in zynq_qspi_exec_mem_op()
and explicitly setting xqspi->txbuf = opaddr before populating address
bytes. Also allow up to 4 address bytes in zynq_qspi_supports_op().

Fixes: 67dca5e580f1 ("spi: spi-mem: Add support for Zynq QSPI controller")
Cc: stable@vger.kernel.org
Signed-off-by: Pufan Jin <cyan2254650260@gmail.com>
Link: https://patch.msgid.link/20261016130812.282624-1-cyan2254650260@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[ resolved context conflict due to mem->spi->master in 5.15 ]
Signed-off-by: Pufan Jin <cyan2254650260@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynq-qspi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-zynq-qspi.c b/drivers/spi/spi-zynq-qspi.c
index f1c1047c949ad..43c4180fb88e0 100644
--- a/drivers/spi/spi-zynq-qspi.c
+++ b/drivers/spi/spi-zynq-qspi.c
@@ -231,7 +231,7 @@ static bool zynq_qspi_supports_op(struct spi_mem *mem,
 	/*
 	 * The number of address bytes should be equal to or less than 3 bytes.
 	 */
-	if (op->addr.nbytes > 3)
+	if (op->addr.nbytes > 4)
 		return false;
 
 	return true;
@@ -535,6 +535,7 @@ static int zynq_qspi_exec_mem_op(struct spi_mem *mem,
 				 const struct spi_mem_op *op)
 {
 	struct zynq_qspi *xqspi = spi_controller_get_devdata(mem->spi->master);
+	u8 opaddr[4] __aligned(4);
 	int err = 0, i;
 	u8 *tmpbuf;
 
@@ -561,11 +562,12 @@ static int zynq_qspi_exec_mem_op(struct spi_mem *mem,
 
 	if (op->addr.nbytes) {
 		for (i = 0; i < op->addr.nbytes; i++) {
-			xqspi->txbuf[i] = op->addr.val >>
+			opaddr[i] = op->addr.val >>
 					(8 * (op->addr.nbytes - i - 1));
 		}
 
 		reinit_completion(&xqspi->data_completion);
+		xqspi->txbuf = opaddr;
 		xqspi->rxbuf = NULL;
 		xqspi->tx_bytes = op->addr.nbytes;
 		xqspi->rx_bytes = op->addr.nbytes;
-- 
2.53.0



