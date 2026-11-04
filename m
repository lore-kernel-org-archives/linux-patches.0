Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831143;
	b=ZarGVghRNBufoZW7pXvw/UjyOPToPKegU+1nBAAw+1q3RDLvPH4MgFtKmO9RS2sG2gDb
	 W96DZaqzBrRzzcQ9hNj8mXimNM8EQX7TIMg31x2CzKnWYpF20YdLDFfPmmFvxQ+/x80Xy
	 LCgxS85FHQ12o3o9lJGMIms/vCaAJU9kjYbC9nHrorXojjNkoex7ZdzTxwzIp1WwjzF/b
	 Paypiyyr24XPEbflgSiagolw9POgaEqlWMQ72bgfPrU2OZNF5esTALplksvnmMnXzW9KI
	 pjPSC3iHpXgOQtKiTjr9rYJhst7/xOykEH5+TxLtC9XSGMpaXzJiviFHI63Aw+tvCKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UxP2Hsn/bddax4CqQPldhV+GZUUon4L6q5bV9sDzJiQ=;
	b=3ZYnR7J5GR+RB3HFPkyPT7EB1BQ4EcD6t6wCnD+KGcvhlf6ILi1qBOx44S6Eiq5HOov/
	 rc4P9a4LEufspCw1HgppDT8rLyv9JhaUG+i9IwZhH85mu+UjV+rc6m5ZBbl207ooLrgxW
	 2YXMag86aMUUuquanJJz1XlA4568utpRQWZWK7HPs+3b5e5vjy2vlhVNpESQGyOsavKM5
	 Ac3UdOgfZKXy9SsuIY3EKUrvXKwUGAfQSbxtKmqp7V9QcPLj9JCKuuzOFk+0ZNkR19Lfz
	 l1EW3Iupd7t4thZ3MrW9gCd7JZFbcHtU2iyd/3l/fPiG5uyabvbLBV48tWzSdPTeVYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NRYXWnpi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69B2606D812;
	Wed,  4 Nov 2026 22:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NRYXWnpi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5109B1F00919;
	Wed,  4 Nov 2026 22:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831142;
	bh=UxP2Hsn/bddax4CqQPldhV+GZUUon4L6q5bV9sDzJiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NRYXWnpirfQjh4fpPGNQ+G7y125Ha0Fy7FEBLeFG+X6jTiSksK/9+HB1YHXtrQ6dl
	 5j8WVQZ3NqNyN0ChJIqLv3ZLF8RV041G393azj7nxcjEHH1RG+CoAT2rKJp7y6wfpt
	 2vsTRv+MMhzPFD+g8AfaQBFIIo7hPeIPBiL01GFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0506/1005] spi: cadence-qspi: Fix status polling with octal DTR chips
Date: Wed,  4 Nov 2026 16:03:59 -0500
Message-ID: <20261104211058.111272240@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit fd99864b0ac936e870c7ae28354c5cd3dad5efd0 ]

Most SPI NOR chips today use 0x05 as ReaD Status Register (RDSR)
opcode. After almost every transaction, the core will wait for the said
transation to be digested by the chip by polling its status
register. This mechanism has been automated by certain chips, such as
the Cadence QSPI controller. Unfortunately, the feature has been
disabled for various (relevant) reasons. Disabling this feature has been
done by setting WRITE_COMPLETION_CTRL_REG.DISABLE_POLLING_FLD, keeping
the rest of the register intact. In this same register, there is also a
field named WRITE_COMPLETION_CTRL_REG.OPCODE_FLD, which by default also
contains 0x05, as primary RDSR opcode.

As a result, both the SPI NOR and SPI NAND cores, primary users through
spi-mem of the spi_mem_ops interface, do send their own RDSR. In this
driver, such command goes through one of the fifth possible data path
specifically crafted for short register-like commands, named STIG. In
STIG mode, the opcode of the operation is written to
OSPI_FLASH_CMD_CTRL_REG. This means that the opcode field of STIG
configuration and the opcode field of the automatic polling
configuration contain the same value.

Unfortunately, the TRM explains in two different places that this
configuration is forbidden, without explaining why it is problematic:

$12.4.2.4.11 OSPI Software-Triggered Instruction Generator (STIG)
```
OSPI_FLASH_CMD_CTRL_REG[31-24] CMD_OPCODE_FLD bits should be set
different than OSPI_DEV_INSTR_RD_CONFIG_REG[7-0] RD_OPCODE_NON_XIP_FLD
and OSPI_DEV_INSTR_WR_CONFIG_REG[7-0] WR_OPCODE_FLD.
```

and

$12.4.2.5.2 Configuring the OSPI Controller for Optimal Use
```
When using the OSPI Controller, the opcodes in
OSPI_DEV_INSTR_RD_CONFIG_REG[7-0] RD_OPCODE_NON_XIP_FLD,
OSPI_DEV_INSTR_WR_CONFIG_REG[7-0] WR_OPCODE_FLD and
OSPI_WRITE_COMPLETION_CTRL_REG[7-0] OPCODE_FLD bit fields shall not
match the opcode in the OSPI_FLASH_CMD_CTRL_REG[31-24] CMD_OPCODE_FLD
bit field.
```

For some reasons, this is only unveiled now when testing in ODTR
mode. Plain SDR modes work flawlessly with the same chips. One possible
reason for this, is that the internal data path in ODTR mode is
very different due to the extra opcode extension/repetition which may be
interpreted differently (this is a wild guess). For sure there is an
interference, as even the TRM states that there is some magic happening:

$12.4.2.4.13 OSPI Command Translation
```
The WREN and the RDSR device instructions are the only ones that are
sent by the controller under the hood.
```

I cannot probe the bus when the problem arises, so I don't know exactly
what is sent on the bus. Practically speaking, the chip was driving the
lines low (reading all 0s), which is not the usual default state when
the chip is not driving the lines (all 1s). Other people on the mailing
list claimed successfully using ODTR chips with this controller. My take
here is that either they were using a variant of the IP without write
completion at all (there is a quirk for it), or they were using chips
slightly more flexible about their opcode sequency or maybe with
different addr/dummy requirements.

Clearing the WRITE_COMPLETION_CTRL_REG.OPCODE_FLD while disabling write
completion polling entirely seems the best compromise.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20261001-winbond-spi-next-cadence-rdsr-fix-v1-1-ec5ff594ba5d@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 0a32e28eefd51..441426bc232ef 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1058,8 +1058,7 @@ static int cqspi_write_setup(struct cqspi_flash_pdata *f_pdata,
 	 * care of polling the status register.
 	 */
 	if (cqspi->wr_completion) {
-		reg = readl(reg_base + CQSPI_REG_WR_COMPLETION_CTRL);
-		reg |= CQSPI_REG_WR_DISABLE_AUTO_POLL;
+		reg = CQSPI_REG_WR_DISABLE_AUTO_POLL;
 		writel(reg, reg_base + CQSPI_REG_WR_COMPLETION_CTRL);
 		/*
 		 * DAC mode require auto polling as flash needs to be polled
-- 
2.53.0



