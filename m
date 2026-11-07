Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062025;
	b=i4rJtM2Bx8BBkUNMQxzipJl7+4c3//K4RfeEc6PJYiUFZp7ykWQoAmqLvhkihP2Q6GIq
	 aHal5CltJ4IoD6lQmKpbW5Extaj+Rv/gp5/Rd6F3Y3hf+8AJmMZXwSFaiDm5Ickt9+YKS
	 U2MGLsoeiBr7narc/eJC03fwXC6nURDnL8Tmni2xR8fz+D4GAl+gm6wsYPguvU53eeDaG
	 C5IId9DNbe1n3e0rPrSUlIxhddTMYEOl5y1j5hKoph9ZWdIrA5GPsHk88w1o++kVrtVbn
	 c6Z/7vimEPtzYicXlJWxCy0Kmzi+AxThvSrL+F8pYnco7Qj+z1mhF9TKinXRg6Xb46w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VIYiXbPNVspRjxZ48vqsEEXHbE0z+Ah1cXGeCkXwRAE=;
	b=IEpcdWNiQWFvNjDim9eAaoAugel/m3c+B8+qvcZHjpm7arupZY6CRprH9oLXC0yVaGGN
	 XKIudfhdf0NGe7wJa+yJJ6mSt62MXeq8mC9Ni6bd5HkLnTmjISKOM2wlZ7NSlW91yvUYk
	 K1GJvjMbNXZlVRzMgzHKhCdIsBOSX02X9FKDt/2wx77VqZNVU2Acsbw5KHEknBZJ/4Ewa
	 01DKyd7Eb/NXGdvSDntfcuI8IKx/2vpSveNeXmMNZU4PGugTlUq9+7fZEPEqAJJVpchjx
	 HI5UqmXvsvgEKBHVsOBWqfRhJbLvrLJRNyrhHtfH+0uHp9PvT4F4TuTCza1nc3cHFmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JIOOLHj9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8B3606A335;
	Sat,  7 Nov 2026 14:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JIOOLHj9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD6D1F008A1;
	Sat,  7 Nov 2026 14:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062025;
	bh=VIYiXbPNVspRjxZ48vqsEEXHbE0z+Ah1cXGeCkXwRAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JIOOLHj9O0LVWeLmR03VTmzYwZUBeWGahDLdXPWnMcQHB8tDpI2QET9kW2UwOwvMJ
	 SgaH7pgYc4w3X+tSj3MMmvJXiE2stwnNLHHtDxhPalocxnOf1dFpKkfeh5wyLjazEI
	 g7pokCJFlPV6wf4a5GmOOcWYu7af2QmbcwiMXFyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1011/1536] ata: libata-scsi: abort multi-sector pass-through commands when multi_count is 0
Date: Sat,  7 Nov 2026 08:50:27 -0500
Message-ID: <20261107135026.069780144@linuxfoundation.org>
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
index d4f6d82fd9085..6198192624141 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3486,6 +3486,11 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
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



