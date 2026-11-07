Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061106;
	b=vCLwxE9nTEHg8w5rXTSUQKIuTQkuCXLMN0UBHJCp4YoTrPq4kyxdgMSHxypvFL0QRgzG
	 CknBC1bvaqBmJyv+owpUK9BP54t0bIgyEk2RfoNvOSGogO9JGxudymgBPetXNxby+GjIP
	 qGzoSDpSsuNMJ/4bPx8WJWe8QAwMbBS4vovdNh+7we54/AbiFfLL2MDhaXD3GGPpopro3
	 tDRYIqYF2FZ0qxrsW6mpkNq7o7zozPOPq5IEmi0uWBlx+mEAjg1sYKBRxb1Spdnp94ByD
	 vEzBfuNlEsghAeTgX30LdCj4RB5ENX2T2tdKc4Q8HyMGpjMrYjYB2f9XIN8jr/9HBcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061106;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mH3GOPB9pDHeRCdQQ5ytqHTwW5UOohnk2AUg6Ww3mjA=;
	b=mYSHs/iv3yuAlj+ZeEt6KZdUkCwYMSXTF5BOLBQ8bFM3dFaXAEOUxAL0oYuGu/5D5U25
	 klQ8ofKGZ+a4/W3JpHFUG86NmtKeUHKd7ulTUCEFOJ3xqvecbeoQRRSVCnhdjninQ85YT
	 bdc0Pt7N4M/1mQy8qsd+2UzLhFNDCHjyU0u0HtlIonqo3ay+SzFfeEqHQvuq66ReYbSYl
	 p+rMj67/h6B7GAI8lV3iFZTK1GH6DpRhdzy7qtonvt9r+m/sEIF3wO3jCFJFu5aIZvhtO
	 /0ZxyWVrxaIEiUX2+hYSgNpWFaxf5wQHZFuNPOuZXn51kTwyQpqE4dANbxNelqhdxwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Hk6Hckf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B24606D836;
	Sat,  7 Nov 2026 14:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Hk6Hckf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666421F008A2;
	Sat,  7 Nov 2026 14:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061105;
	bh=mH3GOPB9pDHeRCdQQ5ytqHTwW5UOohnk2AUg6Ww3mjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Hk6HckfrZMWpiD73CO75K0pMnFF1u4Bo6+2Fo0lpPJFzQZJ9nyxpBkC1SvoibQNF
	 E3sMvFRXMW1/8bPg3L+WOlAhx01D+6XQbxGhm18XcVSeV6ma0nFmOFExEuRps88A+z
	 uImnAk7bkG5dbc2B2Q7zfEw56Lvm38B6/Uo7tbk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0424/1536] spi: cadence-qspi: Fix status polling with octal DTR chips
Date: Sat,  7 Nov 2026 08:40:40 -0500
Message-ID: <20261107135009.480580655@linuxfoundation.org>
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
index da8401261bbc3..0e387dee17323 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1033,8 +1033,7 @@ static int cqspi_write_setup(struct cqspi_flash_pdata *f_pdata,
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



