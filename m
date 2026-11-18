Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027872;
	b=GjPrVKFAHi/J76XtCYI6KC/THfER530SwZ49wB14CsVLEjNvW+Xb8zFKvjYP3H+kWIYD
	 r9/hUJvOTEvo0eahDRR0zvSW+ZMPrAt70BGiJF8hWhcYRZbGVSclfFaYbWM7XE1RajCxf
	 l0Er4jr9hzIlTkM23096c+nlHrOScdRB4Ye8+TTdBo1U1SFwq/5IBB4m6Hmzt06svp2HF
	 y2WP1Rr+GhCJbHbmhwTOxmafrP6mhvmb/tZkFAtlIBkBxDtbU5vavCRgPs7ax9M7FQY/w
	 feOVyTknO231x7e8jC8IsFb8qIWOh8coIcpH5T9d9qsWfdLdDx9Amgg3hMt3o5b3P0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f4r/lcZRC4i48neldSAMJf0rkyafy9xbP0aU0YJIUaY=;
	b=eImpJ5TYwB7T/cDtKD7cEnuya/gzJlr6mRe/KBz0qpUlIPEoqYSSZfmKjqFCtlEF8aUz
	 AMY64c5UNYtD3YsanPcPH9mTn8XutDqQFdsTTz+KK47yzcfTSsg9Lx/ozIY+1plWqaa8t
	 uerkAVQ1bGDLcCErzDDxuVGotNPrXFFd08PG1L0e9dtAnP+UKGfBQcCpX75uAq8M23MRb
	 B77vh9ezc3+z6jmwayHpRzuCABGPLTG/+h3wGu6sFkrxw7UlxS0jeWIuhiRz8ia+ZNpgy
	 zooXRZokbShu0MIHLpvN2i5vYl+0u3ObZ3sg0xoae1JFdRCliCJzOi1xetfoC3tYOOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RHxhtjjj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B6D606A330;
	Wed, 18 Nov 2026 18:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RHxhtjjj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BEA1F000C4;
	Wed, 18 Nov 2026 18:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027872;
	bh=f4r/lcZRC4i48neldSAMJf0rkyafy9xbP0aU0YJIUaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RHxhtjjjWzUNMLt8wFy3tEHVIFJ5t/sCJP4VoNFMWf+04/shHF64Ezzy6Z46KtZM3
	 t1iD0SUJWPqMATMmkqXEdm1oJOPWKbIQMCQ53Zvj/7UJGNJ+EgKZ0M1j4BOCQZpp3e
	 vgY9Rbvt8CMf4SrRRXAxgFZRIyWSELZzT27ZzE+s=
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
Subject: [PATCH 6.18 1942/2151] ALSA: us122l: mark hwdep mappings VM_MIXEDMAP
Date: Wed, 18 Nov 2026 16:01:17 +0100
Message-ID: <20261118150232.511565445@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 46dbf9ea1fb70..92878a1a22960 100644
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



