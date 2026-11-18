Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052364;
	b=2H6GhMrdnF/85OcEtJan6qD/AXoFsuxth62VRaovg5As7EdyhVFrxhcCitO7c1gHz8iq
	 VFHFJUBJd+u/TREhmbGbrG0nW7gk7M5oc0CuSMXDfQ0hQckmw6jYQqJED73rmWAIIVCC+
	 rcu6TG0+nZMRAjPb8fkHBTj2GUZKkCgW+VyePU6lXN2HCbGC64PwRzu0yuXJPoVuIJM7U
	 ki2+VoHCN5ryByFg0qW8nCZJEo9gNscwXbBUrjOWeua5AxhQXujZ2e1r2rm+H2dSZnTdt
	 QZM/HD61q+zEtr93qTDjI3aRhqfX6l65IUk7Mg7N+3lZQi+GkJKAZZfvAX+4KWD7rOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oDIlLOa1jTQjh5bhRC5XfFR5LG6yF2y2EOHrt9TUWRw=;
	b=onBnMlTDbRxz1C8gJ7kFX/JgVFBUeg12UnjRFsyxGXKV/UE48KKbxJsqZ4V4xMDqYuui
	 FpAzL1rNkUberkgs02baidrzbK2ffWf8nfJOH7TLRFZzKGnlgyd0o0N1u4obHEZpExyt+
	 ZQys92MWFsoVIsRfs/sKqSKfgRQUuibFT3yyS2y04YxyzcDBxhJbegP7WhGLu7eA79NHK
	 su6uh7nUzHEYKhCD6tztFfYzbF4CTa8pPvwDWc8Tm/RBpd+0sQUtgCAVsyvNIksxPAZ/9
	 me8MMwTj/UMhL7+EbfLOYfAgBeGyECFaeo6R2XwmNrg9ce7HtdgyB8oiaguLaZWUOeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZVPPEfwS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135FA606A32F;
	Thu, 19 Nov 2026 01:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZVPPEfwS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAC61F000C4;
	Thu, 19 Nov 2026 01:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052363;
	bh=oDIlLOa1jTQjh5bhRC5XfFR5LG6yF2y2EOHrt9TUWRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZVPPEfwSrlzB/qICKV5+mpRa6WvDSLDeHNPn7SnUVv3xxB6K8AtgiV+/F+aQFfASq
	 McG5PH0Wrdx9ZeYt1+sRI9zPurA8QhD9MOkHn2FTtY86XheTfgBw37WIpuG94dFKaU
	 J4oj1QvQp+dVC2q9xv+aOUDkzSTbh42+bYid0cbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0538/2214] mtd: cfi_cmdset_0002: cap the write-buffer chunk at 256 bytes on an x8 device
Date: Wed, 18 Nov 2026 15:36:54 +0100
Message-ID: <20261118150032.551884149@linuxfoundation.org>
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
index 59334530dd46f..3bbd031c05cc7 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -284,6 +284,21 @@ static void fixup_use_write_buffers(struct mtd_info *mtd)
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



