Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058230;
	b=2Y+e4DnUt+w+WaMfUTkaIxbvz3dti5+ub3c/Nf4TI2uDI6Kwf9ZZwMRTqFIND8FOieNi
	 m9yXkD64zmWPtCh0mf+fZdcnHSYD5aXdwnU34dilct72JsfHjuV/lJOkR7PUA7EAEmP3S
	 4QkUh3jYMljvnQdJtS9A59atFa050LBBNwvQ4CG9odSOkxFZa0QFjRN4sOOOTxu/yEl85
	 ufu7TOaQqrV9KplLZJAuI675V0at2fRNC036vpOvqi5uSZCxNx9XxbpMB/pqyJDaAF1k0
	 eKZ9/PjY9mki3G0IdlluJBTxpGFScUpU93J+dpXczHbB8rcaN9EN4ZCyOLK3qgI6h8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4yW0SuWpzwFnbV0zfxJ7xPH0agstfedB+QbG3Hmk5qU=;
	b=H8q6hcrEoirWq/PAa+e4uGtf7b94wSMSMK2O4ChlUkDY2S2KR2KiFFraE8A+D9NUu9kD
	 PaIRxd33DMD5QYLuJ5IU1TU8K1tO6/VhYtVJSdX6zXyuRvXE2h3TYj4o/bLYQP6juRR+R
	 nKAleKMWF5kU66MEia8e5XzsvC+Ug9N8jeQrvpWftDTBuh6kuEDFyH6y7kCc9Vb/IFPPk
	 tBKA+fnzuZyaJ0mSJNcxaC6HaXpXI9rOu6+Qv6QuNyS5Xlot+wzY2mHyChTyrFrnF01Gp
	 tR6hctoWFjH5OQ3qDZLAoypx5kpAFxam4FfVOZwP1LNip29XOnfZ3RwJwkyx+nMnCBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YK124tk2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CD3606A32F;
	Thu, 19 Nov 2026 03:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YK124tk2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3491F000C4;
	Thu, 19 Nov 2026 03:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058230;
	bh=4yW0SuWpzwFnbV0zfxJ7xPH0agstfedB+QbG3Hmk5qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YK124tk272Tuv7tsBzxtIfSTr148/YSBQsamUzQ7i+hPOOprgQ6vEBZwV8nPwbepL
	 uaixdRmIyGid1sG/WQ5H4EVQZDHbs45VB4MBucN7H5CyQmXCsIw4x6vAcxQi+i3vV7
	 nTIfs/GxuGGfBcGCkp9btHc01vaVFRlcy2IMWnzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0413/1848] ata: libata-scsi: abort multi-sector pass-through commands when multi_count is 0
Date: Wed, 18 Nov 2026 15:40:51 +0100
Message-ID: <20261118145931.245143341@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9b9e33fe259a0..77f121266b636 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3077,6 +3077,11 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
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



