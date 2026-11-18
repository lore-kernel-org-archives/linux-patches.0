Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052292;
	b=z1ScnuqCzRuyzeNhtnNHxsx/PaEpxdnLyI70pP0yJxUfFOlserXJZmwwAY3Gj8FLkvW4
	 xJL6wLuOtG6c4CAH4zteTJhCvKZ13QE3YGqvXILetE8dq3EDoxPwCpQcmcj7CJJZX8E7z
	 xzfPGwzWYSZT1U/0Ahqx2wcowkkcCKIruxV2QDh+3ZyuYdHe/G2SUWeJzWxpiyl8MIBf6
	 2Uq2E6uHUFYvfv71eVl1knHYbmN3MBq1Zz3eL0loq5YfrYPAwtcYCve+byYPg3hGoslqz
	 qAZ+T+Ht5JqIMwWPcfWxDYOpzB1JB04jbU+EeRhMhKEiWA880s7rU7MiNhQSvyPptLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=63x3aBBXjcm071OIpcW60clOSQnGqq87s652ie8KHjs=;
	b=ee1awaRSCaI1/2vQbjxxLhlDmY4ZTTATMZr8gktl/Fo6jcxytMDHyNX/W61hw1OCtoa7
	 FJ3FWSVSjw85XLVtk3ss3uO08fXIXkb5+a1hdfNgQ+s5LxbggE4MV/nWBZgHLRqlfq32E
	 h1xZTDvvVCP1RTgEhs5Orkaoo9x7kNhEr47RXaDsPiVl+WAwdsG3Oua0kxfaS3Lv6gbrE
	 n+PY1CdVNe/qH129R4ekVTQhha/socA7G/v65E/3c7tnd22hUczoSf/yFbcpQLqR0tY+/
	 9GOmtH2zEfkOZFzxXhsooYSG9A/E+mDwacQVImzKkITgvayneJiXmg89TtavjFVRyXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qGAcD6jz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F271C606A31C;
	Thu, 19 Nov 2026 01:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qGAcD6jz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B911F000C4;
	Thu, 19 Nov 2026 01:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052291;
	bh=63x3aBBXjcm071OIpcW60clOSQnGqq87s652ie8KHjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qGAcD6jzxP0tTl5joEeNx0+5wynMJBXLpgf/Lc2dq/Dkaf/5ZzhreYPOYmyfA82Xx
	 ylZE3AOiQ4cucyNhI0ZR16SI71oMAACCXC5CVWW35cKTu1OT8gWclU3tlG6796QA+c
	 ugVoVm+3E5bldU/w6sA3NwSDqzm9d+tOSiT8OHBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0509/2214] ata: libata-scsi: abort multi-sector pass-through commands when multi_count is 0
Date: Wed, 18 Nov 2026 15:36:25 +0100
Message-ID: <20261118150031.487539296@linuxfoundation.org>
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
index 7ec130c932576..7725910eca0b6 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3031,6 +3031,11 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
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



