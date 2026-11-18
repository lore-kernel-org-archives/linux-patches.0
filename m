Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035981;
	b=fFVYHtGFwgveX0taC0/GyY2dD/uH2MMznpbeKF/aUwp9inxl2srFnJowHv91b5ypWYUi
	 ht28P6EX58lQ0tE69zqh7jSPxIub9qdyKgDXcMJDZ+m3sNvbLoctqe/OYhTJdWcUmnhDP
	 82SYN9mDe/nr9LdtnapuUGTz4jJSm+5tDdlRvoujSxrDkRJJA8gQooyFQwSXIBjgLLBZ3
	 fy8BYTHAWJg0tvGU1pKa9nBv7YwFDgwtc0phjR+IiwZohe/xEmdCIGUQCZ3o7L9NLZnEw
	 h/Cm/jMJ4KP6b7kLVNnTNol7lnHjBRdb2hFkSzHc89I8alwEcqXgG4XVB+fyNSi9LXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/tjCnXIkZtq15o9BfwHctprL9tGO2pksIT1eaSYUUMI=;
	b=3e4tc1YH58oXaQk+tgeJo06Lj01LLpkw9gQBhyNABTa8YFZBrhyH1CtqzkbtQLrsQL+f
	 l4Z6dVqkqIn44qjS7nFgZh2DdUyAwE6//kVKHsD8HXFl40SLiap2OSw2Zw/LJnEPsfbpd
	 Q3EwLvhVP3+jPW+t7/C+cENFcwNi/4BZVNwIei6rarqZMY3ZtmG0GqILPqgZ4R8R2QqYM
	 xtNK723axEZfNGPu2sgcNiCxEWxxKPTuQvHDkeZMF6OYrLJDxq8ehmtZWHj3XHhXtENem
	 E3Sb3/8bbRxBgGKJzb9UkicP2xPglocsAg7NI0SmwDIG+yu8wJf4gSX5Wx+pPJKOwcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p734z1vc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5399606A31C;
	Wed, 18 Nov 2026 21:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p734z1vc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0704F1F000C4;
	Wed, 18 Nov 2026 21:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035981;
	bh=/tjCnXIkZtq15o9BfwHctprL9tGO2pksIT1eaSYUUMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p734z1vcQTRrCCBqpeKir7AIMRXThKvYdjaAdDNAVgj9iQPXcK1xXTprFDZga30ES
	 yqj+ny3TTPZ/haCMolIKH7PpksvgvNiLvXvK8RD38x/Jy2PV3grGN2NODWY3OAAAc1
	 JgxScw3MHjQoor+FL8bJuAjQUi9qPw43C4ZFcI7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0896/3318] ata: libata-scsi: abort multi-sector pass-through commands when multi_count is 0
Date: Wed, 18 Nov 2026 15:25:18 +0100
Message-ID: <20261118150346.339633157@linuxfoundation.org>
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

From: Hui Peng <benquike@gmail.com>

[ Upstream commit 3bab8c7e0c6ba187a47163a1f71477213a278c48 ]

When an ATA_12, ATA_16, or ATA_32 pass-through command with a
multi-sector PIO command opcode (ATA_CMD_READ_MULTI,
ATA_CMD_WRITE_MULTI, ATA_CMD_READ_MULTI_EXT, ATA_CMD_WRITE_MULTI_EXT, or
ATA_CMD_WRITE_MULTI_FUA_EXT) is submitted via SG_IO on a device where
multiple-sector mode is not configured (dev->multi_count == 0),
ata_scsi_pass_thru() currently logs a warning and still dispatches the
taskfile. When the DRQ interrupt fires, ata_pio_sectors() triggers
WARN_ON_ONCE(qc->dev->multi_count == 0) and computes
nsect = min((qc->nbytes - qc->curbytes) / qc->sect_size, 0) = 0, failing
to transfer any sectors:

  ata1.00: invalid multi_count 1 ignored
  WARNING: drivers/ata/libata-sff.c:666 at ata_pio_sectors+0x27d/0x300
  Call Trace:
   <IRQ>
   ata_sff_hsm_move+0x211/0x22e0
   __ata_sff_port_intr+0x1c8/0x520
   ata_bmdma_port_intr+0xa1/0x5b0
   ata_bmdma_interrupt+0x1f5/0x550

Per ACS-3 section 7.12.7.21, if IDENTIFY DEVICE word 59 bit 8 is cleared
to zero (multi_count == 0) and a READ MULTIPLE or WRITE MULTIPLE command
is received without a preceding successful SET MULTIPLE MODE command, the
device returns command aborted (ABRT). Per the SAT specification, an ABRT
error translates to the ABORTED COMMAND sense key with NO ADDITIONAL SENSE
INFORMATION (0x00, 0x00).

Fail multi-sector taskfile commands in ata_scsi_pass_thru() with
ata_scsi_set_sense(dev, scmd, ABORTED_COMMAND, 0, 0) when
dev->multi_count == 0.

Fixes: 1dce589c38c3 ("libata passthru: support PIO multi commands")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Hui Peng <benquike@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20260921032556.1160734-1-benquike@gmail.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 4b6b4ea65adb3..ebbed8bb5e8e3 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3156,6 +3156,11 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	if (is_multi_taskfile(tf)) {
 		unsigned int multi_count = 1 << (cdb[1] >> 5);
 
+		if (!dev->multi_count) {
+			ata_scsi_set_sense(dev, scmd, ABORTED_COMMAND, 0, 0);
+			return 1;
+		}
+
 		/* compare the passed through multi_count
 		 * with the cached multi_count of libata
 		 */
-- 
2.53.0



