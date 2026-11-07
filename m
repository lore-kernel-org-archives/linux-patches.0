Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062095;
	b=OFgZJXq32D3NBlW0EJh+6nle9gc0Y86/PXPch77vxfZpJ43t5IxQU1C0mqC9iJiHayNZ
	 8GCGIHuTI9spVeePFn4lGJozCz9A/PFDsUZYI9Z8jx2RxM97EUgKsxM6J12HoDRcDVrCR
	 /d61HqxNwfMwdk7tTBnM0/kEhVszV7DHPAZwld22QI8RQAfMo2tWQfkxYutJxLiy543Ne
	 PPBXRlhX9hSS5h80jpfNLC0hHZIpEsgNL0XfwlGs2q6NNjVvR87hKSIo7qvu0aawbB2Xk
	 7vC01nULcwMfhnRWh5/uLOlvN9DlhU6sZw7+vmItft7TC7WtmFhnZRt8qQHiTKjZSeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9q0TJaUL5trPXF8GzM73f9lqWQTwPnofd3vV+4LcvPE=;
	b=130W30PqUUEasohGrAmE0RTJ+kcPG1Pw09TgrKxw+MrUT9LGBKCXBzonK5Yf3aj4x+W0
	 3OWwnKZSSOho1yZw1diHb/iG29mbjkVkxrl9XBOTd26e2L6xq8v3Rog1C3F8HtX936WbG
	 dy86ErExVWvBESPxV/snXxAHjkpZD+snYQpBQNSv5bm/0evDV1n6s1Ye8xuxFSBC3+bRD
	 JvoXM6qg4XUivqGVdLmJ8nwg+76Tm/AShvYJf2b8MbrsdfjckBMXUNipsH5rNH2Kyd3DS
	 OQF6VSi3ACDfqszUivByckPiH25KeE48Xzua4dAIjVHBO1WArNQZSqhn84xVhYTgXOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ET0O381o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6631C6083635;
	Sat,  7 Nov 2026 14:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ET0O381o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157BB1F0089F;
	Sat,  7 Nov 2026 14:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062095;
	bh=9q0TJaUL5trPXF8GzM73f9lqWQTwPnofd3vV+4LcvPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ET0O381oaDRt+Rv++u25LbYk1Uzlkkq/BcNUqSqTrOoEi769V8nJEfIGn6633OzXJ
	 X4eprkMdHVsPeeaw3Hf+1KtP4ounOF+0RXDECXuaO+WppXHeaQoPSCbTRa4U2uTAqQ
	 YEaRX2xRF3vJu62hy5Mih0goctLUxuPQulJELbSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1068/1536] mtd: cfi_cmdset_0002: cap the write-buffer chunk at 256 bytes on an x8 device
Date: Sat,  7 Nov 2026 08:51:24 -0500
Message-ID: <20261107135027.687109945@linuxfoundation.org>
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

From: Orgad Shaneh <orgads@gmail.com>

[ Upstream commit cfc5ebc9540e29f8f96db88bbfa261139e5afedb ]

The Write to Buffer command takes the number of words to program minus
one, and do_write_buffer() sends that count as a single bus word:

	map_write(map, CMD(words - 1), cmd_adr);

CMD() replicates the value into every device lane, so each device reads
the count off its own data lines - eight of them on an x8 part. A count
that does not fit in eight bits is truncated there, which limits one
Write to Buffer to 256 words on an x8 device, however large a buffer the
chip advertises in its CFI query.

The M29EW on a Cavium Octeon CN6335 board (an x16 part strapped to x8)
advertises MaxBufWriteSize = 512 bytes, so cfi_amdstd_write_buffers()
split the data into 512-byte chunks and do_write_buffer() sent a count of
511. The chip saw 511 & 0xff = 255, expected 256 bytes, and aborted the
program when the 257th arrived. Chunks below 256 bytes - the leading
partial chunk of a write - completed normally, so only the full-size ones
failed:

  MTD do_write_buffer_wait(): software timeout, address:0x03278bff.
  jffs2: Write of 4164 bytes at 0x02c789b4 failed. returned -5, retlen 68
  jffs2: No space for garbage collection. Aborting GC thread

Clamp MaxBufWriteSize for x8 devices in the write-buffer fixup, and
recompute mtd->writebufsize, which cfi_cmdset_0002_setup() derives from
MaxBufWriteSize before the fixups run.

The clamp deliberately keys off the device width rather than the part,
even though the driver already recognises this one in is_m29ew(): the
ceiling comes from the width of a device's data bus, not from the chip,
so any x8 device advertising a larger buffer is told a count it cannot
receive. The M29EW is only where it was found.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Orgad Shaneh <orgads@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/chips/cfi_cmdset_0002.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index 9f2223d3e8e11..b278e718dd8f2 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -283,6 +283,21 @@ static void fixup_use_write_buffers(struct mtd_info *mtd)
 		pr_debug("Using buffer write method\n");
 		mtd->_write = cfi_amdstd_write_buffers;
 	}
+
+	/*
+	 * The word count of the Write to Buffer command is a single bus
+	 * word per device, so an x8 device can be told to program at most
+	 * 256 bytes however large a buffer it advertises - including when
+	 * several of them are interleaved on a wider bus, where CMD()
+	 * replicates the count into each device's lane and it is truncated
+	 * there.
+	 */
+	if (cfi->device_type == CFI_DEVICETYPE_X8 &&
+	    cfi->cfiq->MaxBufWriteSize > 8) {
+		cfi->cfiq->MaxBufWriteSize = 8;
+		mtd->writebufsize = cfi_interleave(cfi) <<
+				    cfi->cfiq->MaxBufWriteSize;
+	}
 }
 #endif /* !FORCE_WORD_WRITE */
 
-- 
2.53.0



