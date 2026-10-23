Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774871;
	b=oi8z/nTR7+nTlnD83MswpmRWNHfUB3YonKeEl7ZwncNcHw/IyDFK/abIlROjb7ulkr7i
	 xdtsUyodBiB8vYO2CgSEnkZ99V5wLDEXm8d8pRi8tlrUOmAhCsjfYjzxpV8+1jJS+Ys86
	 mmTZTvmZFX1zBiemW8RPU+8AUkT2Hs7PpM3KZYhJeEj0KlpiOQ2DzDRg2JkczPrRrxiWF
	 PxqBQlbpmPfus1+rExFbzX1SNRYBnvLx+x3Go21ApTPk+KokNf9kgfHGtkwBnMeoPIYDx
	 neqTuVJLaUqgpQ8ifzMceAoSL2si+ngdCf81YySuFePPax9YPp6AZW1Wh8SOK+O5RAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lm3qShQ81asZCAYmCA+0KiTG3G4VgkPhWRsyqOYIXj4=;
	b=I6sZLg5xQyo79pZ2fCV+VDsz6w5uh7s+qlHDv0SggqNDaWPdWFQKRk8DyFoZhLgZQBv9
	 gyDthL7ofDa9WRdEhMDRzK4lkiza3sT4LQs2t3uEuthFR4idQ/0k88w6r370PEULTqF6F
	 dBrLD0Sh5gS8aZNo1Un8RhO4eW/HeMfMBwdEJDbSmTJBvr+FOnDL9HF3UA8twxSt4o3f2
	 R+CJhDR9IYtGfkMuTQ8NIaHaOqlvOeBoS0nqQsPa1Pu9H+3n6OZm21DHKz+E5084J6ytL
	 6bfOq9FFaanG+N9bS/MSof4FYoIfncW0ubG8odnQ4Mcmtj/AXJay76CwbQOykyvfviA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pJxFmSWW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E15606A31D;
	Fri, 23 Oct 2026 17:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pJxFmSWW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BDD01F01828;
	Fri, 23 Oct 2026 17:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774871;
	bh=Lm3qShQ81asZCAYmCA+0KiTG3G4VgkPhWRsyqOYIXj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pJxFmSWWa0pA8Zfqa5btV9dqQwBkM/Unp6MwJoJWsD2raRqpKEpkiv8XAZw4jOUAI
	 qGPDFVHPw+aeyC+XqM2lqrCsJowd2kgVTTJUa1XqyjyTSYyDvupGG3tg7VxVQNi+Ae
	 v146zrGkmDeNve5osE3DmCRLrE2YDDAj2QvITDSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun Yangkai <sunyangkai@fygo.io>,
	Chen Cheng <chencheng@fnnas.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 187/242] dm-integrity: require stable writes for internal hash modes
Date: Fri, 23 Oct 2026 18:40:29 +0200
Message-ID: <20261023163718.211250158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Cheng <chencheng@fnnas.com>

commit b2fd92f016e9d692fd3c8c08d0ee014e9212279d upstream.

dm-integrity direct, bitmap and inline internal-hash modes compute
integrity tags from the pages carried by the write bio.  The lower data
write also uses those pages, so the tag and the data write depend on the
same memory contents staying unchanged while writeback is in flight.

Without stable writes, a buffered writer can modify a writeback folio
after dm-integrity has submitted the data bio and before the lower device
has consumed the data.  After a crash, this can leave data from the later
contents with a tag calculated from the earlier contents, causing
permanent checksum failures on read.

Set BLK_FEAT_STABLE_WRITES for internal-hash D, B and I modes so
filesystems wait for writeback folios to become stable before modifying
them again.  Journal mode is left unchanged because it copies data into
the journal before computing and persisting the tag.

Tested using dm-delay over a virtio-blk test disk, dm-integrity
internal_hash:crc32c and no-journal ext4.  The D and B reproducers both
failed with checksum errors before this change and completed with
READ_RC=0 and zero mismatches after it.

Fixes: 7eada909bfd7 ("dm: add integrity target")
Cc: stable@vger.kernel.org
Reported-by: Sun Yangkai <sunyangkai@fygo.io>
Link: https://github.com/chencheng-fnnas/reproducer/blob/main/dm-integrity-writeback-race.py
Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4176,6 +4176,10 @@ static void dm_integrity_io_hints(struct
 	limits->dma_alignment = limits->logical_block_size - 1;
 	limits->discard_granularity = ic->sectors_per_block << SECTOR_SHIFT;
 
+	if (ic->internal_hash &&
+	    (ic->mode == 'D' || ic->mode == 'B' || ic->mode == 'I'))
+		limits->features |= BLK_FEAT_STABLE_WRITES;
+
 	if (!ic->internal_hash) {
 		struct blk_integrity *bi = &limits->integrity;
 


