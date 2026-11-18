Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021702;
	b=BhZS/TEqueZ0251qS0beb5JIj7z6Rwh3dqsowl4wLT0n+LDXmLJ70ioj7kr5uKxETZCv
	 +iBOUdPkfo3PFYiHl8td+btUJnh5kVOYWK4DKeQGyOa7z6mLNxVud3lShZfSwQKk8Yj5m
	 s1004Cs4TCApTt8dxjHdRsqDUoDBrqBGmDqbNgzstvgr5WJpvQoCfaU/Pdf5j10UZYLqG
	 IYRC1FFT7JAKT0gONe5C6YbIcshfH9AD3OJzcHvQQLXCHbt6POSML360NuqinEEIjXGHr
	 cclEGbi+HQMXN7P+eSFLXVKIcu3OhIuCo5v25oR+fgOUNjkoe2iVAuLVKPvwG+dz6/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021702;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u6TqfuwI0w1EsRPXhOpKxz1nbPmwEGIdCmdFNmutubE=;
	b=KvbxiSDqp//nIS1dlmCbndllV79a5feT5v7DPvwh0E+6FmSGYrq1TfA/KcksU1AcbUJi
	 XKZMxETMKPXcpdJrKSqjIfCaLbbsnmUiGXqphZzvRQih1b1dzoTc3vrkg8ixh9o1j/pP2
	 MUUlIw9RTKZ/Hdkx4M05Acn1I/onGd+OZN1Yv63ZQpRL8ef7pduRafBxKNqHmjRBcRGsS
	 BkGf77JcADQyhgRK7LGXaXkQfqche7a9dz0l/UJcY7CN/TbZaHjCcsWNKUNueFSJmoUPr
	 1p6AP24w2+XjSDJTBwGRnLE3OtKW4l+IRKCl0pkH7Zcmr/e2pjTPQtvwnQMfJ2JSwlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wAYzd2Ov;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D8C606A333;
	Wed, 18 Nov 2026 17:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wAYzd2Ov
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B191F000C4;
	Wed, 18 Nov 2026 17:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021701;
	bh=u6TqfuwI0w1EsRPXhOpKxz1nbPmwEGIdCmdFNmutubE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wAYzd2OvXQMKAGmf3/64/Vg3Splo4Y/M9cWIEDrKHVizCVQG/LniPzH5SZdTMW6/Z
	 gNXm9csLxBhX7s3Gl1AdRa0wbSppl9jXKP7w5qNbKbTSN4XToMroL+xEIzIpid+UaQ
	 2YIx+mYAQ2dYHUptz6sdzoBBgROzcgfYwKlQVHd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Carlier <devnexen@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Kazuki Hanai <hnkz.64@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2399/2651] ALSA: us122l: mark hwdep mappings VM_MIXEDMAP
Date: Wed, 18 Nov 2026 16:00:39 +0100
Message-ID: <20261118150411.729498101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit bbde9d5bdd2d7cf94707b2a8bb466f2e074f9db2 ]

mm has recently moved to a strict model which requires any driver which
clears VMA_MAYWRITE_BIT to be mapping non-mm-managed memory
(VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT), failing any such mmap() with an
error and a kernel warning - see "mm/vma: only allow mmap to clear
VMA_MAYWRITE_BIT if not mm-managed".

However, simultaneous to this, commit 71c610aeb177 ("ALSA: us122l: Prevent
write upgrades for read mappings") updated us122l to clear
VMA_MAYWRITE_BIT without marking the region with either VMA_PFNMAP_BIT or
VMA_MIXEDMAP_BIT.

vm_insert_pages() and friends set this automatically, however this driver
maps its pre-allocated pages from a fault handler, so never calls these.

Simply set the flag in usb_stream_hwdep_mmap() to resolve the issue.  This
correctly marks the mapping as one whose pages core mm does not manage,
which has no meaningful impact for this driver beyond preventing the
mmap() from failing.

Link: https://lore.kernel.org/20261023-fix-us122l-mixedmap-v1-1-e7bdd053850f@kernel.org
Fixes: 71c610aeb177 ("ALSA: us122l: Prevent write upgrades for read mappings")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: David Carlier <devnexen@gmail.com>
Closes: https://lore.kernel.org/20261018025905.201296-1-devnexen@gmail.com
Acked-by: Takashi Iwai <tiwai@suse.de>
Cc: Kazuki Hanai <hnkz.64@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/us122l.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
index 9b4ec9bdc1383..6e491736ca5ba 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -204,7 +204,7 @@ static int usb_stream_hwdep_mmap(struct snd_hwdep *hw,
 	}
 
 	area->vm_ops = &usb_stream_hwdep_vm_ops;
-	vm_flags_set(area, VM_DONTDUMP);
+	vm_flags_set(area, VM_MIXEDMAP | VM_DONTDUMP);
 	if (!read)
 		vm_flags_set(area, VM_DONTEXPAND);
 	area->vm_private_data = us122l;
-- 
2.53.0



