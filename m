Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774119;
	b=Jk1MvadRgh37voHuc4i6JB9k/qdDORgZDuk/yt9/4+JD5R1TqM/zns32eG/BUH66/rsA
	 jtjEHcM4j38AobAOv+lSjgOm361rmKKVXdv/2MRkaze/Dasl33cn1G9GlpD4TbAAsTBzd
	 5wUw331X80eWtoDhgx11JJxwvq2gMCyypFvYyL821ZCWqeX2WMv6Y/JpSWO5pMM9SbMN4
	 7APBp8ezgdTqBEeT3VTx3+/Aa+m4PqwgRtar5MzzfO6U0gCi05zx18ZGgyV3VUbXDmiMn
	 2dezP5wAAQaQTa3t0RSTYyKLyZ0N2xImYFpKuLrupDucJBs6/0sHGdVhIWAZbZ4K+nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=27Zp9zYsmRKD9LSPabOz7HvR0qzQaZNLKr9gDuR8+vw=;
	b=WW929QgZBlL5YXntkTyvfkcNHNAEzx6rX/9uXUgm2X8IkYg1jTvcQcBFyZrHhHdP3Y0s
	 DKTJoAe20o49777ZIptoeGeiP/THF4FEsUBVkhUmFw0aOvsT1HPucHl/StIKNwyll/mFy
	 Eamkm6XyDJm3pONNY+EV5EUqcBiLHdFhW6YhzGGlJabA2IS8/OAFKayQofXJSxXMkp5nD
	 LuXln+2xFIX4VDDQMeW3ggiYA359G5U69/i16ONc07wPKh1rha55UShvmXsq3Mr/YTIeH
	 foXY6ptr+tqsPb+p0UeFHGSel2TmfgQSM5uDtyTspeNQ1phpT7nhN94PHkiIzZMU3qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=urovMk9z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6416606A31B;
	Fri, 23 Oct 2026 16:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=urovMk9z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF3D1F01825;
	Fri, 23 Oct 2026 16:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774118;
	bh=27Zp9zYsmRKD9LSPabOz7HvR0qzQaZNLKr9gDuR8+vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=urovMk9zqwq5sxL1P5tIN1B5WjmwNdXfVdfW3IVZ6v3LPqIv/IqgvQqzpIJP2GRoc
	 4vI2W9MXqVZw12hRCozfStGkiKwUbhod551xqYmq+9RmtGgsSZW2gIZNA821nRfSAs
	 FQuaqVNuTWXVz0CNtG9dXQx6l+NVOeC8Wi8Xablw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun Yangkai <sunyangkai@fygo.io>,
	Chen Cheng <chencheng@fnnas.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 126/193] dm-integrity: require stable writes for internal hash modes
Date: Fri, 23 Oct 2026 18:36:43 +0200
Message-ID: <20261023163717.186970026@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
@@ -4179,6 +4179,10 @@ static void dm_integrity_io_hints(struct
 		limits->discard_granularity = ic->sectors_per_block << SECTOR_SHIFT;
 	}
 
+	if (ic->internal_hash &&
+	    (ic->mode == 'D' || ic->mode == 'B' || ic->mode == 'I'))
+		limits->features |= BLK_FEAT_STABLE_WRITES;
+
 	if (!ic->internal_hash) {
 		struct blk_integrity *bi = &limits->integrity;
 


