Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045163;
	b=G+DjEfQrDjarDMGPA4w0BX1URj/2PAYQAIk94NCdqqKX+AGAQpUq9tdRCbEfdzRt04Ka
	 5i/hpmkoLBNqSmYrNWP3jXkque7PHSno7cLVJqE2gNLYs/Q97cn0n7+JEBZmn7rUsKVeC
	 Z11nOOwMQc9hzRWE6Tki6jlGT6f2pbzudElXrCyWCSTBNCk0dk7+uk204s882TlszXEFv
	 auepeAKYl+SRhcjpJBzrrQNzz7d+U6+caiHP8xgbekFlTr6GIjYvf2B26yA7jGoWmQ6AL
	 hoXItOEAt3jgvi/bLnknHgnSK31gXvdWB1D0fHHz3gSzQXgBU6kHG/TgAJViS4ZXrQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/ChVfPA3nbMLQDzbmzRgCEw7vKPa1xM39ofB6hd9kJA=;
	b=zwDqfrzhiLIhGSIgL/1AJ9ccTmyXyOeSCt1T1eQd+RKIkChJ4OaDdDqpTjwGb4UR9hhv
	 ctTf9tccgk4UZM6mA6T2NmvXaOvCGTdib2/iPgsOJChGf+jbThtZ7axvelAu8zAUI1c13
	 y4RV9rp6V3/Y3ERKwLyUZGYzgfmt5vjgi6SZKyj3Mx1N7YGFiVWImye9CMKy+4NGawZ7H
	 BW7d1T/2NWNH2HJrI88VmBXsG+64Ic3sCOEN3o8Gk/yJJufMubYFTDWyvJIspmzPIYx70
	 nQzpuA4h8EjMkzBMX1KDo4fsTFNoN9ZVqb+AoUPssi9lA49Nr9T/+mhEDyxMigxCmrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ssrG8Bgp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18448606A31C;
	Wed, 18 Nov 2026 23:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ssrG8Bgp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE501F000C4;
	Wed, 18 Nov 2026 23:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045163;
	bh=/ChVfPA3nbMLQDzbmzRgCEw7vKPa1xM39ofB6hd9kJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ssrG8BgpavTC6OmgpNi7auyEzr7eeU/LASKte29SKg2Jo2gQPRzFck0u5FGLtAaxK
	 HNyIxEd1KlK3fnIfUoXSJUaINfG21bUcAoLglwaFg6ynn+xc++OqymfyIAVcGMiA3q
	 BBqKOS1hwJyyqHY0iOO906uqU1vGeGC0rgPxQjlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0823/2857] mtd: cfi_cmdset_0002: cap the write-buffer chunk at 256 bytes on an x8 device
Date: Wed, 18 Nov 2026 15:30:57 +0100
Message-ID: <20261118150231.205530915@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 67453f59c69cb..c95a5eb2a0349 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -285,6 +285,21 @@ static void fixup_use_write_buffers(struct mtd_info *mtd)
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



